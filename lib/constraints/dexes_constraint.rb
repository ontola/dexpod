# frozen_string_literal: true

module Constraints
  # Allow routes targeted towards the dexpod central service.
  module DexesConstraint
    module_function

    def matches?(_request)
      RootHelper.public_tenant?
    end
  end
end
