# frozen_string_literal: true

module Broker
  class CollectionView < LinkedRails::Collection::View
    private

    def broker_query
      @broker_query ||= association_class.where(where_hash)
    end

    def where_hash
      (collection.filters || []).reduce({page: page}) do |hash, filter|
        hash[association_class.predicate_mapping[filter.key].key] = filter.value.first
        hash
      end
    end

    def raw_members
      broker_query
    end

    class << self
      private

      def collection_paginated_view_class
        Broker::PaginatedCollectionView
      end

      def collection_infinite_view_class
        Broker::InfiniteCollectionView
      end
    end
  end
end
