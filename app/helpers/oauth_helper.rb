# frozen_string_literal: true

# rubocop:disable Rails/HelperInstanceVariable
module OauthHelper
  include JWTHelper
  include Doorkeeper::Rails::Helpers
  include Doorkeeper::Helpers::Controller

  SAFE_METHODS = %w[GET HEAD OPTIONS CONNECT TRACE].freeze
  UNSAFE_METHODS = %w[POST PUT PATCH DELETE].freeze

  def current_user
    return @current_user if instance_variable_defined?(:@current_user)

    @current_user ||= current_resource_owner || GuestUser.new

    doorkeeper_render_error unless valid_token?

    @current_user
  end

  def doorkeeper_unauthorized_render_options(error: nil)
    {
      json: {
        error: :invalid_token,
        error_description: error&.description
      }
    }
  end

  def sign_in(resource, *_args)
    update_oauth_token(generate_access_token(resource))
    warden.set_user(resource, scope: :user, store: false) unless warden.user(:user) == resource
  end

  def sign_out(*args)
    super

    update_oauth_token(generate_access_token(GuestUser.new))
  end

  def doorkeeper_scopes
    doorkeeper_token&.scopes || []
  end

  private

  def doorkeeper_token_payload
    @doorkeeper_token_payload ||= decode_token(doorkeeper_token.token)
  end

  def generate_access_token(resource_owner)
    doorkeeper_token.revoke if doorkeeper_token&.resource_owner_id

    Doorkeeper::AccessToken.find_or_create_for(
      application: doorkeeper_token&.application,
      resource_owner: resource_owner,
      scopes: resource_owner.guest? ? :guest : :user,
      expires_in: Doorkeeper.configuration.access_token_expires_in,
      use_refresh_token: true
    )
  end

  def redirect_guests
    return true if current_user && !current_user&.guest?

    redirect_to(LinkedRails.iri(path: '/u/sign_in', query: {r: request.original_url}.to_param).to_s)
  end

  def update_oauth_token(token)
    response.headers['New-Refresh-Token'] = token.refresh_token
    response.headers['New-Authorization'] = token.token
  end

  def valid_token?
    return SAFE_METHODS.include?(request.method) if doorkeeper_token.blank?

    doorkeeper_token&.accessible?
  end
end
# rubocop:enable Rails/HelperInstanceVariable
