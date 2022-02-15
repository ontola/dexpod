# frozen_string_literal: true

require 'types/file_type'

class MediaObject < Node
  ARCHIVE_TYPES = %w[application/gzip application/vnd.rar application/x-7z-compressed application/x-bzip2
                     application/x-compress application/x-gtar application/x-lzip application/x-lzma
                     application/zip].freeze
  AUDIO_TYPES = %w[audio/mpeg audio/mp4 audio/m4a audio/ogg audio/aac].freeze
  DOCUMENT_TYPES = %w[application/msword application/vnd.openxmlformats-officedocument.wordprocessingml.document
                      application/vnd.oasis.opendocument.text application/epub+zip text/plain].freeze
  IMAGE_TYPES = %w[image/jpeg image/png image/webp image/svg+xml].freeze
  PORTABLE_DOCUMENT_TYPES = %w[application/pdf].freeze
  PRESENTATION_TYPES = %w[application/vnd.oasis.opendocument.presentation application/powerpoint
                          application/vnd.openxmlformats-officedocument.presentationml.presentation
                          application/vnd.openxmlformats-officedocument.presentationml.slideshow].freeze
  SPREADSHEET_TYPES = %w[text/csv application/excel application/vnd.ms-excel
                         application/vnd.openxmlformats-officedocument.spreadsheetml.sheet
                         text/comma-separated-values application/vnd.oasis.opendocument.spreadsheet].freeze
  CONTENT_TYPES = ARCHIVE_TYPES +
    AUDIO_TYPES +
    DOCUMENT_TYPES +
    PORTABLE_DOCUMENT_TYPES +
    IMAGE_TYPES +
    PRESENTATION_TYPES +
    SPREADSHEET_TYPES

  enhance LinkedRails::Enhancements::Creatable

  has_one_attached :content
  with_columns default: [
    NS.schema[:uploadDate],
    NS.argu[:copyUrl]
  ]

  attribute :content, FileType.new
  attribute :filename
  attribute :content_type

  enum content_source: {local: 0, remote: 1}

  alias_attribute :display_name, :filename
  alias content_url= content=

  with_columns default: [
    NS.schema[:name]
  ]

  def content_url
    return unless persisted?

    url = Rails.application.routes.url_helpers.rails_blob_path(
      content,
      only_path: true
    )
    LinkedRails.iri(path: url)
  end

  def filename
    content.filename if content.present?
  end

  def content_size
    content.byte_size if content.present?
  end

  def content_type
    content.content_type if content.present?
  end

  def icon # rubocop:disable Metrics/MethodLength, Metrics/CyclomaticComplexity
    case content_type
    when %r{image/[\w+]+}
      RDF::URI('http://fontawesome.io/icon/file-image-o')
    when %r{video/[\w+]+}
      RDF::URI('http://fontawesome.io/icon/file-video-o')
    when %r{audio/[\w+]+}
      RDF::URI('http://fontawesome.io/icon/file-audio-o')
    when *PORTABLE_DOCUMENT_TYPES
      RDF::URI('http://fontawesome.io/icon/file-pdf-o')
    when *DOCUMENT_TYPES
      RDF::URI('http://fontawesome.io/icon/file-word-o')
    when *ARCHIVE_TYPES
      RDF::URI('http://fontawesome.io/icon/file-archive-o')
    when *SPREADSHEET_TYPES
      RDF::URI('http://fontawesome.io/icon/file-excel-o')
    when *PRESENTATION_TYPES
      RDF::URI('http://fontawesome.io/icon/file-powerpoint-o')
    else
      RDF::URI('http://fontawesome.io/icon/file-o')
    end
  end

  def type
    content_type&.split('/')&.first
  end

  def url_for_variant(_variant = nil)
    RDF::DynamicURI(Rails.application.routes.url_helpers.url_for(content, only_path: true))
  end

  class << self
    def iri
      NS.schema[:MediaObject]
    end
  end
end
