class ReunionDestinatario < ApplicationRecord
	belongs_to :reunion
	belongs_to :destinatario, class_name: "Persona", foreign_key: "destinatario_id"

	def format_titulo
		titulo = self.reunion.encabezado
		begin
			mdi = self.reunion.proyecto.flujo.manifestacion_de_interes
		rescue
			mdi = nil
		end
		FlujoTarea.metodos(destinatario.user, self.reunion, mdi).each do |key, value| 
			titulo = titulo.gsub(key.to_s, value.to_s)
		end
		titulo
	end

	def format_cuerpo
		cuerpo = self.reunion.mensaje
		begin
			mdi = self.reunion.proyecto.flujo.manifestacion_de_interes
		rescue
			mdi = nil
		end
		FlujoTarea.metodos(destinatario.user, self.reunion, mdi).each do |key, value| 
			cuerpo = cuerpo.gsub(key.to_s, value.to_s)
		end
		cuerpo
	end
	
end
