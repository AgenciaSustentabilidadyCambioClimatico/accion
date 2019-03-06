class InformeImpacto < ApplicationRecord
  belongs_to :manifestacion_de_interes
  # DZC 2018-11-21 18:06:48 se modifica el uploader al tipo generico, para ser concordante con los tipos de arvchivos permitidos en la carga histórica, o de otra forma el archivo no se sube, y carrierwave no puede manejar el copiar archivos nil
  mount_uploader :documento, ArchivoDocumentosGenericosManifestacionDeInteresUploader
  validates :documento, presence: true
  validates :nombre_documento, presence: true, if: -> { self.subida_parcial == 'false' }
  validates :observacion, presence: true, if: -> { self.rechazado}
  attr_accessor :subida_parcial, :rechazado
end