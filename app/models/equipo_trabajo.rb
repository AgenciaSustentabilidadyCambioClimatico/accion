class EquipoTrabajo < ApplicationRecord
  belongs_to :user
  belongs_to :flujo
  belongs_to :contribuyente, optional: true

  # Validación para asegurarse de que la combinación de user_id, flujo_id, tipo_equipo y contribuyente_id no se repita
  validates :user_id, uniqueness: { scope: [:flujo_id, :tipo_equipo, :contribuyente_id], message: "La combinación de user_id, flujo_id, tipo_equipo y contribuyente_id ya está en uso" }

end
