# frozen_string_literal: true

class ShareNodeForm < ApplicationForm
  self.model_class = Offer

  has_many :invites,
           min_count: 1
  field :rule_sets,
        max_count: 999
  field :contains_private_description,
        datatype: NS::XSD[:string]
  field :attribution_description,
        datatype: NS::XSD[:string]
end
