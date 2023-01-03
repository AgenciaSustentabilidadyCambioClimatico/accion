class RegistroProveedor < ApplicationRecord
  belongs_to :contribuyente, optional: true
  belongs_to :tipo_contribuyente, optional: true
  belongs_to :tipo_proveedor
  has_many :certificado_proveedores, dependent: :destroy
  has_many :documento_registro_proveedores, dependent: :destroy

  accepts_nested_attributes_for :contribuyente, :reject_if => :all_blank
  accepts_nested_attributes_for :certificado_proveedores, allow_destroy: true
  accepts_nested_attributes_for :documento_registro_proveedores, allow_destroy: true

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
