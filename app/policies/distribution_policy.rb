# frozen_string_literal: true

class DistributionPolicy < ApplicationPolicy
  permit_attributes %i[node node_id description format license]
end
