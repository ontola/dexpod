# frozen_string_literal: true

require 'test_helper'

class AuthorizationsTest < ActionDispatch::IntegrationTest
  let(:application) { create(:application) }
  let(:client_id) { application.uid }
  let(:state) { SecureRandom.hex }

  ####################################
  # As Guest
  ####################################
  test 'guest should redirect to login' do
    # assert_difference('Doorkeeper::Application.count' => 1) do
    head auth_url, headers: request_headers
    # end
    assert_redirected_to LinkedRails.iri(path: '/u/sign_in', query: {r: auth_url}.to_param).to_s
  end

  ####################################
  # As User
  ####################################
  test 'user should get new authorization' do
    # assert_difference('Doorkeeper::Application.count' => 1) do
    head auth_url, headers: request_headers
    # end
    assert_response :success
  end

  private

  def auth_url
    oauth_authorization_url(
      redirect_uri: 'https://example.com',
      response_type: 'id_token token',
      display: 'page',
      scope: 'openid',
      client_id: client_id,
      state: state
    )
  end
end
