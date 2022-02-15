# frozen_string_literal: true

class InterledgerPaymentConditionForm < ApplicationForm
  field :amount,
        input_field: MoneyInput
  field :address
end
