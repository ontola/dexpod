# frozen_string_literal: true

module Invalidatable
  extend ActiveSupport::Concern

  included do
    after_commit :invalidate

    def invalidate
      ResourceInvalidationWorker.perform_later(iri.to_s)
      ResourceInvalidationStreamWorker.perform_later(iri.to_s)
    end
  end
end
