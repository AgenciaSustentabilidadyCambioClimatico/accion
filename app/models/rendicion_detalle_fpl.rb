class RendicionDetalleFpl < ApplicationRecord
  self.table_name = 'rendicion_detalles_fpl'

  belongs_to :rendicion_fpl, class_name: 'RendicionFpl', foreign_key: :rendicion_fpl_id

  has_many :rendicion_detalle_actividades_fpl, class_name: 'RendicionDetalleActividadFpl', foreign_key: :rendicion_detalle_fpl_id, dependent: :destroy
  has_many :plan_actividades, through: :rendicion_detalle_actividades_fpl, source: :plan_actividad

  # CARRIERWAVE:
  mount_uploader :archivo, ArchivoRendicionUploader

  enum tipo_tab: { tecnica: 0, financiera_fpl: 1, financiera_aporte: 2 }
  enum cumple: { no_evaluado: 0, si: 1, no: 2 }, _prefix: :cumple
end