class EquipoTrabajo < ApplicationRecord
  belongs_to :user, optional: true
  belongs_to :flujo
  belongs_to :contribuyente, optional: true
  belongs_to :registro_proveedor, optional: true

  has_many :recurso_humanos, foreign_key: :equipo_trabajo_id, dependent: :destroy

  mount_uploader :copia_ci, ArchivoCopiaCiEquipoTrabajoUploader
  mount_uploader :curriculum, ArchivoCurriculumEquipoTrabajoUploader
  

  # Validación para asegurarse de que la combinación de user_id, flujo_id, tipo_equipo y contribuyente_id no se repita
  validates :user_id, uniqueness: { scope: [:flujo_id, :tipo_equipo, :contribuyente_id], message: "La combinación de user_id, flujo_id, tipo_equipo y contribuyente_id ya está en uso" }, unless: -> { registro_proveedores_id.present? }

  def self.postulantes_faltantes(actividad_id, flujo_id)
    select("equipo_trabajos.*, users.nombre_completo AS nombre_usuario, rh.hh AS HH, rh.equipo_trabajo_id AS rrhh_equipo_id")
      .joins("INNER JOIN users ON equipo_trabajos.user_id = users.id")
      .joins("LEFT JOIN (SELECT recurso_humanos.equipo_trabajo_id, recurso_humanos.hh FROM recurso_humanos INNER JOIN plan_actividades ON recurso_humanos.plan_actividad_id = plan_actividades.id WHERE plan_actividades.actividad_id = #{actividad_id}) rh ON equipo_trabajos.id = rh.equipo_trabajo_id")
      .where("equipo_trabajos.flujo_id = ?", flujo_id)
      .where("equipo_trabajos.tipo_equipo = 3")
  end

  def self.consultor_faltantes(actividad_id, flujo_id)
    select("
      equipo_trabajos.*,
      CASE 
        WHEN equipo_trabajos.tipo_equipo IN (1, 2) THEN users.nombre_completo
        WHEN equipo_trabajos.tipo_equipo = 4 THEN registro_proveedores.nombre || ' ' || registro_proveedores.apellido
        ELSE NULL
      END AS nombre_usuario,
      MAX(CASE WHEN rh.tipo_aporte_id = 2 THEN rh.hh END) AS hh_liquido,
      MAX(CASE WHEN rh.tipo_aporte_id = 3 THEN rh.hh END) AS hh_fondo,
      MAX(CASE WHEN rh.tipo_aporte_id = 2 THEN rh.id END) AS rrhh_id_liquido,
      MAX(CASE WHEN rh.tipo_aporte_id = 3 THEN rh.id END) AS rrhh_id_fondo,
      equipo_trabajos.id AS rrhh_equipo_id
    ")
    .joins("LEFT JOIN users ON equipo_trabajos.user_id = users.id")
    .joins("LEFT JOIN registro_proveedores ON equipo_trabajos.registro_proveedores_id = registro_proveedores.id")
    .joins("
      LEFT JOIN (
        SELECT 
          recurso_humanos.id,
          recurso_humanos.equipo_trabajo_id, 
          recurso_humanos.hh, 
          recurso_humanos.tipo_aporte_id
        FROM 
          recurso_humanos
        INNER JOIN plan_actividades ON recurso_humanos.plan_actividad_id = plan_actividades.id
        WHERE plan_actividades.actividad_id = #{actividad_id}
      ) rh ON equipo_trabajos.id = rh.equipo_trabajo_id
    ")
    .where("equipo_trabajos.flujo_id = ?", flujo_id)
    .where("equipo_trabajos.tipo_equipo IN (1, 2, 4)")
    .group("
      equipo_trabajos.id, 
      users.nombre_completo, 
      registro_proveedores.nombre, 
      registro_proveedores.apellido
    ")
  end

end
