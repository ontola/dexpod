# frozen_string_literal: true

class UserSerializer < LinkedSerializer
  attribute :pod_name, predicate: NS::ARGU[:podName]
  attribute :theme_color, predicate: NS::ARGU[:baseColor]
  attribute :display_name, predicate: NS::FOAF[:name]
  has_one :pod, predicate: NS::ARGU[:pod]
end
