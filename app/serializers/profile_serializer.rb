# frozen_string_literal: true

class ProfileSerializer < LinkedSerializer
  attribute :display_name,
            predicate: NS.foaf.name
  attribute :email,
            predicate: NS.foaf.mbox,
            if: lambda { |record, context|
              !context[:scope].guest? && context[:scope].pod&.web_id&.email == record.email
            }
  has_one :root_node,
          predicate: NS.dex[:rootFolder]
  has_one :owner_agreement_collection,
          predicate: NS.dex[:ownerAgreements]
  has_one :recipient_agreement_collection,
          predicate: NS.dex[:recipientAgreements]
end
