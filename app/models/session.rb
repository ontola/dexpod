# frozen_string_literal: true

class Session < LinkedRails::Auth::Session
  attr_accessor :host

  class << self
    def form_class
      SessionForm
    end

    def requested_singular_resource(params, _user_context)
      resource = super
      resource.host = Rails.application.config.host_name
      resource
    end
  end
end
