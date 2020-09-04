# frozen_string_literal: true

class AgreementSerializer < LinkedSerializer
  attribute :created_at, predicate: NS::DEX[:dateSigned]
  has_one :offer, predicate: NS::DEX[:offer]
  has_one :assignee, predicate: NS::DEX[:assignee]
  has_one :assigner, predicate: NS::DEX[:assigner]
  attribute :email, predicate: NS::DEX[:assigneeMail]
end
