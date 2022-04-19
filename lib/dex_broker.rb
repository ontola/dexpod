# frozen_string_literal: true

class DexBroker
  class << self
    # @return boolean The verdict of the broker
    def authorize(action, resource, recipient)
      query = broker_payload(action, resource, recipient)
      get("/authorize?#{query.to_param}")
      Rails.logger.info "[BROKER OK] #{query.to_param}"

      true
    rescue Faraday::ForbiddenError => e
      Rails.logger.info "[Broker ERR] query: #{query.to_param}, err #{e.message}"
      false
    end

    # @return string Iri of the newly created Offer
    def create_offer(body)
      response = post('/offers', body.to_json, Authorization: "Bearer #{authorization}")

      broker_url(response.headers['location'])
    end

    def url?
      broker_url('').present?
    end

    private

    def authorization
      JWT.encode(
        {
          application_id: broker_app_id,
          iss: Rails.application.config.origin,
          sub: RootHelper.current_pod.web_id.profile.iri
        },
        Doorkeeper::JWT.configuration.secret_key,
        Doorkeeper::JWT.configuration.encryption_method.to_s.upcase
      )
    end

    def broker_app_id
      Doorkeeper::Application.order(created_at: :asc).find_by!(name: ENV['BROKER_APP_NAME']).uid
    end

    def broker_headers(headers = nil)
      {
        Accept: 'application/json',
        'Content-Type': 'application/json'
      }.merge(headers || {})
    end

    def broker_payload(action, resource, recipient)
      {
        action: action,
        resource: resource,
        recipient: recipient
      }
    end

    def broker_url(path)
      "#{Rails.application.config.broker_url}#{path}"
    end

    Faraday::Connection::METHODS.each do |method|
      define_method method do |path = nil, params = nil, headers = nil|
        connection = Faraday.new do |f|
          f.use Faraday::Response::RaiseError
        end
        connection.send(method, broker_url(path), params, broker_headers(headers))
      end
    end
  end
end
