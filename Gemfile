# frozen_string_literal: true

source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '2.7.0'

gem 'active_response', git: 'https://github.com/ontola/active_response'
gem 'bootsnap', require: false
gem 'bugsnag'
gem 'devise'
gem 'doorkeeper'
gem 'doorkeeper-jwt'
gem 'doorkeeper-openid_connect'
gem 'dotenv-rails', require: 'dotenv/rails-now'
gem 'faraday'
gem 'fast_jsonapi', git: 'https://github.com/fast-jsonapi/fast_jsonapi', ref: '2de80d48896751d30fb410e042fd21a710100423'
gem 'httpclient', git: 'https://github.com/ArthurWD/httpclient.git'
gem 'image_processing'
gem 'json-ld'
gem 'jsonapi-renderer'
gem 'linked_rails', git: 'https://github.com/ontola/linked_rails', branch: 'master'
gem 'linked_rails-auth', git: 'https://github.com/ontola/linked_rails-auth'
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
gem 'rdf-serializers', git: 'https://github.com/ontola/rdf-serializers', branch: 'graph_operator'
gem 'rdf-turtle'
gem 'rdf-vocab'
gem 'redis'
gem 'ros-apartment', require: 'apartment'
gem 'ruby-kafka'
gem 'sidekiq'
gem 'sprockets', '~> 3'
gem 'tzinfo-data'
gem 'video_info'
gem 'webrick'

group :development, :test do
  gem 'byebug', platforms: %i[mri mingw x64_mingw]
end

group :development do
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
  gem 'factory_bot'
  gem 'factory_bot_rails'
  gem 'minitest'
  gem 'minitest-bang'
  gem 'minitest-rails'
  gem 'minitest-reporters'
  gem 'rspec-instafail', require: false
  gem 'rspec-rails', '~> 3.5'
  gem 'rspec-wait'
  gem 'rspec_junit_formatter'
  gem 'selenium-webdriver'
  gem 'webdrivers'
  gem 'webmock', '3.5.1'
end
