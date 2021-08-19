# frozen_string_literal: true

class UserSerializer < LinkedSerializer
  attribute :name, predicate: NS.foaf[:name]
end
