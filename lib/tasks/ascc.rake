namespace :ascc do

	desc ""
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
								persona = user.persona_segun_(pendiente.flujo.contribuyente_id)
								email = persona.email_institucional
								asunto = Tarea.replace_values(metodos,tarea.recordatorio_tarea_asunto)
								cuerpo = Tarea.replace_values(metodos,tarea.recordatorio_tarea_cuerpo)
	         			RecordatorioMailer.enviar(email,asunto,cuerpo).deliver
	         		end
						end
					end
				end
			end
		rescue ActiveRecord::RecordNotFound => record_not_found
			puts record_not_found
		end
		ap "----------------------------------------------------------------------------"
		ap ""
		ap ""
		ap ""
		ap ""
	end

	desc "Carga de proyectos desde db remota"
	task :carga_proyectos_remoto => :environment do |task, args|
		ExternalFpl.actualizar_proyectos()
	end

	desc "Actualiza la tabla proyectos"
	task :obtener_proyectos => :environment do |task, args|
		# La data no se sabe si se pide o recibe
		username			= 'username'
		password			= 'password'
		authorization	= "http://localhost/authorization.php"
		http_body			=	HTTParty.post(authorization, basic_auth: { username: username, password: password } ).body
		parsed_body		= JSON.parse(http_body)
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
  desc "Agrega la rake task ':limpia_cache_carrierwave' a crontab"
  task :agrega_limpia_cache_carrierwave_a_crontab do |task, args|
    __crontab_old = "#{Rails.root}/tmp/__#{Time.now.to_i}_tareas_crontab_old"
    %x{crontab -l > #{__crontab_old}}
    comando = "/bin/bash -l -c 'cd #{Rails.root} && RAILS_ENV=#{Rails.env.production? ? :production : :development} bundle exec rails ascc:limpia_cache_carrierwave --silent'"
    %x{echo "#{'0 3 * * *'} #{comando}" >> #{__crontab_old} }
    %x{crontab #{__crontab_old}}
    %x{rm #{__crontab_old}}
  end

  desc "Agrega los recordatorios de tareas al crontab"
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


end
