# frozen_string_literal: true

class InterledgerPaymentCondition < Condition
  condition_attrs(
    amount: {
      type: :integer,
      required: true
    },
    currency: {
      type: :string,
      default: 'EUR',
      required: true
    },
    address: {
      type: :string,
      required: true
    }
  )

  def amount
    Money.new(super, currency)
  end
end
