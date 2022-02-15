# frozen_string_literal: true

class TimespanCondition < Condition
  condition_attrs(
    duration: {type: :integer, required: true}
  )
end
