# frozen_string_literal: true

class UserSerializer < LinkedSerializer
  attribute :name, predicate: NS::FOAF[:name]
end
