class RegistroProveedor < ApplicationRecord
  belongs_to :contribuyente, optional: true
  belongs_to :tipo_contribuyente, optional: true

  validates :rut, presence: true
  validates :nombre, presence: true
  validates :apellido, presence: true
  validates :profesion, presence: true
  validates :email, presence: true
  validates :telefono, presence: true
  validates :direccion, presence: true
  validates :region, presence: true
  validates :comuna, presence: true
  validates :ciudad, presence: true
end
