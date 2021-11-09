# frozen_string_literal: true

module Broker
  class PaginatedCollectionView < Broker::CollectionView
    include LinkedRails::Collection::Paginated
  end
end
