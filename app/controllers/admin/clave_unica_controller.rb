class Admin::ClaveUnicaController < ApplicationController
	include Devise::Controllers::Helpers

	def callback
		#Callback de clave unica registro civil
		code = params[:code]
		state = params[:state]
		error = ''
		respond_to do |format|
			if (error.blank? && code.blank? || state.blank?)
				error = "Error al iniciar sesión con Clave Única, reintente"
			end
			if (error.blank? && state != ClaveUnica::server_token)
				error = "Error al iniciar sesión con Clave Única, reintente"
			end
			user_data = ClaveUnica.login(code)
			if (error.blank? && !user_data.key?("RolUnico"))
				error = "Error al iniciar sesión con Clave Única, reintente"
			end
			run = user_data["RolUnico"]["numero"].to_s+"-"+user_data["RolUnico"]["DV"].to_s
			user = User.find_by_rut(run)
			if(error.blank? && user.nil?)
				#ahora crea el usuario mediante datos existentes en claveunica
				#error = "Usuario no existe en el sistema"
				nombre_completo = user_data["name"]["nombres"].join(" ")+" "+user_data["name"]["apellidos"].join(" ")
				password = rand(36**16).to_s(36) #random para simular que cuenta no tiene contraseña
				user = User.create(rut: run.upcase, email: user_data["email"], nombre_completo: nombre_completo, password: password, claveunica: true)
				red_path = edit_user_registration_path
			else
				red_path = session[:user_return_to].blank? ? root_path : session[:user_return_to]
			end

			if(error.blank?)
				sign_in(user)
				#Lo agrego por si acaso
				personas = user.personas.map{|m|m}.compact
				cargos = personas.map{|p|p.persona_cargos.map{|cp| cp.cargo_id}}
				user.session[:cargos] = cargos.blank? ? [] : cargos[0]
				user.session[:personas] = personas.blank? ? [] : personas.map{|p|p.attributes.to_json.as_hash}
				user.save

				format.html{ redirect_to red_path, flash: {success: "Sesión iniciada correctamente mediante Clave Única" } }
			else
				format.html{ redirect_to root_path, flash: {error: error} }
			end
		end
	end
end

