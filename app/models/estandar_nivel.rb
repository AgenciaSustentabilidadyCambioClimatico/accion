class EstandarNivel < ApplicationRecord

	belongs_to :estandar_homologacion

  mount_uploader :archivo, ArchivoEstandarNivelUploader

  validates :nombre, :porcentaje, presence: true
  validate :archivo_dimensiones

  before_destroy :desvilcular_set_metas_acciones

  def desvilcular_set_metas_acciones
  	EstandarSetMetasAccion.where(estandar_nivel_id: self.id).update_all(estandar_nivel_id: nil)
  end

  def archivo_dimensiones
  	if !self.archivo.blank?
      dimensiones = self.archivo.dimensions(self.archivo)
  		errors.add(:archivo, "Dimensiones de archivo no pueden superar los 500 pixeles de alto y 300 pixeles de ancho") if dimensiones.first > 300 || dimensiones.last > 500
  	end
  end


end
