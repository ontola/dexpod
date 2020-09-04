# frozen_string_literal: true

class InviteActionList < ApplicationActionList
  has_action(
    :accept,
    favorite: true,
    # Might be required if specific questions arise from an Offer
    # form: -> { result_class.try(:form_class) },
    http_method: :post,
    policy: :accept?,
    url: lambda {
      iri = resource.iri.dup
      iri.path += '/accept'
      iri
    }
  )
end
