# frozen_string_literal: true

class Profile
  include ActiveModel::Model
  include LinkedRails::Model

  attr_accessor :web_id
  delegate :email, :display_name, :offer_collection, :owner_agreement_collection, :pod, :recipient_agreement_collection,
           to: :web_id
  delegate :root_node, to: :pod

  def iri
    @iri ||= RDF::URI("#{document_iri}#me")
  end

  def document_iri
    @document_iri ||= RDF::URI("#{web_id.pod.iri}/profile")
  end

  class << self
    def iri
      NS.foaf[:Person]
    end

    def requested_singular_resource(_params, _user_context)
      RootHelper.current_pod&.web_id&.profile
    end

    def singular_route_key
      :profile
    end
  end
end
