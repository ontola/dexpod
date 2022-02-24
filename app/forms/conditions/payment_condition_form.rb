# frozen_string_literal: true

class PaymentConditionForm < ApplicationForm
  field :amount,
        input_field: MoneyInput
end
