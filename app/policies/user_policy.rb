# frozen_string_literal: true

class UserPolicy < ApplicationPolicy
  def permitted_attributes
    attrs =  %i[theme_color]
    attrs << :pod_name if record.pod_name.blank?
    attrs
  end

  def update?
    record == user_context
  end
end
