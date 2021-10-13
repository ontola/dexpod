# frozen_string_literal: true

class DistributionSerializer < LinkedSerializer
  attribute :title, predicate: NS.dc.title
  attribute :description, predicate: NS.dc.description
  attribute :license, predicate: NS.dc.license
  attribute :offer, predicate: NS.dex[:offer]
  enum :format, predicate: NS.dc.format, options: EnumHelper.list_options('formats')

  has_one :node, predicate: NS.dcat[:accessURL]
end
