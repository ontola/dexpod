# frozen_string_literal: true

module Invalidatable
  extend ActiveSupport::Concern
  include RootHelper
  include DeltaHelper

  CREATE_TYPE = 'io.ontola.transactions.Created'
  UPDATE_TYPE = 'io.ontola.transactions.Updated'
  DELETED_TYPE = 'io.ontola.transactions.Deleted'

  included do
    after_commit :publish_create, on: :create
    after_commit :publish_update, on: :update
    after_commit :publish_delete, on: :destroy

    def publish_create
      type = CREATE_TYPE
      publish_message(type)
      notify_clients(type)
    end

    def publish_update
      type = UPDATE_TYPE
      publish_message(type)
      notify_clients(type)
    end

    def publish_delete
      type = DELETED_TYPE
      publish_message(type)
      notify_clients(type)
    end

    def publish_message(type)
      ResourceInvalidationStreamJob.perform_later(type, iri.to_s, self.class.iri.to_s)
    end

    def notify_clients(type)
      RootChannel.broadcast_to(current_tenant, delta_for(type, self))
    end

    def delta_for(type, resource)
      case type
      when CREATE_TYPE
        hex_delta(resource_added_delta(resource))
      when UPDATE_TYPE
        hex_delta([invalidate_resource_delta(resource)])
      when DELETED_TYPE
        hex_delta(resource_removed_delta(resource))
      else
        raise("Unknown message type '#{type}'")
      end
    end
  end
end
