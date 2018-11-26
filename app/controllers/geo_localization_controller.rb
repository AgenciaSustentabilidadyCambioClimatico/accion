class GeoLocalizationController < ApplicationController
	protect_from_forgery with: :exception, unless: proc { action_name == 'coordinates' }
	before_action :authenticate_user!

	def coordinates
		string = params.require(:geo_localization).permit(:place)[:place]
		result = LugarCoordenada.consultar(JSON.parse( string ))
		respond_to do |format|
			format.json {
				render json: { 
					response: result
				}
			}
		end
	end
end