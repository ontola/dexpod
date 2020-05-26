# frozen_string_literal: true

class UserForm < ApplicationForm
  fields %i[
    pod_name
    theme_color
  ]
end
