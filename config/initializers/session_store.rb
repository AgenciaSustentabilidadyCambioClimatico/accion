if Rails.env.production?
  Rails.application.config.session_store :cookie_store, key: ENV['SECRET_KEY_BASE'], domain: :all
else
  Rails.application.config.session_store :cookie_store, key: ENV['SECRET_KEY_BASE']
end
