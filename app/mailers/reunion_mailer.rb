class ReunionMailer < ApplicationMailer
	def enviar(reunion_destinatario)
    @message =reunion_destinatario.format_cuerpo
    mail(to: reunion_destinatario.destinatario.email_institucional, subject: reunion_destinatario.format_titulo)
  end
end
