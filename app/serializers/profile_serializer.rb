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
  has_one :offer_collection,
          predicate: NS.dex[:offers]
  has_one :owner_agreement_collection,
          predicate: NS.dex[:ownerAgreements]
  has_one :recipient_agreement_collection,
          predicate: NS.dex[:recipientAgreements]
  has_one :pod, predicate: NS.space[:storage] do |object|
    object.pod&.home_iri
  end
end
