# frozen_string_literal: true

class OtpSecret < LinkedRails::Auth::OtpSecret
  class << self
    def owner_for_otp(params, user_context)
      return super if params.key?(:session)

      user_context unless user_context.guest?
    end
  end
end
