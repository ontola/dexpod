# frozen_string_literal: true

module AuthTestHelper
  def assert_login_differences(example, &block)
    puts schema_for_example(example)
    Apartment::Tenant.switch(schema_for_example(example)) do
      assert_difference(
        'Doorkeeper::AccessToken.where(scopes: "user").count' => 1,
        'Doorkeeper::AccessToken.where(scopes: "guest").count' => 1,
        &block
      )
    end
  end

  def assert_refresh_differences(example, &block)
    puts schema_for_example(example)
    Apartment::Tenant.switch(schema_for_example(example)) do
      assert_difference(
        'Doorkeeper::AccessToken.where(scopes: "user").count' => 1,
        'Doorkeeper::AccessToken.where(scopes: "guest").count' => 0,
        &block
      )
    end
  end

  def assert_no_token_differences(example, &block)
    Apartment::Tenant.switch(schema_for_example(example)) do
      assert_difference(
        'Doorkeeper::AccessToken.where(scopes: "user").count' => 0,
        'Doorkeeper::AccessToken.where(scopes: "guest").count' => 0,
        &block
      )
    end
  end

  def test_expired_token(example)
    assert_refresh_differences(example) do
      visit '/'
    end
    wait_until_loaded
    verify_logged_in
  end

  def test_valid_token(example)
    assert_no_token_differences(example) do
      visit '/'
    end
    wait_until_loaded
    verify_logged_in
  end

  def test_revoked_token(example)
    Apartment::Tenant.switch(schema_for_example(example)) { Doorkeeper::AccessToken.last.revoke }
    assert_no_token_differences(example) do
      visit '/'
    end
    verify_not_logged_in
  end
end
