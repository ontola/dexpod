# frozen_string_literal: true

class AgreementsController < AuthorizedController
  before_action :check_if_registered, only: :create
  active_response :show, :index

  private

  def create_success
    respond_with_redirect(
      location: current_resource.iri.to_s
    )
  end

  def permit_params
    {assignee: current_user, invite: parent_resource}
  end
end
