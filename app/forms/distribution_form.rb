# frozen_string_literal: true

class DistributionForm < ApplicationForm
  field :node_id,
        min_count: 1,
        datatype: NS::XSD[:string],
        input_field: LinkedRails::Form::Field::SelectInput
  field :format,
        min_count: 1
end
