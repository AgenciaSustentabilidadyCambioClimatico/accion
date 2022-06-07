deploy=YAML.load(ERB.new(File.read("#{Dir.pwd}/config/deploy.yml")).result)["production"]
lock "~> 3.10.1"

# Default value for default_env is {}
# set :default_env, { path: "/opt/ruby/bin:$PATH" }

# Default value for local_user is ENV['USER']
# set :local_user, -> { `git config user.name`.chomp }
# Uncomment the following to require manually verifying the host key before first deploy.
# set :ssh_options, verify_host_key: :secure


set :application, deploy["application"] # accion o dev-accion
set :repo_url, deploy["repo"]["url"] # accion.ascc.cl
set :branch, deploy["repo"]["branch"] # master

set :git_http_username, deploy["git_http_username"]
set :git_http_password, deploy["git_http_password"]

set :linked_files, fetch(:linked_files, []).push('config/database.yml', 'config/secrets.yml', 'config/email.yml', 'config/puma.rb', 'config/clave_unica.yml') 
set :linked_dirs, fetch(:linked_dirs, []).push('log', 'tmp/pids', 'tmp/cache', 'tmp/sockets', 'vendor/bundle', 'public/system', 'public/uploads')
set :keep_releases, 7
set :ssl_header_forwarded, true
namespace :deploy do
  before 'check:linked_files', 'puma:config'
  # before 'check:linked_files', 'puma:nginx_config'
  # after 'puma:smart_restart', 'nginx:restart' #
  # after 'nginx:restart', 'puma:stop' #
  # after 'nginx:restart', 'puma:start' #REVISAR

  # DZC 2019-12-13 17:07:52 
  task :ejecuta_seed do
    on roles(:app) do
      within release_path do
        with rails_env: fetch(:rails_env) do
          execute :rake, "db:seed"
          # execute :rake, "jobs:work"
        end
      end
    end
  end
  #after 'deploy:migrate', 'deploy:ejecuta_seed'    
end
after 'deploy:publishing', 'deploy:restart'

# DZC 2018-11-22 12:14:41 se agrega para ingresar a crontab la limpieza de la carpeta de temporales de crontab
# after 'deploy:publishing', 'ascc:agrega_limpia_cache_carrierwave_a_crontab'

# DZC 2018-11-22 14:51:42 se agrega para ingresar todos los recordatorios de tareas al crontab, asi como también la limpieza de la carpeta temporal de carrierwave
# after 'deploy:publishing', 'ascc:agrega_recordatorios_crontab'
# after 'deploy:publishing', 'ascc:ejecuta_muestra_variables_de_entorno'


namespace :deploy do
  task :restart do
    invoke 'delayed_job:restart'
  end
end


