class Admin::TestCorreosController < ApplicationController
  before_action :authenticate_user! # Asegura que solo admins ejecuten esto

  def create
    asunto = "TEST: Verificación del sistema de envíos"
    cuerpo = "Este es un correo de prueba generado desde el panel administrativo."
 
    TestMailer.notificacion_test_mail(asunto, cuerpo).deliver_later

    flash[:notice] = "Test enviado a administradores."
    redirect_to request.referrer
  end
end