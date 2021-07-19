# frozen_string_literal: true

class ResourceInvalidationStreamWorker < ApplicationJob
  def perform(type, iri, resource_type)
    redis = Redis.new(url: Rails.configuration.stream_redis_url)

    entry = {
      type: type,
      resource: iri,
      resourceType: resource_type
    }
    id = redis.xadd(Rails.configuration.cache_stream, entry)

    return if Rails.env.test? || id.present?

    raise('No message id returned, implies failure')
  end
end
