# frozen_string_literal: true

Apartment::Tenant.switch(:public) do
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
end

load(Dir[Rails.root.join('db/seeds/doorkeeper_apps.seeds.rb')][0])

Apartment::Tenant.drop('user') if ApplicationRecord.connection.schema_exists?('user')
Pod.find_by(pod_name: 'user')&.destroy
WebId.find_by(email: 'user@example.com')&.destroy
Pod.create!(
  pod_name: 'user',
  theme_color: '#333333',
  web_id: WebId.new(
    email: 'user@example.com',
    password: 'password'
  )
)
Apartment::Tenant.switch!('user')

def define_pod
  let(:pod) { Pod.find_by!(pod_name: 'user') }
  let(:web_id) { WebId.find_by!(email: 'user@example.com') }
end
