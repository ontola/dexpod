# frozen_string_literal: true

class Deal < BrokerResource
  def data_owner
    RDF::URI(super) if super.present?
  end

  def broker_url
    RDF::URI(element_url.sub('deals', 'deal'))
  end

  def name
    LinkedRails.translate(:class, :label, self.class.iri)
  end

  def offer
    LinkedRails.iri(path: "/offers/#{super}")
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

  class << self
    def iri
      NS.app[:Agreement]
    end
  end
end
