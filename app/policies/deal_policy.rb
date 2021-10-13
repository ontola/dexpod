# frozen_string_literal: true

class DealPolicy < ApplicationPolicy
  def show?
    pod_owner?
  end
end
