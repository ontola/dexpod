# frozen_string_literal: true

module OpenIdHelper
  class SessionBindingRequired < StandardError; end

  private

  def new_nonce
    nonce = SecureRandom.hex(16)
    Redis.new.set(nonce_key, nonce, ex: 1.day.to_i)
    nonce
  end

  def nonce_key
    "nonce.#{doorkeeper_token.token}"
  end

  def stored_nonce
    Redis.new.get(nonce_key) || raise(SessionBindingRequired.new('Invalid Session'))
  end
end
