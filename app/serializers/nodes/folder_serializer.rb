# frozen_string_literal: true

class FolderSerializer < NodeSerializer
  has_one :parent,
          predicate: NS.schema[:isPartOf] do |object|
    object.parent || LinkedRails.iri
  end

  with_collection :nodes, predicate: NS.dex[:entries]
end
