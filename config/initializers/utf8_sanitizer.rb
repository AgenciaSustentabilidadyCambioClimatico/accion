class UTF8Sanitizer
  def initialize(app)
    @app = app
  end

  def call(env)
    # Sanitizar parámetros de query string
    if env['QUERY_STRING']
      begin
        env['QUERY_STRING'] = sanitize_utf8(env['QUERY_STRING'])
      rescue ArgumentError
        return [400, {'Content-Type' => 'text/plain'}, ['Invalid UTF-8 sequence']]
      end
    end

    # Sanitizar body del request
    if env['rack.input']
      begin
        body = env['rack.input'].read
        env['rack.input'] = StringIO.new(sanitize_utf8(body))
      rescue ArgumentError
        return [400, {'Content-Type' => 'text/plain'}, ['Invalid UTF-8 sequence']]
      end
    end

    @app.call(env)
  end

  private

  def sanitize_utf8(string)
    # Remover null bytes y caracteres de control
    string = string.gsub(/[\x00-\x08\x0B\x0C\x0E-\x1F\x7F]/, '')
    
    # Forzar encoding UTF-8 y remover caracteres inválidos
    string.force_encoding('UTF-8').encode('UTF-8', invalid: :replace, undef: :replace, replace: '')
  end
end 