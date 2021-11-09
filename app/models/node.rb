# frozen_string_literal: true

# A place in a hierarchy of {Resource}s
class Node < ApplicationRecord
  include Invalidatable

  enhance LinkedRails::Enhancements::Updatable
  enhance LinkedRails::Enhancements::Destroyable
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

  collection_options(display: :table)
  with_collection :datasets
  with_collection :nodes,
                  default_sortings: [
                    {key: :created_at, direction: :desc}
                  ]
  with_collection :media_objects
  with_collection :folders

  with_columns default: [
    NS.schema[:image],
    NS.schema[:name],
    NS.schema[:dateCreated],
    NS.schema[:dateModified],
    NS.ontola[:quickActions]
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

  def quick_actions
    @quick_actions ||= menu(:quick).menu_sequence_iri
  end

  def root_object?
    parent_id.nil?
  end

  class << self
    def attributes_for_new(opts)
      {
        parent: opts[:parent]
      }
    end

    def inherited(klass)
      klass.enhance LinkedRails::Enhancements::Creatable
      super
    end

    def sort_options(collection)
      return super if collection.type == :infinite

      [
        NS.dex[:nodeType],
        NS.schema.name,
        NS.schema.dateCreated,
        NS.schema.dateModified
      ]
    end
  end
end

Dir["#{Rails.application.config.root}/app/models/nodes/*.rb"].each { |file| require_dependency file }
