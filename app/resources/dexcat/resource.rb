# frozen_string_literal: true

module Dexcat
  class Resource < ActiveResource::Base
    include LinkedRails::Model
    self.include_format_in_path = false
    self.prefix = '/api/dexes-'
    self.site = Rails.application.config.dexcat_url&.sub('https://', 'https://api.')
    self.collection_parser = Dexcat::CollectionParser
    headers['Accept'] = 'application/json'

    def assign_attributes(_); end

    def iri(**opts)
      super
    end

    def load(attributes, remove_root = false, persisted = false)
      super(attributes.transform_keys(&method(:sanitize_key)), remove_root, persisted)
    end

    def to_param
      id
    end

    private

    def sanitize_key(key)
      key.to_s.underscore.sub('uri', 'url')
    end

    class << self
      def requested_single_resource(params, _user_context)
        find(params[:id]) if params.key?(:id)
      end
    end
  end
end
