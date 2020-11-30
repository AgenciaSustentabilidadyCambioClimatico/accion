class ComentariosMetasAccion < ApplicationRecord
  belongs_to :user
  belongs_to :set_metas_accion
  validates :user_id, presence: true
  validates :set_metas_accion_id, presence: true
  validates :nombre, presence: true
  validates :rut, presence: true
  validates :comentario, presence: true
end
