# frozen_string_literal: true

class Distribution < ApplicationRecord
  include Invalidatable

  belongs_to :dataset
  belongs_to :node

  attribute :format, IRIType.new
  attribute :offer_iri, IRIType.new

  delegate :title, to: :dataset
  delegate :license, :description, :user, to: :dataset
  after_commit :schedule_offer_job, on: :create

  def format
    super || format_from_content_type
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
