class PlanActividad < ApplicationRecord
  belongs_to :actividad
  belongs_to :flujo
  belongs_to :objetivos_especifico
  has_many :equipo_trabajos
  has_many :recurso_humanos
end
