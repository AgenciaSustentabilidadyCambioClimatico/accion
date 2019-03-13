class EstadoDocumentoGarantia < ApplicationRecord
	
	has_many :documento_garantias

	VENCIDO = 1
	DEVUELTO = 2
	COBRADO = 3

end