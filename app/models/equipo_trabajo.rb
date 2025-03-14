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
    select("equipo_trabajos.*, users.nombre_completo AS nombre_usuario, registro_proveedores.nombre || ' ' || registro_proveedores.apellido AS nombre_proveedor, rh.hh AS HH, rh.equipo_trabajo_id AS rrhh_equipo_id, rh.tipo_aporte_id AS tipo_aporte")
      .joins("LEFT JOIN users ON equipo_trabajos.user_id = users.id")
      .joins("LEFT JOIN registro_proveedores ON equipo_trabajos.registro_proveedores_id = registro_proveedores.id")
      .joins("LEFT JOIN (SELECT recurso_humanos.equipo_trabajo_id, recurso_humanos.hh, recurso_humanos.tipo_aporte_id FROM recurso_humanos INNER JOIN plan_actividades ON recurso_humanos.plan_actividad_id = plan_actividades.id WHERE plan_actividades.actividad_id = #{actividad_id}) rh ON equipo_trabajos.id = rh.equipo_trabajo_id")
      .where("equipo_trabajos.flujo_id = ?", flujo_id)
      .where("equipo_trabajos.tipo_equipo IN (1, 2, 4)")
  end
  
  
end
