# frozen_string_literal: true

class PodPolicy < ApplicationPolicy
  permit_attributes %i[theme_color]
  permit_attributes %i[pod_name],
                    new_record: true

  def no_pod_name
    record.pod.blank?
  end

  def update?
    record == user_context
  end
end
