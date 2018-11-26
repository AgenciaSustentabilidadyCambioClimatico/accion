class PrivacidadPermiso < ApplicationRecord

	serialize :fields_visibility

	#enum fields_visibility: [:publico,:privado,:eleccion_usuario], _prefix: :fields_visibility
	def self.get_fields_visibility_by_entity(entidad)
		attributos =  []
		case entidad
		when "usuarios"
			attributos = [:rut,:nombre_completo,:telefono,:email,:web_o_red_social_1,:web_o_red_social_2]
		when "instituciones"
			attributos = [:rut,:razon_social]
		when "establecimientos"
			attributos = [:nombre_establecimiento, :tipo_establecimiento, :lugar, :ciudad, :telefono, :email, :pais, :region, :comuna]
		when "maquinarias"
			attributos = [:nombre_maquinaria, :numero_serie, :patente, :tipo, :imagenes]
		when "otros"
			attributos = [:nombre, :tipo, :identificador_unico, :imagen, :alcance]
		end
		return attributos
	end

	def self.posee_eleccion_usuario(entidad)
		por_usuario = false
		permisos = PrivacidadPermiso.find_by_entidad(entidad)
		if permisos.present?
			permisos.fields_visibility.each{|k,v| if v == "Por usuario" then por_usuario = true end}
		end
		por_usuario
	end
end
