# frozen_string_literal: true

describe 'Sign in' do
  let(:web_id) { create(:web_id, pod: build(:pod)) }

  it 'signs in existing user' do
    visit '/'
    wait_for(page).to have_link('Log in / registreer')
    click_link 'Log in / registreer'
    fill_in_login_form(web_id.email)
    verify_logged_in
  end

  it 'signs in new user' do
    visit '/'
    wait_for(page).to have_link('Log in / registreer')
    click_link 'Log in / registreer'
    fill_in_registration_form
    verify_logged_in
  end
end
