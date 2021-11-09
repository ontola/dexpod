# frozen_string_literal: true

module Broker
  class Collection < LinkedRails::Collection
    def total_count; end

    private

    def collection_view_class
      Broker::CollectionView
    end

    class << self
      def policy_class
        LinkedRails::CollectionPolicy
      end
    end
  end
end
