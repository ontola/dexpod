# frozen_string_literal: true

source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '2.7.0'

gem 'active_model_otp'
gem 'active_response', git: 'https://github.com/ontola/active_response'
gem 'bootsnap', require: false
gem 'bugsnag'
gem 'devise'
gem 'doorkeeper'
gem 'doorkeeper-jwt'
# @todo move to official gem when https://github.com/doorkeeper-gem/doorkeeper-openid_connect/pull/153 is merged
gem 'doorkeeper-openid_connect', git: 'https://github.com/sealink/doorkeeper-openid_connect'
gem 'dotenv-rails', require: 'dotenv/rails-now'
gem 'faraday'
gem 'httpclient', git: 'https://github.com/ArthurWD/httpclient.git'
gem 'image_processing'
gem 'json-ld'
gem 'jsonapi-renderer'
gem 'linked_rails', '~> 0.0.3'
gem 'linked_rails-auth'
gem 'ltree_hierarchy'
gem 'mailjet'
gem 'mime-types'
gem 'oj'
gem 'openid_connect'
gem 'pg'
gem 'puma'
gem 'rack-cors'
gem 'rails'
gem 'rdf'
gem 'rdf-n3'
gem 'rdf-rdfa'
gem 'rdf-rdfxml'
gem 'rdf-turtle'
gem 'rdf-vocab'
gem 'redis'
gem 'ros-apartment', require: 'apartment'
gem 'sidekiq'
gem 'sprockets', '~> 3'
gem 'tzinfo-data'
gem 'video_info'
gem 'webrick'

group :development, :test do
  gem 'byebug', platforms: %i[mri mingw x64_mingw]
end

group :development do
  gem 'better_errors', '~> 2.7.0'
  gem 'binding_of_caller'
  gem 'listen'
  gem 'rubocop'
  gem 'rubocop-rails'
  gem 'solargraph'
  gem 'spring'
  gem 'spring-watcher-listen'
  gem 'web-console'
end

group :test do
  gem 'capybara', '>= 2.15', '< 4.0'
  gem 'capybara-screenshot'
  gem 'database_cleaner-active_record'
  gem 'factory_bot'
  gem 'factory_bot_rails'
  gem 'minitest'
  gem 'minitest-bang'
  gem 'minitest-rails'
  gem 'minitest-reporters'
  gem 'rspec-instafail', require: false
  gem 'rspec-rails'
  gem 'rspec-wait'
  gem 'rspec_junit_formatter'
  gem 'selenium-webdriver'
  gem 'webdrivers'
  gem 'webmock', '3.5.1'
end
