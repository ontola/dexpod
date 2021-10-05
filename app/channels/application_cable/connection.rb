# frozen_string_literal: true

module ApplicationCable
  class Connection < ActionCable::Connection::Base
    include RootHelper

    identified_by :current_tenant
    identified_by :current_user

    def initialize(*_args)
      self.current_tenant = Apartment::Tenant.current
      Apartment::Tenant.switch!(current_tenant) if current_tenant
      super
    end

    def current_pod
      @current_pod ||= Pod.find_by!(pod_name: current_tenant) if pod?
    end

    def connect
      self.current_user = find_verified_user
    end

    private

    def allow_request_origin?
      "#{env['HTTP_ORIGIN']}/".ends_with?(current_pod.home_iri.to_s)
    end

    def current_resource_owner
      instance_eval(&Doorkeeper.configuration.authenticate_resource_owner)
    end

    def doorkeeper_token
      ::Doorkeeper.authenticate(request)
    end

    def find_verified_user
      Apartment::Tenant.switch(current_tenant) do
        return current_resource_owner || reject_unauthorized_connection
      end
    end

    def send_welcome_message
      transmit type: ActionCable::INTERNAL[:message_types][:welcome],
               user: current_user.display_name,
               pod: current_tenant
    end
  end
end
