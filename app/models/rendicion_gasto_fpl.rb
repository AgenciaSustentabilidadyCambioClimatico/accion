class RendicionGastoFpl < ApplicationRecord
  self.table_name = 'rendicion_gastos_fpl'

  belongs_to :rendicion_fpl
  belongs_to :plan_actividad

  validates :categoria, presence: true
  validates :cantidad_rendida, numericality: { greater_than_or_equal_to: 0, less_than_or_equal_to: 999 }
 
  before_save :calcular_costo_rendido

  private

  def calcular_costo_rendido
    self.costo_rendido = (cantidad_rendida.to_f * valor_unitario.to_f).round(2)
  end
end