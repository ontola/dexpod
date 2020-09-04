# frozen_string_literal: true

class OffersController < AuthorizedController
  before_action :switch_to_user_pod, only: :create
  before_action :check_if_registered, only: :create

  private

  def switch_to_user_pod
    return if current_user.guest?

    Apartment::Tenant.switch!(current_user.pod.pod_name)
  end

  def create_success_location
    current_resource.iri.to_s
  end

  def new_resource_params
    super.merge(user: current_user)
  end
end
