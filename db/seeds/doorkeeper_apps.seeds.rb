# frozen_string_literal: true

raise 'ARGU_APP_ID is missing' if ENV['ARGU_APP_ID'].blank?

libro_app = Doorkeeper::Application.find_or_create_by(uid: ENV['ARGU_APP_ID']) do |app|
  app.name = 'Libro'
  app.redirect_uri = 'http://example.com/'
  app.scopes = 'guest user'
end
libro_app.save(validate: false)
# rubocop:disable Rails/SkipsModelValidations
libro_app.update_columns(uid: ENV['ARGU_APP_ID'], secret: ENV['ARGU_APP_SECRET'])
# rubocop:enable Rails/SkipsModelValidations

ActiveRecord::Base.connection.reset_pk_sequence!(Doorkeeper::Application.table_name)
