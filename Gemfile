source 'https://rubygems.org'
gem 'rails', '~> 4.2.0'
gem 'rails-i18n'
gem 'pg' # Postgres gem, used in production
gem 'rails_12factor', group: :production # Makes some Heroku-friendly tweaks.
gem 'sass-rails', '~> 5.0'
gem 'uglifier', '>= 1.3.0'
gem 'coffee-rails', '~> 4.1.0'

gem 'jquery-rails'
gem 'turbolinks'
gem 'jbuilder', '~> 2.0'
gem 'sdoc', '~> 0.4.0', group: :doc
gem 'slim-rails' # Templating library
gem 'factory_girl_rails' # Mock objects
gem 'cancancan' # Allow for different kinds of users
gem 'devise' # Authentication framework
gem 'devise-i18n' # Translated strings for Devise
gem 'twitter-bootstrap-rails' # CSS framework
gem 'bourbon' # Useful CSS functions
gem 'google-webfonts-rails' # Helpers for webfonts
gem 'aasm' # Acts as state machine, used by invitations
gem 'draper' # Decorator objects, to make view logic a little less repetitive

group :development, :test do
  gem 'sqlite3' # Lightweight DB used in development
  gem 'rspec-rails' # Testing
  gem 'capybara' # Drive a web browser from our test framework
  gem 'byebug'
  gem 'faker' # Generate filler content
  gem 'pry-remote' # Connect to a debugger session remotely
  gem 'bullet' # Look for and catch N+1 queries
end

group :development do
  gem 'web-console', '~> 2.0' # Access an IRB console on exception pages or by using <%= console %> in views
  gem 'letter_opener' # Open emails in a browser

  gem 'spring' # Keep app running in background.
end

group :test do
  gem 'simplecov', require: false # Code coverage metrics
  gem 'simplecov-console', require: false # Output code coverage report on the CLI
end
