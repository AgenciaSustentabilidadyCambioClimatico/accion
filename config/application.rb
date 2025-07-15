require_relative 'boot'

require 'rails/all'
require 'will_paginate/array'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Ascc
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 5.1
    config.time_zone = 'Santiago'
    config.i18n.default_locale = :es
    config.assets.paths << Rails.root.join('app', 'assets', 'fonts')
    config.active_job.queue_adapter = :sidekiq
    config.active_record.use_yaml_unsafe_load = true

    config.middleware.insert_before(Rack::Sendfile, Rack::Deflater)
    
    # Configurar límite de upload para archivos grandes
    config.middleware.use Rack::ContentLength, 50 * 1024 * 1024  # 50MB
    # config.web_console.whitelisted_ips = '190.215.33.10'
    # Rails.application.configure do
    #   config.web_console.whitelisted_ips = '0.0.0.0/0'
    #   # config.web_console.whitelisted_ips = '192.168.0.0/24'
    # end
    if Rails.env.production?
      config.hosts << /.*\.ascc\.cl/
    end
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    # scaffold config
    # se define que cree migración, vistas, controlador, modelo, ruta, decorator y helper
    # se bloquean los test y jbuilder, descomentar si es necesario
    config.generators do |g|
      # g.helper false # descomentar helper si no se quiere generar
      g.assets false
      g.system_tests false # este por defecto desactiva test_unit por lo que no es necesario desactivarlo despues
      g.test_framework false
      # g.jbuilder false
      # g.test_unit false # con este queda test_unit/system... con -> system_tests false desaparece
    end
    config.eager_load_paths << Rails.root.join('lib')
    #config.action_mailer.asset_host = '190.215.33.11:3999'
    def updating_record?
      persisted? # This checks if the record already exists (i.e., it's an update)
    end
  end
end
