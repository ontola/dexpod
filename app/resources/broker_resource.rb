# frozen_string_literal: true

class BrokerResource < ActiveResource::Base
  include LinkedRails::Model

  self.include_format_in_path = false
  self.site = Rails.application.config.broker_url
  headers['Accept'] = 'application/json'

  def load(attributes, remove_root = false, persisted = false)
    super(attributes.transform_keys(&:underscore), remove_root, persisted)
  end

  class << self
    def requested_single_resource(params, _user_context)
      find(params[:id]) if params.key?(:id)
    end
  end
end
