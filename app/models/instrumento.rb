class Instrumento < ApplicationRecord
	attr_accessor :filter_mode, :sub_tipo_instrumento_id,:pais_id,:region_id,:provincia_id,:comuna_id,:actividad_economica_id
	validates :nombre, presence: true
end
