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
gem 'fast_jsonapi', git: 'https://github.com/fast-jsonapi/fast_jsonapi', ref: '2de80d48896751d30fb410e042fd21a710100423'
gem 'image_processing'
gem 'json-ld'
gem 'jsonapi-renderer'
gem 'linked_rails', git: 'https://github.com/ontola/linked_rails', branch: 'dexes'
gem 'linked_rails-auth', git: 'https://github.com/ontola/linked_rails-auth'
gem 'ltree_hierarchy'
gem 'mailjet'
gem 'mime-types'
gem 'oj'
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
gem 'sprockets', '~> 3'
gem 'tzinfo-data'
gem 'video_info'

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
  gem 'solargraph'
  gem 'web-console'
end

group :test do
  gem 'factory_bot'
  gem 'factory_bot_rails'
  gem 'minitest-rails'
  gem 'minitest-reporters'
end
