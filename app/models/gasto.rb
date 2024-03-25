class Gasto < ApplicationRecord
  belongs_to :tipo_aporte
  belongs_to :flujo
  belongs_to :plan_actividad

  TOPE_MAXIMO_SOLICITAR_DIAGNOSTICO             = 17000000
  PORCENTAJE_APORTE_LIQUIDO_MINIMO_DIAGNOSTICO  = 9
  PORCENTAJE_APORTE_PROPIO_MINIMO_DIAGNOSTICO   = 30 
  PORCENTAJE_GASTO_ADMINISTRACION_DIAGNOSTICO   = 10

end
