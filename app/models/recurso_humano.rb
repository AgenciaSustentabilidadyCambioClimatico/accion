class RecursoHumano < ApplicationRecord
  belongs_to :equipo_trabajo
  belongs_to :flujo
  belongs_to :plan_actividad
end
