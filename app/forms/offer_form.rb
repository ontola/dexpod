# frozen_string_literal: true

class OfferForm < ApplicationForm
  has_one :node,
          min_count: 1,
          form: MediaObjectForm
  has_many :invites,
           min_count: 1
  field :rule_sets,
        max_count: 999
  field :contains_private_description,
        datatype: NS::XSD[:string],
        max_length: 500
  field :attribution_description,
        datatype: NS::XSD[:string],
        max_length: 500
end
