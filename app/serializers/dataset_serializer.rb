# frozen_string_literal: true

class DatasetSerializer < LinkedSerializer
  attribute :title, predicate: NS::DC.title
  attribute :description, predicate: NS::DC.description
  attribute :license_description, predicate: LinkedRails.app_ns[:licenseDescription]
  attribute :updated_at, predicate: NS::DC.modified
  attribute :iri, predicate: NS::DC.identifier
  attribute :publisher, predicate: NS::DC.publisher do
    RDF::URI('https://dexpods.eu')
  end
  attribute :themes, predicate: NS::DCAT[:theme]

  enum :license, predicate: NS::DC.license, options: EnumHelper.list_options('licenses')

  has_one :web_id, predicate: NS::DONL[:authority]
  has_many :distributions, predicate: NS::DCAT[:distribution]
end
