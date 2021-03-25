# frozen_string_literal: true

class ResourceInvalidationWorker < ApplicationJob
  include DeltaHelper

  def perform(iri)
    redis = Redis.new(db: Rails.configuration.redis_database)

    listeners = redis.publish(Rails.configuration.cache_channel, hex_delta([invalidate_resource(iri)]))

    return if Rails.env.test? || listeners >= 1

    raise('Expected at least one listener, but only had none')
  end
end
