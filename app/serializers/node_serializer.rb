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
  attribute :shared_with_iri, predicate: NS.dex[:sharedWith]
  has_one :publish_action, predicate: NS.dex[:publishAction] do |object|
    if object.datasets.any?
      object.datasets.first
    else
      object.dataset_collection.action(:create)
    end
  end
end
