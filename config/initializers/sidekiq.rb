require "sidekiq"
#require "sidekiq-status"
require "sidekiq/web"
#require "sidekiq-status/web"
require "sidekiq/cron/web"

# if Rails.env.development?
# redis_url =  'redis://localhost:6379/0'
# end

Sidekiq.default_job_options = { "backtrace" => true }

schedule_file = "#{Rails.root}/config/sidekiq_schedule.yml"

if File.exist?(schedule_file) && Sidekiq.server? && Rails.env.production?
  Sidekiq::Cron::Job.load_from_hash YAML.load_file(schedule_file)
end

Sidekiq.configure_client do |config|
  config.redis = { url: ENV["REDIS_URL"], :size => 1, network_timeout: 20 }
  config.client_middleware do |chain|
    #chain.add Sidekiq::Status::ClientMiddleware, expiration: 60.minutes.to_i
  end
end

Sidekiq.configure_server do |config|
  # The config.redis is calculated by the
  # concurrency value so you do not need to
  # specify this. For this demo I do
  # show it to understand the numbers
  config.error_handlers << Proc.new { |ex, ctx_hash| Rollbar.log(ex, ctx_hash) }

  config.death_handlers << ->(job, ex) do
    puts "Uh oh, #{job["class"]} #{job["jid"]} just died with error #{ex.message}."
    Rollbar.log("error", "Sidekiq Job died", klass: job["class"], jid: job["jid"], message: ex.message)
  end

  if Rails.env.production?

    #Sidekiq::Logging.logger =  Rails.logger
    Rails.application.config.after_initialize do
      Rails.logger.info("DB Connection Pool size for Sidekiq Server before disconnect is: #{ActiveRecord::Base.connection.pool.instance_variable_get("@size")}")
      ActiveRecord::Base.connection_pool.disconnect!

      ActiveSupport.on_load(:active_record) do
        #config = Rails.application.config.database_configuration[Rails.env]
        config = ActiveRecord::Base.connection_config
        config["reaping_frequency"] = ENV["DATABASE_REAP_FREQ"] || 10 # seconds
        # config['pool'] = ENV['WORKER_DB_POOL_SIZE'] || Sidekiq.options[:concurrency]

        config["pool"] = ENV["REDIS_SIZE"].to_i + 2

        ActiveRecord::Base.establish_connection(config)

        Rails.logger.info("DB Connection Pool size for Sidekiq Server is now: #{ActiveRecord::Base.connection.pool.instance_variable_get("@size")}")
      end
    end
  end

  config.redis = { url: ENV["REDIS_URL"], :size => ENV["REDIS_SIZE"].to_i, network_timeout: 20 }

  config.server_middleware do |chain|
    #chain.add Sidekiq::Status::ServerMiddleware, expiration: 60.minutes.to_i # default
    #chain.add AttentiveSidekiq::Middleware::Server::Attentionist
  end
  config.client_middleware do |chain|
    #chain.add Sidekiq::Status::ClientMiddleware
  end
end
