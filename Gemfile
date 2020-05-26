# frozen_string_literal: true

source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '2.7.0'

gem 'active_response', git: 'https://github.com/ontola/active_response'
gem 'bootsnap', require: false
gem 'devise'
gem 'dotenv-rails', require: 'dotenv/rails-now'
gem 'doorkeeper'
gem 'doorkeeper-jwt'
gem 'fast_jsonapi', git: 'https://github.com/fast-jsonapi/fast_jsonapi', ref: '2de80d48896751d30fb410e042fd21a710100423'
gem 'json-ld'
gem 'linked_rails', git: 'https://github.com/ontola/linked_rails', branch: 'core-127-fast-serializers'
gem 'oj'
gem 'pg'
gem 'puma'
gem 'rails'
gem 'sprockets', '~> 3'
gem 'rdf'
gem 'rdf-n3'
gem 'rdf-rdfa'
gem 'rdf-rdfxml'
gem 'rdf-serializers', git: 'https://github.com/ontola/rdf-serializers', branch: 'fast-jsonapi'
gem 'rdf-turtle'
gem 'rdf-vocab'

group :development, :test do
  gem 'byebug', platforms: %i[mri mingw x64_mingw]
end

group :development do
  gem 'listen'
  gem 'rubocop'
  gem 'rubocop-rails'
  gem 'rubocop-rspec'
  gem 'spring'
  gem 'spring-watcher-listen'
  gem 'web-console'
end

group :test do
  gem 'factory_bot'
  gem 'factory_bot_rails'
  gem 'minitest-rails'
end

gem 'tzinfo-data', platforms: %i[mingw mswin x64_mingw jruby]
