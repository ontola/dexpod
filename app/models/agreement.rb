# frozen_string_literal: true

class Agreement < ApplicationRecord
  include Invalidatable

  enhance LinkedRails::Enhancements::Creatable
  enhance LinkedRails::Enhancements::Indexable
  enhance LinkedRails::Enhancements::Tableable

  belongs_to :assignee,
             class_name: 'User',
             foreign_key: :user_id,
             inverse_of: :agreements
  belongs_to :invite
  has_one :offer, through: :invite
  has_one :assigner, class_name: 'User', through: :offer, source: :user
  has_one :node, through: :offer

  delegate :email, to: :invite

  with_columns default: [
    NS::SCHEMA[:image],
    NS::SCHEMA[:name],
    NS::DEX[:assignee],
    NS::DEX[:dateSigned]
  ]

  def file_icon
    offer.node.icon
  end

  def file_name
    offer.node.display_name
  end

  class << self
    def default_collection_display
      :table
    end
  end
end
