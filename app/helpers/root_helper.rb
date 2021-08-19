# frozen_string_literal: true

module RootHelper
  module_function

  # The pod targeted in this request, if any
  def current_pod
    @current_pod ||= Pod.find_by!(pod_name: current_tenant) if pod? # rubocop:disable Rails/HelperInstanceVariable
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
