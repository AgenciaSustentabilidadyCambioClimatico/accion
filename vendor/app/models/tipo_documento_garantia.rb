class TipoDocumentoGarantia  < ApplicationRecord

	self.table_name = "tipo_documento_garantias"

	has_many :documento_garantia

	BOLETA = 1
	POLIZA = 2
	VALE_VISTA = 3
	ENDOSO = 4
end