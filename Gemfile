# frozen_string_literal: true

source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '2.7.0'

gem 'bootsnap', require: false
gem 'devise'
gem 'dotenv-rails', require: 'dotenv/rails-now'
gem 'factory_bot'
gem 'factory_bot_rails'
gem 'pg'
gem 'puma'
gem 'rails'
gem 'sprockets', '~> 3'

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
  gem 'minitest-rails'
end

gem 'tzinfo-data', platforms: %i[mingw mswin x64_mingw jruby]
