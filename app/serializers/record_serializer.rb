# frozen_string_literal: true

class RecordSerializer < LinkedSerializer
  include LinkedRails::Serializer

  attribute :display_name, predicate: NS.schema[:name]
  attribute :created_at, predicate: NS.schema[:dateCreated]
  attribute :updated_at, predicate: NS.schema[:dateModified]
  attribute :_destroy, predicate: NS.ontola[:_destroy], if: method(:never)
end
