# frozen_string_literal: true

class ConditionPolicy < ApplicationPolicy
  permit_attributes %i[type], new_record: true
  permit_attributes %i[address amount currency duration text]

  def show?
    true
  end
end
