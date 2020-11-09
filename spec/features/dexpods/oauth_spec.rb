# frozen_string_literal: true

describe 'Oauth' do
  let(:user) { create(:user) }

  it 'Valid token' do
    sign_in user

    assert_difference(
      'Doorkeeper::AccessToken.where(scopes: "user").count' => 0,
      'Doorkeeper::AccessToken.where(scopes: "guest").count' => 0
    ) do
      visit '/'
    end
    wait_until_loaded
    expect(page).not_to have_content('Log in / registreer')
  end

  it 'Revoked token' do
    sign_in user
    Doorkeeper::AccessToken.last.revoke
    assert_difference(
      'Doorkeeper::AccessToken.where(scopes: "guest").count' => 1,
      'Doorkeeper::AccessToken.where(scopes: "user").count' => 0
    ) do
      visit '/'
    end
    wait_for { page }.to have_content('Log in / registreer')
  end

  it 'Expired token' do
    travel_to(1.month.ago) do
      sign_in user
    end
    assert_difference(
      'Doorkeeper::AccessToken.where(scopes: "user").count' => 1,
      'Doorkeeper::AccessToken.where(scopes: "guest").count' => 1
    ) do
      visit '/'
    end
    wait_until_loaded
    expect(page).not_to have_content('Log in / registreer')
  end
end
