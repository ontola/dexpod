# frozen_string_literal: true

class IdentitiesController < ApplicationController
  include OpenIdHelper

  before_action :require_anonymous_access

  def show
    sign_in(authenticated_user)

    redirect_to r_param || LinkedRails.iri.to_s
  end

  private

  def authenticated_user
    provider.authenticate(
      provider_identity_url(provider),
      params[:code],
      stored_nonce
    )
  end

  def provider
    @provider ||= Provider.find(params[:provider_id])
  end

  def r_param
    params[:redirect_uri]
  end

  def require_anonymous_access
    raise 'Already authenticated' if current_user && !current_user.guest?
  end
end
