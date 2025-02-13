
deploy = YAML.unsafe_load(ERB.new(File.read("#{Dir.pwd}/config/deploy.yml")).result)["staging"]
login="#{deploy["server"]["user"]}@#{deploy["server"]["host"]}"
# set :user, deploy["gateway"]["user"]
# set :gateway, deploy["gateway"]["host"]
# set :ssh_options, {
#   user: fetch(:user),
#   forward_agent: false,
#   proxy: Net::SSH::Proxy::Command.new(
#     "ssh -l #{fetch(:user)} #{fetch(:gateway)} -W %h:%p"
#   )
# }

set :application, deploy["application"] # staging

set :repo_url, deploy["repo"]["url"]
set :branch, deploy["repo"]["branch"]

set :user, 'ext-binary'
set :stage, "staging"

set :deploy_to, deploy["path"]
set :nginx_server_name, deploy["domain"]
set :nginx_port, 3999
set :nginx_read_timeout, 60
server deploy["server"]["host"], user: deploy["server"]["user"], roles: %w{app web db}
role :app, [login]
role :web, [login]
role :db,  [login]


task :db_update do
  Dir.foreach("#{Dir.pwd}/tables/") do |f|
    unless ['..','.'].include?(f)
      File.delete(File.join("#{Dir.pwd}/tables/", f))
    end
  end
	File.open("#{Dir.pwd}/tables/db_update.sql", 'w') {|f| f.truncate(0) }
	file=File.open("#{Dir.pwd}/tables/db_update.sql", 'a')
	on roles(:app) do
		ENV['tables'].split(";").each do |table|
      database_name = ENV['db'].nil? ? "#{deploy["application"]}_development" : ENV['db']
			system("pg_dump --format custom --file #{Dir.pwd}/tables/#{table}.backup --table #{table} #{database_name}")
			file.puts("DELETE FROM #{table}; ALTER SEQUENCE IF EXISTS #{table}_id_seq RESTART WITH 1;")
		end
	end
	file.close
  if ENV['only_backup'].nil? || ENV['only_backup'] == false
    on ( server deploy["server"]["host"], user: deploy["server"]["user"], roles: %w{app web db} ) do |host|
      execute("rm -rf #{deploy['path']}/tables")
    	execute("mkdir -p #{deploy['path']}/tables/")
    	upload!("#{Dir.pwd}/tables", deploy['path'],{recursive: true})
    	execute("psql -h localhost -U postgres -d #{deploy["application"]}_staging -a -f #{deploy['path']}/tables/db_update.sql")
    	execute("for backup in #{deploy['path']}/tables/*.backup; do pg_restore -h localhost -U postgres -d #{deploy["application"]}_staging -1 -a $backup; done")
  	end
  end
end
