class Actividad < ApplicationRecord
	validates :nombre, presence: true
	validates :descripcion, presence: true

	has_many :actividad_por_lineas
	#belongs_to :actividad_por_linea
	has_many :plan_actividades

	def self.actividad_x_linea(flujo_id)
		joins("INNER JOIN actividad_por_lineas ON actividad_por_lineas.actividad_id = actividades.id")
			.left_joins(:plan_actividades)
			.where(actividad_por_lineas: { tipo_instrumento_id: 11 })
			.where(
			"actividad_por_lineas.tipo_permiso IN (?) AND (plan_actividades.flujo_id = ? OR actividad_por_lineas.tipo_permiso = ?)",
			[1, 3], flujo_id, 1
			)
			.group("actividades.id", "actividades.nombre")
			.order("actividades.id")
			.select("actividades.id", "actividades.nombre")
	end
	
end
