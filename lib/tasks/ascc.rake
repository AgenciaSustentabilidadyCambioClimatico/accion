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
                  FlujoMailer.delay.enviar(
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
              metodos = tarea.metodos(user)
              contenido_pendientes[user.id].each do |pendiente|
                ##
                # DZC 2019-08-16 19:54:56
                # se corrige y simplifica el código, agregando el registro de apertura del correo (bit
                # acusete) y que este se envíe via delayed_job
                email = (pendiente.persona.present? && pendiente.persona.email_institucional.present?) ? pendiente.persona.email_institucional : user.email
                asunto = Tarea.replace_values(metodos,tarea.recordatorio_tarea_asunto)
                cuerpo = Tarea.replace_values(metodos,tarea.recordatorio_tarea_cuerpo)                    
                rgc = RegistroAperturaCorreo.create(user_id: user.id, flujo_tarea_id: nil, fecha_envio_correo: DateTime.now, flujo_id: pendiente.flujo.id)
                FlujoMailer.delay.enviar(
                  asunto,
                  cuerpo,
                  email,
                  rgc.id
                )     
                # RecordatorioMailer.delay.enviar(email,asunto,cuerpo)  
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
      fecha_comparativa = informe_acuerdo.manifestacion_de_interes.firma_fecha

      anios_a_cierre = informe_acuerdo.plazo_vigencia_acuerdo
      #2 meses antes del cierre de proceso de acuerdo notifico a todos los del listado de actores
      if ((fecha_comparativa + anios_a_cierre.years) - hoy).to_i == 60
        manifestacion_de_interes = informe_acuerdo.manifestacion_de_interes
        destinatarios = MapaDeActor.where(flujo_id: manifestacion_de_interes.flujo.id).map{|ma| ma.persona.user.email}.uniq!
        AvisosMailer.cierre_proceso(destinatarios, manifestacion_de_interes).deliver_now!
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
          AvisosMailer.certificacion_vencimiento_inminente(destinatarios, auditoria).deliver_now!
        end
        #venció
        if (minuta_ceremonia.fecha_acta + auditoria.plazo.years + 1.day) == hoy
          AvisosMailer.certificacion_vencida(destinatarios, auditoria).deliver_now!
        end
      end
    end
  end


end
