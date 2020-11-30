class EncuestaUserRespuesta < ApplicationRecord
	self.table_name = :encuesta_user_respuestas

	belongs_to :user
	attr_accessor :errores, :preguntas_y_respuestas

	def initialize(attributes={})
		super(attributes)
		self.errores = {}
		validar!
	end

	def tiene_errores?
		self.errores.size > 0
	end

	# DZC 2018-11-06 09:52:27 se modifica para signar las respuestas de las preguntas 1 y 2 a la ASCC y proveedor, respectivamente
	def cerrar(user_id,flujo_id, institucion_proveedor_id) #DZC se agrega el flujo_id y la institución del responsable de entregables
		creadas = false
		unless self.tiene_errores?
			respuestas = []
			self.preguntas_y_respuestas.each do |pid,respuesta|
				
				institucion_id = nil
				if pid == "1"
					institucion_id = Contribuyente.find_by(rut: 75980060).id # DZC 2018-11-06 09:50:08 se obtiene el id de la ASCC
				elsif pid == "2"
					institucion_id = institucion_proveedor_id # DZC 2018-11-06 09:50:42 se usa el id del proveedor
				end
				respuestas << { encuesta_id: self.encuesta_id, user_id: user_id, pregunta_id: pid, respuesta: respuesta[respuesta.keys.first], flujo_id: flujo_id, institucion_proveedor_id: institucion_id}
			end
			creadas = EncuestaUserRespuesta.create(respuestas)
		end
		creadas
	end

	private
	def validar!
		unless self.preguntas_y_respuestas.blank?
			self.preguntas_y_respuestas.each do |pid,respuesta|
				key = respuesta.keys.first
				if key == 'true' && respuesta[key].blank?
					self.errores[pid] = I18n.t(:debe_responder_este_campo)
				end
			end
		end
	end
end