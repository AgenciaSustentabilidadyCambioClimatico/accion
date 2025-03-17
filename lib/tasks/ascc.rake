namespace :ascc do



  desc "ENV"
  task :escribe_env => :environment do |task, args|
    #`tail /home/dzuniga/PROYECTOS/DESARROLLO/ASCC/RAILS/ascc_sistemas/log/prueba.log`
    #x{touch /home/dzuniga/PROYECTOS/DESARROLLO/ASCC/RAILS/ascc_sistemas/log/prueba.log}
    File.open('/home/dzuniga/PROYECTOS/DESARROLLO/ASCC/RAILS/ascc_sistemas/log/prueba.log', 'w+') do |f|
      ENV.each do |e|
        f.write(e)
      end
    end
  end

  desc "Notifica tareas pendientes"
  task :notificador_de_tareas_pendientes, [:tarea_id] => :environment do |task, args|
    begin
      tarea = Tarea.find(args.tarea_id)
      if tarea.necesita_notificacion?
        pendientes = tarea.pendientes.where(estado_tarea_pendiente_id: EstadoTareaPendiente::NO_INICIADA)
        if pendientes.size > 0
          if tarea.codigo == Tarea::COD_FPL_004
            pendientes.each do |pendiente|
              hoy = Date.today
              prox_mes = hoy + 1.months

              flujo = pendiente.flujo
              proyecto = flujo.proyecto
              condiciones = []

              # Contrato
              if proyecto.fecha_fin_contrato == hoy
                condiciones << 'A'
              elsif proyecto.fecha_fin_contrato == prox_mes
                condiciones << 'B'
              end

              #documentos garantia
              proyecto.documento_garantias.where("fecha_vencimiento = #{hoy} OR fecha_vencimiento = #{prox_mes}").each do |dg|
#DZC Agregado por nosotros
                condiciones << 'C' if dg.fecha_vencimiento == hoy && !condiciones.include?('C')
                condiciones << 'D' if dg.fecha_vencimiento == prox_mes && !condiciones.include?('D')
              end

              #actividades de rendicion rendidas
              unless proyecto.rendiciones_rendidas
                condiciones << 'E'
#DZC
              end

              #rendiciones
              if proyecto.rendiciones.where("fecha_rendicion = #{prox_mes}").count > 0
                condiciones << 'F'
#DZC Agregado por nosotros
              end

              #anticipo con boleta revisar todos los lunes
              if hoy.monday? && proyecto.monto_garantizado == 0 && proyecto.rendiciones.where(modalidad_id: Modalidad::ANTICIPO).size > 0
                condiciones << 'G'
#DZC
              end

              # DZC 2018-10-05 13:19:01 se modifica para registrar la apertura de correo
              FlujoTarea.where(tarea_entrada_id: tarea.id).where(condicion_de_salida: condiciones).each do |ft|
                ft.responsables.each do |persona|
                  rgc = RegistroAperturaCorreo.create(user_id: persona.user.id, flujo_tarea_id: ft.id, fecha_envio_correo: DateTime.now, flujo_id: pendiente.flujo.id)
                  FlujoMailer.enviar(
                    ft.asunto_format(persona.user),
                    ft.cuerpo_format(persona.user),
                    persona.email_institucional,
                    rgc.id)
                end
              end

            end
          else
            contenido_pendientes = pendientes.inject({}){|h,p|h[p.user_id]=[] unless h.include?(p.user_id); h[p.user_id] << p; h }
            User.includes([:personas]).where(id: pendientes.map{|m|m.user_id}).each do |user|
              contenido_pendientes[user.id].each do |pendiente|
                begin
                  mdi = pendiente.flujo.manifestacion_de_interes
                rescue
                  fpl = pendiente.flujo.fondo_produccion_limpia
                  if fpl && fpl.flujo_apl_id
                    flujo_apl = Flujo.find(fpl.flujo_apl_id)
                    mdi = flujo_apl.manifestacion_de_interes
                  else
                   mdi = nil   
                  end
                end

                metodos = tarea.metodos(user, mdi)
                ##
                # DZC 2019-08-16 19:54:56
                # se corrige y simplifica el código, agregando el registro de apertura del correo (bit
                # acusete) y que este se envíe via delayed_job
                email = (pendiente.persona.present? && pendiente.persona.email_institucional.present?) ? pendiente.persona.email_institucional : user.email
                asunto = Tarea.replace_values(metodos,tarea.recordatorio_tarea_asunto)
                cuerpo = Tarea.replace_values(metodos,tarea.recordatorio_tarea_cuerpo)                    
                rgc = RegistroAperturaCorreo.create(user_id: user.id, flujo_tarea_id: nil, fecha_envio_correo: DateTime.now, flujo_id: pendiente.flujo.id)
                FlujoMailer.enviar(
                  asunto,
                  cuerpo,
                  email,
                  rgc.id
                )
                RecordatorioMailer.enviar(email, asunto, cuerpo).deliver_now
              end
            end
          end
        end
      end
    rescue ActiveRecord::RecordNotFound => record_not_found
      puts record_not_found
    end
    puts "------"
    puts ""
  end

  desc "Carga de proyectos desde db remota"
  task :carga_proyectos_remoto => :environment do |task, args|
    ExternalFpl.actualizar_proyectos()
  end

  desc "Actualiza la tabla proyectos"
  task :obtener_proyectos => :environment do |task, args|
    # La data no se sabe si se pide o recibe
    username      = 'username'
    password      = 'password'
    authorization = "http://localhost/authorization.php"
    http_body     = HTTParty.post(authorization, basic_auth: { username: username, password: password } ).body
    parsed_body   = JSON.parse(http_body)
    ap parsed_body
  end

  # DZC 2018-11-22 12:19:09 rake task que elimina los temporales creados por carrierwave cuando ocurrio un error al intentar subir archivos
  desc "Limpia el cache de carrierwave"
  task :limpia_cache_carrierwave do |task, args|
    %x{echo "Eliminando temporales de Carrierwave"}
    ruta = "#{Rails.root}/public/uploads/tmp/"
    FileUtils.rm_rf Dir.glob(ruta+"*") if File.exist?(ruta)
    # CarrierWave.clean_cached_files!
    %x{echo "Temporales de Carrierwave eliminados"}
  end

  # DZC 2018-11-22 12:19:48 rake task que agrega a crontab la ejecución de :limpia_cache_carrierwave todos los días a las 03:00 horas
  desc "# DZC 2019-08-23 20:24:47 DEPLETED - Agrega la rake task ':limpia_cache_carrierwave' a crontab"
  task :agrega_limpia_cache_carrierwave_a_crontab do |task, args|
    __crontab_old = "#{Rails.root}/tmp/__#{Time.now.to_i}_tareas_crontab_old"
    %x{crontab -l > #{__crontab_old}}
    comando = "/bin/bash -l -c 'cd #{Rails.root} && RAILS_ENV=#{Rails.env.production? ? :production : :development} bundle exec rails ascc:limpia_cache_carrierwave --silent'"
    %x{echo "#{'0 3 * * *'} #{comando}" >> #{__crontab_old} }
    %x{crontab #{__crontab_old}}
    %x{rm #{__crontab_old}}
  end

  desc "# DZC 2019-08-23 20:24:47 DEPLETED - Agrega los recordatorios de tareas al crontab"
  task :agrega_recordatorios_crontab => :environment do |task, args|
    tarea = Tarea.first
    if tarea.present?
      tarea.update_crontab
    else
      Rake::Task["ascc:agrega_limpia_cache_carrierwave_a_crontab"].reenable
      Rake::Task["ascc:agrega_limpia_cache_carrierwave_a_crontab"].invoke
    end
  end

  desc "Muestra las variables de entorno"
  task :muestra_variables_de_entorno => :environment do |task, args|
    puts(%x{env})
  end

  desc "Crea el usuario superadmin del sistema"
  task :crea_superadmin, [:rut,:nombre,:telefono,:email,:password,:password_confirm,:contribuyente_id] => :environment do |task,args|

    u = User.new({
      rut: args.rut,
      nombre_completo: args.nombre,
      telefono: args.telefono,
      email: args.email,
      password: args.password,
      password_confirmation: args.password_confirm,
      personas_attributes: [{
        contribuyente_id: args.contribuyente_id,
        email_institucional: args.email,
        persona_cargos_attributes: [{
          cargo_id: 1
        }]
      }]
    })
    if u.save
      p 'Usuario creado correctamente'
    else
      p "Error al crear #{u.errors.messages}"
    end
  end

  desc "Asigna establecimiento a cargo en personas, relacion actualizada"
  task :asigna_establecimiento_cargo => :environment do |task, args|
    Persona.all.each do |persona|
      ec_id = persona.establecimiento_contribuyente_id
      ec_id = persona.contribuyente.direccion_principal.id if ec_id.nil?
      persona.persona_cargos.update_all(establecimiento_contribuyente_id: ec_id)
    end
  end

  desc "Terminar tareas despues de x dias"
  task :terminar_tareas_programadas => :environment do |task, args|

    #V2: quitar metodo 'continua_flujo_tareas_plazo_vencido' que procesa al usar el sistema (¬.¬) y ejecutarlo todos los dias en la madrugada,
    # ademas agregar lo que era especifico de ésta task al método

    TareaPendiente.continua_flujo_tareas_plazo_vencido

    #tareas_a_finalizar = {
    # "45" => {
    #   Tarea::COD_APL_004_1 => 'B',
    #   Tarea::COD_APL_004_2 => 'B',
    #   Tarea::COD_APL_006 => 'C',
    # }
    #}

    #tareas_a_finalizar.each do |dia, tareas|
    # tareas_codigos = tareas.keys
    # tareas_filtradas = TareaPendiente.includes(:tarea).where("((now() AT TIME ZONE 'UTC')::date - (tarea_pendientes.created_at AT TIME ZONE 'UTC')::date) > "+dia)
    #                                     .where(tareas: {codigo: tareas_codigos})
    #                                     .where(estado_tarea_pendiente_id: EstadoTareaPendiente::NO_INICIADA)
    # tareas_filtradas.each do |tarea_pendiente|
    #    tarea_pendiente.pasar_a_siguiente_tarea tareas[tarea_pendiente.tarea.codigo]
    # end
    #end
  end

  desc "Retornar traspasos programados para hoy"
  task :retornar_traspasos => :environment do |task, args|
    traspasos = TraspasoInstrumento.where("(now() AT TIME ZONE 'UTC')::date = fecha_retorno")
    traspasos.each do |traspaso|
      p "Retornando "+traspaso.id.to_s
      traspaso.retornar_traspaso
    end
  end

  desc "Envía correos de aviso"
  task :envia_correos_aviso => :environment do |task, args|
    hoy =  Date.today
    #notifica cierre proceso de acuerdo
    InformeAcuerdo.all.each do |informe_acuerdo|
      fecha_comparativa = informe_acuerdo.manifestacion_de_interes.firma_fecha_hora.blank? ? informe_acuerdo.manifestacion_de_interes.firma_fecha : informe_acuerdo.manifestacion_de_interes.firma_fecha_hora

      anios_a_cierre = informe_acuerdo.plazo_vigencia_acuerdo
      #2 meses antes del cierre de proceso de acuerdo notifico a todos los del listado de actores
      if ((fecha_comparativa + anios_a_cierre.years) - hoy).to_i == 60
        manifestacion_de_interes = informe_acuerdo.manifestacion_de_interes
        destinatarios = MapaDeActor.where(flujo_id: manifestacion_de_interes.flujo.id).map{|ma| ma.persona.user.email}.uniq!
        AvisosMailer.cierre_proceso(destinatarios, manifestacion_de_interes).deliver_now
      end
    end

    #notifico perdida de vigencia (inminente y final)
    #la fecha proviene de la ceremonia, el dia de ceremonia es el dia oficial de certificacion 
    #y de ahi se calcula con los plazos en años en tarea apl-018
    #notifico a coordinador del acuerdo y actores que sean de la empresa
    Auditorias.where(con_certificacion: true).each do |auditoria|
      destinatarios = []
      convocatoria_id = auditoria.convocatoria_id
      minuta_ceremonia = convocatoria_id.present? ? Minuta.find_by(convocatoria_id: convocatoria_id) : nil
      if (minuta_ceremonia.present? && minuta_ceremonia.fecha_acta.present?)
        flujo = auditoria.flujo
        manifestacion_de_interes = flujo.manifestacion_de_interes
        contribuyente = manifestacion_de_interes.contribuyente
        contribuyente = contribuyente.contribuyente if contribuyente.temporal
        MapaDeActor.where(flujo_id: flujo.id).each do |ma|
          #coordinador
          destinatarios << ma.persona.user.email if ma.rol_id == Rol::COORDINADOR
          #actores de la empresa
          destinatarios << ma.persona.user.email if ma.persona.contribuyente_id == contribuyente.id
        end
        #quito emails repetidos
        destinatarios = destinatarios.uniq!

        #vence en 1 mes
        if ((minuta_ceremonia.fecha_acta + auditoria.plazo.years) - hoy).to_i == 30
          AvisosMailer.certificacion_vencimiento_inminente(destinatarios, auditoria).deliver_now
        end
        #venció
        if (minuta_ceremonia.fecha_acta + auditoria.plazo.years + 1.day) == hoy
          AvisosMailer.certificacion_vencida(destinatarios, auditoria).deliver_now
        end
      end
    end
  end

  desc "Envía correos de aviso registro proveedores"
  task :envia_correos_aviso_registro_proveedores => :environment do |task, args|
    hoy =  Date.today
    #notifico que se puede actualizar el registro proveedor o que se vencio
    registro_proveedores = RegistroProveedor.where(estado: 'aprobado')
    registro_proveedores.each do |registro_proveedor|
      fecha = registro_proveedor.fecha_aprobado
      plazo = 3.years
      aviso = 3.years + 11.months
      if fecha + aviso == hoy
        registro_proveedor.update!(estado: 'actualizar')
        RegistroProveedorMailer.aviso_venciminento_proveedor(registro_proveedor).deliver_now
      elsif fecha + plazo <= hoy
        registro_proveedor.update!(estado: 'vencido')
        RegistroProveedorMailer.aviso_vencido_proveedor(registro_proveedor).deliver_now
      end
    end
  end

  desc "Genera vistas de reporteria"
  task :genera_data_reporteria => :environment do |task, args|
    #header
    manif_de_intereses_firmadas = ManifestacionDeInteres.where("firma_fecha IS NOT NULL OR firma_fecha_hora IS NOT NULL")
    acuerdos_firmados = manif_de_intereses_firmadas.count
    empresas_adheridas = []
    empresas_certificadas = []
    ManifestacionDeInteres.all.each do |manif_de_interes|
      manif_de_interes.elementos_adheridos.each do |elem_adherido|
        empresas_adheridas << elem_adherido[:rut_institucion]
      end
      manif_de_interes.elementos_certificados.each do |elem_cert|
        empresas_certificadas << elem_cert[:rut_institucion]
      end
    end
    empresas_adheridas = empresas_adheridas.uniq.length
    empresas_certificadas = empresas_certificadas.uniq.length
    flujos = Flujo.where(manifestacion_de_interes_id: manif_de_intereses_firmadas.pluck(:id))
    acciones = SetMetasAccion.where(flujo_id: flujos.pluck(:id)).count

    header = ReporteriaDato.find_or_create_by(ruta: nil)
    header.datos = {
      acuerdos_firmados: acuerdos_firmados,
      empresas_adheridas: empresas_adheridas,
      empresas_certificadas: empresas_certificadas,
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
      flujos_ids = clasificacion.acuerdos
      manifestacion_de_intereses_ids = Flujo.where(id: flujos_ids).pluck(:manifestacion_de_interes_id)
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

  desc "Procesa archivos de auditoria: FIX sobrecarga FTP"
  task :procesa_archivos_auditoria_elemento => :environment do |task, args|
    Auditoria.order(id: :asc).each do |a|
      p "Procesando auditoria #{a.id}"
      archivos_informe = {}
      archivos_evidencia = {}

      a.auditoria_elementos.each do |ae|
        if !ae.archivo_informe.blank?
          if archivos_informe.has_key?(ae.archivo_informe.file.original_filename)
            ai_id = archivos_informe[ae.archivo_informe.file.original_filename]
          else
            archivo = AuditoriaElementoArchivo.create({
              archivo: ae.archivo_informe.file,
              auditoria_id: a.id
            })
            archivos_informe[ae.archivo_informe.file.original_filename] = archivo.id
            ai_id = archivo.id
          end
        end
        if !ae.archivo_evidencia.blank?
          if archivos_evidencia.has_key?(ae.archivo_evidencia.file.original_filename)
            ae_id = archivos_evidencia[ae.archivo_evidencia.file.original_filename]
          else
            archivo = AuditoriaElementoArchivo.create({
              archivo: ae.archivo_evidencia.file,
              auditoria_id: a.id
            })
            archivos_evidencia[ae.archivo_evidencia.file.original_filename] = archivo.id
            ae_id = archivo.id
          end
        end
        ae.archivo_informe_id = ai_id
        ae.archivo_evidencia_id = ae_id
        #ae.remove_archivo_informe!
        #ae.remove_archivo_evidencia!
        ae.save
      end
    end
  end

  desc "Elimina archivos de auditoria: FIX sobrecarga FTP"
  task :eliminar_archivos_auditoria_elemento => :environment do |task, args|
    Auditoria.order(id: :asc).each do |a|
      p "Procesando auditoria #{a.id}"
      archivos_informe = {}
      archivos_evidencia = {}

      a.auditoria_elementos.each do |ae|
        ae.remove_archivo_informe!
        ae.remove_archivo_evidencia!
        ae.save
      end
    end
  end

  desc "Procesa archivos de adhesion: FIX sobrecarga FTP"
  task :procesa_archivos_adhesion_elemento => :environment do |task, args|
    Adhesion.unscoped.order(id: :asc).each do |a|
      p "Procesando adhesion #{a.id}"

      a.adhesion_elemento_externos.each do |ae|
        ae.remove_archivo_adhesion! if !ae.archivo_adhesion.blank?
        ae.remove_archivo_respaldo! if !ae.archivo_respaldo.blank?
        ae.save
      end

      a.adhesion_elemento_retirados.each do |ae|
        ae.remove_archivo_adhesion! if !ae.archivo_adhesion.blank?
        ae.remove_archivo_respaldo! if !ae.archivo_respaldo.blank?
        ae.save
      end
    end
  end

  private

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
