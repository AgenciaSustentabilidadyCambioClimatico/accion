class TestMailer < ApplicationMailer
  # Ahora recibe el email específico del administrador como primer parámetro
  def notificacion_test_mail(email_destinatario, asunto, cuerpo)
    @cuerpo = cuerpo
    
    mail(to: email_destinatario, subject: "[ADMIN] " + asunto) do |format|
      format.text { render plain: cuerpo }
    end
  end
end