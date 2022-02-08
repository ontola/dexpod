# frozen_string_literal: true

module Broker
  class CollectionParser < ActiveResource::Collection
    def initialize(elements = [])
      @elements = elements['items']
    end
  end
end
