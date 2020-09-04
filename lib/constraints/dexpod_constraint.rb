# frozen_string_literal: true

module Constraints
  # Allow routes targeted towards a pod
  module DexpodConstraint
    module_function

    def matches?(_request)
      RootHelper.pod?
    end
  end
end
