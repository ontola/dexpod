# frozen_string_literal: true

class ImplicitDisclaimerConditionForm < ApplicationForm
  field :text,
        input_field: LinkedRails::Form::Field::TextAreaInput
end
