# frozen_string_literal: true

require 'apartment/elevators/generic'
require 'apartment/elevators/first_subdomain'

class FirstSubDomainWithoutAPIAndDexTransfer < Apartment::Elevators::Generic
  def parse_tenant_name(request)
    return if spi_request?(request)
    return 'dex_transfer' if dex_transfer_host?(request)

    Apartment::Elevators::FirstSubdomain.new(@app, @processor).parse_tenant_name(request)
  end

  def dex_transfer_host?(request)
    request.url.starts_with?("https://#{Rails.application.config.dex_transfer_host_name}/")
  end

  def spi_request?(request)
    ENV['ARGU_API_URL'].present? && request.url.starts_with?(ENV['ARGU_API_URL'])
  end
end
