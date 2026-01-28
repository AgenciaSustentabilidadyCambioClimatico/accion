class Actividad < ApplicationRecord
	validates :nombre, presence: true
	validates :descripcion, presence: true

	has_many :actividad_por_lineas
	#belongs_to :actividad_por_linea
	has_many :plan_actividades

	def self.actividad_x_linea(flujo_id, tipo_instrumento_id)
		PlanActividad
		.joins(:actividad)
		.joins("INNER JOIN actividad_por_lineas ON actividad_por_lineas.actividad_id = actividades.id")
		.where(plan_actividades: { flujo_id: flujo_id })
		.where(actividad_por_lineas: { tipo_instrumento_id: tipo_instrumento_id })
		.where("actividad_por_lineas.tipo_permiso IN (1, 3)")
		.group("plan_actividades.actividad_id", "actividades.nombre", "actividad_por_lineas.tipo_actividad", "actividad_por_lineas.tipo_permiso", "plan_actividades.correlativo")
		.order("actividad_por_lineas.tipo_actividad ASC, plan_actividades.correlativo ASC NULLS LAST")
		.select("plan_actividades.actividad_id AS id", "actividades.nombre", "actividad_por_lineas.tipo_actividad",	"actividad_por_lineas.tipo_permiso", "plan_actividades.correlativo")
	end
end
