class TraspasoMailer < ApplicationMailer
  def notificar(traspaso)
    @usuario_origen = traspaso.origen
    @usuario_destino = traspaso.destino
    ascc = Contribuyente.find_by_rut(75980060)
    admins = User.includes(personas: :persona_cargos).where(personas: {contribuyente_id: ascc.id, persona_cargos: {cargo_id: Cargo::ADMIN}})
    destinatarios = [@usuario_origen.email, @usuario_destino.email] + admins.pluck(:email)
    @nombre_instrumento = traspaso.flujo.id.to_s+" - "+traspaso.flujo.nombre_instrumento
    mail(to: destinatarios, subject: "Estimado/a, el Instrumento "+@nombre_instrumento+" ha sido traspasado")
  end
end