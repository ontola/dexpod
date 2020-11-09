# frozen_string_literal: true

describe 'Sign out' do
  let(:user) { create(:user, pod: build(:pod)) }

  it 'sign out' do
    sign_in user
    visit '/'
    wait_until_loaded
    expect(page).not_to have_content('Log in / registreer')
    click_application_menu_button 'Uitloggen'
    wait_for { page }.to have_content('Log in / registreer')
  end
end
