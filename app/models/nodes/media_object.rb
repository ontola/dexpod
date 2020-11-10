# frozen_string_literal: true

require 'types/file_type'

class MediaObject < Node
  ARCHIVE_TYPES = %w[application/gzip application/vnd.rar application/x-7z-compressed application/x-bzip2
                     application/x-compress application/x-gtar application/x-lzip application/x-lzma
                     application/zip].freeze
  DOCUMENT_TYPES = %w[application/msword application/vnd.openxmlformats-officedocument.wordprocessingml.document
                      application/vnd.oasis.opendocument.text application/epub+zip text/plain].freeze
  PORTABLE_DOCUMENT_TYPES = %w[application/pdf].freeze
  PRESENTATION_TYPES = %w[application/vnd.oasis.opendocument.presentation application/powerpoint
                          application/vnd.openxmlformats-officedocument.presentationml.presentation
                          application/vnd.openxmlformats-officedocument.presentationml.slideshow].freeze
  SPREADSHEET_TYPES = %w[text/csv application/excel application/vnd.openxmlformats-officedocument.spreadsheetml.sheet
                         text/comma-separated-values application/vnd.oasis.opendocument.spreadsheet].freeze

  enhance LinkedRails::Enhancements::Actionable
  enhance LinkedRails::Enhancements::Menuable
  enhance LinkedRails::Enhancements::Creatable
  enhance LinkedRails::Enhancements::Tableable

  has_one_attached :content
  with_columns default: [
    # NS::DBO[:filename],
    NS::SCHEMA[:uploadDate],
    NS::ARGU[:copyUrl]
  ]

  attribute :content, FileType.new

  # attribute :content, FileType.new
  # validates :url, presence: true

  # validates_integrity_of :content
  # validates_processing_of :content
  # validates_download_of :content

  enum content_source: {local: 0, remote: 1}

  # delegate :file, :icon, :avatar, :is_image?, to: :content
  #
  # attr_writer :content_source
  #
  # before_save :set_file_name
  # before_save :set_publisher_and_creator

  alias_attribute :display_name, :filename
  alias content_url= content=

  with_columns default: [
    NS::SCHEMA[:name]
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

  # def allowed_content_types
  #   content.content_type_white_list
  # end
  #
  # def content=(val)
  #   super unless val.is_a?(String)
  # end
  #
  # def content_source
  #   remote_url.present? ? :remote : :local
  # end

  def content_type
    content.content_type if content.present?
    # rescue Aws::S3::Errors::NotFound
    #   Bugsnag.notify(RuntimeError.new("Aws::S3::Errors::NotFound: #{id}")) unless Rails.env.staging?
    #   nil
  end

  # def content_type=(val); end
  #
  # delegate :embed_url, to: :video_info, allow_nil: true
  #
  # def remote_content_url=(url)
  #   self.remote_url = url
  #   video_info ? super(video_info.thumbnail) : super
  # end

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

  # def url(*args)
  #   RDF::DynamicURI(type == 'video' ? remote_url : content.url(*args)).presence
  # end

  def url_for_variant(_variant = nil)
    RDF::DynamicURI(Rails.application.routes.url_helpers.url_for(content, only_path: true))
  end

  # private
  #
  # def set_file_name
  #   if video_info
  #     self.filename = video_info.title
  #   elsif content&.file.try(:original_filename).present?
  #     self.filename = content.file.original_filename
  #   end
  # end
  #
  # def set_publisher_and_creator
  #   if creator.nil? && creator_id.nil? && about.present?
  #     self.creator = about.is_a?(Edge) ? about.creator : about.profile
  #   end
  #   return if publisher.present? || publisher_id.present?
  #
  #   self.publisher = about.is_a?(Edge) ? about.publisher : creator.profileable
  # end
  #
  # def url_for_environment(type)
  #   url = content.url(type)
  #   return url && RDF::DynamicURI(url) if ENV['AWS_ID'].present? || url&.to_s&.include?('gravatar.com')
  #   return if content.file.blank?
  #
  #   if File.exist?(content.file.path)
  #     RDF::DynamicURI(content.url(:icon))
  #   else
  #     path = icon.path.gsub(File.expand_path(content.root), '')
  #     RDF::DynamicURI("#{Rails.application.config.aws_url}#{path}")
  #   end
  # end
  #
  # def video_info
  #   return unless remote_url.present? && VideoInfo.usable?(remote_url)
  #
  #   @video_info ||= VideoInfo.new(remote_url)
  # end

  class << self
    def iri
      NS::SCHEMA[:MediaObject]
    end
    # def content_type_white_list
    #   ARCHIVE_TYPES +
    #     MediaObjectUploader::DOCUMENT_TYPES +
    #     MediaObjectUploader::IMAGE_TYPES +
    #     MediaObjectUploader::PORTABLE_DOCUMENT_TYPES +
    #     MediaObjectUploader::PRESENTATION_TYPES +
    #     MediaObjectUploader::SPREADSHEET_TYPES
    # end
    #
    # def default_collection_display
    #   :table
    # end
  end
end
