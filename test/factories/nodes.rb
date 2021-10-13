# frozen_string_literal: true

FactoryBot.define do
  factory :node do
    sequence(:title) { |n| "node#{n}" }
  end
end
