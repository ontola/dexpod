# frozen_string_literal: true

class InvitePolicy < ApplicationPolicy
  permit_attributes %i[email]

  def show?
    # Person is in invites list
    true
  end

  def accept?
    # Person is in invites list, see AgreementPolicy#create?
    true
  end
end
