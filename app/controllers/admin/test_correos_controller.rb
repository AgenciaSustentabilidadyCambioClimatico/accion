class Admin::TestCorreosController < ApplicationController
  before_action :authenticate_user!

  def create
    asunto = "TEST: Verificación del sistema de envíos"
    cuerpo = "Este es un correo de prueba generado desde el panel administrativo."
 
    begin
      TestMailer.notificacion_test_mail(asunto, cuerpo).deliver_now
      flash[:notice] = "Test enviado correctamente a los administradores."
    rescue => e
      flash[:alert] = "No se pudo enviar el correo de prueba: #{e.message}"
      Rails.logger.error("Error en TestMailer: #{e.message}")
    end

    redirect_to request.referrer
  end
end