class Devise::Strategies::Authenticatable
	alias_method :original_with_authentication_hash, :with_authentication_hash
	def with_authentication_hash(auth_type, auth_values)
		auth_values["rut"] = auth_values["rut"].to_s.upcase.gsub(/[^0-9\-K]/,'') if auth_values.has_key?("rut")
  	original_with_authentication_hash(auth_type, auth_values)
	end
end