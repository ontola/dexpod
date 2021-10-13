# frozen_string_literal: true

require 'test_helper'

class ProfilesTest < ActionDispatch::IntegrationTest
  define_pod

  ####################################
  # As Guest
  ####################################
  test 'should get profile of pod' do
    get "#{pod.home_iri}/profile", headers: request_headers

    assert_response :success
  end
end
