# frozen_string_literal: true

source 'https://rubygems.org'

ruby '3.3.0'

# Bundle edge Rails instead: gem "rails", github: "rails/rails", branch: "main"
gem 'rails', '~> 7.2.0'

# Use sqlite3 as the database for Active Record
gem 'sqlite3', '~> 1.4'

# Use the Puma web server [https://github.com/puma/puma]
gem 'puma', '>= 5.0'

# Build JSON APIs with ease [https://github.com/rails/jbuilder]
# gem "jbuilder"

# Use Redis adapter to run Action Cable in production
# gem "redis", ">= 4.0.1"

# Use Kredis to get higher-level data types in Redis [https://github.com/rails/kredis]
# gem "kredis"

# Use Active Model has_secure_password [https://guides.rubyonrails.org/active_model_basics.html#securepassword]
# gem "bcrypt", "~> 3.1.7"

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: %i[windows jruby]

# Reduces boot times through caching; required in config/boot.rb
gem 'bootsnap', require: false

# Use Active Storage variants [https://guides.rubyonrails.org/active_storage_overview.html#transforming-images]
# gem "image_processing", "~> 1.2"

# Use Rack CORS for handling Cross-Origin Resource Sharing (CORS), making cross-origin Ajax possible
gem 'rack-cors'

gem 'active_model_serializers', '~> 0.10'
gem 'devise'
gem 'devise-jwt'
gem 'jsonapi-serializer'

gem 'rswag'
gem 'rswag-api'
gem 'rswag-ui'

group :development, :test do
  # See https://guides.rubyonrails.org/debugging_rails_applications.html#debugging-with-the-debug-gem
  gem 'debug', platforms: %i[mri windows]
  gem 'factory_bot_rails', '<= 2.6.0'
end

group :development do
  gem 'annotate' # adds a comment summarizing the current schema to the top or bottom of each of your models
  gem 'seed_dump' # adds a db:seed:dump task to create seed data files from the existing data in your database
  gem 'spring'
end

group :test do
  gem 'rspec'
  gem 'rspec-rails'
  gem 'rswag-specs'
  gem 'rubocop', require: false
  gem 'rubocop-performance', require: false
  gem 'rubocop-rails_config', require: false
  gem 'rubocop-rspec', require: false
  gem 'simplecov', require: false
  gem 'json_expressions'
end
