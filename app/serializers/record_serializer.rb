# frozen_string_literal: true

class RecordSerializer < LinkedSerializer
  include LinkedRails::Serializer

  attribute :display_name, predicate: NS::SCHEMA[:name]
  attribute :created_at, predicate: NS::SCHEMA[:dateCreated]
  attribute :updated_at, predicate: NS::SCHEMA[:dateModified]
  attribute :_destroy, predicate: NS::ONTOLA[:_destroy], if: method(:never)
end
