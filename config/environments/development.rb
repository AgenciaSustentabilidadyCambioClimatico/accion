#DZC Necesario para la habilitación de config.web_console.whitelisted_ips desde cualquier ip
require 'socket'
require 'ipaddr'

Rails.application.configure do
  # Configuración de recarga en desarrollo para Rails 7+
  config.enable_reloading = true

  # Do not eager load code on boot.
  config.eager_load = false

  # Show full error reports.
  config.consider_all_requests_local = true

  # Enable/disable caching. By default caching is disabled.
  if Rails.root.join('tmp/caching-dev.txt').exist?
    config.action_controller.perform_caching = true

    config.cache_store = :memory_store
    config.public_file_server.headers = {
      'Cache-Control' => "public, max-age=#{2.days.seconds.to_i}"
    }
  else
    config.action_controller.perform_caching = false

    config.cache_store = :null_store
  end

  email = YAML.unsafe_load(ERB.new(File.read("#{Dir.pwd}/config/email.yml")).result)
  config.action_mailer.default_url_options = { host: 'localhost', port: 3000 }

  # No detener transacciones si falla el mailer en local
  config.action_mailer.raise_delivery_errors = false
  config.action_mailer.perform_deliveries = true
  config.action_mailer.delivery_method = :letter_opener
  
  if email.is_a?(Hash)
    config.action_mailer.asset_host = email['asset_host'] || email['default_url_options_host']
    config.action_mailer.smtp_settings = {
      :address              => email['smtp_settings_address'],
      :port                 => email['smtp_settings_port'],
      :domain               => email['smtp_settings_domain'],
      :user_name            => email['smtp_settings_user_name'],
      :password             => email['smtp_settings_password'],
      :authentication       => email['smtp_settings_authentication'],
      :enable_starttls_auto => email['smtp_settings_enable_starttls_auto'],
    }
  end

  config.action_mailer.perform_caching = false

  # Print deprecation notices to the Rails logger.
  config.active_support.deprecation = :log

  # Raise an error on page load if there are pending migrations.
  config.active_record.migration_error = :page_load

  # Highlight code that triggered an ActiveRecord query
  config.active_record.verbose_query_logs = true

  # Debug mode disables concatenation and preprocessing of assets.
  config.assets.debug = true

  # Suppress logger output for asset requests.
  config.assets.quiet = true

  # oob_uri for Google Calendar authentication
  config.oob_uri = 'http://localhost:3999/oauth2callback'

  # Permitir conexiones desde cualquier host e IP en desarrollo
  config.hosts = nil
  config.web_console.permissions = '0.0.0.0/0'
  config.action_controller.allow_forgery_protection = false

  config.active_support.disallowed_deprecation = :raise
  config.active_support.disallowed_deprecation_warnings = []
end