# frozen_string_literal: true

module RootHelper
  module_function

  # The pod targeted in this request, if any
  def current_pod
    Thread.current[:current_pod] = nil if Thread.current[:current_pod]&.pod_name != current_tenant

    Thread.current[:current_pod] ||= Pod.find_by!(pod_name: current_tenant) if pod?
  end

  def current_tenant
    Apartment::Tenant.current.to_sym
  end

  def public_tenant?
    current_tenant == :public
  end

  # Whether the current request is for an individual pod
  def pod?
    !%i[public].include?(current_tenant)
  end
end
