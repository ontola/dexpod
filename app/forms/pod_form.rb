# frozen_string_literal: true

class PodForm < ApplicationForm
  field :pod_name
  field :theme_color,
        input_field: ColorInput
end
