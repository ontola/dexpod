# frozen_string_literal: true

class AttributionCondition < Condition
  condition_attrs(
    text: {type: :string, required: true}
  )
end
