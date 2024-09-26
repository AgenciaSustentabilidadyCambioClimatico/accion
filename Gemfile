source 'https://rubygems.org'

git_source(:github) do |repo_name|
  repo_name = "#{repo_name}/#{repo_name}" unless repo_name.include?("/")
  "https://github.com/#{repo_name}.git"
end
ruby '3.0.6'

gem 'caracal-rails'
gem "animate-rails"
gem "hashid-rails", "~> 1.0"
gem 'activerecord-session_store'
gem 'autonumeric-rails'
gem 'rails', '~> 6.0.1'
gem 'caxlsx_rails'
gem 'bootstrap', '~> 4.0.0'
gem 'carrierwave', '~> 1.0'
gem 'chartkick', '~>5.0.4'
gem 'ckeditor', git: 'https://github.com/galetahub/ckeditor.git', ref: 'dc2cef2c2c3358124ebd86ca2ef2335cc898b41f'
gem 'crontab_syntax_checker'
gem 'daemons'
gem 'data-confirm-modal'
gem 'datejs-rails'
gem 'delayed_job'
gem 'delayed_job_active_record'
gem 'devise', '~> 4.7.3'
gem 'devise_invitable', '~> 2.0.6'
gem 'font-awesome-rails'
gem 'geocoder'
gem 'geoxml-rails'
gem 'google-api-client'
gem 'googleauth', '~> 1.5.2'
gem 'haml'
gem 'haml-rails', '~> 1.0'
gem 'htmltoword'
gem 'httparty'
gem 'jquery-datatables'
gem 'jquery-rails'
gem 'nested_form'
gem 'pg'
gem 'prawn', '~>2.4.0'
gem 'prawn-table', '~> 0.2.2'
gem 'puma', '~> 4.0'
gem 'pundit'
gem 'puredocx', '~> 0.0.2'
gem 'quilljs-rails'
gem 'roo'
gem 'roo-xls'
gem 'ruby-units', '~> 2.3'
# gem 'rubyzip', '~> 1.2.0'
gem 'rubyzip'
gem 'rut_validation'
gem 'sass-rails', '~> 5.0'
gem 'simple_form'
gem 'uglifier', '>= 1.3.0'
gem 'whenever', require: false # DZC 2019-08-23 18:41:54 se agrega para manejar cron
gem 'zip-zip'
gem 'select2-rails'
gem 'wicked_pdf'  
gem 'wkhtmltopdf-binary'
gem 'mini_magick'
gem 'multi_json', '~> 1.14.1'
gem 'globalid', '~> 1.0'
gem 'letter_opener', group: :development
gem "cocoon"
gem "dotenv-rails", groups: [:development, :test]
gem 'will_paginate'
gem 'will_paginate-bootstrap4'
gem 'rollbar'
gem 'ruby-graphviz'
group :development, :test do
  gem 'byebug', platforms: [:mri, :mingw, :x64_mingw]
  gem 'capybara', '~> 2.13'
  # gem 'selenium-webdriver' ## DZC 2019-08-26 14:47:15 comentado por incompatibilidad con axslx -> rubyzip 
end


group :development do
  gem 'awesome_print'
  gem 'capistrano', "~> 3.10", require: false
  gem 'capistrano-delayed-job', '~> 1.0'
  gem 'capistrano-rails', "~> 1.3", require: false
  gem 'capistrano-rvm'
  gem 'capistrano-upload-config'
  gem 'capistrano3-nginx'
  gem 'capistrano3-puma'
  gem 'colorize'
  gem 'faker', :git => 'https://github.com/stympy/faker.git', :branch => 'main'
  gem 'listen', '>= 3.1.5', '< 3.7.1'
  gem 'pry'
  gem 'rails-erd'
  gem 'scout_apm'
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
  gem 'web-console', '>= 3.3.0'
  gem 'hirb'
end
