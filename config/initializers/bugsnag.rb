# frozen_string_literal: true

Bugsnag.configure do |config|
  config.api_key = ENV['BUGSNAG_KEY']
  config.notify_release_stages = %w[production staging]
  config.app_version = "v#{::VERSION}"
end
