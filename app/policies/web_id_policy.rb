# frozen_string_literal: true

class WebIdPolicy < ApplicationPolicy
  permit_attributes %i[theme_color]
  permit_attributes %i[email redirect_url password password_confirmation current_password]
  permit_nested_attributes %i[pod]

  def no_pod_name
    record.pod.blank?
  end

  def update?
    record == user_context
  end
end
