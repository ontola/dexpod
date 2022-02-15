# frozen_string_literal: true

class AttributionConditionForm < ApplicationForm
  field :text,
        input_field: LinkedRails::Form::Field::TextAreaInput
end
