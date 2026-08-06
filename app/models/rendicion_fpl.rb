class RendicionFpl < ApplicationRecord
  self.table_name = 'rendiciones_fpl'

  belongs_to :flujo
  belongs_to :revisor_tecnico, class_name: 'User', foreign_key: 'revisor_tecnico_id', optional: true
  belongs_to :revisor_financiero, class_name: 'User', foreign_key: 'revisor_financiero_id', optional: true

  # Especificar class_name evita que Rails busque 'RendicionDetallesFpl'
  has_many :rendicion_detalles_fpl, class_name: 'RendicionDetalleFpl', foreign_key: :rendicion_fpl_id, dependent: :destroy
  accepts_nested_attributes_for :rendicion_detalles_fpl, allow_destroy: true

  enum estado: { borrador_tecnico: 0, tecnica_completada: 1, finalizada: 2 }

  validates :flujo_id, presence: true
  validates :mes_a_rendir, presence: true
end