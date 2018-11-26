class TipoProveedor < ApplicationRecord
	validates :nombre, presence: true
	validates :descripcion, presence: true
	validates :solo_asignable_por_ascc, presence: true, unless: -> { solo_asignable_por_ascc == false }
end