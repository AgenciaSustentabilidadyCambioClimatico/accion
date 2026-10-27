class Rack::Attack
  # 1. Utilizar Redis si existe REDIS_URL para compartir contadores entre procesos
  if ENV["REDIS_URL"].present?
    redis_client = Redis.new(url: ENV["REDIS_URL"])
    Rack::Attack.cache.store = Rack::Attack::StoreProxy::RedisStoreProxy.new(redis_client)
  else
    Rack::Attack.cache.store = ActiveSupport::Cache::MemoryStore.new
  end

  # === SALVAVIDAS PARA AZURE APPLICATION GATEWAY ===
  require "ipaddr"
  APP_GATEWAY_SUBNET = IPAddr.new("172.29.3.0/24") unless defined?(APP_GATEWAY_SUBNET)

  Rack::Attack.safelist("allow Azure App Gateway health probes") do |req|
    begin
      APP_GATEWAY_SUBNET.include?(IPAddr.new(req.ip.to_s))
    rescue IPAddr::Error, IPAddr::InvalidAddressError, ArgumentError
      false
    end
  end
  # =================================================

  # Reglas de bloqueo por User-Agent y bots
  Rack::Attack.blocklist("block python-requests") do |req|
    req.user_agent.to_s.include?("python-requests")
  end

  Rack::Attack.blocklist("block requests without domain") do |req|
    req.host.match?(/\A\d{1,3}(\.\d{1,3}){3}\z/)
  end

  Rack::Attack.blocklist("block curl") do |req|
    req.user_agent.to_s.include?("curl")
  end

  Rack::Attack.blocklist("block bots by user-agent") do |req|
    req.user_agent =~ /\b(bot|crawler|spider|scanner)\b/i
  end

  Rack::Attack.blocklist("block requests without User-Agent") do |req|
    req.user_agent.nil? || req.user_agent.strip.empty?
  end

  # Bloqueos de paths maliciosos típicos
  Rack::Attack.blocklist("block malicious paths") do |req|
    req.path.start_with?("/HNAP1") ||
      req.path.include?("/.git/config") ||
      req.path.include?("wlwmanifest.xml") ||
      req.path =~ /\.(env|cfg|exp|php|PHP)(\/|$)/i
  end

  # Throttle: Logins (5 intentos cada 20 segundos)
  throttle("logins/ip", limit: 5, period: 20.seconds) do |req|
    req.ip if req.path == "/users/login" && req.post?
  end

  # Throttle B2.2: Anti-enumeración en endpoints públicos de proveedores (5 peticiones por minuto)
  throttle("req/ip/registro_proveedores", limit: 5, period: 1.minute) do |req|
    if req.path.include?("get_by_rut") || req.path.include?("get_contribuyentes")
      req.ip
    end
  end

  # Respuesta HTTP 429 personalizada
  self.throttled_response = lambda do |env|
    match_data = env["rack.attack.match_data"]
    retry_after = match_data ? match_data[:period] - (match_data[:epoch_time] % match_data[:period]) : 60

    headers = {
      "Content-Type" => "application/json",
      "Retry-After" => retry_after.to_s
    }

    body = {
      error: "Límite de consultas excedido. Intente nuevamente en 1 minuto.",
      retry_after_seconds: retry_after
    }.to_json

    [429, headers, [body]]
  end
end