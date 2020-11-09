# frozen_string_literal: true

module TestMethods
  def generate_token(scopes, application = Doorkeeper::Application.first, params = {})
    user = params[:user] || create(:user, params)
    token = Doorkeeper::AccessToken.create!(
      application: application,
      scopes: scopes,
      resource_owner_id: user&.id || SecureRandom.hex,
      use_refresh_token: true
    )
    token
  end

  def request_headers(accept: :nq, token: @request_token)
    headers = {
      accept: Mime::Type.lookup_by_extension(accept).to_s
    }
    headers['Authorization'] = "Bearer #{token}" if token
    headers
  end

  def sign_in(resource = create(:user))
    token =
      if resource == :guest_user
        generate_token('guest').token
      elsif resource.is_a?(String)
        resource
      else
        generate_token(:user, Doorkeeper::Application.first, user: resource).token
      end

    @request_token = token
  end
end
