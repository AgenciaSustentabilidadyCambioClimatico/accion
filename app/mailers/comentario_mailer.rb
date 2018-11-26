class ComentarioMailer < ApplicationMailer

	def nuevo(comentario)
    @comentario = comentario
    mail(to: comentario.email_contacto, subject: 'Nuevo comentario del sitio ASCC')
  end

  def welcome(recipient)
    mail(to: recipient, subject: "Correo")
  end
end