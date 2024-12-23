Rails.application.config.session_store :cookie_store, key: ENV['SECRET_KEY_BASE'], domain: :all
