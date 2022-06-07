class MateriaSustanciaMeta < ApplicationRecord
  belongs_to :materia_sustancia, optional: true
  belongs_to :clasificacion
  
  validates :clasificacion_id, presence: true
end
