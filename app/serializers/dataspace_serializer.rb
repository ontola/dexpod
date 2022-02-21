# frozen_string_literal: true

class DataspaceSerializer < LinkedSerializer
  attribute :title, predicate: NS.schema.name
  attribute :intro_text, predicate: NS.schema.text
  attribute :updated_at, predicate: NS.schema.dateModified
  attribute :created_at, predicate: NS.schema.dateCreated
  attribute :url, predicate: NS.skos.exactMatch
end
