# frozen_string_literal: true

module Oauth
  class AuthorizationsController < Doorkeeper::AuthorizationsController
    include OauthHelper

    # @todo Skipping CSRF is needed because we are skipping the FE, but also don't have a session in the BE
    # Should be fixed by rendering the authorization screen by the FE
    skip_before_action :verify_authenticity_token, only: :create # rubocop:disable Rails/LexicallyScopedActionFilter
    before_action :redirect_guests

    def flash
      {}
    end
  end
end
