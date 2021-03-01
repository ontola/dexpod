# frozen_string_literal: true

class DistributionSerializer < LinkedSerializer
  attribute :title, predicate: NS::DC.title
  attribute :description, predicate: NS::DC.description
  attribute :license, predicate: NS::DC.license
  enum :format, predicate: NS::DC.format, options: EnumHelper.list_options('formats')

  has_one :node, predicate: NS::DCAT[:accessURL]
end
