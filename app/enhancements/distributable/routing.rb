# frozen_string_literal: true

module Distributable
  module Routing; end

  class << self
    def dependent_classes
      [Dataset, Distribution]
    end

    def route_concerns(mapper)
      mapper.concern :distributable do
        mapper.resources :datasets, only: %i[create new]
      end
    end
  end
end
