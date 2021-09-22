# frozen_string_literal: true

class MediaObjectSerializer < NodeSerializer
  extend LinkedRails::Helpers::OntolaActionsHelper

  class << self
    def copy_action_statements(object, _params) # rubocop:disable Metrics/AbcSize
      action_iri = ontola_copy_action(object.iri)
      target_iri = RDF::URI("#{action_iri}#entrypoint")
      [
        RDF::Statement.new(action_iri, RDF[:type], NS.argu[:CopyAction]),
        RDF::Statement.new(action_iri, NS.schema.name, I18n.t('menus.default.copy')),
        RDF::Statement.new(action_iri, NS.schema.target, target_iri),
        RDF::Statement.new(target_iri, RDF[:type], NS.schema.EntryPoint),
        RDF::Statement.new(target_iri, NS.schema.name, I18n.t('menus.default.copy')),
        RDF::Statement.new(target_iri, NS.schema.image, RDF::URI('http://fontawesome.io/icon/clipboard'))
      ]
    end
  end

  attribute :rdf_type, predicate: RDF[:type] do |object|
    if object.type == 'image'
      NS.schema[:ImageObject]
    elsif object.type == 'video'
      NS.schema[:VideoObject]
    else
      NS.schema[:MediaObject]
    end
  end
  attribute :content_size,
            predicate: NS.schema[:contentSize],
            datatype: NS.xsd.string
  attribute :content_type,
            predicate: NS.schema[:encodingFormat],
            datatype: NS.xsd.string do |object|
    object.content_type unless object.type == 'video'
  end
  attribute :uploaded_at,
            predicate: NS.schema[:uploadDate],
            &:created_at
  # attribute :description, predicate: NS.schema[:caption]
  # attribute :embed_url, predicate: NS.schema[:embedUrl]
  attribute :filename, predicate: NS.dbo[:filename]
  # attribute :remote_content_url,
  #           predicate: NS.argu[:remoteContentUrl],
  #           datatype: NS.xsd.string, &:remote_url
  # attribute :thumbnail, predicate: NS.schema[:thumbnail] do |object|
  #   object.url_for_variant('thumbnail')
  # end
  # attribute :copy_url, predicate: NS.argu[:copyUrl] do |object|
  #   ontola_copy_action(object.iri)
  # end
  # enum :content_source, predicate: NS.argu[:contentSource]
  statements :copy_action_statements

  # MediaObjectUploader::IMAGE_VERSIONS.each do |format, opts|
  #   attribute format, predicate: NS.ontola[:"imgUrl#{opts[:w]}x#{opts[:h]}"] do |object|
  #     object.url_for_variant(format)
  #   end
  # end
end
