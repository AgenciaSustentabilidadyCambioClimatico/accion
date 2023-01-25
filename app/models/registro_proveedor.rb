class RegistroProveedor < ApplicationRecord
  belongs_to :contribuyente, optional: true
  belongs_to :tipo_contribuyente, optional: true
  belongs_to :tipo_proveedor
  has_many :certificado_proveedores, dependent: :destroy
  has_many :documento_registro_proveedores, dependent: :destroy

  accepts_nested_attributes_for :certificado_proveedores, allow_destroy: true
  accepts_nested_attributes_for :documento_registro_proveedores, allow_destroy: true

  validates :rut, presence: true
  validates :rut, uniqueness: true
  validates :nombre, presence: true
  validates :apellido, presence: true
  validates :profesion, presence: true
  validates :email, presence: true, format: { with: /\A([\w\.%\+\-]+)@([\w\-]+\.)+([\w]{2,})\z/i }
  validates :telefono, presence: true
  validates :telefono, numericality: true, length: {in: 8..11}
  validates :direccion, presence: true
  validates :region, presence: true
  validates :comuna, presence: true
  validates :ciudad, presence: true
  validates :rut_institucion, :nombre_institucion, presence: true, if: :asociar_institucion_present?
  validates :nombre_institucion, presence: true, if: :asociar_institucion_present?
  validates :direccion_casa_matriz, presence: true, if: :asociar_institucion_present?
  validates :ciudad_casa_matriz, presence: true, if: :asociar_institucion_present?
  validate :terms_of_service_value

  enum estado: [:enviado, :aceptado]

  before_validation :normalizar_rut

  def terms_of_service_value
    if terminos_y_servicion != true
      errors.add(:terminos_y_servicion, "Debes aceptar los terminos y servicios")
    end
  end

  def normalizar_rut
    self.rut = self.rut.to_s.upcase.gsub(/[^0-9\-K]/,'') unless self.rut.blank?
  end

  def asociar_institucion_present?
    self.asociar_institucion == true && !self.contribuyente_id.present?
  end
end
