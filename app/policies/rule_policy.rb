# frozen_string_literal: true

class RulePolicy < ApplicationPolicy
  def show?
    # Person is in invites list
    true
  end
end
