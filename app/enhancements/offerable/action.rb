# frozen_string_literal: true

module Offerable
  module Action
    extend ActiveSupport::Concern

    included do
      has_action(
        :new_offer,
        url: -> { resource.offer_collection.iri },
        image: 'fa-envelope-o',
        http_method: :post,
        predicate: NS::DEX[:createOffer],
        form: ShareNodeForm
      )
    end
  end
end
