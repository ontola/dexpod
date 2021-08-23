# frozen_string_literal: true

require_relative 'boot'

require 'rails'
# Pick the frameworks you want:
require 'active_model/railtie'
require 'active_job/railtie'
require 'active_record/railtie'
require 'active_storage/engine'
require 'action_controller/railtie'
require 'action_mailer/railtie'
# require 'action_mailbox/engine'
# require 'action_text/engine'
# require 'action_view/railtie'
# require 'action_cable/engine'
# require "sprockets/railtie"
require 'rails/test_unit/railtie'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

JSON::LD::Reader # rubocop:disable Lint/Void, fix weird autoload failure

require 'linked_rails/middleware/linked_data_params'
require_relative '../lib/apartment_sidekiq'
require_relative '../lib/types/iri_type'
require_relative './initializers/version'

require_relative '../lib/first_sub_domain_without_api'

module Dexpod
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 6.0
    # config.autoloader = :classic

    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration can go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded after loading
    # the framework and any gems in your application.

    %i[controllers forms models policies serializers].each do |type|
      config.autoload_paths += %W[#{config.root}/app/#{type}/nodes]
    end

    # Only loads a smaller set of middleware suitable for API only apps.
    # Middleware like session, flash, cookies can be added back manually.
    # Skip views, helpers and assets when generating a new resource.
    config.api_only = true

    config.host_name = ENV['HOSTNAME']
    config.origin = "https://#{ENV['HOSTNAME']}"

    config.cache_channel = ENV['CACHE_CHANNEL'].presence || 'cache'
    config.cache_stream = ENV['CACHE_STREAM'].presence || 'transactions'
    redis_url_db = ENV['REDIS_URL'] && URI(ENV['REDIS_URL']).path&.split('/')&.dig(1)
    config.redis_database = (ENV['BACKEND_REDIS_DATABASE'] || redis_url_db)&.to_i || 0
    config.stream_redis_url = ENV['STREAM_REDIS_URL'] || ENV['REDIS_URL']

    config.action_mailer.default_url_options = {
      host: config.host_name,
      protocol: :https
    }

    config.from_email = ENV['FROM_EMAIL']

    config.time_zone = 'UTC'
    config.i18n.available_locales = %i[nl en]
    config.i18n.load_path += Dir[Rails.root.join('config/locales/**/*.{rb,yml}')]
    config.i18n.enforce_available_locales = true
    config.i18n.default_locale = ENV['DEFAULT_LOCALE'] || :nl

    # https://github.com/rails/rails/issues/34665
    ActiveStorage::Engine.config
      .active_storage
      .content_types_to_serve_as_binary
      .delete('image/svg+xml')

    config.middleware.use FirstSubDomainWithoutAPI
    config.middleware.use LinkedRails::Middleware::LinkedDataParams
    config.middleware.insert_before 0, Rack::Cors do
      allow do
        origins do |source, _env|
          source.presence || '*'
        end

        resource '/.well-known/*', headers: :any, methods: %i[get]
        resource '/oauth/*', headers: :any, methods: %i[get post put patch delete options head], credentials: true
        resource '*', headers: :any, methods: %i[get post put patch delete options head], credentials: true
      end
    end
  end
end
