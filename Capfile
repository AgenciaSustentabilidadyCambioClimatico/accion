require "capistrano/setup"
require "capistrano/deploy"
require "capistrano/scm/git"
install_plugin Capistrano::SCM::Git
require "capistrano/rails"
require "capistrano/rvm"
require "capistrano/bundler"
require "capistrano/rails/assets"
require "capistrano/nginx"
require "capistrano/puma"
install_plugin Capistrano::Puma
require "capistrano/puma/nginx"
install_plugin Capistrano::Puma::Nginx
require "capistrano/upload-config"

# DZC 2019-08-23 19:10:27 
require "whenever/capistrano"

# Load custom tasks from `lib/capistrano/tasks` if you have any defined
Dir.glob("lib/capistrano/tasks/*.rake").each { |r| import r }