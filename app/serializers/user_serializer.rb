# frozen_string_literal: true

class UserSerializer < LinkedSerializer
  attribute :name, predicate: NS.foaf[:name]
  attribute :dex_identity, predicate: NS.dex[:webId] do |object|
    identifier = object.dex_identity&.identifier

    RDF::URI(identifier) if identifier
  end
end
