# frozen_string_literal: true

class DistributionForm < ApplicationForm
  def self.has_part_of(has: true)
    [
      LinkedRails::SHACL::PropertyShape.new(
        path: [NS.schema.isPartOf, NS.schema.isPartOf],
        max_count: has ? nil : 0,
        min_count: has ? 1 : nil
      )
    ]
  end

  field :node_id,
        min_count: 1,
        datatype: NS.xsd.string,
        input_field: LinkedRails::Form::Field::SelectInput,
        if: has_part_of(has: true)
  field :title,
        min_count: 1,
        datatype: NS.xsd.string,
        if: has_part_of(has: false)
  field :access_url,
        min_count: 1,
        datatype: NS.xsd.string,
        if: has_part_of(has: false)
  field :format,
        min_count: 1
end
