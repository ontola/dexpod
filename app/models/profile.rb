# frozen_string_literal: true

class Profile
  include ActiveModel::Model
  include LinkedRails::Model

  attr_accessor :user
  delegate :email, to: :user

  def iri
    @iri ||= RDF::URI("#{document_iri}#me")
  end

  def document_iri
    @document_iri ||= RDF::URI("#{user.pod.iri}/profile")
  end

  class << self
    def iri
      NS::FOAF[:Person]
    end
  end
end
