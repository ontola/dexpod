# frozen_string_literal: true

class ImplicitDisclaimerCondition < Condition
  condition_attrs(
    text: {type: :string, required: true}
  )
end
