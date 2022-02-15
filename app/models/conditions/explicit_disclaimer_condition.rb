# frozen_string_literal: true

class ExplicitDisclaimerCondition < Condition
  condition_attrs(
    text: {type: :string, required: true}
  )
end
