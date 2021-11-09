# frozen_string_literal: true

module Broker
  class InfiniteCollectionView < Broker::CollectionView
    include LinkedRails::Collection::Infinite
  end
end
