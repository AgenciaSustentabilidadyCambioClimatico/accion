class EstadoRendicion < ApplicationRecord

	belongs_to :tecnica_items, class_name: "ActividadItem", foreign_key: "estado_tecnica_id", optional: true
	belongs_to :respaldo_items, class_name: "ActividadItem", foreign_key: "estado_respaldo_id", optional: true

	NO_ENVIADA	= 1
	EN_REVISION	= 2
	ACEPTADA		= 3
	OBSERVADA		= 4

	NO_MODIFICABLE = [EN_REVISION,OBSERVADA]
end