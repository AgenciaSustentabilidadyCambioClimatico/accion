class EstandarHomologacion < ApplicationRecord
  has_many :estandar_niveles, dependent: :destroy
  has_many :estandar_set_metas_acciones, dependent: :destroy

  accepts_nested_attributes_for :estandar_niveles, allow_destroy: true, reject_if: :all_blank
  accepts_nested_attributes_for :estandar_set_metas_acciones, allow_destroy: true, reject_if: :all_blank

  mount_uploaders :referencias, EstandaHomologacionReferenciaUploader

  validates :nombre, presence: true
  validates :descripcion, presence: true
  #validate :cantidad_niveles

  after_create :debo_crear_certificacion_tradicional

  def cantidad_niveles
  	errors.add(:base, "Debe agregar al menos un nivel") if self.estandar_niveles.size == 0
  end

  def debo_crear_certificacion_tradicional
  	if self.estandar_niveles.size == 0
	  	self.estandar_niveles.create({
	  		numero: 1,
	  		nombre: 'Certificación tradicional',
	  		porcentaje: 100
	  	})
	  end
  end
end
