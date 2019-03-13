class Rendicion < ApplicationRecord
	attr_accessor :suma_fpl, :gb_id
	belongs_to :modalidad, optional: true
	belongs_to :proyecto, optional: true

	validates :fecha_rendicion, presence: true
	# validate :fecha_con_monto

	# attr_accessor :monto
	# def fecha_rendicion
	# 	unless self.read_attribute(:fecha_rendicion).nil?
	# 		self.read_attribute(:fecha_rendicion).strftime("%d-%m-%Y")
	# 	end
	# end
	def monto_multa
		# solo para linea 1 o sus subtipos
		# si tipo instrumento entre 11,12,13 hay multa
		if TipoInstrumento::FPL_LINEA_1.include?(self.proyecto.tipo_instrumento_id)
			# si es anticipo 0.4 + 0.2 * dia
			# si es reembolso 0.4 + 0.1 * dia
			base_dias = self.modalidad_id == 1 ? 0.2 : 0.1

			fecha_ultima_rendicion =  fecha_ultima_rendicion()
			if !fecha_ultima_rendicion.nil?
				dias = (fecha_ultima_rendicion.to_date - self.fecha_rendicion).to_i
				# dias = 4
				dias > 0 ? (0.4 + (dias * base_dias)).round(3) : 0
			else
				0
			end
		else
			0
		end
	end

	def fecha_ultima_rendicion

		rendicion_anterior = Rendicion.where(proyecto_id: self.proyecto.id).where("id < ?", self.id).last
		fecha_anterior = rendicion_anterior.nil? ? Date.new(1900,1,1) : rendicion_anterior.fecha_rendicion
		pa_id = self.proyecto.proyecto_actividad.where("fecha_finalizacion > ? AND fecha_finalizacion <= ?", fecha_anterior, self.fecha_rendicion).map { |e|  e.id}
		fecha_ultima_rendicion =  ActividadItem.where(proyecto_actividad_id: pa_id)
																						.where("estado_tecnica_id > ? OR estado_respaldo_id > ?", 1, 1)
																						.order(fecha_ultima_rendicion: :desc).first
		unless fecha_ultima_rendicion.nil?
			return fecha_ultima_rendicion.fecha_ultima_rendicion
		end
	end

end