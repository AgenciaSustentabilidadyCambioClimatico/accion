class TestMailer < ApplicationMailer
  # Correo a los administradores/revisores
  def notificacion_test_mail(asunto, cuerpo)
    ascc = Contribuyente.find_by_rut(75980060)
    admins = User.includes(personas: :persona_cargos).where(personas: {contribuyente_id: ascc.id, persona_cargos: {cargo_id: Cargo::ADMIN}})
    destinatarios = admins.pluck(:email)
    
    # Usamos un bloque para renderizar directamente el string 'cuerpo'
    mail(to: destinatarios, subject: "[ADMIN] " + asunto) do |format|
      format.text { render plain: cuerpo }
    end
  end
end