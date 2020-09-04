# frozen_string_literal: true

module RootHelper
  module_function

  def current_tenant
    Apartment::Tenant.current.to_sym
  end

  # Whether the current request is for an individual pod
  def pod?
    !%i[public dex_transfer].include?(current_tenant)
  end

  def public_tenant?
    current_tenant == :public
  end

  def dex_transfer?
    current_tenant == :dex_transfer
  end
end
