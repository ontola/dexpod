# frozen_string_literal: true

class DistributionPolicy < ApplicationPolicy
  permit_attributes %i[access_url description format license node node_id title]

  def show?
    true
  end
end
