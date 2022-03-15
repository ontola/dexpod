# frozen_string_literal: true

require_relative './ns'

LinkedRails.host = Rails.application.config.host_name
LinkedRails.scheme = :https
LinkedRails.serializer_parent_class = 'LinkedSerializer'
LinkedRails.registration_form_class = 'RegistrationForm'
LinkedRails.guest_user_class = 'GuestUser'
LinkedRails.user_class = 'WebId'
LinkedRails.ontology_class = 'Ontology'
LinkedRails.otp_secret_class = 'OtpSecret'
LinkedRails.otp_owner_class = 'WebId'

LinkedRails::Renderers.register!

module LinkedRails
  class << self
    def host
      case Apartment::Tenant.current
      when 'public'
        Rails.application.config.host_name
      else
        "#{Apartment::Tenant.current}.#{Rails.application.config.host_name}"
      end
    end
  end
end
