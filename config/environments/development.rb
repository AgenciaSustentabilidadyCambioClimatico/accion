#DZC Necesario para la habilitación de config.web_console.whitelisted_ips desde cualquier ip
require 'socket'
require 'ipaddr'
require 'psych'

Rails.application.configure do
  # Settings specified here will take precedence over those in config/application.rb.

  # In the development environment your application's code is reloaded on
  # every request. This slows down response time but is perfect for development
  # since you don't have to restart the web server when you make code changes.
  config.cache_classes = false

  #DZC permite la rederización de la consola desde ips externas
  # config.web_console.whitelisted_ips = Socket.ip_address_list.reduce([]) do |res, addrinfo|
  #   addrinfo.ipv4? ? res << IPAddr.new(addrinfo.ip_address).mask(24) : res
  # end
  # config.web_console.whitelisted_ips = ['190.215.33.10']
  # # config.web_console.whitelisted_ips += ['190.215.33.11']
  config.web_console.allowed_ips = ['0.0.0.0/0']
  # config.web_console.whitelisted_ips += ['10.0.0.0/8', '172.16.0.0/12', '192.168.0.0/16']

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
  config.action_mailer.raise_delivery_errors = true
  config.action_mailer.perform_deliveries = true
  config.action_mailer.delivery_method = :letter_opener
  config.action_mailer.asset_host = email['asset_host']
  config.action_mailer.asset_host = email['default_url_options_host']
  config.action_mailer.smtp_settings = {
    :address              => email['smtp_settings_address'],
    :port                 => email['smtp_settings_port'],
    :domain               => email['smtp_settings_domain'],
    :user_name            => email['smtp_settings_user_name'],
    :password             => email['smtp_settings_password'],
    :authentication       => email['smtp_settings_authentication'],
    :enable_starttls_auto => email['smtp_settings_enable_starttls_auto'],
  }

  config.action_mailer.perform_caching = false


  # Print deprecation notices to the Rails logger.
  config.active_support.deprecation = :log

  # Raise an error on page load if there are pending migrations.
  config.active_record.migration_error = :page_load

  # Debug mode disables concatenation and preprocessing of assets.
  # This option may cause significant delays in view rendering with a large
  # number of complex assets.
  config.assets.debug = true

  # Suppress logger output for asset requests.
  config.assets.quiet = true

  # Raises error for missing translations
  # config.action_view.raise_on_missing_translations = true

  # Use an evented file watcher to asynchronously detect changes in source code,
  # routes, locales, etc. This feature depends on the listen gem.
  config.file_watcher = ActiveSupport::EventedFileUpdateChecker

  #oob_uri for Google Calendar authentication
  config.oob_uri = 'http://localhost:3999/oauth2callback'
end
