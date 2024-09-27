class PlanActividad < ApplicationRecord
  belongs_to :actividad
  has_many :actividades
  belongs_to :flujo
  belongs_to :objetivos_especifico, optional: true
  has_many :gasto
  has_many :gastos, foreign_key: 'plan_actividad_id'
  has_many :equipo_trabajos
  has_many :recurso_humanos


  def self.actividad_detalle(flujo_id)
    # Subconsulta para recursos humanos
    hh_gastos_subquery = PlanActividad
      .select(
        'plan_actividades.actividad_id',
        'actividades.nombre',
        'plan_actividades.duracion',
        'SUM(CASE WHEN equipo_trabajos.tipo_equipo = 3 THEN equipo_trabajos.valor_hh * recurso_humanos.hh ELSE 0 END) AS valor_hh_tipo_3',
        'SUM(CASE WHEN equipo_trabajos.tipo_equipo IN (1, 2) THEN equipo_trabajos.valor_hh * recurso_humanos.hh ELSE 0 END) AS valor_hh_tipos_1_2'
      )
      .joins('LEFT JOIN recurso_humanos ON recurso_humanos.plan_actividad_id = plan_actividades.id')
      .joins('LEFT JOIN actividades ON actividades.id = plan_actividades.actividad_id')
      .joins('LEFT JOIN equipo_trabajos ON equipo_trabajos.id = recurso_humanos.equipo_trabajo_id')
      .where(plan_actividades: { flujo_id: flujo_id })
      .group('plan_actividades.actividad_id, actividades.nombre, plan_actividades.duracion')
  
    # Subconsulta para gastos
    gastos_subquery = PlanActividad
      .select(
        'plan_actividades.actividad_id',
        'actividades.nombre',
        'plan_actividades.duracion',
        'SUM(CASE WHEN gastos.tipo_gasto = 1 THEN gastos.valor_unitario * gastos.cantidad ELSE 0 END) AS total_gastos_tipo_1',
        'SUM(CASE WHEN gastos.tipo_gasto = 2 THEN gastos.valor_unitario * gastos.cantidad ELSE 0 END) AS total_gastos_tipo_2'
      )
      .joins('LEFT JOIN gastos ON gastos.plan_actividad_id = plan_actividades.id')
      .joins('LEFT JOIN actividades ON actividades.id = plan_actividades.actividad_id')
      .where(plan_actividades: { flujo_id: flujo_id })
      .group('plan_actividades.actividad_id, actividades.nombre, plan_actividades.duracion')
  
    # Subconsulta para todas las actividades
    todas_actividades = PlanActividad
      .select(
        'plan_actividades.actividad_id',
        'actividades.nombre',
        'plan_actividades.duracion'
      )
      .joins('LEFT JOIN actividades ON actividades.id = plan_actividades.actividad_id')
      .where(plan_actividades: { flujo_id: flujo_id })
      .group('plan_actividades.actividad_id, actividades.nombre, plan_actividades.duracion')
  
    # Consulta principal que une las subconsultas
    result = PlanActividad
      .from("(#{hh_gastos_subquery.to_sql}) AS hh_gastos_subquery")
      .joins("LEFT JOIN (#{gastos_subquery.to_sql}) AS gastos_subquery ON hh_gastos_subquery.actividad_id = gastos_subquery.actividad_id")
      .joins("LEFT JOIN (#{todas_actividades.to_sql}) AS todas_actividades ON todas_actividades.actividad_id = COALESCE(hh_gastos_subquery.actividad_id, gastos_subquery.actividad_id)")
      .select(
        'COALESCE(hh_gastos_subquery.actividad_id, gastos_subquery.actividad_id, todas_actividades.actividad_id) AS id',
        'COALESCE(hh_gastos_subquery.nombre, gastos_subquery.nombre, todas_actividades.nombre) AS nombre',
        'COALESCE(hh_gastos_subquery.duracion, gastos_subquery.duracion, todas_actividades.duracion) AS duracion',
        'COALESCE(hh_gastos_subquery.valor_hh_tipo_3, 0) AS valor_hh_tipo_3',
        'COALESCE(hh_gastos_subquery.valor_hh_tipos_1_2, 0) AS valor_hh_tipos_1_2',
        'COALESCE(gastos_subquery.total_gastos_tipo_1, 0) AS total_gastos_tipo_1',
        'COALESCE(gastos_subquery.total_gastos_tipo_2, 0) AS total_gastos_tipo_2'
      )
  
    result
  end
  
  def self.costos(flujo_id)
    # Subconsulta para recursos humanos
    hh_gastos_subquery = RecursoHumano
      .select(
        'recurso_humanos.flujo_id',
        'SUM(CASE WHEN equipo_trabajos.tipo_equipo = 3 THEN equipo_trabajos.valor_hh * recurso_humanos.hh ELSE 0 END) AS valor_hh_tipo_3',
        'SUM(CASE WHEN equipo_trabajos.tipo_equipo IN (1, 2) THEN equipo_trabajos.valor_hh * recurso_humanos.hh ELSE 0 END) AS valor_hh_tipos_1_2',
        'SUM(CASE WHEN recurso_humanos.tipo_aporte_id = 1 THEN equipo_trabajos.valor_hh * recurso_humanos.hh ELSE 0 END) AS aporte_propio_valorado',
        'SUM(CASE WHEN recurso_humanos.tipo_aporte_id = 2 THEN equipo_trabajos.valor_hh * recurso_humanos.hh ELSE 0 END) AS aporte_propio_liquido',
        'SUM(CASE WHEN recurso_humanos.tipo_aporte_id = 3 THEN equipo_trabajos.valor_hh * recurso_humanos.hh ELSE 0 END) AS aporte_solicitado_al_fondo',
        'SUM(CASE WHEN recurso_humanos.tipo_aporte_id = 1 AND equipo_trabajos.tipo_equipo = 3 THEN equipo_trabajos.valor_hh * recurso_humanos.hh ELSE 0 END) AS aporte_propio_valorado_rrhh_propio',
        'SUM(CASE WHEN recurso_humanos.tipo_aporte_id = 1 AND equipo_trabajos.tipo_equipo IN (1, 2) THEN equipo_trabajos.valor_hh * recurso_humanos.hh ELSE 0 END) AS aporte_propio_liquido_rrhh_propio',
        'SUM(CASE WHEN recurso_humanos.tipo_aporte_id = 2 AND equipo_trabajos.tipo_equipo = 3 THEN equipo_trabajos.valor_hh * recurso_humanos.hh ELSE 0 END) AS aporte_propio_valorado_rrhh_externo',
        'SUM(CASE WHEN recurso_humanos.tipo_aporte_id = 2 AND equipo_trabajos.tipo_equipo IN (1, 2) THEN equipo_trabajos.valor_hh * recurso_humanos.hh ELSE 0 END) AS aporte_propio_liquido_rrhh_externo',
        'SUM(CASE WHEN recurso_humanos.tipo_aporte_id = 3 AND equipo_trabajos.tipo_equipo IN (1, 2) THEN equipo_trabajos.valor_hh * recurso_humanos.hh ELSE 0 END) AS aporte_solicitado_fondo_rrhh_externo'
      )
      .joins('LEFT JOIN equipo_trabajos ON equipo_trabajos.id = recurso_humanos.equipo_trabajo_id')
      .where(flujo_id: flujo_id)
      .group('recurso_humanos.flujo_id')
    
    # Subconsulta para gastos
    gastos_subquery = Gasto
      .select(
        'gastos.flujo_id',
        'SUM(CASE WHEN gastos.tipo_gasto = 1 THEN gastos.valor_unitario * gastos.cantidad ELSE 0 END) AS total_gastos_tipo_1',
        'SUM(CASE WHEN gastos.tipo_gasto = 2 THEN gastos.valor_unitario * gastos.cantidad ELSE 0 END) AS total_gastos_tipo_2',
        'SUM(CASE WHEN gastos.tipo_aporte_id = 1 THEN gastos.valor_unitario * gastos.cantidad ELSE 0 END) AS aporte_propio_valorado',
        'SUM(CASE WHEN gastos.tipo_aporte_id = 2 THEN gastos.valor_unitario * gastos.cantidad ELSE 0 END) AS aporte_propio_liquido',
        'SUM(CASE WHEN gastos.tipo_aporte_id = 3 THEN gastos.valor_unitario * gastos.cantidad ELSE 0 END) AS aporte_solicitado_al_fondo',
        'SUM(CASE WHEN gastos.tipo_aporte_id = 1 AND tipo_gasto = 1 THEN gastos.valor_unitario * gastos.cantidad ELSE 0 END) AS aporte_propio_valorado_gasto_operacion',
        'SUM(CASE WHEN gastos.tipo_aporte_id = 1 AND tipo_gasto = 2 THEN gastos.valor_unitario * gastos.cantidad ELSE 0 END) AS aporte_propio_valorado_gasto_administracion',
        'SUM(CASE WHEN gastos.tipo_aporte_id = 2 AND tipo_gasto = 1 THEN gastos.valor_unitario * gastos.cantidad ELSE 0 END) AS aporte_propio_liquido_gasto_operacion',
        'SUM(CASE WHEN gastos.tipo_aporte_id = 2 AND tipo_gasto = 2 THEN gastos.valor_unitario * gastos.cantidad ELSE 0 END) AS aporte_propio_liquido_gasto_administracion',
        'SUM(CASE WHEN gastos.tipo_aporte_id = 3 AND tipo_gasto = 1 THEN gastos.valor_unitario * gastos.cantidad ELSE 0 END) AS aporte_solicitado_fondo_gasto_operacion',
        'SUM(CASE WHEN gastos.tipo_aporte_id = 3 AND tipo_gasto = 2 THEN gastos.valor_unitario * gastos.cantidad ELSE 0 END) AS aporte_solicitado_fondo_gasto_administracion'
      )
      .where(flujo_id: flujo_id)
      .group('gastos.flujo_id')
    
    # Consulta principal que une las dos subconsultas
    result = RecursoHumano
      .from("(#{hh_gastos_subquery.to_sql}) AS hh_gastos_subquery")
      .joins("LEFT JOIN (#{gastos_subquery.to_sql}) AS gastos_subquery ON hh_gastos_subquery.flujo_id = gastos_subquery.flujo_id")
      .select(
        'COALESCE(hh_gastos_subquery.flujo_id, gastos_subquery.flujo_id) AS id',
        'COALESCE(hh_gastos_subquery.valor_hh_tipo_3, 0) AS recursos_humanos_propios',
        'COALESCE(hh_gastos_subquery.valor_hh_tipos_1_2, 0) AS recursos_humanos_externos',
        'COALESCE(gastos_subquery.total_gastos_tipo_1, 0) AS gastos_operacion',
        'COALESCE(gastos_subquery.total_gastos_tipo_2, 0) AS gastos_administrativos',
        'COALESCE(hh_gastos_subquery.valor_hh_tipo_3, 0) + COALESCE(hh_gastos_subquery.valor_hh_tipos_1_2, 0) + COALESCE(gastos_subquery.total_gastos_tipo_1, 0) + COALESCE(gastos_subquery.total_gastos_tipo_2, 0) AS costo_total_de_la_propuesta',
        'COALESCE(hh_gastos_subquery.aporte_propio_valorado, 0) + COALESCE(gastos_subquery.aporte_propio_valorado, 0) AS aporte_propio_valorado',
        'COALESCE(hh_gastos_subquery.aporte_propio_liquido, 0) + COALESCE(gastos_subquery.aporte_propio_liquido, 0) AS aporte_propio_liquido',
        'COALESCE(hh_gastos_subquery.aporte_solicitado_al_fondo, 0) + COALESCE(gastos_subquery.aporte_solicitado_al_fondo, 0) AS aporte_solicitado_al_fondo',
        'COALESCE(hh_gastos_subquery.aporte_propio_valorado_rrhh_propio, 0) AS aporte_propio_valorado_rrhh_propio',
        'COALESCE(hh_gastos_subquery.aporte_propio_valorado_rrhh_externo, 0) AS aporte_propio_valorado_rrhh_externo',
        'COALESCE(hh_gastos_subquery.aporte_propio_liquido_rrhh_propio, 0) AS aporte_propio_liquido_rrhh_propio',
        'COALESCE(hh_gastos_subquery.aporte_propio_liquido_rrhh_externo, 0) AS aporte_propio_liquido_rrhh_externo',
        'COALESCE(hh_gastos_subquery.aporte_solicitado_fondo_rrhh_externo, 0) AS aporte_solicitado_fondo_rrhh_externo',
        'COALESCE(gastos_subquery.aporte_propio_valorado_gasto_operacion, 0) AS aporte_propio_valorado_gasto_operacion',
        'COALESCE(gastos_subquery.aporte_propio_valorado_gasto_administracion, 0) AS aporte_propio_valorado_gasto_administracion',
        'COALESCE(gastos_subquery.aporte_propio_liquido_gasto_operacion, 0) AS aporte_propio_liquido_gasto_operacion',
        'COALESCE(gastos_subquery.aporte_propio_liquido_gasto_administracion, 0) AS aporte_propio_liquido_gasto_administracion',
        'COALESCE(gastos_subquery.aporte_solicitado_fondo_gasto_operacion, 0) AS aporte_solicitado_fondo_gasto_operacion',
        'COALESCE(gastos_subquery.aporte_solicitado_fondo_gasto_administracion, 0) AS aporte_solicitado_fondo_gasto_administracion'
      )
      .order('id ASC')  # Ordenar por la columna id derivada, que está disponible en la consulta principal
      .first
    
    result
  end

  def self.costos_seguimiento(flujo_id, tipo_instrumento_id)
    # Subconsulta para recursos humanos
    hh_gastos_subquery = RecursoHumano
      .select(
        'recurso_humanos.flujo_id',
        'actividad_por_lineas.tipo_actividad',
        'SUM(CASE WHEN recurso_humanos.tipo_aporte_id = 1 THEN equipo_trabajos.valor_hh * recurso_humanos.hh ELSE 0 END) AS aporte_propio_valorado',
        'SUM(CASE WHEN recurso_humanos.tipo_aporte_id = 2 THEN equipo_trabajos.valor_hh * recurso_humanos.hh ELSE 0 END) AS aporte_propio_liquido',
        'SUM(CASE WHEN recurso_humanos.tipo_aporte_id = 3 THEN equipo_trabajos.valor_hh * recurso_humanos.hh ELSE 0 END) AS aporte_solicitado_al_fondo'
        )
      .joins('LEFT JOIN equipo_trabajos ON equipo_trabajos.id = recurso_humanos.equipo_trabajo_id')
      .joins('LEFT JOIN plan_actividades ON plan_actividades.id = recurso_humanos.plan_actividad_id')
      .joins('LEFT JOIN actividades ON actividades.id = plan_actividades.actividad_id')
      .joins('LEFT JOIN actividad_por_lineas ON actividad_por_lineas.actividad_id = actividades.id')
      .where(flujo_id: flujo_id)
      .where('actividad_por_lineas.tipo_instrumento_id' => tipo_instrumento_id)
      .group('recurso_humanos.flujo_id', 'actividad_por_lineas.tipo_actividad')
  
    # Subconsulta para gastos
    gastos_subquery = Gasto
      .select(
        'gastos.flujo_id',
        'actividad_por_lineas.tipo_actividad',
        'SUM(CASE WHEN gastos.tipo_aporte_id = 1 THEN gastos.valor_unitario * gastos.cantidad ELSE 0 END) AS aporte_propio_valorado',
        'SUM(CASE WHEN gastos.tipo_aporte_id = 2 THEN gastos.valor_unitario * gastos.cantidad ELSE 0 END) AS aporte_propio_liquido',
        'SUM(CASE WHEN gastos.tipo_aporte_id = 3 THEN gastos.valor_unitario * gastos.cantidad ELSE 0 END) AS aporte_solicitado_al_fondo'
        )
      .joins('LEFT JOIN plan_actividades ON plan_actividades.id = gastos.plan_actividad_id')
      .joins('LEFT JOIN actividades ON actividades.id = plan_actividades.actividad_id')
      .joins('LEFT JOIN actividad_por_lineas ON actividad_por_lineas.actividad_id = actividades.id')  
      .where(flujo_id: flujo_id)
      .where('actividad_por_lineas.tipo_instrumento_id' => tipo_instrumento_id)
      .group('gastos.flujo_id', 'actividad_por_lineas.tipo_actividad')
  
    # Consulta principal que une las dos subconsultas
    result = RecursoHumano
      .from("(#{hh_gastos_subquery.to_sql}) AS hh_gastos_subquery")
      .joins("LEFT JOIN (#{gastos_subquery.to_sql}) AS gastos_subquery ON hh_gastos_subquery.flujo_id = gastos_subquery.flujo_id AND hh_gastos_subquery.tipo_actividad = gastos_subquery.tipo_actividad")
      .select(
        'COALESCE(hh_gastos_subquery.aporte_propio_valorado, 0) + COALESCE(gastos_subquery.aporte_propio_valorado, 0) AS aporte_propio_valorado',
        'COALESCE(hh_gastos_subquery.aporte_propio_liquido, 0) + COALESCE(gastos_subquery.aporte_propio_liquido, 0) AS aporte_propio_liquido',
        'COALESCE(hh_gastos_subquery.aporte_solicitado_al_fondo, 0) + COALESCE(gastos_subquery.aporte_solicitado_al_fondo, 0) AS aporte_solicitado_al_fondo'
      )
      .order('hh_gastos_subquery.tipo_actividad ASC')  # Ordenar por la columna tipo_actividad de hh_gastos_subquery
  
    result
  end
  
  ##Insertar Gastos
  def self.total_gastos_tipo_1_insert(flujo_id, actividad_id)
    select('plan_actividades.id, plan_actividades.actividad_id, SUM(
        CASE 
          WHEN gastos.tipo_gasto = 1  THEN gastos.valor_unitario * gastos.cantidad 
          ELSE 0 
        END
      ) AS total_gastos_tipo_1')
    .joins("LEFT JOIN gastos ON gastos.plan_actividad_id = plan_actividades.id")
    .where(plan_actividades: { flujo_id: flujo_id, actividad_id: actividad_id })
    .group("plan_actividades.id, plan_actividades.actividad_id")
    .first
  end

  def self.total_gastos_tipo_2_insert(flujo_id, actividad_id)
    select('plan_actividades.id, plan_actividades.actividad_id, SUM(
        CASE 
          WHEN gastos.tipo_gasto = 2  THEN gastos.valor_unitario * gastos.cantidad 
          ELSE 0 
        END
      ) AS total_gastos_tipo_2')
    .joins("
      LEFT JOIN gastos ON gastos.plan_actividad_id = plan_actividades.id
    ")
    .where(plan_actividades: { flujo_id: flujo_id, actividad_id: actividad_id })
    .group("plan_actividades.id, plan_actividades.actividad_id")
    .first
  end

  ##Eliminar Gastos
  def self.total_gastos_tipo_1(flujo_id, plan_actividad_id)
    select('plan_actividades.id, plan_actividades.actividad_id, SUM(
      CASE 
        WHEN gastos.tipo_gasto = 1  THEN gastos.valor_unitario * gastos.cantidad 
        ELSE 0 
      END
    ) AS total_gastos_tipo_1')
    .joins("LEFT JOIN gastos ON gastos.plan_actividad_id = plan_actividades.id")
    .where(gastos: { flujo_id: flujo_id, plan_actividad_id: plan_actividad_id })
    .group("plan_actividades.id, plan_actividades.actividad_id")
    .first
  end

  def self.total_gastos_tipo_2(flujo_id, plan_actividad_id)
    select('plan_actividades.id, plan_actividades.actividad_id, SUM(
        CASE 
          WHEN gastos.tipo_gasto = 2  THEN gastos.valor_unitario * gastos.cantidad 
          ELSE 0 
        END
      ) AS total_gastos_tipo_2')
    .joins("LEFT JOIN gastos ON gastos.plan_actividad_id = plan_actividades.id")
    .where(gastos: { flujo_id: flujo_id, plan_actividad_id: plan_actividad_id })
    .group("plan_actividades.id, plan_actividades.actividad_id")
    .first
  end

  def self.recursos_internos(flujo_id, actividad_id)
    select('recurso_humanos.id, recurso_humanos.hh AS hh, equipo_trabajos.valor_hh AS valor_hh, users.nombre_completo AS user_name')
      .joins(recurso_humanos: { equipo_trabajo: :user })
      .where(recurso_humanos: { flujo_id: flujo_id })
      .where(equipo_trabajos: { tipo_equipo: 3 })
      .where(plan_actividades: { actividad_id: actividad_id })
  end

  def self.recursos_externos(flujo_id, actividad_id)
    select('recurso_humanos.id, recurso_humanos.hh AS hh, equipo_trabajos.valor_hh AS valor_hh, users.nombre_completo AS user_name')
      .joins(recurso_humanos: { equipo_trabajo: :user })
      .where(recurso_humanos: { flujo_id: flujo_id })
      .where(equipo_trabajos: { tipo_equipo: [1, 2] })
      .where(plan_actividades: { actividad_id: actividad_id })
  end    

  def self.recursos_auditores(flujo_id, actividad_id)
    select('recurso_humanos.id, recurso_humanos.hh AS hh, equipo_trabajos.valor_hh AS valor_hh, registro_proveedores.nombre || \' \' || registro_proveedores.apellido AS user_name')
      .joins("INNER JOIN recurso_humanos ON recurso_humanos.plan_actividad_id = plan_actividades.id")
      .joins("INNER JOIN equipo_trabajos ON equipo_trabajos.id = recurso_humanos.equipo_trabajo_id")
      .joins("INNER JOIN registro_proveedores ON registro_proveedores.id = equipo_trabajos.registro_proveedores_id")
      .where(recurso_humanos: { flujo_id: flujo_id })
      .where(equipo_trabajos: { tipo_equipo: 4 })
      .where(plan_actividades: { actividad_id: actividad_id })
  end

  def self.gastos_operaciones(flujo_id, actividad_id)
    select('gastos.id, gastos.nombre, gastos.valor_unitario, gastos.cantidad, 
            CASE gastos.unidad_medida 
              WHEN 1 THEN \'Unidad\' 
              WHEN 2 THEN \'Global\' 
              ELSE \'Otro\' 
            END AS unidad_medida')
    .joins("INNER JOIN gastos ON gastos.plan_actividad_id = plan_actividades.id")
    .where(gastos: { flujo_id: flujo_id })
    .where(plan_actividades: { actividad_id: actividad_id })
    .where(gastos: { tipo_gasto: 1 })
  end

  def self.gastos_administraciones(flujo_id, actividad_id)
    select('gastos.id, gastos.nombre, gastos.valor_unitario, gastos.cantidad, 
              CASE gastos.unidad_medida 
                WHEN 1 THEN \'Unidad\' 
                WHEN 2 THEN \'Global\' 
                ELSE \'Otro\' 
              END AS unidad_medida')
      .joins("INNER JOIN gastos ON gastos.plan_actividad_id = plan_actividades.id")
      .where(gastos: { flujo_id: flujo_id })
      .where(plan_actividades: { actividad_id: actividad_id })
      .where(gastos: { tipo_gasto: 2 })
  end    

  def self.recursos_x_ids(flujo_id, actividad_id, rrhh_propio_ids)
    select('recurso_humanos.id, recurso_humanos.hh AS hh, equipo_trabajos.valor_hh AS valor_hh, users.nombre_completo AS user_name, equipo_trabajos.id AS equipo_trabajos_id')
    .joins(recurso_humanos: { equipo_trabajo: :user })
    .where(recurso_humanos: { flujo_id: flujo_id })
    .where(plan_actividades: { actividad_id: actividad_id })
    .where(equipo_trabajos: { id: rrhh_propio_ids })  # Utilizar los IDs almacenados
  end 

  def self.valor_hh_tipos_1_2_(flujo_id, actividad_id)
    select('plan_actividades.id, plan_actividades.actividad_id, SUM(
              CASE 
              WHEN equipo_trabajos.tipo_equipo IN (1, 2) THEN equipo_trabajos.valor_hh * recurso_humanos.hh
              ELSE 0 
              END
            ) AS valor_hh_tipos_1_2_')
    .joins("
      LEFT JOIN recurso_humanos ON recurso_humanos.plan_actividad_id = plan_actividades.id
      LEFT JOIN actividades ON actividades.id = plan_actividades.actividad_id
      LEFT JOIN equipo_trabajos ON equipo_trabajos.id = recurso_humanos.equipo_trabajo_id
    ")
    .where(plan_actividades: { flujo_id: flujo_id, actividad_id: actividad_id })
    .group("plan_actividades.id, plan_actividades.actividad_id")
    .first
  end

  def self.valor_hh_tipo_3(flujo_id, actividad_id)
    select('plan_actividades.id, plan_actividades.actividad_id, SUM(
              CASE 
              WHEN equipo_trabajos.tipo_equipo = 3 THEN equipo_trabajos.valor_hh * recurso_humanos.hh
              ELSE 0 
              END
            ) AS valor_hh_tipo_3')
    .joins("
      LEFT JOIN recurso_humanos ON recurso_humanos.plan_actividad_id = plan_actividades.id
      LEFT JOIN actividades ON actividades.id = plan_actividades.actividad_id
      LEFT JOIN equipo_trabajos ON equipo_trabajos.id = recurso_humanos.equipo_trabajo_id
    ")
    .where(plan_actividades: { flujo_id: flujo_id, actividad_id: actividad_id })
    .group("plan_actividades.id, plan_actividades.actividad_id")
    .first
  end

  ##TOTALES GENERALES
  def self.total_valor_hh_tipo_3(flujo_id)
    select('SUM(
                CASE 
                WHEN equipo_trabajos.tipo_equipo = 3 THEN equipo_trabajos.valor_hh * recurso_humanos.hh
                ELSE 0 
                END
              ) AS total_valor_hh_tipo_3')
      .joins("
        LEFT JOIN recurso_humanos ON recurso_humanos.plan_actividad_id = plan_actividades.id
        LEFT JOIN actividades ON actividades.id = plan_actividades.actividad_id
        LEFT JOIN equipo_trabajos ON equipo_trabajos.id = recurso_humanos.equipo_trabajo_id
      ")
      .where(plan_actividades: { flujo_id: flujo_id })
      .pluck('SUM(
                CASE 
                WHEN equipo_trabajos.tipo_equipo = 3 THEN equipo_trabajos.valor_hh * recurso_humanos.hh
                ELSE 0 
                END
              )')
      .first
  end

  def self.total_valor_hh_tipos_1_2(flujo_id)
    select('SUM(
                CASE 
                WHEN equipo_trabajos.tipo_equipo IN (1, 2) THEN equipo_trabajos.valor_hh * recurso_humanos.hh
                ELSE 0 
                END
              ) AS total_valor_hh_tipos_1_2')
      .joins("
        LEFT JOIN recurso_humanos ON recurso_humanos.plan_actividad_id = plan_actividades.id
        LEFT JOIN actividades ON actividades.id = plan_actividades.actividad_id
        LEFT JOIN equipo_trabajos ON equipo_trabajos.id = recurso_humanos.equipo_trabajo_id
      ")
      .where(plan_actividades: { flujo_id: flujo_id })
      .pluck('SUM(
                CASE 
                WHEN equipo_trabajos.tipo_equipo IN (1, 2) THEN equipo_trabajos.valor_hh * recurso_humanos.hh
                ELSE 0 
                END
              )')
      .first
  end
  
  def self.total_total_gastos_tipo_1(flujo_id)
    select('SUM(
        CASE 
          WHEN gastos.tipo_gasto = 1  THEN gastos.valor_unitario * gastos.cantidad 
          ELSE 0 
        END
      ) AS total_total_gastos_tipo_1')
    .joins("LEFT JOIN gastos ON gastos.plan_actividad_id = plan_actividades.id")
    .where(plan_actividades: { flujo_id: flujo_id})
    .pluck('SUM(
                CASE 
                  WHEN gastos.tipo_gasto = 1  THEN gastos.valor_unitario * gastos.cantidad 
                  ELSE 0 
                END
              )')
    .first
  end

  def self.total_total_gastos_tipo_2(flujo_id)
    select('SUM(
        CASE 
          WHEN gastos.tipo_gasto = 2  THEN gastos.valor_unitario * gastos.cantidad 
          ELSE 0 
        END
      ) AS total_total_gastos_tipo_2')
    .joins("
      LEFT JOIN gastos ON gastos.plan_actividad_id = plan_actividades.id
    ")
    .where(plan_actividades: { flujo_id: flujo_id })
    .pluck('SUM(
                CASE 
                  WHEN gastos.tipo_gasto = 2  THEN gastos.valor_unitario * gastos.cantidad 
                  ELSE 0 
                END
              )')
    .first
  end
end
