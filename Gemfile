source 'https://rubygems.org'

git_source(:github) do |repo_name|
  repo_name = '#{repo_name}/#{repo_name}' unless repo_name.include?('/')
  'https://github.com/#{repo_name}.git'
end

#ruby '2.2.5'

gem 'rails', '~> 5.1.6'
gem 'puma', '~> 3.7'
gem 'sass-rails', '~> 5.0'
gem 'uglifier', '>= 1.3.0'
gem 'coffee-rails', '~> 4.2'
gem 'turbolinks', '~> 5'
gem 'jbuilder', '~> 2.5'

gem 'administrate'
gem 'administrate-field-password'
gem 'awesome_print'
gem 'aws-sdk', '~> 2.3.0'
gem 'best_in_place', git: 'git@github.com:rogsmith/best_in_place.git'
gem 'bootstrap-generators', '~> 3.3.4'
gem 'bootstrap-sass'
gem 'bourbon'
gem 'commontator', '~> 5.1.0'
gem 'devise'
gem 'exception_notification'
gem 'font-awesome-rails'
gem 'high_voltage'
gem 'jquery-datatables-rails', '~> 3.4.0'
gem 'jquery-fileupload-rails'
gem 'jquery-rails'
gem 'kaminari'
gem 'local_time'
gem 'mysql2', '~> 0.3.18'
gem 'paperclip', '~> 5.1.0'
gem 'rails_autolink'
gem 'ransack'
gem 'record_tag_helper', '~> 1.0'
gem 'sendgrid-ruby', '~> 1.1.6'
gem 'sidekiq', '~> 3.5.0'
gem 'simple_form'
gem 'summernote-rails'
gem 'therubyracer', :platform=>:ruby
gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]
gem 'workflow'


group :development do
  gem 'better_errors'
  gem 'capistrano', '~> 3.8'
  gem 'capistrano-bundler'
  gem 'capistrano-rails', '~> 1.1.1'
  gem 'capistrano-rails-console'
  gem 'capistrano-rbenv', git: 'git@github.com:capistrano/rbenv.git'
  gem 'capistrano-rvm', '~> 0.1.1'
  gem 'guard-bundler'
  gem 'guard-rails'
  gem 'guard-rspec'
  gem 'letter_opener'
  gem 'listen', '>= 3.0.5', '< 3.2'
  gem 'log_analyzer'
  gem 'rails_layout'
  gem 'rb-fchange', :require=>false
  gem 'rb-fsevent', :require=>false
  gem 'rb-inotify', :require=>false
  gem 'spring'
  gem 'spring-commands-rspec'
  gem 'spring-watcher-listen', '~> 2.0.0'
  gem 'web-console', '>= 3.3.0'
end

group :development, :test do
  gem 'byebug', platforms: [:mri, :mingw, :x64_mingw]
  gem 'capybara', '~> 2.13'
  gem 'factory_bot_rails'
  gem 'faker'
  gem 'pry-rails'
  gem 'rspec-rails'
  gem 'selenium-webdriver'
end

group :test do
  gem 'database_cleaner'
  gem 'launchy'
end
