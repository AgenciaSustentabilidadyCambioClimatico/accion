class ReunionDestinatario < ApplicationRecord
	belongs_to :reunion
	belongs_to :destinatario, class_name: "Persona", foreign_key: "destinatario_id"

	def format_titulo
		titulo = self.reunion.encabezado
		FlujoTarea.metodos(destinatario.user, self.reunion).each do |key, value| 
			titulo = titulo.gsub(key.to_s, value.to_s)
		end
		titulo
	end

	def format_cuerpo
		cuerpo = self.reunion.mensaje
		FlujoTarea.metodos(destinatario.user, self.reunion).each do |key, value| 
			cuerpo = cuerpo.gsub(key.to_s, value.to_s)
		end
		cuerpo
	end
	
end
