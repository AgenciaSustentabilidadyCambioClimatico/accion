class GenerarVistaReporteriaWorker
  include Sidekiq::Job

    sidekiq_options retry: false, queue: "default", backtrace: true

    sidekiq_retries_exhausted do |msg|
      Sidekiq.logger.warn "Failed #{msg["class"]} with #{msg["args"]}: #{msg["error_message"]}"
    end

  def perform
    manif_de_intereses_firmadas = ManifestacionDeInteres.where.not(firma_fecha: nil).or(
      ManifestacionDeInteres.where.not(firma_fecha_hora: nil)
    )

    acuerdos_firmados = manif_de_intereses_firmadas.count

    empresas_adheridas = Set.new
    empresas_certificadas = Set.new

    ManifestacionDeInteres.find_each do |manif_de_interes|
      empresas_adheridas.merge(manif_de_interes.elementos_adheridos.pluck(:rut_institucion))
      empresas_certificadas.merge(manif_de_interes.elementos_certificados.pluck(:rut_institucion))
    end

    header = ReporteriaDato.find_or_create_by(ruta: nil)
    header.update(datos: {
      acuerdos_firmados: acuerdos_firmados,
      empresas_adheridas: empresas_adheridas.size,
      empresas_certificadas: empresas_certificadas.size,
      acciones: SetMetasAccion.where(flujo_id: manif_de_intereses_firmadas.pluck(:id)).count
    })

    clasificaciones_data = ReporteriaDato.find_or_create_by(ruta: "index")
    clasificaciones = Clasificacion.where(clasificacion_id: nil).order(updated_at: :desc).includes(:acuerdos, :set_metas_acciones, :empresas, :elementos)

    clasificaciones_info = clasificaciones.map do |clasificacion|
      {
        id: clasificacion.id,
        imagen: clasificacion.imagen.url,
        icono: clasificacion.icono.url,
        color: clasificacion.color,
        nombre: clasificacion.nombre,
        descripcion: clasificacion.descripcion,
        acuerdos: clasificacion.acuerdos.size,
        acciones: clasificacion.set_metas_acciones.size,
        empresas: clasificacion.empresas.size,
        elementos: clasificacion.elementos.size
      }
    end

    clasificaciones_data.update(datos: clasificaciones_info)

    clasificaciones.each do |clasificacion|
      _acuerdos_firmados = ReporteriaDato.find_or_create_by(ruta: "acuerdos-firmados", clasificacion_id: clasificacion.id)

      acuerdos_ids = clasificacion.acuerdos.pluck(:id)
      manifestacion_de_intereses_ids = Flujo.where(id: acuerdos_ids).pluck(:manifestacion_de_interes_id)

      acuerdos_firmados_data = manif_de_intereses_firmadas.where(id: manifestacion_de_intereses_ids).map do |manif|
        {
          acuerdo_id: manif.id,
          flujo_id: manif.flujo.id,
          clasificacion_id: nil,
          nombre_acuerdo: manif.nombre_acuerdo,
          diagnostico_de_acuerdo_anterior: manif.diagnostico_de_acuerdo_anterior&.url,
          documento_diagnosticos: manif.documento_diagnosticos.present?,
          informe_acuerdo: manif.informe_acuerdo.archivos_anexos.present?,
          informe_impacto: manif.informe_impacto.documento&.url,
          estado_consulta_publica: manif.estado_acuerdo,
          empresas_adheridas: manif.empresas_adheridas.count,
          empresas_certificadas: TareaPendiente.exists?(flujo_id: manif.flujo.id, tarea_id: Tarea::ID_APL_032) ? manif.empresas_certificadas.count : "Por certificar"
        }
      end

      _acuerdos_firmados.update(datos: acuerdos_firmados_data)
    end
  end
end
