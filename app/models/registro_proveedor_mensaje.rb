class RegistroProveedorMensaje < ApplicationRecord
  belongs_to :tarea

  validates :asunto, presence: true
  validates :body, presence: true
end
