# frozen_string_literal: true

module Oauth
  class AuthorizationsController < Doorkeeper::AuthorizationsController
    before_action :redirect_guests

    def flash
      {}
    end
  end
end
