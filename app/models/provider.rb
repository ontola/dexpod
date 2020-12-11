# frozen_string_literal: true

class Provider < ApplicationRecord
  serialize :scopes_supported, JSON

  has_many :identities, dependent: :destroy

  validates :issuer, presence: true, uniqueness: {allow_nil: true}
  validates :name, presence: true
  validates :identifier, presence: {if: :registered?}
  validates :authorization_endpoint, presence: {if: :registered?}
  validates :token_endpoint, presence: {if: :registered?}
  validates :userinfo_endpoint, presence: {if: :registered?}

  scope :valid, -> { where('expires_at IS NULL OR expires_at >= ?', Time.now.utc) }

  def as_json(_options = {})
    %i[identifier secret scopes_supported host scheme jwks_uri authorization_endpoint token_endpoint userinfo_endpoint]
      .inject({}) do |hash, key|
      hash.merge!(
        key => send(key)
      )
    end
  end

  def authorization_uri(redirect_uri, nonce)
    client.redirect_uri = redirect_uri

    client.authorization_uri(
      response_type: :code,
      nonce: nonce,
      state: nonce,
      scope: scopes_supported & %i[openid email profile address].collect(&:to_s)
    )
  end

  def authenticate(redirect_uri, code, nonce)
    client.redirect_uri = redirect_uri
    client.authorization_code = code

    access_token = client.access_token!(client_auth_method)
    identity = identity_for_authentication(access_token, nonce)
    identity.access_token = access_token.access_token
    identity.id_token = access_token.id_token
    identity.user ||= User.new(name: identity.name)
    identity.save!

    identity.user
  end

  def client
    @client ||= OpenIDConnect::Client.new(as_json)
  end

  def expired?
    expires_at.try(:past?)
  end

  def register!(redirect_uri) # rubocop:disable Metrics/AbcSize
    client = register_client(redirect_uri)

    self.identifier = client.identifier
    self.secret = client.secret
    self.scopes_supported = config.scopes_supported
    self.authorization_endpoint = config.authorization_endpoint
    self.token_endpoint = config.token_endpoint
    self.userinfo_endpoint = config.userinfo_endpoint
    self.jwks_uri = config.jwks_uri
    self.expires_at = client.expires_in.try(:from_now)

    save!
  end

  def registered?
    identifier.present? && !expired?
  end

  private

  def client_auth_method
    supported = config.token_endpoint_auth_methods_supported
    if supported.present? && !supported.include?('client_secret_basic')
      :post
    else
      :basic
    end
  end

  def config
    @config ||= OpenIDConnect::Discovery::Provider::Config.discover!(issuer)
  end

  def decode_id(id_token)
    OpenIDConnect::ResponseObject::IdToken.decode(id_token, config.jwks)
  end

  def identity_for_authentication(access_token, nonce)
    new_id_token = decode_id(access_token.id_token)
    new_id_token.verify!(
      issuer: issuer,
      client_id: identifier,
      nonce: nonce
    )

    identities.find_or_initialize_by(identifier: new_id_token.subject)
  end

  def register_client(redirect_uri)
    OpenIDConnect::Client::Registrar.new(
      config.registration_endpoint,
      client_name: 'NOV RP',
      application_type: 'web',
      redirect_uris: [redirect_uri],
      subject_type: 'pairwise'
    ).register!
  end

  class << self
    def discover!(host)
      config = OpenIDConnect::Discovery::Provider.discover!(host)

      find_by(issuer: config.issuer) || create(issuer: config.issuer, name: host)
    end
  end
end
