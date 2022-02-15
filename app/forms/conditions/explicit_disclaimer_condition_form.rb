# frozen_string_literal: true

class ExplicitDisclaimerConditionForm < ApplicationForm
  field :text,
        input_field: LinkedRails::Form::Field::TextAreaInput
end
