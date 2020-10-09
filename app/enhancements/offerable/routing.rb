# frozen_string_literal: true

module Offerable
  module Routing; end

  class << self
    def dependent_classes
      [Offer]
    end

    def route_concerns(mapper)
      mapper.concern :offerable do
        mapper.resources :offers, only: %i[index create new]
      end
    end
  end
end
