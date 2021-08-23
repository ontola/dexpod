# frozen_string_literal: true

describe 'User pod' do
  describe 'Sign out' do
    let!(:web_id) { create(:web_id, pod: build(:pod)) }

    it 'sign out' do
      sign_in_oidc web_id
      click_application_menu_button 'Uitloggen'
      verify_not_logged_in
    end
  end
end
