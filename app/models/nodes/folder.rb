# frozen_string_literal: true

class Folder < Node
  enhance LinkedRails::Enhancements::Actionable
  enhance LinkedRails::Enhancements::Creatable
  enhance LinkedRails::Enhancements::Indexable
  enhance LinkedRails::Enhancements::Tableable

  with_columns default: [
    NS::SCHEMA[:name]
  ]

  def title
    super || ''
  end

  def icon
    RDF::URI('http://fontawesome.io/icon/folder-o')
  end

  def folder?
    true
  end

  class << self
    def default_collection_display
      :table
    end
  end
end
