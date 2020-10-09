# frozen_string_literal: true

class OfferPolicy < ApplicationPolicy
  permit_attributes %i[display_name]
  permit_attributes %i[attribution_description], has_values: {rule_sets: 'attribution'}
  permit_array_attributes %i[rule_sets]
  permit_nested_attributes %i[node invites]

  def show?
    # @todo check if you're the creator, or one of the invites
    true
  end

  def create?
    true
  end

  def accept?
    # @todo check if person is in invites list
    true
  end
end
