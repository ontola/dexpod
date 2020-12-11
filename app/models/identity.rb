# frozen_string_literal: true

class Identity < ApplicationRecord
  belongs_to :user, optional: true
  belongs_to :provider

  validates :identifier, uniqueness: {scope: :provider_id}

  delegate :userinfo!, to: :access_token
  delegate :name, to: :userinfo!

  def access_token
    @access_token ||=
      OpenIDConnect::AccessToken.new(
        access_token: super,
        client: provider.client
      )
  end

  def check_id!
    provider.decode_id(id_token)
  end
end
