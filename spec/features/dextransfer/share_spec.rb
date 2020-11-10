# frozen_string_literal: true

describe 'Share' do
  let(:user) { create(:user, pod: build(:pod)) }

  it 'shares file as existing user' do
    visit '/'
    wait_for(page).to have_content('Deel een bestand')
    select_file
    fill_in field_name(NS::DEX[:invites].to_s, 0, NS::SCHEMA.email.to_s), with: 'assignee@example.com'
    click_button 'Opslaan'
    fill_in_login_form(user.email)
    wait_for(page).to have_content('Deel een bestand')
    select_file
    assert_difference('Offer.count' => 1) do
      click_button 'Opslaan'
      wait_for { page }.to have_current_path("/offers/#{Offer.last.id}")
      wait_for(page).to have_content('photo.jpg')
    end
  end

  private

  def select_file
    within("fieldset[property=\"#{NS::DEX[:file]}\"]") do
      attach_file(nil, File.absolute_path('spec/fixtures/photo.jpg'), make_visible: true)
    end
  end
end
