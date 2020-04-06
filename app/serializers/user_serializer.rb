# frozen_string_literal: true

class UserSerializer < LinkedSerializer
  attribute :email, predicate: NS::SCHEMA[:name]
end
