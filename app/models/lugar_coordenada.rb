class LugarCoordenada < ApplicationRecord

	def self.consultar(lugares)
		lugares = lugares.is_a?(Array) ? lugares : [lugares]
		encontrados = self.where(lugar: lugares).all
		resultado = encontrados.map{|e| { latitud: e.latitud, longitud: e.longitud }}
		if (resultado.size < lugares.size)
			(lugares - encontrados.map{|e|e.lugar}).each do |l|
				geometria = GeoLocalization.geometry(l)
				if ! geometria.blank? && geometria.include?(:location)
					resultado << { latitud: geometria[:location][:lat].to_f, longitud: geometria[:location][:lng].to_f }
				end
			end
		end

		resultado
	end
end
