# frozen_string_literal: true

module Oauth
  class DiscoveryController < Doorkeeper::OpenidConnect::DiscoveryController
    private

    def provider_response
      super.merge(
        registration_endpoint: register_url(protocol: protocol, host: Rails.application.config.host_name)
      )
    end

    def root_url(*_args)
      Rails.application.config.origin
    end

    %i[oauth_authorization_url oauth_token_url oauth_revoke_url oauth_introspect_url
       oauth_userinfo_url oauth_discovery_keys_url].each do |url_method|
      define_method(url_method) do |args = {}|
        args[:host] = Rails.application.config.host_name

        super(args)
      end
    end
  end
end
