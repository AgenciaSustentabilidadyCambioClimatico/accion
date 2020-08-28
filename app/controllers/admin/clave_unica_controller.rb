class Admin::ClaveUnicaController < ApplicationController
	include Devise::Controllers::Helpers

	def callback
		#Callback de clave unica registro civil
		code = params[:code]
		state = params[:state]
		error = ''
		respond_to do |format|
			if(error.blank? && code.blank? || state.blank?)
				error = "Error al iniciar sesión con clave única, reintente"
			end
			if(error.blank? && state != ClaveUnica::server_token)
				error = "Error al iniciar sesión con clave única, reintente"
			end
			user_data = ClaveUnica.login(code)
			if(error.blank? && !user_data.key?("RolUnico"))
				error = "Error al iniciar sesión con clave única, reintente"
			end
			run = user_data["RolUnico"]["numero"].to_s+"-"+user_data["RolUnico"]["DV"]
			user = User.find_by_rut(run)
			if(error.blank? && user.nil?)
				error = "Usuario no existe en el sistema"
			end

			if(error.blank?)
				sign_in(user)
				#Lo agrego por si acaso
				personas = user.personas.map{|m|m}.compact
		  	cargos = personas.map{|p|p.persona_cargos.map{|cp| cp.cargo_id}}
		  	session[:cargos] = cargos.blank? ? [] : cargos[0]
		    session[:personas] = personas.blank? ? [] : personas.map{|p|p.attributes.to_json.as_hash}

				format.html{ redirect_to root_path, flash: {success: "Sesión correctamente iniciada con clave única"} }
			else
				format.html{ redirect_to root_path, flash: {error: error} }
			end
		end
	end
end
