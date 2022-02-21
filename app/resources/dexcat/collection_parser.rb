# frozen_string_literal: true

module Dexcat
  class CollectionParser < ActiveResource::Collection
    def initialize(elements = [])
      @elements = elements['results']
    end
  end
end
