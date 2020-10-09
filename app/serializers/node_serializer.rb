# frozen_string_literal: true

class NodeSerializer < RecordSerializer
  has_one :parent,
          predicate: NS::SCHEMA[:isPartOf]
  has_one :quick_actions,
          predicate: NS::ONTOLA[:quickActions]

  attribute :content_url,
            predicate: NS::SCHEMA[:contentUrl]
  attribute :icon,
            predicate: NS::SCHEMA[:image]
end
