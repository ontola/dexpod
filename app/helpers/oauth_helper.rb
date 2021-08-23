# frozen_string_literal: true

module OauthHelper
  include LinkedRails::Auth::AuthHelper

  private

  def check_if_registered
    return unless current_user.guest?

    head 401
  end

  def handle_invalid_token
    @current_user = create_guest_user
  end

  def redirect_guests
    return true if (current_user && !current_user&.guest?) || response_body

    redirect_to(LinkedRails.iri(path: '/u/session/new', query: {redirect_url: request.original_url}.to_param).to_s)
  end
end
