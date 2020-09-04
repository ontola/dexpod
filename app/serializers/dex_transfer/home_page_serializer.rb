# frozen_string_literal: true

module DexTransfer
  class HomePageSerializer < LinkedRails::WebPageSerializer
    has_one :transfer_action, predicate: NS::DEX[:transferAction]
  end
end
