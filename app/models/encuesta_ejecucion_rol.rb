class EncuestaEjecucionRol < ApplicationRecord
  belongs_to :tarea
  belongs_to :rol
end
