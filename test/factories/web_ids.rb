# frozen_string_literal: true

FactoryBot.define do
  factory :web_id do
    sequence(:email) { |n| "user#{n}@example.com" }
    password { 'password' }
    pod
  end
end
