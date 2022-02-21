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
  field :title
  field :description
  field :dataspace_id,
        sh_in: -> { Dataspace.collection_iri }
  has_one :distributions,
          label: '',
          min_count: 1,
          if: with_part_of(has: true)
  has_many :distributions,
           min_count: 1,
           if: with_part_of(has: false)
  field :themes,
        input_field: LinkedRails::Form::Field::SelectInput,
        grouped: true,
        datatype: NS.xsd.string,
        sh_in: form_options_iri(:theme, DatasetTheme),
        min_count: 1,
        max_count: 99
  group :conditions,
        description: -> { I18n.t('forms.datasets.conditions.description') },
        label: -> { I18n.t('forms.datasets.conditions.label') },
        collapsible: false do
    Condition.types.each do |klass|
      has_one klass.name.underscore.to_sym
    end
  end
end
