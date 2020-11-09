# frozen_string_literal: true

module Oauth
  class AuthorizationsController < Doorkeeper::AuthorizationsController
    before_action :redirect_guests

    private

    def flash
      {}
    end

    def redirect_or_render(auth)
      if auth.redirectable?
        redirect_to auth.redirect_uri
      else
        render json: auth.body, status: auth.status
      end
    end
  end
end
