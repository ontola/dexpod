# frozen_string_literal: true

class OfferSerializer < LinkedSerializer
  attribute :data_owner, predicate: NS.app[:dataOwner]
  attribute :name, predicate: NS.schema.name
  attribute :parent, predicate: NS.schema.isPartOf
  attribute :resource, predicate: NS.app[:file]
  attribute :recipient, predicate: NS.app[:recipients]
  attribute :updated_at, predicate: NS.schema.dateModified
  attribute :created_at, predicate: NS.schema.dateCreated
  attribute :broker_url, predicate: NS.app[:brokerUrl]
  # has_many :conditions, predicate: NS.app[:conditions]
end
