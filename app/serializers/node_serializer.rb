# frozen_string_literal: true

class NodeSerializer < RecordSerializer
  attribute :parent,
            predicate: NS.schema[:isPartOf] do |object|
    object.parent&.iri
  end
  attribute :quick_actions,
            predicate: NS.ontola[:quickActions]

  attribute :content_url,
            predicate: NS.schema[:contentUrl]
  attribute :icon,
            predicate: NS.schema[:image]
  attribute :type,
            predicate: NS.dex[:nodeType]
  attribute :payment_pointer,
            predicate: NS.dex[:paymentPointer]
end
