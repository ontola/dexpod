# frozen_string_literal: true

module OpenIdHelper
  class SessionBindingRequired < StandardError; end

  private

  def store_redirect
    Redis.new.set(redirect_key, params[:redirect_url], ex: 1.hour.to_i) if params[:redirect_url]
  rescue StandardError
    nil
  end

  def stored_redirect
    return unless redirect_key

    value = Redis.new.get(redirect_key)
    Redis.new.del(redirect_key) if value
    value
  end

  def redirect_key
    "dexpod.redirect.#{doorkeeper_token.token}" if doorkeeper_token
  end

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
