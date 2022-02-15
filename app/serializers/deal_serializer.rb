# frozen_string_literal: true

class DealSerializer < LinkedSerializer
  attribute :offer, predicate: NS.schema.isPartOf
  attribute :name, predicate: NS.schema.name
  attribute :data_owner, predicate: NS.app[:dataOwner]
  attribute :broker_url, predicate: NS.app[:brokerUrl]
  attribute :resource, predicate: NS.app[:file]
  attribute :recipient, predicate: NS.app[:recipients]
  attribute :signature, predicate: NS.app[:signature]
  attribute :updated_at, predicate: NS.schema.dateModified
  attribute :created_at, predicate: NS.schema.dateCreated
  # has_many :commitments, predicate: NS.app[:commitments]
end
