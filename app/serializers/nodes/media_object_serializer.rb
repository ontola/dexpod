# frozen_string_literal: true

class MediaObjectSerializer < NodeSerializer
  extend LinkedRails::Helpers::OntolaActionsHelper

  class << self
    def copy_action_statements(object, _params) # rubocop:disable Metrics/AbcSize
      action_iri = ontola_copy_action(object.iri)
      target_iri = RDF::URI("#{action_iri}#entrypoint")
      [
        RDF::Statement.new(action_iri, RDF[:type], NS::ARGU[:CopyAction]),
        RDF::Statement.new(action_iri, NS::SCHEMA.name, I18n.t('menus.default.copy')),
        RDF::Statement.new(action_iri, NS::SCHEMA.target, target_iri),
        RDF::Statement.new(target_iri, RDF[:type], NS::SCHEMA.EntryPoint),
        RDF::Statement.new(target_iri, NS::SCHEMA.name, I18n.t('menus.default.copy')),
        RDF::Statement.new(target_iri, NS::SCHEMA.image, RDF::URI('http://fontawesome.io/icon/clipboard'))
      ]
    end
  end

  attribute :rdf_type, predicate: RDF[:type] do |object|
    if object.type == 'image'
      NS::SCHEMA[:ImageObject]
    elsif object.type == 'video'
      NS::SCHEMA[:VideoObject]
    else
      NS::SCHEMA[:MediaObject]
    end
  end
  attribute :content_type,
            predicate: NS::SCHEMA[:encodingFormat],
            datatype: NS::XSD[:string] do |object|
    object.content_type unless object.type == 'video'
  end
  attribute :uploaded_at,
            predicate: NS::SCHEMA[:uploadDate],
            &:created_at
  # attribute :description, predicate: NS::SCHEMA[:caption]
  # attribute :embed_url, predicate: NS::SCHEMA[:embedUrl]
  attribute :filename, predicate: NS::DBO[:filename]
  # attribute :remote_content_url,
  #           predicate: NS::ARGU[:remoteContentUrl],
  #           datatype: NS::XSD[:string], &:remote_url
  # attribute :thumbnail, predicate: NS::SCHEMA[:thumbnail] do |object|
  #   object.url_for_variant('thumbnail')
  # end
  # attribute :copy_url, predicate: NS::ARGU[:copyUrl] do |object|
  #   ontola_copy_action(object.iri)
  # end
  # enum :content_source, predicate: NS::ARGU[:contentSource]
  statements :copy_action_statements

  # MediaObjectUploader::IMAGE_VERSIONS.each do |format, opts|
  #   attribute format, predicate: NS::ONTOLA[:"imgUrl#{opts[:w]}x#{opts[:h]}"] do |object|
  #     object.url_for_variant(format)
  #   end
  # end
end
