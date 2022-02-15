# frozen_string_literal: true

raise 'LIBRO_CLIENT_ID is missing' if ENV['LIBRO_CLIENT_ID'].blank?

libro_app = Doorkeeper::Application.find_by!(uid: ENV['LIBRO_CLIENT_ID'])
token = Doorkeeper::AccessToken.find_or_create_for(
  application: libro_app,
  scopes: 'service',
  expires_in: 10.years.to_i,
  resource_owner: nil,
  use_refresh_token: true
)
token.update(token: ENV['RAILS_OAUTH_TOKEN'])
token


