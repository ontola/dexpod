# frozen_string_literal: true

class Distribution < ApplicationRecord
  include Invalidatable

  belongs_to :dataset
  belongs_to :node, optional: true

  attribute :format, LinkedRails::Types::IRI.new
  attribute :offer_iri, LinkedRails::Types::IRI.new
  attribute :access_url, LinkedRails::Types::IRI.new

  delegate :dataspace, :dataspace_uri, :license, :description, :user, to: :dataset
  after_commit :schedule_offer_job, on: :create

  def format
    super || format_from_content_type
  end

  def offer
    return if offer_iri.blank?

    offer_id = offer_iri.to_s.split('/').last

    LinkedRails.iri(path: Offer.iri_template.expand(id: offer_id))
  end

  def title
    super || dataset&.title
  end

  private

  def format_from_content_type # rubocop:disable Metrics/AbcSize
    options = DistributionSerializer.enum_options(:format)
    return options.keys.detect { |k| k.to_s.split('/').last == 'HTML' } if node&.is_a?(Folder)

    return unless node&.content_type

    options.keys.detect { |k| k.to_s.split('/').last == node.content_type.split('/').last.upcase }
  end

  def schedule_offer_job
    CreateOfferJob.perform_later(id)
  end
end
