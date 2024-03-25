class DocumentacionLegal < ApplicationRecord
    has_many :dato_anual_contribuyentes

    def self.descargables_tarea_para_flujo(flujo_id)
        find_by_sql("
          SELECT documentacion_legals.id, descargable_tareas.codigo AS codigo, descargable_tareas.nombre AS nombre
          FROM contribuyentes
          LEFT JOIN dato_anual_contribuyentes ON contribuyentes.id = dato_anual_contribuyentes.contribuyente_id
          LEFT JOIN tipo_contribuyentes ON dato_anual_contribuyentes.tipo_contribuyente_id = tipo_contribuyentes.id 
          LEFT JOIN documentacion_legals ON tipo_contribuyentes.tipo_contribuyente_id = documentacion_legals.tipo_contribuyentes_id
          LEFT JOIN descargable_tareas ON descargable_tareas.id = documentacion_legals.descargable_tareas_id
          WHERE contribuyentes.flujo_id = #{flujo_id}
          AND documentacion_legals.estado = 1")
      end
end
