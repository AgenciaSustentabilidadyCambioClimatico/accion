class PlanActividad < ApplicationRecord
  belongs_to :actividad
  belongs_to :flujo
  belongs_to :objetivos_especifico, optional: true
  has_many :gasto
  has_many :gastos, foreign_key: 'plan_actividad_id'
  has_many :equipo_trabajos
  has_many :recurso_humanos


  def self.actividad_detalle(flujo_id)
    find_by_sql("
      SELECT 
        COALESCE(hh_gastos_subquery.actividad_id, gastos_subquery.actividad_id, todas_actividades.actividad_id) AS id,
        COALESCE(hh_gastos_subquery.nombre, gastos_subquery.nombre, todas_actividades.nombre) AS nombre,
        COALESCE(hh_gastos_subquery.duracion, gastos_subquery.duracion, todas_actividades.duracion) AS duracion, 
        COALESCE(hh_gastos_subquery.valor_hh_tipo_3, 0) AS valor_hh_tipo_3,
        COALESCE(hh_gastos_subquery.valor_hh_tipos_1_2, 0) AS valor_hh_tipos_1_2,
        COALESCE(gastos_subquery.total_gastos_tipo_1, 0) AS total_gastos_tipo_1,
        COALESCE(gastos_subquery.total_gastos_tipo_2, 0) AS total_gastos_tipo_2
      FROM (
        SELECT 
          plan_actividades.actividad_id,
          actividades.nombre,
          plan_actividades.duracion, 
          SUM(
            CASE 
              WHEN equipo_trabajos.tipo_equipo = 3 THEN equipo_trabajos.valor_hh * recurso_humanos.hh
              ELSE 0 
            END
          ) AS valor_hh_tipo_3,
          SUM(
            CASE 
              WHEN equipo_trabajos.tipo_equipo IN (1, 2) THEN equipo_trabajos.valor_hh * recurso_humanos.hh
              ELSE 0 
            END
          ) AS valor_hh_tipos_1_2
        FROM 
          plan_actividades
        LEFT JOIN 
          recurso_humanos ON recurso_humanos.plan_actividad_id = plan_actividades.id
        LEFT JOIN 
          actividades ON actividades.id = plan_actividades.actividad_id
        LEFT JOIN 
          equipo_trabajos ON equipo_trabajos.id = recurso_humanos.equipo_trabajo_id 
        WHERE 
          plan_actividades.flujo_id = #{flujo_id}
        GROUP BY 
          plan_actividades.actividad_id, actividades.nombre, plan_actividades.duracion
      ) AS hh_gastos_subquery
      LEFT JOIN (
        SELECT
          plan_actividades.actividad_id,
          actividades.nombre,
          plan_actividades.duracion, 
          SUM(
            CASE 
              WHEN gastos.tipo_gasto = 1  THEN gastos.valor_unitario * gastos.cantidad 
              ELSE 0 
            END
          ) AS total_gastos_tipo_1,
          SUM(
            CASE 
              WHEN gastos.tipo_gasto = 2 THEN gastos.valor_unitario * gastos.cantidad 
              ELSE 0 
            END
          ) AS total_gastos_tipo_2
        FROM 
          plan_actividades
        LEFT JOIN 
          gastos ON gastos.plan_actividad_id = plan_actividades.id
        LEFT JOIN 
          actividades ON actividades.id = plan_actividades.actividad_id
        WHERE 
          plan_actividades.flujo_id = #{flujo_id}
        GROUP BY 
          plan_actividades.actividad_id, actividades.nombre, plan_actividades.duracion
      ) AS gastos_subquery ON hh_gastos_subquery.actividad_id = gastos_subquery.actividad_id
      LEFT JOIN (
        SELECT 
          actividad_id,
          nombre,
          duracion
        FROM 
          plan_actividades
        LEFT JOIN 
          actividades ON actividades.id = plan_actividades.actividad_id
        WHERE 
          plan_actividades.flujo_id = #{flujo_id}
        GROUP BY 
          plan_actividades.actividad_id, actividades.nombre, plan_actividades.duracion
      ) AS todas_actividades ON todas_actividades.actividad_id = COALESCE(hh_gastos_subquery.actividad_id, gastos_subquery.actividad_id);
      ")
  end
  

  def self.costos(flujo_id)
    find_by_sql("
      SELECT
        COALESCE(hh_gastos_subquery.flujo_id, gastos_subquery.flujo_id) AS id,
        COALESCE(hh_gastos_subquery.valor_hh_tipo_3, 0) AS recursos_humanos_propios,
        COALESCE(hh_gastos_subquery.valor_hh_tipos_1_2, 0) AS recursos_humanos_externos,
        COALESCE(gastos_subquery.total_gastos_tipo_1, 0) AS gastos_operacion,
        COALESCE(gastos_subquery.total_gastos_tipo_2, 0) AS gastos_administrativos,
        COALESCE(hh_gastos_subquery.valor_hh_tipo_3+hh_gastos_subquery.valor_hh_tipos_1_2+gastos_subquery.total_gastos_tipo_1+gastos_subquery.total_gastos_tipo_2, 0) AS costo_total_de_la_propuesta,
        COALESCE(hh_gastos_subquery.aporte_propio_valorado+gastos_subquery.aporte_propio_valorado, 0) AS aporte_propio_valorado,
        COALESCE(hh_gastos_subquery.aporte_propio_liquido+gastos_subquery.aporte_propio_liquido, 0) AS aporte_propio_liquido,
        COALESCE(hh_gastos_subquery.aporte_solicitado_al_fondo+gastos_subquery.aporte_solicitado_al_fondo, 0) AS aporte_solicitado_al_fondo,
        COALESCE(hh_gastos_subquery.aporte_propio_valorado_rrhh_propio, 0) AS aporte_propio_valorado_rrhh_propio,
        COALESCE(hh_gastos_subquery.aporte_propio_valorado_rrhh_externo, 0) AS aporte_propio_valorado_rrhh_externo,
        COALESCE(hh_gastos_subquery.aporte_propio_liquido_rrhh_propio, 0) AS aporte_propio_liquido_rrhh_propio,
        COALESCE(hh_gastos_subquery.aporte_propio_liquido_rrhh_externo, 0) AS aporte_propio_liquido_rrhh_externo,
        COALESCE(hh_gastos_subquery.aporte_solicitado_fondo_rrhh_externo, 0) AS aporte_solicitado_fondo_rrhh_externo,
        COALESCE(gastos_subquery.aporte_propio_valorado_gasto_operacion, 0) AS aporte_propio_valorado_gasto_operacion,
        COALESCE(gastos_subquery.aporte_propio_valorado_gasto_administracion, 0) AS aporte_propio_valorado_gasto_administracion,
        COALESCE(gastos_subquery.aporte_propio_liquido_gasto_operacion, 0) AS aporte_propio_liquido_gasto_operacion,
        COALESCE(gastos_subquery.aporte_propio_liquido_gasto_administracion, 0) AS aporte_propio_liquido_gasto_administracion,
        COALESCE(gastos_subquery.aporte_solicitado_fondo_gasto_operacion, 0) AS aporte_solicitado_fondo_gasto_operacion,
        COALESCE(gastos_subquery.aporte_solicitado_fondo_gasto_administracion, 0) AS aporte_solicitado_fondo_gasto_administracion
      FROM (
      SELECT
        recurso_humanos.flujo_id,
        SUM(
          CASE 
            WHEN equipo_trabajos.tipo_equipo = 3 THEN equipo_trabajos.valor_hh * recurso_humanos.hh
            ELSE 0 
          END
        ) AS valor_hh_tipo_3,
        SUM(
          CASE 
            WHEN equipo_trabajos.tipo_equipo IN (1, 2) THEN equipo_trabajos.valor_hh * recurso_humanos.hh
            ELSE 0 
          END
        ) AS valor_hh_tipos_1_2,
        SUM(
          CASE 
            WHEN recurso_humanos.tipo_aporte_id = 1  THEN equipo_trabajos.valor_hh * recurso_humanos.hh
            ELSE 0 
          END
        ) AS aporte_propio_valorado,
        SUM(
          CASE 
            WHEN recurso_humanos.tipo_aporte_id = 2  THEN equipo_trabajos.valor_hh * recurso_humanos.hh
            ELSE 0 
          END
        ) AS aporte_propio_liquido,
        SUM(
          CASE 
            WHEN recurso_humanos.tipo_aporte_id = 3  THEN equipo_trabajos.valor_hh * recurso_humanos.hh
            ELSE 0 
          END
        ) AS aporte_solicitado_al_fondo,
        SUM(
          CASE 
            WHEN recurso_humanos.tipo_aporte_id = 1 AND equipo_trabajos.tipo_equipo = 3  THEN equipo_trabajos.valor_hh * recurso_humanos.hh
            ELSE 0 
          END
        ) AS aporte_propio_valorado_rrhh_propio,
        SUM(
          CASE 
            WHEN recurso_humanos.tipo_aporte_id = 1 AND equipo_trabajos.tipo_equipo IN (1,2) THEN equipo_trabajos.valor_hh * recurso_humanos.hh
            ELSE 0 
          END
        ) AS aporte_propio_liquido_rrhh_propio,
        SUM(
          CASE 
            WHEN recurso_humanos.tipo_aporte_id = 2 AND equipo_trabajos.tipo_equipo = 3  THEN equipo_trabajos.valor_hh * recurso_humanos.hh
            ELSE 0 
          END
        ) AS aporte_propio_valorado_rrhh_externo,
        SUM(
          CASE 
            WHEN recurso_humanos.tipo_aporte_id = 2 AND equipo_trabajos.tipo_equipo IN (1,2)  THEN equipo_trabajos.valor_hh * recurso_humanos.hh
            ELSE 0 
          END
        ) AS aporte_propio_liquido_rrhh_externo,
        SUM(
          CASE 
            WHEN recurso_humanos.tipo_aporte_id = 3 AND equipo_trabajos.tipo_equipo IN (1,2)  THEN equipo_trabajos.valor_hh * recurso_humanos.hh
            ELSE 0 
          END
        ) AS aporte_solicitado_fondo_rrhh_externo
      FROM 
        recurso_humanos
      LEFT JOIN 
        equipo_trabajos ON equipo_trabajos.id = recurso_humanos.equipo_trabajo_id 
      WHERE 
        recurso_humanos.flujo_id = #{flujo_id}
      GROUP BY 
        recurso_humanos.flujo_id
      ) AS hh_gastos_subquery
      LEFT JOIN (
      SELECT
        gastos.flujo_id,
        SUM(
          CASE 
            WHEN gastos.tipo_gasto = 1  THEN gastos.valor_unitario * gastos.cantidad 
            ELSE 0 
          END
        ) AS total_gastos_tipo_1,
        SUM(
          CASE 
            WHEN gastos.tipo_gasto = 2 THEN gastos.valor_unitario * gastos.cantidad 
            ELSE 0 
          END
        ) AS total_gastos_tipo_2,
        SUM(
          CASE 
            WHEN gastos.tipo_aporte_id = 1 THEN gastos.valor_unitario * gastos.cantidad 
            ELSE 0 
          END
        ) AS aporte_propio_valorado,
        SUM(
          CASE 
            WHEN gastos.tipo_aporte_id = 2 THEN gastos.valor_unitario * gastos.cantidad 
            ELSE 0 
          END
        ) AS aporte_propio_liquido,
        SUM(
          CASE 
            WHEN gastos.tipo_aporte_id = 3 THEN gastos.valor_unitario * gastos.cantidad 
            ELSE 0 
          END
        ) AS aporte_solicitado_al_fondo,
        SUM(
          CASE 
            WHEN gastos.tipo_aporte_id = 1 AND tipo_gasto = 1  THEN gastos.valor_unitario * gastos.cantidad 
            ELSE 0 
          END
        ) AS aporte_propio_valorado_gasto_operacion,
        SUM(
          CASE 
            WHEN gastos.tipo_aporte_id = 1 AND tipo_gasto = 2  THEN gastos.valor_unitario * gastos.cantidad 
            ELSE 0 
          END
        ) AS aporte_propio_valorado_gasto_administracion,
        SUM(
          CASE 
            WHEN gastos.tipo_aporte_id = 2 AND tipo_gasto = 1  THEN gastos.valor_unitario * gastos.cantidad 
            ELSE 0 
          END
        ) AS aporte_propio_liquido_gasto_operacion,
        SUM(
          CASE 
            WHEN gastos.tipo_aporte_id = 2 AND tipo_gasto = 2  THEN gastos.valor_unitario * gastos.cantidad 
            ELSE 0 
          END
        ) AS aporte_propio_liquido_gasto_administracion,
        SUM(
          CASE 
            WHEN gastos.tipo_aporte_id = 3 AND tipo_gasto = 1  THEN gastos.valor_unitario * gastos.cantidad 
            ELSE 0 
          END
        ) AS aporte_solicitado_fondo_gasto_operacion,
        SUM(
          CASE 
            WHEN gastos.tipo_aporte_id = 3 AND tipo_gasto = 2  THEN gastos.valor_unitario * gastos.cantidad 
            ELSE 0 
          END
        ) AS aporte_solicitado_fondo_gasto_administracion
      FROM 
        gastos
      WHERE 
        gastos.flujo_id = #{flujo_id}
      GROUP BY gastos.flujo_id
      ) AS gastos_subquery ON hh_gastos_subquery.flujo_id = gastos_subquery.flujo_id; ").first
    
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
    select('recurso_humanos.id, recurso_humanos.hh AS hh, equipo_trabajos.valor_hh AS valor_hh, users.nombre_completo AS user_name')
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

end
