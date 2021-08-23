# frozen_string_literal: true

require 'active_support/testing/assertions'
require 'active_support/testing/time_helpers'
require 'capybara/rspec'
require 'capybara-screenshot/rspec'
require 'database_cleaner/active_record'
require 'selenium/webdriver'
require 'webdrivers'
require 'rspec/instafail'
require 'webmock/rspec'
require 'sidekiq/testing'

require 'support/exception_helper'
require 'support/helper_methods'
require 'support/matchers'
require 'support/auth_test_helper'

Bugsnag.configuration.notify_release_stages = %w[test]
Sidekiq::Testing.inline!
DatabaseCleaner.strategy = :truncation

Capybara.configure do |config|
  config.default_driver = :selenium_chrome
  config.server_host = '0.0.0.0'
  config.server_port = 3000
  config.app_host = 'https://dexpods.localdev'
end

Webdrivers::Chromedriver.required_version = '2.41'

WebMock.disable_net_connect!(
  allow_localhost: true,
  allow: HelperMethods::ALLOWED_HOSTS
)

Capybara.register_driver :selenium_chrome do |app| # rubocop:disable Metrics/BlockLength
  capabilities = Selenium::WebDriver::Remote::Capabilities.chrome(
    'elementScrollBehavior' => 1,
    'goog:loggingPrefs' => {browser: 'ALL'},
    loggingPrefs: {
      browser: 'ALL'
    },
    chromeOptions: {w3c: false}
  )

  client = Selenium::WebDriver::Remote::Http::Default.new
  client.read_timeout = 90
  client.open_timeout = 90
  options = Selenium::WebDriver::Chrome::Options.new
  options.headless! unless ENV['NO_HEADLESS']
  options.add_argument('--window-size=1920,1080')
  options.add_argument('--enable-logging')
  options.add_argument('--disable-gpu')
  options.add_argument('--disable-dev-shm-usage')
  options.add_argument('--disable-extensions')
  options.add_argument('--disable-popup-blocking')
  options.add_argument('--no-sandbox')
  options.add_preference('intl.accept_languages', 'en-US')
  options.add_option('w3c', false)

  Capybara::Selenium::Driver.new(
    app,
    browser: :chrome,
    options: options,
    http_client: client,
    desired_capabilities: capabilities
  )
end

Capybara::Screenshot.register_filename_prefix_formatter(:rspec) do |example|
  ExceptionHelper.example_filename(example)
end
Capybara::Screenshot.append_timestamp = false

RSpec.configure do |config|
  config.include HelperMethods
  config.include AuthTestHelper
  config.include Matchers
  config.include FactoryBot::Syntax::Methods
  config.include ExceptionHelper
  config.include ActiveSupport::Testing::Assertions
  config.include ActiveSupport::Testing::TimeHelpers
  config.include ActionMailer::TestHelper
  config.include ActiveJob::TestHelper

  # rspec-expectations config goes here. You can use an alternate
  # assertion/expectation library such as wrong or the stdlib/minitest
  # assertions if you prefer.
  config.expect_with :rspec do |expectations|
    # This option will default to `true` in RSpec 4. It makes the `description`
    # and `failure_message` of custom matchers include text for helper methods
    # defined using `chain`, e.g.:
    #     be_bigger_than(2).and_smaller_than(4).description
    #     # => "be bigger than 2 and smaller than 4"
    # ...rather than:
    #     # => "be bigger than 2"
    expectations.include_chain_clauses_in_custom_matcher_descriptions = true
  end

  # rspec-mocks config goes here. You can use an alternate test double
  # library (such as bogus or mocha) by changing the `mock_with` option here.
  config.mock_with :rspec do |mocks|
    # Prevents you from mocking or stubbing a method that does not exist on
    # a real object. This is generally recommended, and will default to
    # `true` in RSpec 4.
    mocks.verify_partial_doubles = true
  end

  # This option will default to `:apply_to_host_groups` in RSpec 4 (and will
  # have no way to turn it off -- the option exists only for backwards
  # compatibility in RSpec 3). It causes shared context metadata to be
  # inherited by the metadata hash of host groups and examples, rather than
  # triggering implicit auto-inclusion in groups with matching metadata.
  config.shared_context_metadata_behavior = :apply_to_host_groups

  config.before do |example|
    Capybara.app_host = "https://#{user_pod?(example) ? 'user.' : ''}dexpods.localdev"
    Rails.application.load_seed
  end

  config.after do |example|
    LinkedRails::Cache.invalidate_all
    ActionMailer::Base.deliveries.clear

    if example.exception
      upload_browser_logs(example)
      copy_test_log(example)
    end
  end

  config.before(:suite) do
    DatabaseCleaner.clean_with(:truncation)
  end

  config.before(:each) do
    DatabaseCleaner.strategy = :transaction
    Apartment::Tenant.drop('user') if ApplicationRecord.connection.schema_exists?('user')
  end

  config.before(:each, type: :feature) do
    # :rack_test driver's Rack app under test shares database connection
    # with the specs, so continue to use transaction strategy for speed.
    driver_shares_db_connection_with_specs = Capybara.current_driver == :rack_test

    unless driver_shares_db_connection_with_specs
      # Driver is probably for an external browser with an app
      # under test that does *not* share a database connection with the
      # specs, so use truncation strategy.
      DatabaseCleaner.strategy = :truncation
    end
  end

  config.before(:each) do
    DatabaseCleaner.start
  end

  config.append_after(:each) do
    DatabaseCleaner.clean
  end
end

module CapybaraNodeFix
  private

  def synced_resolve(*args)
    super
  rescue Capybara::ElementNotFound
    sleep 1
    super
  end
end

Capybara::Node::Base.prepend CapybaraNodeFix

module CapybaraExecuteFix
  def execute(*args)
    super
  rescue Selenium::WebDriver::Error::StaleElementReferenceError
    sleep 1
    super
  end
end

Selenium::WebDriver::Remote::OSS::Bridge.prepend CapybaraExecuteFix

module WaitFix
  def with_wait(*args)
    super
  rescue Selenium::WebDriver::Error::StaleElementReferenceError
    sleep 1
    super
  end
end

RSpec::Wait::Target.prepend WaitFix
