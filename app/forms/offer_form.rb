# frozen_string_literal: true

class OfferForm < ApplicationForm
  has_one :node,
          min_count: 1,
          form: MediaObjectForm
  has_many :invites,
           min_count: 1
  field :rule_sets,
        max_count: 999
  field :attribution_description,
        datatype: NS::XSD[:string]
end
