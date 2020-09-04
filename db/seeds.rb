# frozen_string_literal: true

load(Dir[Rails.root.join('db/seeds/doorkeeper_apps.seeds.rb')][0])

# Create dex_transfer schema
unless Apartment.connection.schema_exists?('dex_transfer')
  Apartment::Tenant.create('dex_transfer')
  Apartment::Tenant.switch('dex_transfer') do
    load(Dir[Rails.root.join('db/seeds/doorkeeper_apps.seeds.rb')][0])
  end
end
