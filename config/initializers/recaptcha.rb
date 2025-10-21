Recaptcha.configure do |config|
  config.site_key  = ENV['RECAPTCHA_SITE_KEY']
  config.secret_key = ENV['RECAPTCHA_SECRET_KEY']
  # config.proxy = 'http://myproxy.com.au:8080' # si usas proxy
end
