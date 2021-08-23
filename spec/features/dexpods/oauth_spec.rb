# frozen_string_literal: true

describe 'DexPods' do
  describe 'Oauth' do
    let!(:web_id) { create(:web_id) }

    it 'Valid token' do |example|
      sign_in(web_id)
      test_valid_token(example)
    end

    it 'Revoked token' do |example|
      sign_in(web_id)
      test_revoked_token(example)
    end

    it 'Expired token' do |example|
      travel_to(1.month.ago) do
        sign_in(web_id)
      end
      test_expired_token(example)
    end
  end
end
