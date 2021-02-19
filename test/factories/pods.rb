# frozen_string_literal: true

FactoryBot.define do
  factory :pod do
    pod_name { 'user' }
    theme_color { '#333333' }
    web_id
  end
end
