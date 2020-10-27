# frozen_string_literal: true

require 'test_helper'

class RegistrationsTest < ActionDispatch::IntegrationTest
  let!(:application) { create(:application) }
  let(:user) { create(:user) }

  ####################################
  # As Guest
  ####################################
  test 'should not post create existing' do
    user
    assert_difference('User.count' => 0) do
      post users_path,
           params: {
             user: {
               email: user.email
             }
           }, headers: request_headers
    end
    assert_response :unprocessable_entity
  end

  test 'should post create without password' do
    user
    assert_difference('User.count' => 1) do
      post users_path,
           params: {
             user: {
               email: 'new@example.com'
             }
           }, headers: request_headers
    end
    assert_response :success
  end

  test 'should post create with password' do
    user
    assert_difference('User.count' => 1) do
      post users_path,
           params: {
             user: {
               email: 'new@example.com',
               password: 'password'
             }
           }, headers: request_headers
    end
    assert_response :success
  end
end
