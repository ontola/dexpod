# frozen_string_literal: true

class ProfileSerializer < LinkedSerializer
  attribute :email, predicate: NS::FOAF[:name]
end
