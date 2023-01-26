class ComentarioMailer < ApplicationMailer

	def nuevo(comentario)
    @comentario = comentario
    mail(to: comentario.email_contacto, subject: 'Nuevo comentario del sitio ASCC')
  end

  def nuevo_para_revisor(comentario)
    users = @users = Responsable.__personas_responsables(Rol::REVISOR_TECNICO, TipoInstrumento.find_by(nombre: 'Acuerdo de Producción Limpia').id)
    @comentario = comentario
    mail(to: users.last.email_institucional, subject: 'Nuevo comentario del sitio ASCC')
  end

  def welcome(recipient)
    mail(to: recipient, subject: "Correo")
  end
end
