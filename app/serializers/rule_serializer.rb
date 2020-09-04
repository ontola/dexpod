# frozen_string_literal: true

class RuleSerializer < LinkedSerializer
  attribute :action, predicate: NS::SCHEMA[:name]
  attribute :description, predicate: NS::SCHEMA[:text]
end
