class ComentariosInformeAcuerdo < ApplicationRecord
  belongs_to :user
  belongs_to :informe_acuerdo
  validates :user_id, presence: true
  validates :informe_acuerdo_id, presence: true
  validates :nombre, presence: true
  validates :rut, presence: true
  validates :comentario, presence: true
end
