source 'https://rubygems.org'

git_source(:github) do |repo_name|
  repo_name = "#{repo_name}/#{repo_name}" unless repo_name.include?("/")
  "https://github.com/#{repo_name}.git"
end

gem 'rails', '~> 5.1.6'
gem 'puma', '~> 3.7'
gem 'sass-rails', '~> 5.0'
gem 'uglifier', '>= 1.3.0'
gem 'pg'
gem 'haml'
gem 'haml-rails', '~> 1.0'
gem 'simple_form'
gem 'devise'
gem 'font-awesome-rails'
gem 'bootstrap', '~> 4.0.0'
gem 'jquery-rails'
gem 'chartkick'
gem 'jquery-datatables'
gem 'pundit'
gem 'nested_form'
gem 'rut_validation'
gem 'carrierwave', '~> 1.0'
gem "animate-rails"
gem "hashid-rails", "~> 1.0"
gem 'activerecord-session_store'
gem 'quilljs-rails'
gem 'puredocx', '~> 0.0.2'
gem 'prawn', '~>2.2.2'
gem 'crontab_syntax_checker'
gem 'rubyzip', '~> 1.2.0'
gem 'zip-zip'
gem 'autonumeric-rails'
gem 'geocoder'
gem 'httparty'
gem 'data-confirm-modal'
gem 'delayed_job'
gem 'delayed_job_active_record'
gem 'geoxml-rails'
gem 'ckeditor', github: 'galetahub/ckeditor'
gem 'daemons'
#gem 'axlsx', '~> 2.1.0.pre'
gem 'axlsx'
gem 'axlsx_rails'
gem 'devise_invitable'
gem 'ruby-units', '~> 2.3'
gem 'datejs-rails'
gem 'htmltoword'
gem 'roo'
gem 'roo-xls'

group :development, :test do
  gem 'byebug', platforms: [:mri, :mingw, :x64_mingw]
  gem 'capybara', '~> 2.13'
  gem 'selenium-webdriver'
end

group :development do
  gem 'web-console', '>= 3.3.0'
  gem 'listen', '>= 3.0.5', '< 3.2'
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
  gem 'awesome_print'
  gem 'pry'
  gem 'colorize'
  gem "capistrano", "~> 3.10", require: false
  gem 'capistrano-delayed-job', '~> 1.0'
  gem "capistrano-rails", "~> 1.3", require: false
  gem 'capistrano-rvm'
  gem 'capistrano3-puma'
  gem 'capistrano3-nginx'
  gem 'capistrano-upload-config'
  gem 'faker', :git => 'https://github.com/stympy/faker.git', :branch => 'master'
  gem 'scout_apm'
  gem 'rails-erd'
end
