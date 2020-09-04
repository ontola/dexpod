# frozen_string_literal: true

module Constraints
  # Allow routes targeted towards the DexTransfer site
  module DexTransferConstraint
    module_function

    def matches?(_request)
      RootHelper.dex_transfer?
    end
  end
end
