# frozen_string_literal: true

FactoryBot.define do
  factory :application, class: Doorkeeper::Application do
    sequence(:name) { |i| "app_name_#{i}" }
    redirect_uri { 'https://example.com' }
  end
end
