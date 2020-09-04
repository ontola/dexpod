# frozen_string_literal: true

class AgreementPolicy < NodePolicy
  def create?
    # Person is in invites list
    true
  end
end
