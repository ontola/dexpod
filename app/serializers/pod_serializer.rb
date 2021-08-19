# frozen_string_literal: true

class PodSerializer < RecordSerializer
  attribute :pod_name, predicate: NS.argu[:podName]
  attribute :theme_color, predicate: NS.argu[:baseColor] do |obj, ctx|
    obj.theme_color || ctx[:manifest].app_theme_color
  end
  attribute :display_name, predicate: NS.foaf[:name]
end
