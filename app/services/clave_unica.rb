class ClaveUnica

	CLAVE_UNICA_URL 	= 'https://accounts.claveunica.gob.cl'

	SERVER_AUTH 			= self::CLAVE_UNICA_URL+'/openid/authorize'
	ACCESS_TOKEN_AUTH = self::CLAVE_UNICA_URL+'/openid/token'
	USER_INFO 				= self::CLAVE_UNICA_URL+'/openid/userinfo'
	LOGOUT 						= self::CLAVE_UNICA_URL+'/api/v1/accounts/app/logout'

	def self.variables
		YAML.safe_load(ERB.new(File.read("#{Dir.pwd}/config/clave_unica.yml")).result)
	end

	def self.client_id
		variables['client_id']
	end

	def self.client_secret
		variables['client_secret']
	end

	def self.host
		variables['host']
	end

	def self.port
		variables['port']
	end

	def self.redirect_uri
		uri = self.host
		uri += ":" + self.port unless self.port.blank?
		uri += "/claveunica"
		uri
	end

	def self.server_token
		#Genera md5 en base a secret key base de rails
		require 'digest/md5'
		Digest::MD5.hexdigest(ENV["ASCC_SECRET_KEY_BASE"])
	end

	def self.url_server_auth
		#Obtiene url de boton que carga login de clave única
		require 'uri'

		uri = URI.parse(self::SERVER_AUTH)
		uri.query = URI.encode_www_form(
		  client_id: self::client_id,
		  response_type: 'code',
		  scope: 'openid run name email',
		  redirect_uri: self.redirect_uri,
		  state: self.server_token
		)
		uri.to_s
	end

	def self.login code
		#Combina el obtener access token y la data de usuario
		access_token_json = self.get_access_token(code)
		user_data_json = self.get_user_data(access_token_json["access_token"])
		user_data_json
	end

	def self.get_access_token code
		#Obtiene access token con el code devuelto en login
		require "uri"
		require "net/http"

		params = {
			client_id: self::client_id,
			client_secret: self::client_secret,
		  redirect_uri: self.redirect_uri,
		  grant_type: 'authorization_code',
		  code: code,
		  state: self.server_token
		}
		response = Net::HTTP.post_form(URI.parse(self::ACCESS_TOKEN_AUTH), params)
		JSON.parse(response.body)
	end

	def self.get_user_data access_token
		#Obtiene la data de usuario con access token
		require "uri"
		require "net/http"

		uri = URI(self::USER_INFO)
		params = {}
		headers = {
	    'Authorization'=>'Bearer '+access_token
		}

		http = Net::HTTP.new(uri.host, uri.port)
		http.use_ssl = true
		response = http.post(uri.path, params.to_json, headers)

		JSON.parse(response.body)
	end



end
