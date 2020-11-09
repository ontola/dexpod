# frozen_string_literal: true

require 'test_helper'

class RegistrationsTest < ActionDispatch::IntegrationTest
  let(:user) { create(:user) }

  ####################################
  # As Guest
  ####################################
  test 'should not post create existing' do
    sign_in :guest_user
    user
    assert_difference('User.count' => 0) do
      post users_path,
           params: {
             registration: {
               email: user.email
             }
           }, headers: request_headers
    end
    assert_response :unprocessable_entity
  end

  test 'should post create without password' do
    sign_in :guest_user
    user
    assert_difference('User.count' => 1) do
      post users_path,
           params: {
             registration: {
               email: 'new@example.com'
             }
           }, headers: request_headers
    end
    assert_response :success
  end

  test 'should post create with password' do
    sign_in :guest_user
    user
    assert_difference('User.count' => 1) do
      post users_path,
           params: {
             registration: {
               email: 'new@example.com',
               password: 'password'
             }
           }, headers: request_headers
    end
    assert_response :success
  end
end
