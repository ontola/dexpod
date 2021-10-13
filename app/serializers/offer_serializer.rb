# frozen_string_literal: true

class OfferSerializer < LinkedSerializer
  attribute :data_owner, predicate: NS.app[:dataOwner]
  attribute :name, predicate: NS.schema.name
  attribute :parent, predicate: NS.schema.isPartOf
  attribute :resource, predicate: NS.app[:file]
  attribute :recipient, predicate: NS.app[:recipients]
  attribute :permitted, predicate: NS.app[:permitted]
  attribute :scope, predicate: NS.app[:scope]
  attribute :based_on, predicate: NS.app[:basedOn]
  attribute :source_template, predicate: NS.app[:sourceTemplate]
  attribute :updated_at, predicate: NS.schema.dateModified
  attribute :broker_url, predicate: NS.app[:brokerUrl]
end
