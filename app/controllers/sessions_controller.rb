# frozen_string_literal: true

class SessionsController < LinkedRails::Auth::SessionsController
  include OpenIdHelper

  def create_execute
    provider.present?
  end

  private

  def create_success_location
    authorization_uri
  end

  def active_response_failure_message
    'Geen OpenId configuratie gevonden'
  end

  def authorization_uri
    provider.authorization_uri(
      provider_identity_url(provider),
      new_nonce
    )
  end

  def discover_provider
    provider = Provider.discover!(permit_params[:host])

    provider.register!(provider_identity_url(provider)) unless provider.registered?

    provider
  end

  def new_resource_params
    super.merge(
      host: ENV['HOSTNAME']
    )
  end

  def permit_params
    params.require(:session).permit(:redirect_url, :email, :host)
  end

  def provider
    @provider ||= discover_provider
  rescue OpenIDConnect::Discovery::DiscoveryFailed, OpenIDConnect::Discovery::InvalidIdentifier
    nil
  end

  class <<self
    def controller_class
      Session
    end
  end
end
