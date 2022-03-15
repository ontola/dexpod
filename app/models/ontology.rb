# frozen_string_literal: true

class Ontology < LinkedRails::Ontology
  def properties
    super + [
      LinkedRails::Ontology::Property.new(iri: NS.app[:customLicense])
    ]
  end
end
