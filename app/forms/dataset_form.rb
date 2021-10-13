# frozen_string_literal: true

class DatasetForm < ApplicationForm
  field :title
  field :description
  has_one :distributions, label: '', min_count: 1
  field :themes,
        input_field: LinkedRails::Form::Field::SelectInput,
        grouped: true,
        datatype: NS.xsd.string,
        sh_in: form_options_iri(:theme, DatasetTheme),
        min_count: 1,
        max_count: 99
  field :license,
        min_count: 1
  field :license_description,
        min_count: 1
end
