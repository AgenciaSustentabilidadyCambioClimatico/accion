namespace :rake do
  # DZC 2018-11-22 12:15:24 se agrega para ejecutar rake tasks desde capistrano
  def args
    fetch(:delayed_job_args, "")
  end
 
  desc "Invoke rake task"
  task :invoke do
    execute :cd, "#{deploy_to}/current"
    execute :bundle, :exec, :rake, "#{ENV['task']} RAILS_ENV=#{rails_env}"
    # run "cd #{deploy_to}/current"
    # run "bundle exec rake #{ENV['task']} RAILS_ENV=#{rails_env}"
  end
end
 