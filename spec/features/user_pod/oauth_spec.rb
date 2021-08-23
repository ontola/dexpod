# frozen_string_literal: true

describe 'User pod' do
  describe 'Oauth' do
    let!(:web_id) { create(:web_id, pod: build(:pod)) }

    it 'Valid token' do |example|
      sign_in_oidc(web_id)
      test_valid_token(example)
    end

    it 'Revoked token' do |example|
      sign_in_oidc(web_id)
      test_revoked_token(example)
    end
  end
end
