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

  Rack::Attack.blocklist("bad-robots-documents") do |req|
    req.ip if /\S+\/document/.match?(req.path)
  end

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
end
