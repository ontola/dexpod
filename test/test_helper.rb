# frozen_string_literal: true

ENV['RAILS_ENV'] ||= 'test'
require_relative '../config/environment'
require 'rails/test_help'
require 'database_cleaner/active_record'
require 'linked_rails/test_methods'
require 'minitest/rails'
require 'minitest/reporters'

require_relative 'support/test_methods'
require_relative 'support/test_seed'

DatabaseCleaner.strategy = :truncation
Minitest::Reporters.use! unless ENV['RM_INFO']

module ActiveSupport
  class TestCase
    include FactoryBot::Syntax::Methods
    include TestMethods

    # Run tests in parallel with specified workers
    # parallelize(workers: :number_of_processors)

    # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
    fixtures :all

    # Add more helper methods to be used by all tests here...
  end
end

module ActionDispatch
  class IntegrationTest
    setup do
      host! Rails.application.config.host_name
    end

    before do
      Apartment::Tenant.switch! 'user'
    end
  end
end
