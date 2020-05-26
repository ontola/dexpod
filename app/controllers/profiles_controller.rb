# frozen_string_literal: true

class ProfilesController < ApplicationController
  active_response :show

  private

  def requested_resource
    @requested_resource ||= current_pod&.user&.profile
  end
end
