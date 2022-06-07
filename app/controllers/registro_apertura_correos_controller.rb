class RegistroAperturaCorreosController < ApplicationController
	def image
    registro = RegistroAperturaCorreo.find_by_id(params[:id])
    if registro.present?
      registro.estado = true
      registro.fecha_apertura_correo = DateTime.now
      registro.save
    end
    send_file "#{Rails.root}/public/pixel.png", :type => 'image/png', :disposition => 'inline'
  end
  def test
  	r = RegistroAperturaCorreo.create(user_id: 18)
  	FlujoMailer.enviar( "test", 
										"correo test", 
										"rdiaz@binarybag.com", r.id).deliver_now
  end
end
