# frozen_string_literal: true

class DistributionPolicy < ApplicationPolicy
  permit_attributes %i[description format license node node_id title]
  permit_attributes %i[access_url], new_record: true

  def show?
    true
  end
end
