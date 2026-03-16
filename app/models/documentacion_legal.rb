class DocumentacionLegal < ApplicationRecord
    has_many :dato_anual_contribuyentes

    def self.descargables_postulante(tipo_contribuyente_id)
        select("documentacion_legals.id AS id, 
                descargable_tareas.codigo AS codigo, 
                descargable_tareas.nombre AS nombre, 
                documentacion_legals.nombre_campo AS nombre_campo")
        .joins("LEFT JOIN descargable_tareas ON descargable_tareas.id = documentacion_legals.descargable_tareas_id")
        .where("tipo_contribuyentes_id = ? AND tipo_descargable = ? AND estado = ?", tipo_contribuyente_id, 1, 1)
        .order("documentacion_legals.id")

    end

    def self.descargables_receptor(tipo_contribuyente_id)
        select("documentacion_legals.id AS id, 
                descargable_tareas.codigo AS codigo, 
                descargable_tareas.nombre AS nombre, 
                documentacion_legals.nombre_campo AS nombre_campo")
        .joins("LEFT JOIN descargable_tareas ON descargable_tareas.id = documentacion_legals.descargable_tareas_id")
        .where("tipo_contribuyentes_id = ? AND tipo_descargable = ? AND estado = ?", tipo_contribuyente_id, 2, 1)
        .order("documentacion_legals.id")

    end

    def self.descargables_ejecutor(flujo_id)
        joins_clause = <<-SQL
            LEFT JOIN descargable_tareas
            ON descargable_tareas.id = documentacion_legals.descargable_tareas_id
        SQL

        where_clause = <<-SQL
            documentacion_legals.tipo_descargable = 3
            AND documentacion_legals.estado = 1
            AND (
            (
                COALESCE(
                (SELECT check_documentos_juridicos
                FROM fondo_produccion_limpia
                WHERE flujo_id = #{flujo_id}
                LIMIT 1),
                false
                ) = false
                AND (
                (EXISTS (SELECT 1 FROM equipo_empresas WHERE flujo_id = #{flujo_id})
                AND documentacion_legals.tipo_contribuyentes_id = 12)
                OR
                (NOT EXISTS (SELECT 1 FROM equipo_empresas WHERE flujo_id = #{flujo_id})
                AND documentacion_legals.tipo_contribuyentes_id = 1)
                )
            )
            OR
            (
                COALESCE(
                (SELECT check_documentos_juridicos
                FROM fondo_produccion_limpia
                WHERE flujo_id = #{flujo_id}
                LIMIT 1),
                false
                ) <> false
                AND documentacion_legals.tipo_contribuyentes_id IN (1,12)
            )
            )
        SQL

        DocumentacionLegal
            .select("documentacion_legals.id AS id,
                    descargable_tareas.codigo AS codigo,
                    descargable_tareas.nombre AS nombre,
                    documentacion_legals.nombre_campo AS nombre_campo")
            .joins(joins_clause)
            .where(where_clause)
            .order("documentacion_legals.id")
        end
end
