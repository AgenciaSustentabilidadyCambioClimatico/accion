class Actividad < ApplicationRecord
	validates :nombre, presence: true
	validates :descripcion, presence: true

	has_many :actividad_por_lineas
	#belongs_to :actividad_por_linea
	has_many :plan_actividades

	def self.actividad_x_linea(flujo_id, tipo_instrumento_id)
		Actividad
			.joins("INNER JOIN actividad_por_lineas apl ON apl.actividad_id = actividades.id")
			.joins("LEFT JOIN plan_actividades pa 
					ON pa.actividad_id = actividades.id
					AND pa.flujo_id = #{flujo_id}")
			.where("apl.tipo_instrumento_id = ?", tipo_instrumento_id)
			.where(
			"apl.tipo_permiso = 1
			OR (apl.tipo_permiso = 3 AND pa.flujo_id IS NOT NULL)"
			)
			.group(
			"actividades.id,
			actividades.nombre,
			apl.tipo_actividad,
			apl.tipo_permiso,
			pa.correlativo"
			)
			.order("
			apl.tipo_actividad ASC,
			string_to_array(pa.correlativo, '.')::int[] ASC NULLS LAST
			")
			.select(
			"actividades.id,
			actividades.nombre,
			apl.tipo_actividad,
			apl.tipo_permiso,
			pa.correlativo"
			)
	end
end
