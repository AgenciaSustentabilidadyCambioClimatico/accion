class DocumentoDiagnostico < ApplicationRecord
	attr_accessor :desde_estandar, :desde_set_antiguo
	belongs_to :tipo_documento_diagnostico, optional: true
	accepts_nested_attributes_for :tipo_documento_diagnostico, allow_destroy: true
	
	validates :manifestacion_de_interes_id, presence: true
	validates :tipo_documento_diagnostico_id, presence: true, unless: -> { desde_estandar == true || desde_set_antiguo == true } # DZC 2018-10-11 11:24:59 se incorpora la posibilidad de que el atributo sea nulo cuando se instancia desde un set antiguo
	validates :nombre, presence: true
	validates :publico, presence: true, unless: -> { publico == false }
	validates :archivo, presence: true
	validates :requiere_correcciones, presence: true, unless: -> { requiere_correcciones == false }

	mount_uploader :archivo, EstandaHomologacionReferenciaUploader # se cambia para que acepten los mismo tipos de extensiones ArchivoDocumentosGenericosManifestacionDeInteresUploader
end
