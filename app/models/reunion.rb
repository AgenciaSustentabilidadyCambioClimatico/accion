class Reunion < ApplicationRecord
	belongs_to :proyecto
	has_many :reunion_destinatarios

	validates :fecha, :direccion, presence: true
	validate :fecha_mayor_hoy
	validate :direccion_en_mapa

	def reunion_success tarea_pendiente

		tarea_pendiente.estado_tarea_pendiente_id = EstadoTareaPendiente::ENVIADA
		if tarea_pendiente.save

			flujo_tareas = FlujoTarea.where(tarea_entrada_id: tarea_pendiente.tarea_id).all
			flujo_tareas.each do |ft|
				ft.continuar_flujo tarea_pendiente.flujo.id
			end
		end

	end

  def fecha_mayor_hoy
    if self.fecha <= Date.today
      errors.add(:fecha, "Fecha debe ser mayor a hoy")
    end
  end

	def direccion_en_mapa
		if self.lat.blank? || self.lng.blank?
			errors.add(:direccion, "Debe ubicar la dirección en el mapa")
		end
	end
	
end
