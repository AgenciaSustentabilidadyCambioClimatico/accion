class ComentarioFlujo < ApplicationRecord
  belongs_to :flujo
  belongs_to :user
  belongs_to :tarea
end
