class UnidadBase < ApplicationRecord

	def self.descritas
		descripcion = {}
		UnidadBase.all.each do |ub|
			descripcion[ub.id] = {
			}
		end
		descripcion
	end
end
