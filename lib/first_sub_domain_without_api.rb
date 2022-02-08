# frozen_string_literal: true

require 'apartment/elevators/generic'
require 'apartment/elevators/first_subdomain'

class FirstSubDomainWithoutAPI < Apartment::Elevators::Generic
  def parse_tenant_name(request)
    return if spi_request?(request) || landing_page?(request)

    Apartment::Elevators::FirstSubdomain.new(@app, @processor).parse_tenant_name(request)
  end

  def landing_page?(request)
    request.url.starts_with?("#{Rails.application.config.origin}/")
  end

  def spi_request?(request)
    ENV['DATA_SERVICE_URL'].present? && request.url.starts_with?(ENV['DATA_SERVICE_URL'])
  end
end
