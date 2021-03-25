# frozen_string_literal: true

class ResourceInvalidationStreamWorker < ApplicationJob
  include DeltaHelper

  def perform(iri)
    redis = Redis.new(db: Rails.configuration.redis_database)

    entry = {delta: hex_delta([invalidate_resource(iri)])}
    id = redis.xadd(Rails.configuration.cache_stream_channel, entry)

    return if Rails.env.test? || id.present?

    raise('No message id returned, implies failure')
  end
end
