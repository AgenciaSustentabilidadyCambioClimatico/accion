class GeoLocalization

	#El formato es "Moneda 1541, Santiago Región Metropolitana, Chile"
	def self.get_coordinates(direccion, ciudad_comuna_region, pais=:Chile)

		location = { latitude: nil, longitude: nil }
		geocoder	=	self.execute("#{direccion}, #{ciudad_comuna_region} #{pais}").first
		unless geocoder.nil?
			location[:latitude] = geocoder.data["lat"]
			location[:longitude] = geocoder.data["lon"]
		end
		location
	end

	def self.execute(place)
		Geocoder::Query.new(place).execute
	end

	def self.data(string)
		data_as_hash = { query: string }
		place = self.execute(string)
		if ! place.blank? && place.is_a?(Array) && place.size > 0 && place.first.respond_to?(:data) && place.first.data.is_a?(Hash)
			data_as_hash = place.first.data.to_json.as_hash
		end
		data_as_hash
	end

  def self.geometry(string)
    data = self.data(string)
    if data[:lat] && data[:lon]
      result = { query: string, location: { lat: data[:lat], lng: data[:lon] } }
      result
    else
      puts "No coordinates found for '#{string}'"
      { query: string }
    end
  end
end
