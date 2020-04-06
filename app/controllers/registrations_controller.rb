# frozen_string_literal: true

class RegistrationsController < Devise::RegistrationsController
  private

  def sign_in(scope, resource)
    @current_user = resource

    super(resource, scope)
  end
end
