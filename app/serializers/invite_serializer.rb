# frozen_string_literal: true

class InviteSerializer < LinkedSerializer
  attribute :email, predicate: NS::SCHEMA[:email]
  attribute :name, predicate: NS::SCHEMA[:name]
  has_one :offer, predicate: NS::DEX[:offer]
end
