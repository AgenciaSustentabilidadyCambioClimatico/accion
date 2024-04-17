class DocumentacionLegal < ApplicationRecord
    has_many :dato_anual_contribuyentes

    def self.descargables_postulante_old(flujo_id)
        find_by_sql("
            SELECT descargable_tareas.codigo AS codigo, descargable_tareas.nombre AS nombre
            FROM contribuyentes
            LEFT JOIN dato_anual_contribuyentes ON contribuyentes.id = dato_anual_contribuyentes.contribuyente_id
            LEFT JOIN tipo_contribuyentes ON dato_anual_contribuyentes.tipo_contribuyente_id = tipo_contribuyentes.id 
            LEFT JOIN documentacion_legals ON tipo_contribuyentes.tipo_contribuyente_id = documentacion_legals.tipo_contribuyentes_id
            LEFT JOIN descargable_tareas ON descargable_tareas.id = documentacion_legals.descargable_tareas_id
            WHERE contribuyentes.flujo_id = #{flujo_id}
            AND documentacion_legals.estado = 1
            AND documentacion_legals.tipo_descargable = 1
            ORDER BY documentacion_legals.id")
    end

    def self.descargables_postulante(flujo_id)
        find_by_sql("SELECT descargable_tareas.codigo AS codigo, descargable_tareas.nombre AS nombre
            FROM contribuyentes 
            LEFT JOIN fondo_produccion_limpia On fondo_produccion_limpia.institucion_entregables_id = contribuyentes.id 
            LEFT JOIN dato_anual_contribuyentes ON contribuyentes.id = dato_anual_contribuyentes.contribuyente_id
            LEFT JOIN tipo_contribuyentes ON dato_anual_contribuyentes.tipo_contribuyente_id = tipo_contribuyentes.id 
            LEFT JOIN documentacion_legals ON tipo_contribuyentes.tipo_contribuyente_id = documentacion_legals.tipo_contribuyentes_id
            LEFT JOIN descargable_tareas ON descargable_tareas.id = documentacion_legals.descargable_tareas_id
            WHERE fondo_produccion_limpia.flujo_id = #{flujo_id}
            AND documentacion_legals.estado = 1
            AND documentacion_legals.tipo_descargable = 1
            ORDER BY documentacion_legals.id")
    end
    
    ###CAMBIAR AL SELECCIONADO EN LA TAREA FPL-00
    def self.descargables_receptor_old(flujo_id)
        find_by_sql("
            SELECT descargable_tareas.codigo AS codigo, descargable_tareas.nombre AS nombre
            FROM contribuyentes
            LEFT JOIN dato_anual_contribuyentes ON contribuyentes.id = dato_anual_contribuyentes.contribuyente_id
            LEFT JOIN tipo_contribuyentes ON dato_anual_contribuyentes.tipo_contribuyente_id = tipo_contribuyentes.id 
            LEFT JOIN documentacion_legals ON tipo_contribuyentes.tipo_contribuyente_id = documentacion_legals.tipo_contribuyentes_id
            LEFT JOIN descargable_tareas ON descargable_tareas.id = documentacion_legals.descargable_tareas_id
            WHERE contribuyentes.flujo_id = #{flujo_id}
            AND documentacion_legals.estado = 1
            AND documentacion_legals.tipo_descargable = 2
            ORDER BY documentacion_legals.id")
    end

    def self.descargables_receptor(flujo_id)
     find_by_sql("
            SELECT descargable_tareas.codigo AS codigo, descargable_tareas.nombre AS nombre
            FROM contribuyentes 
            LEFT JOIN fondo_produccion_limpia On fondo_produccion_limpia.institucion_entregables_id = contribuyentes.id 
            LEFT JOIN dato_anual_contribuyentes ON contribuyentes.id = dato_anual_contribuyentes.contribuyente_id
            LEFT JOIN tipo_contribuyentes ON dato_anual_contribuyentes.tipo_contribuyente_id = tipo_contribuyentes.id 
            LEFT JOIN documentacion_legals ON tipo_contribuyentes.tipo_contribuyente_id = documentacion_legals.tipo_contribuyentes_id
            LEFT JOIN descargable_tareas ON descargable_tareas.id = documentacion_legals.descargable_tareas_id
            WHERE fondo_produccion_limpia.flujo_id = #{flujo_id}
            AND documentacion_legals.estado = 1
            AND documentacion_legals.tipo_descargable = 2
            ORDER BY documentacion_legals.id")
    end

    def self.descargables_ejecutor(flujo_id)
        find_by_sql("
            SELECT descargable_tareas.codigo AS codigo, descargable_tareas.nombre AS nombre
            FROM documentacion_legals
            LEFT JOIN descargable_tareas ON descargable_tareas.id = documentacion_legals.descargable_tareas_id
            WHERE tipo_descargable = 3
            AND documentacion_legals.estado = 1
            AND (
                CASE 
                    WHEN EXISTS (SELECT 1 FROM equipo_empresas WHERE flujo_id = #{flujo_id}) THEN 
                        tipo_contribuyentes_id = 12
                    ELSE 
                        tipo_contribuyentes_id = 1
                END
            )
         ORDER BY documentacion_legals.id")
      end     

end
