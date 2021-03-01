# frozen_string_literal: true

class DatasetForm < ApplicationForm
  field :title
  field :description
  has_one :distributions, label: '', min_count: 1
  field :themes,
        input_field: LinkedRails::Form::Field::SelectInput,
        grouped: true,
        datatype: NS::XSD[:string],
        sh_in: form_options_iri(:theme, DatasetTheme),
        max_count: 99
  field :license
  field :license_description
end
