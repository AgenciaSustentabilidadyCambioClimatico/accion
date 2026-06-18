class TestMailer < ApplicationMailer
  # Correo a los administradores/revisores
  def notificacion_test_mail(asunto, cuerpo)
    @cuerpo = cuerpo
    admins = User.includes(personas: :persona_cargos).where(personas: {contribuyente_id: ascc.id, persona_cargos: {cargo_id: Cargo::ADMIN}})
    destinatarios = admins.pluck(:email)
    mail(to: destinatarios, subject: "[ADMIN] " + asunto)
  end
end
