class DocumentoGarantia < ApplicationRecord
	mount_uploader :archivo, ArchivoDocumentoGarantiaUploader
	belongs_to :proyecto
	belongs_to :tipo_documento_garantia#, optional: true
	belongs_to :documento_garantia, optional: true
	belongs_to :estado_documento_garantia, optional: true
	has_many :documentos_garantias, :class_name => 'DocumentoGarantia', :foreign_key => 'documento_garantia_id', :dependent => :delete_all

	validates :tipo_documento_garantia_id, presence: true
	validates :documento_garantia_id, presence: true, if:  -> { tipo_documento_garantia_id == TipoDocumentoGarantia::ENDOSO }
	validates :numero_documento, presence: true
	validates :fecha_vencimiento, presence: true
	validates :monto, presence: true, unless:  -> { tipo_documento_garantia_id == TipoDocumentoGarantia::ENDOSO }
	validate :endoso_fecha_correcta

	def self.por_padre(proyecto_id,current=nil,key=:numero_documento,object=false,include_parent=true)
		self.agrupar(
			DocumentoGarantia.includes([:tipo_documento_garantia])
			.where(proyecto_id: proyecto_id)
			.where.not(tipo_documento_garantia_id: 4)
			.where(estado_documento_garantia_id: [nil, EstadoDocumentoGarantia::VENCIDO])
			.order(numero_documento: :asc,tipo_documento_garantia_id: :asc).all
			.map{ |dg| 
				dg.id != current ? dg.documentos_garantias.count > 0 ? nil: dg : dg 
			}.compact,
			:tipo_documento_garantia_id,
			:tipo_documento_garantia,
			key,
			object,
			include_parent
		)
	end

	def endoso_fecha_correcta
		if self.tipo_documento_garantia_id == TipoDocumentoGarantia::ENDOSO && self.documento_garantia.fecha_vencimiento >= self.fecha_vencimiento
			errors.add(:fecha_vencimiento, "Fecha de endoso debe ser posterior a documento endosado")
		end
	end

	def posee_endosos
		self.documentos_garantias.count > 0
	end
	
end