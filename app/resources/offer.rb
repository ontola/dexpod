# frozen_string_literal: true

class Offer < Broker::Resource
  class Condition < Broker::Resource
  end

  with_columns default: [
    NS.app[:file],
    NS.app[:dataOwner],
    NS.app[:recipients]
  ]

  def data_owner
    RDF::URI(super) if super.present?
  end

  def name
    LinkedRails.translate(:class, :label, self.class.iri)
  end

  def broker_url
    RDF::URI(element_url)
  end

  def parent
    return unless local_resource?

    node = LinkedRails.iri_mapper.resource_from_iri(resource, nil)

    (node.datasets.any? ? node.datasets.first : node).iri if node
  end

  def resource
    RDF::URI(super) if super.present?
  end

  def recipient
    RDF::URI(super) if super.present?
  end

  private

  def local_resource?
    resource.host == LinkedRails.iri.host
  end
end
