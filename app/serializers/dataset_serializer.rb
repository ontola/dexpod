# frozen_string_literal: true

class DatasetSerializer < LinkedSerializer
  has_one :part_of, predicate: NS.schema.isPartOf
  attribute :title, predicate: NS.dc.title
  attribute :description, predicate: NS.dc.description
  attribute :license_description, predicate: NS.app[:licenseDescription]
  attribute :updated_at, predicate: NS.dc.modified
  attribute :iri, predicate: NS.dc.identifier do |object|
    object.iri unless object.anonymous_iri?
  end
  attribute :publisher, predicate: NS.dc.publisher do
    RDF::URI('https://dexpods.eu')
  end
  attribute :themes, predicate: NS.dcat[:theme]
  attribute :dexes_resolve, predicate: NS.dex[:resolve] do |object|
    RDF::URI("#{Rails.application.config.dexcat_url}/resolve?uri=#{CGI.escape(object.iri.to_s)}")
  end
  attribute :web_id, predicate: NS.donl[:authority] do |object|
    RDF::URI(object.web_id.identifier) if object.web_id
  end
  with_collection :conditions, predicate: NS.dex[:conditions]
  Condition.types.each do |klass|
    has_one klass.name.underscore.to_sym, predicate: NS.dex[klass.name.camelize(:lower)]
  end
  enum :license, predicate: NS.dc.license, options: EnumHelper.list_options('licenses')

  has_many :distributions, predicate: NS.dcat[:distribution]
end
