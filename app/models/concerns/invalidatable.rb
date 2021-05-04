# frozen_string_literal: true

module Invalidatable
  extend ActiveSupport::Concern

  included do
    after_commit :publish_create, on: :create
    after_commit :publish_update, on: :update
    after_commit :publish_delete, on: :destroy

    after_commit :invalidate

    def publish_create
      publish_message('io.ontola.transactions.Created')
    end

    def publish_update
      publish_message('io.ontola.transactions.Updated')
    end

    def publish_delete
      publish_message('io.ontola.transactions.Deleted')
    end

    def invalidate
      ResourceInvalidationWorker.perform_later(iri.to_s)
    end

    def publish_message(type)
      ResourceInvalidationStreamWorker.perform_later(type, iri.to_s, self.class.iri.to_s)
    end
  end
end
