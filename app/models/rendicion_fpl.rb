class RendicionFpl < ApplicationRecord
  self.table_name = 'rendiciones_fpl'

  belongs_to :flujo
  belongs_to :revisor_tecnico, class_name: 'User', foreign_key: 'revisor_tecnico_id', optional: true
  belongs_to :revisor_financiero, class_name: 'User', foreign_key: 'revisor_financiero_id', optional: true

  # Especificar class_name evita que Rails busque 'RendicionDetallesFpl'
  has_many :rendicion_detalles_fpl, class_name: 'RendicionDetalleFpl', foreign_key: :rendicion_fpl_id, dependent: :destroy
  has_many :rendicion_gastos_fpl, class_name: 'RendicionGastoFpl', dependent: :destroy
  accepts_nested_attributes_for :rendicion_detalles_fpl, allow_destroy: true

  enum estado: {
  borrador: 0,                           # FPL-12: Postulante guardando avance de la rendición
  enviada_a_revision: 1,                 # FPL-12 -> FPL-13: Enviada por postulante, pendiente designar revisores
  en_evaluacion: 2,                      # FPL-14 / FPL-15: En revisión por revisor técnico/financiero
  observada_tecnica: 3,                  # FPL-18: Rechazada en FPL-15, en corrección técnica por postulante
  observada_financiera: 4,               # FPL-17: Rechazada en FPL-14, en corrección financiera por postulante
  pendiente_verificacion_contable: 5,    # FPL-16: Aprobada por técnica y financiera, esperando auditoría contable
  verificada_contablemente: 6            # FPL-16: Aprobada definitivamente por contabilidad (Estado Final)
}

  validates :flujo_id, presence: true
  # Evita que existan dos registros con el mismo mes_a_rendir para un mismo flujo_id
  validates :mes_a_rendir, presence: true, uniqueness: { scope: :flujo_id, message: "ya posee una rendición creada para este mes." }
end