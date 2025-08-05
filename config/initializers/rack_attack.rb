class Rack::Attack
  Rack::Attack.cache.store = ActiveSupport::Cache::MemoryStore.new

  Rack::Attack.blocklist("block python-requests") do |req|
    req.user_agent.to_s.include? "python-requests"
  end

  Rack::Attack.blocklist("block requests without domain") do |req|
    req.host.match?(/\A\d{1,3}(\.\d{1,3}){3}\z/) # Detecta direcciones IP en el host
  end

  Rack::Attack.blocklist("block curl") do |req|
    req.user_agent.to_s.include? "curl"
  end

  Rack::Attack.blocklist("HNAP1") do |request|
    # Requests are blocked if the return value is truthy
    request.path.start_with?("/HNAP1")
  end

  # Rack::Attack.blocklist("bad-robots-documents") do |req|
  #   req.ip if /\S+\/document/.match?(req.path)
  # end

  Rack::Attack.blocklist('block bots by user-agent') do |req|
    req.user_agent =~ /\b(bot|crawler|spider|scanner)\b/i
  end

  Rack::Attack.blocklist("bad-robots-txt") do |req|
    req.ip if /\S+\.txt/.match?(req.path)
  end

    Rack::Attack.blocklist("block requests without User-Agent") do |req|
    req.user_agent.nil? || req.user_agent.strip.empty?
  end

    Rack::Attack.blocklist("block .git/config requests") do |req|
    req.path.include?("/.git/config")
  end

  Rack::Attack.blocklist("block wlwmanifest.xml requests") do |req|
    req.path.include?("wlwmanifest.xml")
  end

   Rack::Attack.blocklist("env") do |req|
    req.ip if /\S+\.env/.match?(req.path)
  end
  Rack::Attack.blocklist("bad-robots-php") do |req|
    req.ip if /\S+\.php/.match?(req.path)
  end
  Rack::Attack.blocklist("bad-robots-PHP") do |req|
    req.ip if /\S+\.PHP/.match?(req.path)
  end

  Rack::Attack.blocklist("any cfg request") do |req|
    req.ip if /\S+\.cfg/.match?(req.path)
  end

  Rack::Attack.blocklist("any cfg request") do |req|
    req.ip if /\S+\.exp/.match?(req.path)
  end

  Rack::Attack.blocklist("any php request") do |req|
    req.path =~ /\.php/ && (req.get? || req.post?)  #&& req.user_agent == 'BadUA'
  end

  throttle("logins/ip", limit: 5, period: 20.seconds) do |req|
    if req.path == "/users/login" && req.post?
      req.ip
    end
  end

  # Bloquear requests con métodos HTTP maliciosos
  blocklist('block malicious HTTP methods') do |req|
    malicious_methods = %w[TRACK TRACE CONNECT PROPFIND PROPPATCH MKCOL COPY MOVE LOCK UNLOCK VERSION-CONTROL REPORT CHECKOUT CHECKIN UNCHECKOUT MKWORKSPACE UPDATE]
    malicious_methods.include?(req.request_method)
  end

  # Bloquear requests con payloads maliciosos
  blocklist('block malicious payloads') do |req|
    malicious_patterns = [
      /%25.*%25url%25/,  # Patrón del ataque anterior
      /\.exec\|\{\.\?cmd\.\}/,  # Intentos de ejecución de comandos
      /timeout=\d+\|out=/,  # Parámetros maliciosos
      /ACXTEST:/,  # Marcador de ataque
      /\.\.\/\.\.\/\.\.\/\.\.\/\.\.\/\.\.\/\.\.\/etc\//,  # Path traversal
      /%c0%af%c0%af/,  # Unicode encoding attacks
      /%00/,  # Null byte injection
      /[\x00-\x08\x0B\x0C\x0E-\x1F\x7F]/  # Control characters
    ]
    
    malicious_patterns.any? { |pattern| req.path.match?(pattern) || req.query_string.match?(pattern) }
  end

  # Bloquear requests con encoding malicioso
  blocklist('block malicious encoding') do |req|
    begin
      # Verificar si el path o query string contienen bytes maliciosos
      req.path.force_encoding('UTF-8').encode('UTF-8', invalid: :raise)
      req.query_string.force_encoding('UTF-8').encode('UTF-8', invalid: :raise)
      false
    rescue ArgumentError
      true
    end
  end

  # Rate limiting para prevenir ataques de fuerza bruta
  throttle('requests by IP', limit: 300, period: 5.minutes) do |req|
    req.ip
  end

  # Bloquear IPs que envían muchos requests maliciosos
  blocklist('block malicious IPs') do |req|
    Rack::Attack::Allow2Ban.filter(req.ip, maxretry: 5, findtime: 10.minutes, bantime: 1.hour) do
      req.request_method != 'GET' && req.request_method != 'POST'
    end
  end
end
