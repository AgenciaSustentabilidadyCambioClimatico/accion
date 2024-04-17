class Actividad < ApplicationRecord
	validates :nombre, presence: true
	validates :descripcion, presence: true

	has_many :actividad_por_lineas

	def self.actividad_x_linea(flujo_id)
		find_by_sql("
		  SELECT actividades.id, actividades.nombre 
		  FROM actividades
		  INNER JOIN actividad_por_lineas ON actividad_por_lineas.actividad_id = actividades.id
		  LEFT JOIN plan_actividades ON actividades.id = plan_actividades.actividad_id
		  WHERE actividad_por_lineas.tipo_instrumento_id = 11 
		  AND (
			  (actividad_por_lineas.tipo_permiso IN (1, 3) AND plan_actividades.flujo_id = #{flujo_id})
			  OR actividad_por_lineas.tipo_permiso = 1
		  )
		  GROUP BY 1,2
		  ORDER BY actividades.id")
	end
	
end
