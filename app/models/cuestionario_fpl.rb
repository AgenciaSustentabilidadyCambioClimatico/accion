class CuestionarioFpl < ApplicationRecord
  belongs_to :flujo

  ###CAMPO REVISION###
  #EL CODIGO 1 REPRESENTA APROBADO 
  #EL CODIGO 2 REPRESENTA CON OBSERVACION
  #EL CODIGO 3 REPRESENTA RECHAZO
  #EL CODIGO 4 REPRESENTA CON OBSERVACION SEGUNDA ITERACION Y FINAL
end
