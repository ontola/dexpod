# frozen_string_literal: true

class Distribution < ApplicationRecord
  include Invalidatable

  belongs_to :dataset
  belongs_to :node

  attribute :format, IRIType.new

  delegate :title, to: :node
  delegate :license, :description, to: :dataset

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
end
