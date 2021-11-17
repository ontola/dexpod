# frozen_string_literal: true

class DistributionSerializer < LinkedSerializer
  has_one :dataset, predicate: NS.schema.isPartOf
  attribute :title, predicate: NS.dc.title
  attribute :description, predicate: NS.dc.description
  attribute :license, predicate: NS.dc.license
  attribute :offer, predicate: NS.dex[:offer]
  enum :format, predicate: NS.dc.format, options: EnumHelper.list_options('formats')
  attribute :resolved_access_url, predicate: NS.dcat[:accessURL] do |object|
    object.node&.iri || object.access_url
  end
  attribute :access_url, predicate: NS.app[:accessURL]
  has_one :node, predicate: NS.app[:nodeId]
end
