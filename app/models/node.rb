# frozen_string_literal: true

# A place in a hierarchy of {Resource}s
class Node < ApplicationRecord
  include Invalidatable

  enhance LinkedRails::Enhancements::Actionable
  enhance LinkedRails::Enhancements::Indexable
  enhance LinkedRails::Enhancements::Updatable
  enhance LinkedRails::Enhancements::Destroyable
  enhance LinkedRails::Enhancements::Tableable
  enhance Distributable

  belongs_to :parent,
             class_name: 'Folder',
             inverse_of: :nodes
  has_many :nodes,
           class_name: 'Node',
           inverse_of: :parent,
           foreign_key: :parent_id,
           dependent: false
  has_many :media_objects,
           inverse_of: :parent,
           foreign_key: :parent_id,
           dependent: :destroy
  has_many :folders,
           inverse_of: :parent,
           foreign_key: :parent_id,
           dependent: :destroy
  has_many :distributions,
           dependent: :destroy
  has_many :datasets,
           through: :distributions

  has_ltree_hierarchy

  with_collection :nodes,
                  default_sortings: [
                    {key: :type, direction: :asc}
                  ]
  with_collection :media_objects
  with_collection :folders

  with_columns default: [
    NS::SCHEMA[:image],
    NS::SCHEMA[:name],
    NS::SCHEMA[:dateCreated],
    NS::SCHEMA[:dateModified],
    NS::ONTOLA[:quickActions]
  ]

  alias_attribute :display_name, :title

  validates :parent,
            presence: true,
            unless: :root_object?

  def content_url; end

  def content_url=(_val); end

  def folder?
    false
  end

  def quick_actions # rubocop:disable Metrics/AbcSize
    @quick_actions ||= LinkedRails::Sequence.new([
      action(:update)&.iri,
      action(:destroy)&.iri,
      datasets.any? ? datasets.first.action(:update)&.iri : dataset_collection.action(:create)&.iri
    ].compact)
  end

  def root_object?
    parent_id.nil?
  end

  class << self
    def default_collection_display
      :table
    end

    def inherited(klass)
      klass.enhance LinkedRails::Enhancements::Creatable
      super
    end

    def preview_includes
      super + [:quick_actions]
    end

    def sort_options(collection)
      return super if collection.type == :infinite

      [
        NS::SCHEMA[:image],
        NS::SCHEMA[:name]
      ]
    end
  end
end

Dir["#{Rails.application.config.root}/app/models/nodes/*.rb"].each { |file| require_dependency file }
