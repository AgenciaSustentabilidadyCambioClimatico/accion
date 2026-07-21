class Admin::TestCorreosController < ApplicationController
  before_action :authenticate_user!

  def create
    asunto = "TEST: Verificación del sistema de envíos"
    cuerpo = "Este es un correo de prueba generado desde el panel administrativo."

    # 1. Buscamos los administradores aquí en el controlador
    ascc = Contribuyente.find_by_rut(75980060)
    admins = User.includes(personas: :persona_cargos).where(personas: {contribuyente_id: ascc.id, persona_cargos: {cargo_id: Cargo::ADMIN}})

    if admins.empty?
      flash[:alert] = "No se encontraron administradores para recibir el test."
      return redirect_to request.referrer
    end

    begin
      # 2. Iteramos y enviamos un correo INDIVIDUAL a cada uno
      admins.each do |admin|
        # Validamos que el admin tenga un email registrado antes de intentar enviar
        if admin.email.present?
          TestMailer.notificacion_test_mail(admin.email, asunto, cuerpo).deliver_now
        end
      end

      flash[:notice] = "Test enviado individualmente a #{admins.count} administradores."
    rescue => e
      flash[:alert] = "Error al enviar el correo de prueba: #{e.message}"
      Rails.logger.error("Error en TestMailer: #{e.message}")
    end

    redirect_to request.referrer
  end
end