class GenerarVistaReporteriaWorker
  include Sidekiq::Job

  sidekiq_options retry: false, queue: "default", backtrace: true

  sidekiq_retries_exhausted do |msg|
    Sidekiq.logger.warn "Failed #{msg["class"]} with #{msg["args"]}: #{msg["error_message"]}"
  end

  def perform
    #header
    manif_de_intereses_firmadas = ManifestacionDeInteres.where("firma_fecha IS NOT NULL OR firma_fecha_hora IS NOT NULL")
    acuerdos_firmados = manif_de_intereses_firmadas.count
    empresas_adheridas = Set.new
    empresas_certificadas = Set.new

    ManifestacionDeInteres.find_each do |manif_de_interes|
      empresas_adheridas.merge(manif_de_interes.elementos_adheridos.pluck(:rut_institucion))
      empresas_certificadas.merge(manif_de_interes.elementos_certificados.pluck(:rut_institucion))
    end

    flujos = Flujo.where(manifestacion_de_interes_id: manif_de_intereses_firmadas.pluck(:id))
    acciones = SetMetasAccion.where(flujo_id: flujos.pluck(:id)).count

    header = ReporteriaDato.find_or_create_by(ruta: nil)
    header.datos = {
      acuerdos_firmados: acuerdos_firmados,
      empresas_adheridas: empresas_adheridas.size,
      empresas_certificadas: empresas_certificadas.size,
      acciones: acciones
    }
    header.save


    #index
    clasificaciones_padre = Clasificacion.where(clasificacion_id: nil).order(updated_at: :desc)
    clasificaciones_data = ReporteriaDato.find_or_create_by(ruta: "index")
    _clasificaciones_data = []
    clasificaciones_padre.each do |clasificacion|
      _clasificaciones_data << {
        id: clasificacion.id,
        imagen: clasificacion.imagen.url,
        icono: clasificacion.icono.url,
        color: clasificacion.color,
        nombre: clasificacion.nombre,
        descripcion: clasificacion.descripcion,
        acuerdos: clasificacion.acuerdos.length,
        acciones: clasificacion.set_metas_acciones.length,
        empresas: clasificacion.empresas.length,
        elementos: clasificacion.elementos.length
      }


      #acuerdos firmados por clasificacion
      _acuerdos_firmados = ReporteriaDato.find_or_create_by(ruta: "acuerdos-firmados", clasificacion_id: clasificacion.id)
      manifestacion_de_intereses_ids= clasificacion.acuerdos
      _acuerdos_firmados.datos = manif_de_intereses_firmadas.where(id: manifestacion_de_intereses_ids).map{|manif_de_interes|
        {
          acuerdo_id: manif_de_interes.id,
          flujo_id: manif_de_interes.flujo.id,
          clasificacion_id: nil,
          nombre_acuerdo: manif_de_interes.nombre_acuerdo,
          diagnostico_de_acuerdo_anterior: (manif_de_interes.diagnostico_de_acuerdo_anterior.url rescue nil),
          documento_diagnosticos: !manif_de_interes.documento_diagnosticos.blank?,
          informe_acuerdo: (!manif_de_interes.informe_acuerdo.archivos_anexos.blank? rescue false),
          informe_impacto: (manif_de_interes.informe_impacto.documento.url rescue nil),
          estado_consulta_publica: manif_de_interes.estado_acuerdo,
          empresas_adheridas: manif_de_interes.empresas_adheridas.count,
          empresas_certificadas: (TareaPendiente.where(flujo_id: manif_de_interes.flujo.id, tarea_id: Tarea::ID_APL_032).count > 0 ? manif_de_interes.empresas_certificadas.count : "Por certificar")
        }
      }
      _acuerdos_firmados.save
    end
    clasificaciones_data.datos = _clasificaciones_data
    clasificaciones_data.save


    #acuerdos firmados
    #totales
    acuerdos_firmados_totales = ReporteriaDato.find_or_create_by(ruta: 'acuerdos-firmados', clasificacion_id: nil)
    _acuerdos_firmados_totales = []
    manif_de_intereses_firmadas.each do |manif_de_interes|
      _acuerdos_firmados_totales << {
        acuerdo_id: manif_de_interes.id,
        flujo_id: manif_de_interes.flujo.id,
        clasificacion_id: nil,
        nombre_acuerdo: manif_de_interes.nombre_acuerdo,
        diagnostico_de_acuerdo_anterior: (manif_de_interes.diagnostico_de_acuerdo_anterior.url rescue nil),
        documento_diagnosticos: !manif_de_interes.documento_diagnosticos.blank?,
        informe_acuerdo: (!manif_de_interes.informe_acuerdo.archivos_anexos.blank? rescue false),
        informe_impacto: (manif_de_interes.informe_impacto.documento.url rescue nil),
        estado_consulta_publica: manif_de_interes.estado_acuerdo,
        empresas_adheridas: manif_de_interes.empresas_adheridas.count,
        empresas_certificadas: (TareaPendiente.where(flujo_id: manif_de_interes.flujo.id, tarea_id: Tarea::ID_APL_032).count > 0 ? manif_de_interes.empresas_certificadas.count : "Por certificar")
      }

      #empresas adheridas por acuerdo
      _empresas_adheridas = ReporteriaDato.find_or_create_by(ruta: 'empresas-y-elementos-adheridos', acuerdo_id: manif_de_interes.id)
      _empresas_adheridas.datos = manif_de_interes.elementos_adheridos
      _empresas_adheridas.save

      #empresas cert por acuerdo
      _empresas_cert = ReporteriaDato.find_or_create_by(ruta: 'empresas-y-elementos-certificados', acuerdo_id: manif_de_interes.id)
      _empresas_cert.datos = manif_de_interes.elementos_certificados
      _empresas_cert.save

      #datos acuerdo seleccionado
      #datos generales
      adhesiones_ids = Adhesion.unscoped.where(flujo_id: manif_de_interes.flujo.id).pluck(:id)
      adhesion_elementos = AdhesionElemento.where(adhesion_id: adhesiones_ids).map{|ae| {id: ae.id, nombre: ae.nombre_del_elemento_v2}}
      _datos_clasif = {
        id: manif_de_interes.id,
        nombre_acuerdo: manif_de_interes.nombre_acuerdo,
        contribuyente_razon_social: (manif_de_interes.contribuyente.razon_social rescue ""),
        contribuyente_rut: (manif_de_interes.contribuyente.rut_completo rescue ""),
        firma_fecha: manif_de_interes.firma_fecha,
        firma_fecha_hora: manif_de_interes.firma_fecha_hora,
        acciones: manif_de_interes.acciones.count,
        empresas_adheridas: manif_de_interes.empresas_adheridas.count,
        empresas_certificadas: manif_de_interes.empresas_certificadas.count,
        elementos_adheridos: adhesion_elementos,
        clasificaciones: []
      }
      _datos_metas = _datos_clasif.deep_dup

      #clasificaciones
      _cards_clasif = []
      _seleccionado_clasif = ReporteriaDato.find_or_create_by(ruta: 'acuerdo-seleccionado', acuerdo_id: manif_de_interes.id, vista: "clasificaciones")

      clasificaciones_ids = []
      clasif_ids = []
      clasif_ids += AccionClasificacion.joins("INNER JOIN set_metas_acciones ON set_metas_acciones.accion_id = accion_clasificaciones.accion_id")
                                                .where("set_metas_acciones.flujo_id = #{manif_de_interes.flujo.id}")
                                                .pluck("accion_clasificaciones.clasificacion_id")
      clasif_ids += MateriaSustanciaClasificacion.joins("INNER JOIN set_metas_acciones ON set_metas_acciones.materia_sustancia_id = materia_sustancia_clasificaciones.materia_sustancia_id")
                                                .where("set_metas_acciones.flujo_id = #{manif_de_interes.flujo.id}")
                                                .pluck("materia_sustancia_clasificaciones.clasificacion_id")
      Clasificacion.where(id: clasif_ids).each do |clasif|
        clasificaciones_ids << clasif.mi_padre_mayor.id
      end
      clasificaciones_ids.uniq
      clasificaciones = Clasificacion.where(id: clasificaciones_ids)

      _datos_clasif[:clasificaciones] = clasificaciones_acuerdo_seleccionado(manif_de_interes, clasificaciones, "clasificaciones")
      _seleccionado_clasif.datos = _datos_clasif
      _seleccionado_clasif.save

      #metas
      _cards_metas = []
      _seleccionado_metas = ReporteriaDato.find_or_create_by(ruta: 'acuerdo-seleccionado', acuerdo_id: manif_de_interes.id, vista: "metas")

      metas_ids = []
      metas_ids += Accion.joins("INNER JOIN set_metas_acciones ON set_metas_acciones.accion_id = acciones.id")
                                      .where("set_metas_acciones.flujo_id = #{manif_de_interes.flujo.id}")
                                      .pluck("acciones.meta_id")
      metas_ids += MateriaSustanciaMeta.joins("INNER JOIN materia_sustancias ON materia_sustancia_metas.materia_sustancia_id = materia_sustancias.id INNER JOIN set_metas_acciones ON set_metas_acciones.materia_sustancia_id = materia_sustancias.id")
                                              .where("set_metas_acciones.flujo_id = #{manif_de_interes.flujo.id}")
                                              .pluck("materia_sustancia_metas.clasificacion_id")
      metas_ids += SetMetasAccion.where(flujo_id: manif_de_interes.flujo.id).pluck(:meta_id)
      metas = Clasificacion.where(id: metas_ids)

      _datos_metas[:clasificaciones] = clasificaciones_acuerdo_seleccionado(manif_de_interes, metas, "metas")
      _seleccionado_metas.datos = _datos_metas
      _seleccionado_metas.save

    end
    acuerdos_firmados_totales.datos = _acuerdos_firmados_totales
    acuerdos_firmados_totales.save

    #empresas adheridas y certificadas
    #totales
    empresas_adheridas_totales = ReporteriaDato.find_or_create_by(ruta: "empresas-y-elementos-adheridos", acuerdo_id: nil)
    empresas_certificadas_totales = ReporteriaDato.find_or_create_by(ruta: "empresas-y-elementos-certificados", acuerdo_id: nil)
    _elementos_adheridos = []
    _elementos_certificados = []
    ManifestacionDeInteres.all.each do |manif_de_interes|
      _elementos_adheridos += manif_de_interes.elementos_adheridos
      _elementos_certificados += manif_de_interes.elementos_certificados
    end
    empresas_adheridas_totales.datos = _elementos_adheridos
    empresas_adheridas_totales.save
    empresas_certificadas_totales.datos = _elementos_certificados
    empresas_certificadas_totales.save

  end

  def clasificaciones_acuerdo_seleccionado(manif_de_interes, clasificaciones, vista)
    _data = []
    clasificaciones.each do |clasificacion|
    _acciones_comprometidas = []
    _metas_comprometidas = []
    if vista == "clasificaciones"
      acciones_ids = clasificacion.set_metas_acciones_comprometidas(manif_de_interes).pluck(:id)
  
      clasificacion.metas_comprometidas(manif_de_interes).each do |meta|
        _meta_comprometida = {nombre: meta.nombre, acciones: []}
        meta.set_metas_acciones_comprometidas_de_meta(manif_de_interes).each do |accion|
          if acciones_ids.include?(accion.id)
            _meta_comprometida[:acciones] << {
              descripcion: accion.descripcion_accion,
              nombre: "#{accion.accion.nombre}#{(accion.materia_sustancia.blank? ? '' : '/'+accion.materia_sustancia.nombre)}",
              porcentaje_avance: accion.obtiene_porcentaje_avance,
              porcentaje_cumplimiento: accion.obtiene_procentaje_cumplimiento.gsub("%","").to_f
            }
          end
        end
        _metas_comprometidas << _meta_comprometida
      end
    else
      clasificacion.set_metas_acciones_comprometidas_de_meta(manif_de_interes).each do |accion|
        _acciones_comprometidas << {
          descripcion: accion.descripcion_accion,
          nombre: "#{accion.accion.nombre}#{(accion.materia_sustancia.blank? ? '' : '/'+accion.materia_sustancia.nombre)}",
          porcentaje_avance: accion.obtiene_porcentaje_avance,
          porcentaje_cumplimiento: accion.obtiene_procentaje_cumplimiento.gsub("%","").to_f
        }
      end
    end
    _data << {
      id: clasificacion.id,
      imagen: clasificacion.imagen.url,
      color: clasificacion.color,
      icono: clasificacion.icono.url,
      nombre: clasificacion.nombre,
      descripcion: clasificacion.descripcion,
      metas_comprometidas: _metas_comprometidas,
      acciones_comprometidas: _acciones_comprometidas,
      empresas_comprometidas: clasificacion.empresas_comprometidas(manif_de_interes, vista).length,
      cumplimiento_promedio: "#{clasificacion.cumplimiento_promedio(manif_de_interes, vista)}%",
      elementos_comprometidos: clasificacion.elementos_comprometidos(manif_de_interes, vista).count
    }
  end
  return _data
  end
end

