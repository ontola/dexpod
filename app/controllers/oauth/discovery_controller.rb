# frozen_string_literal: true

module Oauth
  class DiscoveryController < Doorkeeper::OpenidConnect::DiscoveryController
    private

    def provider_response
      super.merge(
        registration_endpoint: register_url(protocol: protocol)
      )
    end
  end
end
