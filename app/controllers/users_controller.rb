# frozen_string_literal: true

class UsersController < ApplicationController
  active_response :show, :update

  private

  def update_execute
    params = permit_params
    params[:pod_attributes][:id] = current_resource.pod.id if params.key?(:pod_attributes)
    current_resource!.update(params)
  end

  def update_success
    return super unless current_pod.blank? && current_resource.pod.present?

    add_exec_action_header(response.headers, ontola_redirect_action(current_resource.pod.home_iri.to_s, reload: true))
  end
end
