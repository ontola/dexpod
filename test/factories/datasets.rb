# frozen_string_literal: true

FactoryBot.define do
  factory :dataset do
    user
    sequence(:title) { |n| "dataset#{n}" }
    sequence(:description) { |n| "description for dataset#{n}" }
    license { RDF::URI('http://standaarden.overheid.nl/owms/terms/geslotenlicentie') }
    license_description { 'license_description' }
  end
end
