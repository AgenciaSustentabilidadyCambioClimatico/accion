if %w[prod].include?(ENV["AMBIENTE"])
  Rails.application.config.session_store :cookie_store, key: ENV['SECRET_KEY_BASE'], domain: 'accion.ascc.cl'
elsif %w[stag].include?(ENV["AMBIENTE"])
  Rails.application.config.session_store :cookie_store, key: ENV['SECRET_KEY_BASE'], domain: 'accion-stag.ascc.cl'
else
  Rails.application.config.session_store :cookie_store, key: ENV['SECRET_KEY_BASE'], domain: :all
end
