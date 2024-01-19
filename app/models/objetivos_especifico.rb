class ObjetivosEspecifico < ApplicationRecord
  belongs_to :flujo

  validates :descripcion, presence: true
  validates :metodologia, presence: true
  #validates :resultado, presence: true
  validates :indicadores, presence: true
  #validates :resultado, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 1, less_than_or_equal_to: 2 }
  validates :resultado, numericality: true, length: {in: 8..11}, allow_blank: false
  validates :email, presence: true #, if: -> { !claveunica }
  validates :email, format: { with: /\A([\w\.%\+\-]+)@([\w\-]+\.)+([\w]{2,})\z/i }, if: -> { !email.blank? && email != "no"}

end
