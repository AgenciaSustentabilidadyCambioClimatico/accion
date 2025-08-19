class NotificadorDeTareasPendientesWorker
  include Sidekiq::Job

  sidekiq_options retry: true, queue: "mailers", backtrace: true

  sidekiq_retries_exhausted do |msg|
    Sidekiq.logger.warn "Failed #{msg["class"]} with #{msg["args"]}: #{msg["error_message"]}"
  end

  def perform(tarea_id)
    tarea = Tarea.find_by(id: tarea_id)
    return unless tarea&.necesita_notificacion?

    pendientes = tarea.pendientes.where(estado_tarea_pendiente_id: EstadoTareaPendiente::NO_INICIADA)
    return if pendientes.empty?

    if tarea.codigo == Tarea::COD_FPL_004
      procesar_tarea_fpl_004(tarea, pendientes)
    else
      procesar_otras_tareas(tarea, pendientes)
    end
  rescue ActiveRecord::RecordNotFound => e
    Rails.logger.error "Tarea no encontrada: #{e.message}"
  end

  private

  def procesar_tarea_fpl_004(tarea, pendientes)
    hoy = Date.today
    prox_mes = hoy + 1.month

    pendientes.each do |pendiente|
      flujo = pendiente.flujo
      proyecto = flujo.proyecto
      condiciones = []

      # Contrato
      condiciones << 'A' if proyecto.fecha_fin_contrato == hoy
      condiciones << 'B' if proyecto.fecha_fin_contrato == prox_mes

      # Documentos de garantía
      proyecto.documento_garantias.where("fecha_vencimiento = ? OR fecha_vencimiento = ?", hoy, prox_mes).each do |dg|
        condiciones << 'C' if dg.fecha_vencimiento == hoy && !condiciones.include?('C')
        condiciones << 'D' if dg.fecha_vencimiento == prox_mes && !condiciones.include?('D')
      end

      # Actividades de rendición
      condiciones << 'E' unless proyecto.rendiciones_rendidas

      # Rendiciones
      condiciones << 'F' if proyecto.rendiciones.where(fecha_rendicion: prox_mes).exists?

      # Anticipo con boleta (revisar lunes)
      if hoy.monday? && proyecto.monto_garantizado.zero? && proyecto.rendiciones.where(modalidad_id: Modalidad::ANTICIPO).exists?
        condiciones << 'G'
      end

      # Enviar notificación
      FlujoTarea.where(tarea_entrada_id: tarea.id).where(condicion_de_salida: condiciones).each do |ft|
        ft.responsables.each do |persona|
          rgc = RegistroAperturaCorreo.create!(
            user_id: persona.user.id,
            flujo_tarea_id: ft.id,
            fecha_envio_correo: DateTime.now,
            flujo_id: pendiente.flujo.id
          )

          FlujoMailer.enviar(
            ft.asunto_format(persona.user),
            ft.cuerpo_format(persona.user),
            persona.email_institucional,
            rgc.id
          ).deliver_later
        end
      end
    end
  end

  def procesar_otras_tareas(tarea, pendientes)
    contenido_pendientes = pendientes.group_by(&:user_id)

    User.includes(:personas).where(id: contenido_pendientes.keys).each do |user|
      contenido_pendientes[user.id].each do |pendiente|
        mdi = obtener_manifestacion_interes(pendiente.flujo)
      
        fpl = nil
        if pendiente.flujo.fondo_produccion_limpia.present?
          fpl = pendiente.flujo.fondo_produccion_limpia
        end

        metodos = tarea.metodos(user, mdi, fpl)
        email = pendiente.persona&.email_institucional.presence || user.email
        asunto = Tarea.replace_values(metodos, tarea.recordatorio_tarea_asunto)
        cuerpo = Tarea.replace_values(metodos, tarea.recordatorio_tarea_cuerpo)

        rgc = RegistroAperturaCorreo.create!(
          user_id: user.id,
          flujo_tarea_id: nil,
          fecha_envio_correo: DateTime.now,
          flujo_id: pendiente.flujo.id
        )

        FlujoMailer.enviar(asunto, cuerpo, email, rgc.id).deliver_later
        #RecordatorioMailer.enviar(email, asunto, cuerpo).deliver_later
      end
    end
  end

  def obtener_manifestacion_interes(flujo)
    flujo.manifestacion_de_interes || begin
      fpl = flujo.fondo_produccion_limpia
      if fpl&.flujo_apl_id
        Flujo.find(fpl.flujo_apl_id).manifestacion_de_interes
      end
    end
  end
end
