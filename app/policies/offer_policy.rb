# frozen_string_literal: true

class OfferPolicy < ApplicationPolicy
  def show?
    pod_owner?
  end
end
