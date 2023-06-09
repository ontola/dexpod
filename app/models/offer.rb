# frozen_string_literal: true

class Offer < ApplicationRecord
  enhance LinkedRails::Enhancements::Actionable
  enhance LinkedRails::Enhancements::Creatable
  enhance LinkedRails::Enhancements::Indexable

  has_many :rules,
           dependent: :destroy
  has_many :obligations,
           dependent: :destroy
  has_many :permissions,
           dependent: :destroy
  has_many :prohibitions,
           dependent: :destroy
  has_many :recipients,
           dependent: :destroy
  has_many :invites,
           dependent: :destroy
  belongs_to :user
  belongs_to :node,
             foreign_key: :node_id,
             inverse_of: :offers

  with_collection :invites
  with_collection :rules
  with_collection :obligations
  with_collection :permissions
  with_collection :prohibitions

  accepts_nested_attributes_for :node
  accepts_nested_attributes_for :invites

  attr_accessor :rule_sets, :attribution_description, :contains_private_description

  before_save :build_rules

  enum rule_sets: {contains_private: 0, edit: 1, share: 2, attribution: 3}

  def node_attributes=(attrs)
    attrs[:parent] ||= current_pod&.root_node
    attrs[:type] = 'MediaObject' if attrs.key?(:content_url)
    super
  end

  private

  def build_rules # rubocop:disable Metrics/AbcSize, Metrics/MethodLength
    sets = rule_sets.is_a?(Array) ? rule_sets : [rule_sets]
    sets.each do |set|
      case set
      when 'contains_private'
        rules << Permission.contains_private.new(offer: self, description: contains_private_description)
      when 'edit'
        rules << Permission.edit.new(offer: self)
      when 'share'
        rules << Permission.share.new(offer: self)
      when 'attribution'
        rules << Obligation.attribution.new(offer: self, description: attribution_description)
      end
    end
  end

  class << self
    def includes_for_serializer
      super.merge(node: {})
    end

    def route_key
      'offers'
    end
  end
end
