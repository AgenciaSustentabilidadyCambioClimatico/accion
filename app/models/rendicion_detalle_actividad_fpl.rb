class RendicionDetalleActividadFpl < ApplicationRecord
  self.table_name = 'rendicion_detalle_actividades_fpl'

  belongs_to :rendicion_detalle_fpl, class_name: 'RendicionDetalleFpl', foreign_key: :rendicion_detalle_fpl_id
  belongs_to :plan_actividad, class_name: 'PlanActividad', foreign_key: :plan_actividad_id
end