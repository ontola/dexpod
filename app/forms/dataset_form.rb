# frozen_string_literal: true

class DatasetForm < ApplicationForm
  def self.with_part_of(has: true)
    [
      LinkedRails::SHACL::PropertyShape.new(
        path: [NS.schema.isPartOf],
        max_count: has ? nil : 0,
        min_count: has ? 1 : nil
      )
    ]
  end

  group :describe_data,
        label: -> { I18n.t('forms.datasets.describe_data.label') },
        collapsible: false do
    field :title
    field :description
    has_one :distributions,
            label: '',
            min_count: 1,
            if: with_part_of(has: true)
    has_many :distributions,
             min_count: 1,
             if: with_part_of(has: false)
    field :data_owned,
          input_field: LinkedRails::Form::Field::CheckboxInput
    field :data_owner,
          min_count: 1
    field :themes,
          input_field: LinkedRails::Form::Field::SelectInput,
          grouped: true,
          datatype: NS.xsd.string,
          sh_in: form_options_iri(:theme, DatasetTheme),
          min_count: 1,
          max_count: 99
  end
  group :conditions,
        label: -> { I18n.t('forms.datasets.conditions.label') },
        collapsible: false do
    # field :dataspace_id,
    #       sh_in: -> { Dataspace.collection_iri }
    field :license,
          min_count: 1
    Condition.types.each do |klass|
      has_one klass.name.underscore.to_sym
    end
  end
end
