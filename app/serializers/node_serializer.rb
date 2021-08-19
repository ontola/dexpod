# frozen_string_literal: true

class NodeSerializer < RecordSerializer
  has_one :parent,
          predicate: NS.schema[:isPartOf]
  has_one :quick_actions,
          predicate: NS.ontola[:quickActions]

  attribute :content_url,
            predicate: NS.schema[:contentUrl]
  attribute :icon,
            predicate: NS.schema[:image]
end
