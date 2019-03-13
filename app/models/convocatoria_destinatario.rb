class ConvocatoriaDestinatario < ApplicationRecord
	belongs_to :convocatoria
	belongs_to :destinatario, class_name: "Persona", foreign_key: "destinatario_id" # crea y asocia el objeto destinatario con la clase Persona mediante FK "destinanario_id"
	has_many :registro_apertura_correos, dependent: :destroy

	def format_titulo 
		titulo = self.convocatoria.mensaje_encabezado
		# titulo = self.convocatoria.encabezadodestinatario.update({
		# 					fecha_correo: DateTime.now.in_time_zone.to_date,
		# 					asistio: false
		# 				})

		# FlujoTarea.metodos(destinatario.user, self.convocatoria).each do |key, value| 
		# 	titulo = titulo.gsub(key.to_s, value.to_s)
		# end
		# titulo
	end

	def format_cuerpo
		cuerpo = self.convocatoria.mensaje_cuerpo
		# FlujoTarea.metodos(destinatario.user, self.convocatoria).each do |key, value| 
		# 	cuerpo = cuerpo.gsub(key.to_s, value.to_s)
		# end
		# cuerpo
	end
end
