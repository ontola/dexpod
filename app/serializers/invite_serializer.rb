# frozen_string_literal: true

class InviteSerializer < LinkedSerializer
  attribute :email, predicate: NS::SCHEMA[:email]
  attribute :assigner_email, predicate: NS::DEX[:assigner]
  has_one :offer, predicate: NS::DEX[:offer]
end
