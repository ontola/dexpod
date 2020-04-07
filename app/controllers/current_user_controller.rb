# frozen_string_literal: true

class CurrentUserController < ApplicationController
  active_response :show

  private

  def current_resource
    @current_resource ||= CurrentUser.new(user: current_user)
  end
end
