# frozen_string_literal: true

class PodsController < ApplicationController
  active_response :show

  private

  def current_resource
    return current_pod if action_name == 'show'

    super
  end
end
