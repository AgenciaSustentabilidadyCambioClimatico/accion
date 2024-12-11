class CuestionarioFpl < ApplicationRecord
  belongs_to :flujo

    #Preguntas cuestionario financiamiento
  def self.preguntas_financiamiento 
    [
      { id: 1, pregunta: "Los ítems que componen los gastos de operación y de administración son financiables de acuerdo a las bases del Fondo PL y corresponden a productos específicos e identificables." },
      { id: 2, pregunta: "El valor de las HH de los profesionales es cercano al valor de mercado." },
      { id: 3, pregunta: "Los costos por actividades son consistentes con los aspectos técnicos abordados, la cantidad y tamaño de las instalaciones, y su cobertura geográfica." },
      { id: 4, pregunta: "El proyecto cuenta con participación de empresas no socias y con un alto porcentaje de empresas de menor tamaño (Se evalúa positivamente en caso de cumplimiento)." },
      { id: 5, pregunta: "Las actividades están correctamente formuladas en relación a las bases del Fondo PL y permiten realizar un análisis de costos." }
    ]
  end

  #Preguntas cuestionario técnico
  def self.preguntas_tecnicas
    [
      { id: 1, pregunta: "Los objetivos están correctamente planteados y su cumplimiento es verificable al finalizar el proyecto." },
      { id: 2, pregunta: "La metodología es consistente con el cumplimiento de los objetivos. (Incluye la definición del tamaño muestral)." },
      { id: 3, pregunta: "Las actividades propuestas son adecuadas y pertinentes para conseguir los productos y objetivos del proyecto." },
      { id: 4, pregunta: "La organización del equipo de trabajo y las horas destinadas están acorde con las actividades del proyecto." },
      { id: 5, pregunta: "Los indicadores de resultado están correcta y claramente planteados." },
      { id: 6, pregunta: "La empresa consultora y el equipo de trabajo reúnen la formación y especialización necesaria para abordar las temáticas del proyecto." },
      { id: 7, pregunta: "La empresa consultora y el equipo de trabajo reúnen la experiencia en el desarrollo de proyectos en ámbitos productivos, ambientales y en el sector productivo abordado." },
      { id: 8, pregunta: "El equipo de trabajo resulta suficiente para abordar el proyecto." }
    ]
  end

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
