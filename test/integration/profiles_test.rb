# frozen_string_literal: true

require 'test_helper'

class ProfilesTest < ActionDispatch::IntegrationTest
  let(:pod) { create(:pod, web_id: build(:web_id)) }

  ####################################
  # As Guest
  ####################################
  test 'should get profile of pod' do
    get "#{pod.home_iri}/profile", headers: request_headers

    assert_response :success
  end
end
