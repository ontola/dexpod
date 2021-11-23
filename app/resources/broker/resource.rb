# frozen_string_literal: true

module Broker
  class Resource < ActiveResource::Base
    include LinkedRails::Model

    collection_options(
      collection_class: Broker::Collection
    )
    self.collection_parser = Broker::CollectionParser
    self.include_format_in_path = false
    self.site = Rails.application.config.broker_url
    headers['Accept'] = 'application/json'

    def assign_attributes(_); end

    def load(attributes, remove_root = false, persisted = false)
      super(attributes.transform_keys(&method(:sanitize_key)), remove_root, persisted)
    end

    private

    def sanitize_key(key)
      key.to_s.underscore.sub('_id', 'id')
    end

    class << self
      def requested_single_resource(params, _user_context)
        find(params[:id]) if params.key?(:id)
      end
    end
  end
end
