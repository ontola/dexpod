# frozen_string_literal: true

# Based on acts_as_tenant/sidekiq

module Apartment
  module Sidekiq
    class Client
      def call(_worker_class, msg, _queue, _redis_pool)
        msg['tenant'] ||= Apartment::Tenant.current

        yield
      end
    end

    class Server
      def call(_worker_class, msg, _queue)
        if msg.key?('tenant')
          Apartment::Tenant.switch(msg['tenant']) do
            yield
          end
        else
          yield
        end
      end
    end
  end
end

Sidekiq.configure_client do |config|
  config.client_middleware do |chain|
    chain.add Apartment::Sidekiq::Client
  end
end

Sidekiq.configure_server do |config|
  config.client_middleware do |chain|
    chain.add Apartment::Sidekiq::Client
  end
  config.server_middleware do |chain|
    if defined?(Sidekiq::Middleware::Server::RetryJobs)
      chain.insert_before Sidekiq::Middleware::Server::RetryJobs, Apartment::Sidekiq::Server
    else
      chain.add Apartment::Sidekiq::Server
    end
  end
end
