# frozen_string_literal: true

raise 'LIBRO_CLIENT_ID is missing' if ENV['LIBRO_CLIENT_ID'].blank?

libro_app = Doorkeeper::Application.find_or_initialize_by(uid: ENV['LIBRO_CLIENT_ID']) do |app|
  app.name = 'Libro'
  app.redirect_uri = 'http://example.com/'
  app.scopes = 'guest user'
  app.secret = ENV['LIBRO_CLIENT_SECRET']
end
libro_app.save!(validate: false)
# rubocop:disable Rails/SkipsModelValidations
libro_app.update_columns(uid: ENV['LIBRO_CLIENT_ID'], secret: ENV['LIBRO_CLIENT_SECRET'])
# rubocop:enable Rails/SkipsModelValidations

ActiveRecord::Base.connection.reset_pk_sequence!(Doorkeeper::Application.table_name)

token = Doorkeeper::AccessToken.find_or_create_for(
  application: libro_app,
  scopes: 'service',
  expires_in: 10.years.to_i,
  resource_owner: nil,
  use_refresh_token: true
)
token.update(token: ENV['RAILS_OAUTH_TOKEN'])
token
