class Gasto < ApplicationRecord
  belongs_to :tipo_aporte
  belongs_to :flujo
  belongs_to :plan_actividad
end
