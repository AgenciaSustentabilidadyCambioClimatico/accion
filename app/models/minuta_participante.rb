class MinutaParticipante < ApplicationRecord
	belongs_to :minuta
	belongs_to :destinatario, class_name: "Persona", foreign_key: "destinatario_id"

	def format_titulo 
		titulo = self.minuta.mensaje_encabezado
	end

	def format_cuerpo
		cuerpo = self.minuta.mensaje_cuerpo
	end
end
