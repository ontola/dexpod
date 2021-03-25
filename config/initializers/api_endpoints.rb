# frozen_string_literal: true

endpoints_key = 'frontend.runtime.plain_endpoints'

begin
  current_keys = Redis.new(db: Rails.configuration.redis_database).lrange(endpoints_key, 0, -1)
  required_keys = %w[
    /.well-known/webfinger
    /.well-known/webfinger?(.*)
    /.well-known/openid-configuration
    /oauth/(.*)
    /rails/(.*)
  ]

  (required_keys - current_keys).each do |key|
    Rails.logger.info "Registering #{key} as API endpoint"
    Redis.new(db: Rails.configuration.redis_database).lpush(endpoints_key, key)
  end
rescue ::Redis::CannotConnectError
  nil
end
