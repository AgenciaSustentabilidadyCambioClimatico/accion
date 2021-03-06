source 'https://rubygems.org'

git_source(:github) do |repo_name|
  repo_name = "#{repo_name}/#{repo_name}" unless repo_name.include?("/")
  "https://github.com/#{repo_name}.git"
end

gem "animate-rails"
gem "hashid-rails", "~> 1.0"
gem 'activerecord-session_store'
gem 'autonumeric-rails'
gem 'axlsx', '~> 2.1.0.pre'
# gem 'axlsx'
gem 'axlsx_rails', '~> 0.3.0'
gem 'bootstrap', '~> 4.0.0'
gem 'carrierwave', '~> 1.0'
gem 'chartkick'
gem 'ckeditor', github: 'galetahub/ckeditor'
gem 'crontab_syntax_checker'
gem 'daemons'
gem 'data-confirm-modal'
gem 'datejs-rails'
gem 'delayed_job'
gem 'delayed_job_active_record'
gem 'devise'
gem 'devise_invitable'
gem 'font-awesome-rails'
gem 'geocoder'
gem 'geoxml-rails'
gem 'haml'
gem 'haml-rails', '~> 1.0'
gem 'htmltoword'
gem 'httparty'
gem 'jquery-datatables'
gem 'jquery-rails'
gem 'nested_form'
gem 'pg'
gem 'prawn', '~>2.2.2'
gem 'prawn-table', '~> 0.2.2'
gem 'puma', '~> 3.7'
gem 'pundit'
gem 'puredocx', '~> 0.0.2'
gem 'quilljs-rails'
gem 'rails', '~> 5.1.6'
gem 'roo'
gem 'roo-xls'
gem 'ruby-units', '~> 2.3'
# gem 'rubyzip', '~> 1.2.0'
gem 'rubyzip', '~> 1.1.7'
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
  gem 'faker', :git => 'https://github.com/stympy/faker.git', :branch => 'master'
  gem 'listen', '>= 3.0.5', '< 3.2'
  gem 'pry'
  gem 'rails-erd'
  gem 'scout_apm'
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
  gem 'web-console', '>= 3.3.0'
end
