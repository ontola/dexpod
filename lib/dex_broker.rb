# frozen_string_literal: true

class DexBroker
  class << self
    # @return boolean The verdict of the broker
    def authorize(action, resource, recipient)
      puts recipient&.class
      puts recipient
      query = {
        action: action,
        resource: resource,
        recipient: recipient
      }
      get("/authorize?#{query.to_param}")

      true
    rescue Faraday::ForbiddenError
      false
    end

    # @return string Iri of the newly created Offer
    def create_offer(body)
      response = post('/offers', body.to_json)

      broker_url(response.headers['location'])
    end

    def url?
      broker_url('').present?
    end

    private

    def broker_headers(headers = nil)
      {
        Accept: 'application/json',
        'Content-Type': 'application/json'
      }.merge(headers || {})
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
