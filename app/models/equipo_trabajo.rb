class EquipoTrabajo < ApplicationRecord
  belongs_to :user
  belongs_to :flujo
  belongs_to :contribuyente, optional: true

  # Validación para asegurarse de que la combinación de user_id, flujo_id, tipo_equipo y contribuyente_id no se repita
  validates :user_id, uniqueness: { scope: [:flujo_id, :tipo_equipo, :contribuyente_id], message: "La combinación de user_id, flujo_id, tipo_equipo y contribuyente_id ya está en uso" }

  def self.postulantes_faltantes(actividad_id, flujo_id)
    find_by_sql("
        SELECT et.*, u.nombre_completo AS nombre_usuario, rh.hh AS HH, rh.equipo_trabajo_id AS rrhh_equipo_id
        FROM equipo_trabajos et
        INNER JOIN users u ON et.user_id = u.id
        LEFT JOIN (
            SELECT rh.equipo_trabajo_id, rh.hh
            FROM recurso_humanos rh
            INNER JOIN plan_actividades pa ON rh.plan_actividad_id = pa.id
            WHERE pa.actividad_id = #{actividad_id}
        ) rh ON et.id = rh.equipo_trabajo_id
        WHERE et.flujo_id = #{flujo_id}
        AND et.tipo_equipo = 3;
      ")
  end

  def self.consultor_faltantes(actividad_id, flujo_id)
    find_by_sql("
          SELECT et.*, u.nombre_completo AS nombre_usuario, rh.hh AS HH, rh.equipo_trabajo_id AS rrhh_equipo_id, rh.tipo_aporte_id AS tipo_aporte
          FROM equipo_trabajos et
          INNER JOIN users u ON et.user_id = u.id
          LEFT JOIN (
            SELECT rh.equipo_trabajo_id, rh.hh, rh.tipo_aporte_id
            FROM recurso_humanos rh
            INNER JOIN plan_actividades pa ON rh.plan_actividad_id = pa.id
            WHERE pa.actividad_id = #{actividad_id}
          ) rh ON et.id = rh.equipo_trabajo_id
          WHERE et.flujo_id = #{flujo_id}
          AND et.tipo_equipo IN (1,2);
        ")
  end
  
end
