require "sidekiq"
#require "sidekiq-status"
require "sidekiq/web"
#require "sidekiq-status/web"
require "sidekiq/cron/web"

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
  config.error_handlers << Proc.new { |ex, ctx_hash| Rollbar.log(ex, ctx_hash) }

  config.death_handlers << ->(job, ex) do
    puts "Uh oh, #{job["class"]} #{job["jid"]} just died with error #{ex.message}."
    Rollbar.log("error", "Sidekiq Job died", klass: job["class"], jid: job["jid"], message: ex.message)
  end

  if Rails.env.production?
    Rails.application.config.after_initialize do
      pool_size = (ENV["REDIS_SIZE"].presence || 20).to_i + 2
      reap_freq = (ENV["DATABASE_REAP_FREQ"].presence || 10).to_i

      ActiveRecord::Base.connection_pool.disconnect!

      ActiveSupport.on_load(:active_record) do
        # 1. Si existe DATABASE_URL (Dokku / Heroku), respetar la URL inyectada
        if ENV["DATABASE_URL"].present?
          uri = URI.parse(ENV["DATABASE_URL"])
          params = Rack::Utils.parse_nested_query(uri.query || "")
          params["pool"] = pool_size
          params["reaping_frequency"] = reap_freq
          uri.query = Rack::Utils.build_query(params)

          ActiveRecord::Base.establish_connection(uri.to_s)
        else
          # 2. Si no hay DATABASE_URL, tomar la configuración de database.yml de Rails 7
          db_config = ActiveRecord::Base.configurations.configs_for(env_name: Rails.env).first.configuration_hash.dup
          db_config[:pool] = pool_size
          db_config[:reaping_frequency] = reap_freq

          ActiveRecord::Base.establish_connection(db_config)
        end

        Rails.logger.info("DB Connection Pool size for Sidekiq Server is now: #{ActiveRecord::Base.connection_pool.size}")
      end
    end
  end

  config.redis = { url: ENV["REDIS_URL"], :size => ENV["REDIS_SIZE"].to_i, network_timeout: 20 }

  config.server_middleware do |chain|
    #chain.add Sidekiq::Status::ServerMiddleware, expiration: 60.minutes.to_i # default
  end

  config.client_middleware do |chain|
    #chain.add Sidekiq::Status::ClientMiddleware
  end
end