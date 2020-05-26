# frozen_string_literal: true

require 'test_helper'

class ClientsTest < ActionDispatch::IntegrationTest
  ####################################
  # As Guest
  ####################################
  test 'should post create client' do
    assert_difference('Doorkeeper::Application.count' => 1) do
      post register_path,
           params: client_data,
           headers: request_headers
    end
    assert_response :success
  end

  private

  def client_data
    {
      issuer: 'https://argu.localdev',
      grant_types: ['implicit'],
      redirect_uris: ['http://localhost:8080/popup.html', 'https://example.com'],
      response_types: ['id_token token'],
      scope: 'openid profile'
    }
  end
end
