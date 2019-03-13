class PpfActividad < ApplicationRecord
	validates :contribuyente_id, presence: true, unless: -> {ppf_tipo_actividad_id == PpfTipoActividad::PPF_CONVOCATORIA}
	validates :comuna_id, presence: true
	validates :programa_proyecto_propuesta_id, presence: true
	validates :ppf_tipo_actividad_id, presence: true
	validates :direccion, presence: true
	validates :fecha, presence: true 	
end
