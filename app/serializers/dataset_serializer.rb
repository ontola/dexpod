# frozen_string_literal: true

class DatasetSerializer < LinkedSerializer
  attribute :title, predicate: NS.dc.title
  attribute :description, predicate: NS.dc.description
  attribute :license_description, predicate: NS.app[:licenseDescription]
  attribute :updated_at, predicate: NS.dc.modified
  attribute :iri, predicate: NS.dc.identifier
  attribute :publisher, predicate: NS.dc.publisher do
    RDF::URI('https://dexpods.eu')
  end
  attribute :themes, predicate: NS.dcat[:theme]
  attribute :web_id, predicate: NS.donl[:authority] do |object|
    RDF::URI(object.web_id.identifier) if object.web_id
  end

  enum :license, predicate: NS.dc.license, options: EnumHelper.list_options('licenses')

  has_many :distributions, predicate: NS.dcat[:distribution]
end
