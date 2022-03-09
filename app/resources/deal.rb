# frozen_string_literal: true

class Deal < Broker::Resource
  collection_options(
    display: :table,
    title: lambda do
      web_id = RootHelper.current_pod&.web_id&.profile&.iri
      return I18n.t('deals.shared_with_me') if filter[NS.app[:recipients]] == [web_id]
      return I18n.t('deals.shared_with_others') if filter[NS.app[:dataOwner]] == [web_id]

      I18n.t('dex.Agreement.plural_label')
    end
  )

  with_columns(
    default: [
      NS.app[:file],
      NS.app[:dataOwner],
      NS.schema.dateCreated,
      NS.app[:brokerUrl]
    ],
    owner: [
      NS.app[:file],
      NS.app[:recipients],
      NS.schema.dateCreated,
      NS.app[:brokerUrl]
    ]
  )

  def data_owner
    RDF::URI(super) if super.present?
  end

  def broker_url
    RDF::URI(element_url)
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
