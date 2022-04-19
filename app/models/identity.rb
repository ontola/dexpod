# frozen_string_literal: true

class Identity < ApplicationRecord
  belongs_to :user, optional: true
  belongs_to :provider
  scope :dexpod, -> { where('identifier LIKE ?', "https://%.#{Rails.application.config.host_name}/profile#me") }

  validates :identifier, uniqueness: {scope: :provider_id}

  delegate :name, to: :userinfo, allow_nil: true

  def access_token
    @access_token ||=
      OpenIDConnect::AccessToken.new(
        access_token: super,
        client: provider.client
      )
  end

  def userinfo!
    Timeout.timeout(5) do
      access_token.userinfo!
    end
  end

  def userinfo
    userinfo!
  rescue Timeout::Error
    nil
  end

  def check_id!
    provider.decode_id(id_token)
  end
end
