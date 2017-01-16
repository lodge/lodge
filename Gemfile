source 'https://rubygems.org'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '4.1.14'
# Use SCSS for stylesheets
gem 'sass-rails', '4.0.2'
# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '~> 2.5'
# Use CoffeeScript for .js.coffee assets and views
gem 'coffee-rails', '~> 4.0'
# See https://github.com/sstephenson/execjs#readme for more supported runtimes
# gem 'therubyracer',  platforms: :ruby

# Use jquery as the JavaScript library
gem 'jquery-rails', '~> 3.1'
# Turbolinks makes following links in your web application faster. Read more: https://github.com/rails/turbolinks
gem 'turbolinks', '~> 2.2'
gem 'jquery-turbolinks', '~> 2.0'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.1'
# bundle exec rake doc:rails generates the API under doc/api.
gem 'sdoc',          group: :doc

# Spring speeds up development by
# keeping your application running in the background.
# Read more: https://github.com/rails/spring
gem 'spring',        group: :development

# Use ActiveModel has_secure_password
# gem 'bcrypt', '~> 3.1.7'

# Use unicorn as the app server
gem 'unicorn', '~> 4.8'

# Use sunspot as the search engine.
gem 'sunspot_rails'
gem 'sunspot_solr'
gem 'progress_bar'

# Use Capistrano for deployment
# gem 'capistrano-rails', group: :development

# Use debugger
# gem 'debugger', group: [:development, :test]

gem 'devise', '~> 3.2'
gem 'awesome_print', '~> 1.2'
gem 'foreigner', '~> 1.6'
gem 'railroady', '~> 1.1'
gem 'acts-as-taggable-on', '~> 3.3'
gem 'thin', '~> 1.6'
gem 'kaminari', '~> 0.16'
gem 'diffy', '~> 3.0'
gem 'yaml_db'
gem 'activerecord-import', '~> 0.5'
gem 'counter_culture', '~> 0.1'
gem 'config', '~> 1.0.0'
gem 'dotenv-rails', '~> 0.11'
gem 'bootstrap-sass', '~> 3.2'
gem 'bootswatch-rails', '~> 3.2'
gem 'autoprefixer-rails', '~> 2.2'
gem 'compass-rails', '~> 2.0'
# gem 'whenever', :require => false
gem 'omniauth-google-oauth2', '~> 0.2'
gem 'carrierwave', '~> 0.10'
gem 'jquery-fileupload-rails', '~> 0.4'
gem 'qiita-markdown'

group :development do
  gem 'bullet'
  gem 'rack-mini-profiler'
  gem 'letter_opener'
  gem 'binding_of_caller'
  gem 'better_errors'
end

group :development, :test do
  gem 'pry'
  gem 'pry-rails'
  gem 'pry-byebug'
  gem 'pry-rescue'
  gem 'coveralls', require: false
end

group :test do
  gem 'forgery'
  gem 'rspec-rails'
  gem 'rspec-its'
  gem 'rspec-parameterized'
  gem 'factory_girl_rails'
  gem 'spring-commands-rspec'
  gem 'shoulda-matchers', '~> 3.1'
  gem 'capybara'
  gem 'poltergeist'
  gem 'database_cleaner'
  gem 'launchy'
  gem 'codeclimate-test-reporter', group: :test, require: nil
end

# Include database gems for the adapters found in the database
# configuration file
require 'erb'
require 'yaml'
database_file = File.join(File.dirname(__FILE__), 'config/database.yml')
if File.exist?(database_file)
  database_config = YAML.load(ERB.new(IO.read(database_file)).result)
  adapters = database_config.values.map { |c| c['adapter'] }.compact.uniq
  if adapters.any?
    adapters.each do |adapter|
      case adapter
      when 'mysql2'
        gem 'mysql2', '~> 0.3.20'
      when /postgresql/
        gem 'pg', '~> 0.17'
      when /sqlite3/
        gem 'sqlite3', '~> 1.3'
      else
        warn(
          "Unknown database adapter `#{adapter}` found in config/database.yml"
        )
      end
    end
  else
    warn('No adapter found in config/database.yml, please configure it first')
  end
else
  warn('Please configure your config/database.yml first')
end
