class CuestionarioFpl < ApplicationRecord
  belongs_to :flujo

  ###CAMPO REVISION###
  #EL CODIGO 1 REPRESENTA APROBADO 
  #EL CODIGO 2 REPRESENTA CON OBSERVACION
  #EL CODIGO 3 REPRESENTA RECHAZO
  #EL CODIGO 4 REPRESENTA CON OBSERVACION SEGUNDA ITERACION Y FINAL

  def self.obtener_cuestionarios(flujo_id, tipo_contribuyentes_id, tipo_descargable)
    # Realizamos la consulta utilizando ActiveRecord
      cuestionarios = CuestionarioFpl
      .select('descargable_tareas.nombre AS nombre', 'cuestionario_fpls.nota', 'cuestionario_fpls.justificacion')
      .joins('LEFT JOIN documentacion_legals ON documentacion_legals.id = cuestionario_fpls.criterio_id')
      .joins('LEFT JOIN descargable_tareas ON documentacion_legals.descargable_tareas_id = descargable_tareas.id')
      .where(
        documentacion_legals: { tipo_contribuyentes_id: tipo_contribuyentes_id, tipo_descargable: tipo_descargable, estado: 1 },
        cuestionario_fpls: { flujo_id: flujo_id, tipo_cuestionario_id: 3 }
      )
      .order('cuestionario_fpls.criterio_id ASC')

  # Retornamos el resultado de la consulta
    return cuestionarios
  end

  def self.obtener_cuestionario_ejecutor(flujo_id)
    # Realizamos la consulta utilizando ActiveRecord
    cuestionarios = CuestionarioFpl
    .select('descargable_tareas.nombre AS nombre', 'cuestionario_fpls.nota', 'cuestionario_fpls.justificacion')
    .joins('LEFT JOIN documentacion_legals ON documentacion_legals.id = cuestionario_fpls.criterio_id')
    .joins('LEFT JOIN descargable_tareas ON documentacion_legals.descargable_tareas_id = descargable_tareas.id')
    .where(
      '(
        CASE
          WHEN EXISTS (SELECT 1 FROM equipo_empresas WHERE flujo_id = ?) 
          THEN documentacion_legals.tipo_contribuyentes_id = 12
          ELSE documentacion_legals.tipo_contribuyentes_id = 1
        END
      )', flujo_id
    )
    .where(documentacion_legals: { tipo_descargable: 3, estado: 1 })
    .where(cuestionario_fpls: { flujo_id: flujo_id, tipo_cuestionario_id: 3 })
    .order('cuestionario_fpls.criterio_id ASC')

    # Retornamos el resultado de la consulta
    return cuestionarios
  end

end
