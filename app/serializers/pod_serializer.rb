# frozen_string_literal: true

class PodSerializer < RecordSerializer
  attribute :pod_name, predicate: NS::ARGU[:podName]
  attribute :theme_color, predicate: NS::ARGU[:baseColor] do |obj, ctx|
    obj.theme_color || ctx[:manifest].app_theme_color
  end
  attribute :display_name, predicate: NS::FOAF[:name]
end
