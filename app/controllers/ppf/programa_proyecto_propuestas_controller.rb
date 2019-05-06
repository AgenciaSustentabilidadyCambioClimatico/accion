class Ppf::ProgramaProyectoPropuestasController < ApplicationController
	before_action :authenticate_user! #, unless: proc {  }
	before_action :set_tarea_pendiente, except: [:index,:create]
	before_action :set_flujo, except: [:index,:create]
	before_action :set_programa_proyecto_propuesta, except: [:index,:create]
	before_action :set_representantes, except: [:index,:create]
	before_action :set_tipo_instrumentos, except: [:index,:create,:asignar_revisor,:guardar_revisor]
	before_action :set_contribuyente, except: [:index,:destroy,:asignar_revisor,:guardar_revisor]
	before_action :set_revision_scope, only: [:revision,:guardar_revision]
	before_action :set_resolucion_scope, only: [:resolver_observaciones,:guardar_observaciones_resueltas]
	before_action :set_visitas_y_cargadores, only: [:asignar_usuarios_a_cargo_ejecucion_programa]

	def agenda #DZC NO DA ACCESO A TAREA PPF-013, ELLO OCURRE EN CONTROLADOR 'ppf_actividades_controller'
	end

	def guardar_agenda 
		respond_to do |format|
			if @programa_proyecto_propuesta.update(programa_proyecto_propuesta_agenda_params)
				success = 'Agenda del programa correctamente guardada'
				format.js { flash.now[:success] = success }
				format.html { redirect_to agenda_programa_ppf_tarea_pendiente_programa_proyecto_propuesta_url, notice: success }
			else
				format.js { }
				format.html { render :agenda }
			end
		end
	end

	def datos_ejecucion_presupuestaria_anual #DZC ACCESO A TAREA PPF-012
		@actecos_checked = @programa_proyecto_propuesta.checked_sectores_economicos
	end

	def guardar_datos_ejecucion_presupuestaria_anual #DZC TAREA PPF-012 TERMINO
		respond_to do |format|
			if @programa_proyecto_propuesta.update(programa_proyecto_propuesta_datos_ejecucion_presupuestaria_anual_params)
				success = 'Datos ejecución presupuestaria correctamente guardados'
				continua_flujo_segun_tipo_tarea
				format.js { 
					flash[:success] = success   
					render js: "window.location='#{root_url}'"
				}
				format.html { redirect_to root_path, notice: success }
			else
				format.js { }
				format.html { render :datos_ejecucion_presupuestaria_anual }
			end
		end
		@actecos_checked = @programa_proyecto_propuesta.checked_sectores_economicos
	end

	def asignar_usuarios_a_cargo_ejecucion_programa #DZC ACCESO A TAREA PPF-011
	end

	def guardar_usuarios_a_cargo_ejecucion_programa #DZC TAREA PPF-011 TERMINO
		respond_to do |format|
			
			if @programa_proyecto_propuesta.update(programa_proyecto_propuesta_asignar_usuarios_a_cargo_ejecucion_programa_params)
				success = 'Usuarios responsables de visitas y cargar datos productivos correctamente ingresados'
				
				mapa = MapaDeActor.find_or_create_by({
					flujo_id: @tarea_pendiente.flujo_id,
					rol_id: Rol::RESPONSABLE_ENTREGABLES,
					persona_id: @programa_proyecto_propuesta.usuario_visitas_id
				})
				mapa = MapaDeActor.find_or_create_by({
					flujo_id: @tarea_pendiente.flujo_id,
					rol_id: Rol::CARGADOR_DATOS_ACUERDO,
					persona_id: @programa_proyecto_propuesta.usuario_carga_datos_id
				})
				continua_flujo_segun_tipo_tarea
				format.js { 
					flash[:success] = success  
					render js: "window.location='#{root_url}'"
				}
				format.html { redirect_to root_path, notice: success }
			else
				set_visitas_y_cargadores
				format.js { }
				format.html { render :asignar_usuarios_a_cargo_ejecucion_programa }
			end
		end
	end

	def seguimiento_proyecto
	end

	def guardar_seguimiento_proyecto #DZC TAREA PPF-010 TERMINO
		respond_to do |format|
			
			if @programa_proyecto_propuesta.update(programa_proyecto_propuesta_seguimiento_proyecto_params)
				success = 'Seguimiento proyecto correctamente guardado'
				continua_flujo_segun_tipo_tarea
				format.js { 
					flash[:success] = success 
					render js: "window.location='#{root_url}'"
				}
				format.html { redirect_to root_path, notice: success }
			else
				format.js { }
				format.html { render :seguimiento_proyecto }
			end
		end
	end

	def datos_postulacion
	end

	def guardar_datos_postulacion #DZC TAREA PPF-009 TERMINO
		
		respond_to do |format|
			if @programa_proyecto_propuesta.update(programa_proyecto_propuesta_datos_postulacion_params)
				
				success = 'Datos postulación correctamente guardados'
				continua_flujo_segun_tipo_tarea
				format.js { flash[:success] = success   
					render js: "window.location='#{root_url}'"
				}
				format.html { redirect_to root_path, notice: success }
			else
				format.js { }
				format.html { render :datos_postulacion }
			end
		end
	end

	def observaciones_tecnicas
	end

	def guardar_observaciones_tecnicas #DZC TAREA PPF-008 TERMINO
		respond_to do |format|
			
			if @programa_proyecto_propuesta.update(programa_proyecto_propuesta_observaciones_tecnicas_params)
				success = 'Observaciones correctamente enviadas'
				continua_flujo_segun_tipo_tarea
				format.js { 
					flash[:success] = success  
					render js: "window.location='#{root_url}'"
				}
				format.html { redirect_to root_path, notice: success }
			else
				format.js { }
				format.html { render :observaciones_tecnicas }
			end
		end
	end

	def elaboracion_inicial_propuesta
		
	end

	def guardar_elaboracion_inicial_propuesta #DZC TAREA PPF-007 TERMINO (BOTON GUARDAR)
		respond_to do |format|
			@programa_proyecto_propuesta.temporal = true # DZC 2018-10-08 15:37:12 se corrige error por el cual se intentaba validar atributos que no corresponden a esta vista
			if @programa_proyecto_propuesta.update(programa_proyecto_propuesta_elaboracion_inicial_propuesta_params)
				success = 'Elaboración propuesta inicial correctamente enviada'
				continua_flujo_segun_tipo_tarea
				format.js { 
					flash[:success] = success 
					render js: "window.location='#{root_url}'"
				}
				format.html { redirect_to root_path, notice: success }
			else
				format.js { }
				format.html { render :elaboracion_inicial_propuesta }
			end
		end
	end

	def seguimiento_a_terceros
		@mantener_temporal = true 
	end

	def guardar_seguimiento_a_terceros #DZC TAREA PPF-006 TERMINO (BOTON GUARDAR)
		respond_to do |format|
			if @programa_proyecto_propuesta.update(programa_proyecto_propuesta_seguimiento_a_terceros_params)
				if programa_proyecto_propuesta_seguimiento_a_terceros_params[:temporal]=="false"  
					    
					success = 'Programa / Proyecto correctamente finalizado'
					continua_flujo_segun_tipo_tarea
					format.js { flash[:notice] = success 
						render js: "window.location='#{root_url}'"}
					format.html { redirect_to root_path, notice: success }
				else
					@mantener_temporal = true 
					success = 'Programa / Proyecto correctamente actualizada'
					format.js { flash.now[:success] = success }
					format.html { render :seguimiento_a_terceros }      
				end					
			else
				format.js { }
				format.html { render :seguimiento_a_terceros }
			end
		end
	end

	def finalizar #DZC TAREA PPF-006 TERMINO, PPF-010 TERMINO (BOTON FINALIZAR)

		respond_to do |format|
			# 
			if @programa_proyecto_propuesta.update(programa_proyecto_propuesta_finalizar_params)
				if programa_proyecto_propuesta_resolver_observaciones_params[:temporal]=="false" || programa_proyecto_propuesta_resolver_observaciones_params[:temporal].blank?      
					success = 'Programa / Proyecto correctamente finalizado'
					continua_flujo_segun_tipo_tarea 
					format.js { 
						flash[:success] = success
						render js: "window.location='#{root_url}'"
					}
					format.html { redirect_to root_url, notice: success }
				else
					@mantener_temporal = true 
					success = 'Programa / Proyecto correctamente actualizada'
					format.js {}
					format.html { render :seguimiento_a_terceros }      
				end				
			else
				format.js { }
				format.html { render :seguimiento_a_terceros }
			end
		end
	end

	def carta_de_apoyo
	end

	def subir_carta_de_apoyo #DZC TAREA PPF-005 TERMINO
		respond_to do |format|
			if @programa_proyecto_propuesta.update(programa_proyecto_propuesta_carta_de_apoyo_params)
				success = 'Carta de apoyo correctamente enviada'
				continua_flujo_segun_tipo_tarea
				format.js { flash[:notice] = success 
					render js: "window.location='#{root_path}'"
				 }
				format.html { redirect_to root_path, notice: success }
			else
				format.js { }
				format.html { render :carta_de_apoyo }
			end
		end
	end

	def resolver_observaciones
		@mantener_temporal = true #Se concidera que es temporal siempre, a excepcion de cuando se presiona el boton de enviar.-
		@recuerde_guardar_minutos = ManifestacionDeInteres::MINUTOS_MENSAJE_GUARDAR #DZC 2019-05-06 12:31:55 precave ocurrencia de situación reportada en requerimiento 2019-05-03
	end

	def guardar_observaciones_resueltas #DZC TAREA PPF-004 TERMINO
		respond_to do |format|
			#Este codigo se deberia optimizar, dado que se utiliza en apl -001
			instrumento_relacionado_params = params[:programa_proyecto_propuesta][:instrumento_relacionado].match(/^(?<type>\w+):(?<id>\d+)$/)
			@programa_proyecto_propuesta.assign_attributes(programa_proyecto_propuesta_resolver_observaciones_params)
			@programa_proyecto_propuesta.instrumento_relacionado_id         =   instrumento_relacionado_params.present? ? instrumento_relacionado_params[:id] : nil
			@programa_proyecto_propuesta.instrumento_relacionado_type       =  instrumento_relacionado_params.present? ? instrumento_relacionado_params[:type] : nil
			# 
			@programa_proyecto_propuesta.completar_informacion!
			if @programa_proyecto_propuesta.save
				if programa_proyecto_propuesta_resolver_observaciones_params[:temporal]=="false"      
					success = 'Resolución de observaciones propuesta correctamente enviada'
					continua_flujo_segun_tipo_tarea
					format.js { flash[:notice] = success
						render js: "window.location='#{root_path}'"
					 }
					format.html { redirect_to root_path, notice: success }
				else
					@mantener_temporal = true 
					success = 'Resolución de observaciones propuesta correctamente actualizada' 
					format.js { flash.now[:success] = success }
					format.html { render :resolver_observaciones }       
				end					
			else
				@recuerde_guardar_minutos = ManifestacionDeInteres::MINUTOS_MENSAJE_GUARDAR #DZC 2019-05-06 12:31:55 precave ocurrencia de situación reportada en requerimiento 2019-05-03
				format.js { }
				format.html { render :resolver_observaciones }
			end
		end
	end

	def revision
		@recuerde_guardar_minutos = ManifestacionDeInteres::MINUTOS_MENSAJE_GUARDAR #DZC 2019-05-06 12:31:55 corrige requerimiento 2019-05-03
	end

	def guardar_revision #DZC TAREA PPF-003 TERMINO
		respond_to do |format|
			if @programa_proyecto_propuesta.update(programa_proyecto_propuesta_revision_params)
				#En caso de seleecionar como representante a un usuario que no se encuentra dentro de la institucion cogestora, se debe agreagrar.-
				if @nuevo_usuario					
					usuario = User.find_by_id(@programa_proyecto_propuesta.representante_institucion_para_solicitud_id)
					contribuyente = @programa_proyecto_propuesta.institucion_que_solicita_apoyo_id
					persona = usuario.persona_segun_(contribuyente)
					if persona.present?
						persona.persona_cargos.create(cargo_id: Cargo::ENCARGADO_INS)
					else
						persona = Persona.create(user_id: usuario.id, contribuyente_id: contribuyente,email_institucional: @programa_proyecto_propuesta.email_representante_institucion_para_solicitud,telefono_institucional: @programa_proyecto_propuesta.telefono_representante_institucion_para_solicitud)
						persona.persona_cargos.create(cargo_id: Cargo::ENCARGADO_INS)
					end
				end
				success = 'Revisión propuesta correctamente enviada'			
				continua_flujo_segun_tipo_tarea
				format.js { 
					flash[:success] = success
					render js: "window.location='#{root_path}'"
				 }
				format.html { redirect_to root_path, notice: success }
			else
				@recuerde_guardar_minutos = ManifestacionDeInteres::MINUTOS_MENSAJE_GUARDAR #DZC 2019-05-06 12:31:55 corrige requerimiento 2019-05-03
				format.js { }
				format.html { render :revision }
			end
		end
	end

	def asignar_revisor
	end

	def guardar_revisor #DZC TAREA PPF-002 TERMINO
		respond_to do |format|
			if @programa_proyecto_propuesta.update(programa_proyecto_propuesta_asignar_revisor_params)
				success = 'Revisor Propuesta programa / proyecto correctamente asignado'
				mapa = MapaDeActor.find_or_create_by({
					flujo_id: @tarea_pendiente.flujo_id,
					rol_id: Rol::REVISOR_TECNICO,
					persona_id: @programa_proyecto_propuesta.revisor_id
				}) 
				continua_flujo_segun_tipo_tarea
				format.js { 
					flash[:success] = success
					render js: "window.location='#{root_path}'"
				 }
				format.html { redirect_to root_path, notice: success }
			else
				format.js { }
				format.html { render :asignar_revisor }
			end
		end
	end

	def create #DZC INICIO DE FLUJO PPF
		
		if @personas.blank?
			@flash_trio[:warning] = 'Este usuario no esta asociado a ninguna institución, por lo tanto no puede iniciar el proceso.'
		# elsif !current_user.is_proponente?
		# 	@flash_trio[:warning] = 'Este usuario no tiene cargo de Proponente, por lo tanto no puede iniciar el proceso.'
		else
			personas_proponentes = current_user.personas & Responsable.responsables_por_rol(Rol::PROPONENTE)
			if personas_proponentes.blank?
				@flash_trio[:warning] = 'Usted NO puede iniciar Programas o Proyectos de financiamiento, ya que no cumple con los requisitos para ser PROPONENTE.'
			else
				flujo = Flujo.new({
					contribuyente_id: personas_proponentes.first[:contribuyente_id],
					tipo_instrumento_id: TipoInstrumento::PROGRAMAS_Y_PROYECTOS_REGIONALES
				})
			end

			if !flujo.blank? && flujo.save 
				tarea_ppf = Tarea.find_by_codigo(Tarea::COD_PPF_001)
				tarea_ppp = flujo.tarea_pendientes.create([{ 
						tarea_id: tarea_ppf.id,
						estado_tarea_pendiente_id: EstadoTareaPendiente::NO_INICIADA,
						user_id: current_user.id,
						data: { }
					}]
				)
				@flash_trio[:success] = 'Flujo programa y programas finacimientos creado correctamente.'
				ppp = ProgramaProyectoPropuesta.new({
					proponente_id: current_user.id,
					proponente: current_user.nombre_completo#,
					#institucion_que_solicita_apoyo_id: @personas.first[:contribuyente_id]
				})
				current_user.contribuyente_ids.uniq.each do |contribuyente|
					# se consulta si el usuario proponente tiene alguna institucion, que posea el rol cogestor.-
					if Responsable.__instituciones_con_rol(Rol::COGESTOR, TipoInstrumento::PPP_EJECUTADOS_POR_TERCEROS, contribuyente)
						ppp.institucion_que_solicita_apoyo_id = contribuyente
						break
					end
				end
				ppp.current_user = current_user
				if ppp.save

					flujo.update({programa_proyecto_propuesta_id: ppp.id})
					mapa = MapaDeActor.find_or_create_by({
						flujo_id: flujo.id,
						rol_id: Rol::PROPONENTE,
						persona_id: current_user.personas.first.id
					})
					#Complata los cambios, pero para esto es necesario, tener el flujo.-
					# ppp.completar_informacion!
					# ppp.save
					@default_url = edit_ppf_tarea_pendiente_programa_proyecto_propuesta_url(tarea_ppp,ppp)
				else
					@flash_trio[:errors] = __list_errors(ppp)
				end
			end
		end

		respond_to do |format|
			format.html { redirect_to @default_url, flash: @flash_trio}
		end
	end

	def edit #DZC ACCESO A TAREA PPF-001
		@mantener_temporal = true #Se concidera que es temporal siempre, a excepcion de cuando se presiona el boton de enviar.-
		
		# DZC 2019-03-01 11:40:02 se setean las varibles relativas al mensaje "Recuerde gradar sus cambios"
		@recuerde_guardar_minutos = ProgramaProyectoPropuesta::MINUTOS_MENSAJE_GUARDAR		
	end

	def update #DZC TAREA PPF-001 TERMINO
		# 
		instrumento_relacionado_params = params[:programa_proyecto_propuesta][:instrumento_relacionado].match(/^(?<type>\w+):(?<id>\d+)$/)
		@programa_proyecto_propuesta.assign_attributes(programa_proyecto_propuesta_params)
		@programa_proyecto_propuesta.instrumento_relacionado_id         =   instrumento_relacionado_params.present? ? instrumento_relacionado_params[:id] : nil
		@programa_proyecto_propuesta.instrumento_relacionado_type       =  instrumento_relacionado_params.present? ? instrumento_relacionado_params[:type] : nil 	
		@programa_proyecto_propuesta.completar_informacion!
		set_representantes
		#@representantes = Persona.por_institucion_cargo(@programa_proyecto_propuesta.representante_institucion_para_solicitud_id, Cargo::ENCARGADO_INS)
		set_actividad_economicas
		respond_to do |format|
			if @programa_proyecto_propuesta.valid?
				@programa_proyecto_propuesta.save
				success = 'Propuesta programa / proyecto correctamente actualizada.'
				# DZC 2018-10-10 16:47:12 se modifica cambiando el contribuyente en el flujo en concordancia al que se seleccionó en la manifestación
        @tarea_pendiente.flujo.update(contribuyente_id: @programa_proyecto_propuesta.institucion_que_solicita_apoyo_id) if !@programa_proyecto_propuesta.institucion_que_solicita_apoyo_id.blank?
				if programa_proyecto_propuesta_params[:temporal]=="false"      
					continua_flujo_segun_tipo_tarea
					success = 'Propuesta programa / proyecto Enviado'
					flash[:notice] = success
					format.js { render js: "window.location='#{root_path}'" }
					format.html { redirect_to root_path, notice: success }
				else
					# DZC 2019-03-01 11:40:02 se setean las varibles relativas al mensaje "Recuerde gradar sus cambios"
    			@recuerde_guardar_minutos = ProgramaProyectoPropuesta::MINUTOS_MENSAJE_GUARDAR

					@mantener_temporal = programa_proyecto_propuesta_params[:temporal]    
					format.js { flash.now[:success] = success }
					format.html { redirect_to root_path, notice: success }       
				end				
			else
				@recuerde_guardar_minutos = ProgramaProyectoPropuesta::MINUTOS_MENSAJE_GUARDAR

				if @programa_proyecto_propuesta.temporal.blank?
					flash.now[:error] = "Antes de enviar la propuesta programa / proyecto debe completar todos los campos requeridos"
				end
				format.js { }
				format.html { render :edit }
			end
		end
	end

	#DZC método para continuar con el flujo según de que tipo de tarea se trate 
	def continua_flujo_segun_tipo_tarea
		
		case @tarea.codigo
		when Tarea::COD_PPF_001, Tarea::COD_PPF_002, Tarea::COD_PPF_004, Tarea::COD_PPF_005, Tarea::COD_PPF_007, Tarea::COD_PPF_011 
			
			@tarea_pendiente.pasar_a_siguiente_tarea 'A'
		when Tarea::COD_PPF_003
			case @programa_proyecto_propuesta.resultado_revision_texto
			when "Rechazado"
				@tarea_pendiente.pasar_a_siguiente_tarea 'A'
			when "Con observaciones"
				@tarea_pendiente.pasar_a_siguiente_tarea 'B'
			when "Aceptado"
				# DZC 2018-10-24 16:08:04 asigna el responsable_coordinacion_postulacion_y_seguimiento_id directamente al mapa de actores
				mapa = MapaDeActor.find_or_create_by({
					flujo_id: @tarea_pendiente.flujo_id,
					rol_id: Rol::COORDINADOR,
					persona_id: @programa_proyecto_propuesta.responsable_coordinacion_postulacion_y_seguimiento_id
				})
				if [3,18].include?(@programa_proyecto_propuesta.tipo_instrumento_id)
					mapa = MapaDeActor.find_or_create_by({
						flujo_id: @tarea_pendiente.flujo_id,
						rol_id: Rol::RESPONSABLE_ELABORACION_PROPUESTA,
						persona_id: @programa_proyecto_propuesta.responsable_elaboracion_propuesta_y_seguimiento_id
					})
					@tarea_pendiente.pasar_a_siguiente_tarea 'C'
				elsif @programa_proyecto_propuesta.tipo_instrumento_id = 2
					@tarea_pendiente.pasar_a_siguiente_tarea 'D'
				end
			end
		when Tarea::COD_PPF_006
			@tarea_pendiente.pasar_a_siguiente_tarea 'A'
		when Tarea::COD_PPF_008
			case @programa_proyecto_propuesta.resultado_observaciones_tecnicas_texto
			when "A postulación"
				@tarea_pendiente.pasar_a_siguiente_tarea 'A'
			when "Desechado"
				@tarea_pendiente.pasar_a_siguiente_tarea 'C'
			when "Con observaciones"
				@tarea_pendiente.pasar_a_siguiente_tarea 'B'
			end
		when Tarea::COD_PPF_009
			if @programa_proyecto_propuesta.resultado_postulacion_texto == "Rechazado"
				@tarea_pendiente.pasar_a_siguiente_tarea 'C'
			else
				unless @programa_proyecto_propuesta.responsable_coordinacion_ejecucion_seguimiento_id.blank?
					mapa = MapaDeActor.find_or_create_by({
						flujo_id: @tarea_pendiente.flujo_id,
						rol_id: Rol::COORDINADOR,
						persona_id: @programa_proyecto_propuesta.responsable_coordinacion_ejecucion_seguimiento_id
					})
				end
				@programa_proyecto_propuesta.update(monto_adjudicado: @programa_proyecto_propuesta.monto_aprobado)
				@tarea_pendiente.pasar_a_siguiente_tarea 'A'
				if [18].include?(@programa_proyecto_propuesta.tipo_instrumento_id)
					@tarea_pendiente.pasar_a_siguiente_tarea 'B'
				end
			end
		when Tarea::COD_PPF_010
			if @programa_proyecto_propuesta.finalizado
				@tarea_pendiente.pasar_a_siguiente_tarea 'B'
			end
		when Tarea::COD_PPF_012
			MapaDeActor.where(flujo_id: @tarea_pendiente.flujo_id).each do |a|
				MapaDeActor.find_or_create_by({
					flujo_id: a.flujo_id,
					rol_id: Rol::PARTE_INTERESADA_RELEVANTE,
					persona_id: a.persona_id
				})
			end
			@tarea_pendiente.pasar_a_siguiente_tarea 'A', {}, false
			if @programa_proyecto_propuesta.proyecto_con_atencion_directa_a_beneficiarios
				@tarea_pendiente.pasar_a_siguiente_tarea 'B', {primera_ejecucion: true}, false 
			end
		end

	end

	private
	def set_tarea_pendiente
		@tarea_pendiente = TareaPendiente.find(params[:tarea_pendiente_id])
		autorizado? @tarea_pendiente
		@tarea = @tarea_pendiente.tarea
		@descargables = @tarea_pendiente.get_descargables
	end

	def set_flujo
    @flujo = @tarea_pendiente.flujo
  end

	def set_programa_proyecto_propuesta
		@programa_proyecto_propuesta = ProgramaProyectoPropuesta.find(params[:id])
		@programa_proyecto_propuesta.current_user = current_user
		set_actividad_economicas
	end

	def set_tipo_instrumentos
		@tipo_instrumentos = TipoInstrumento.where(
			tipo_instrumento_id: TipoInstrumento::PROGRAMAS_Y_PROYECTOS_REGIONALES
		).all
	end

	def set_contribuyente
		@contribuyente    = Contribuyente.new
		# DZC 2018-10-10 16:42:42 se agrega contribuyente del proponente
    personas_proponentes = current_user.personas & Responsable.responsables_por_rol(Rol::PROPONENTE)
    @contribuyentes_del_proponente = Contribuyente.where(id: personas_proponentes.pluck(:contribuyente_id))
    #DZC 2018-10-10 16:44:00 TODO: revisar impacto y eliminar si corresponde
		@contribuyentes  = []
	end

	def set_actividad_economicas
		@actecos = []
		unless @programa_proyecto_propuesta.contribuyente.blank?
			@actecos = @programa_proyecto_propuesta.contribuyente.actividad_economica_contribuyentes.map{|m|m.actividad_economica}
		end
	end

	def set_revision_scope
		@url_main_form = guardar_revision_ppf_tarea_pendiente_programa_proyecto_propuesta_path(@tarea_pendiente,@programa_proyecto_propuesta)
		@revisando = true
	end

	def set_resolucion_scope
		@url_main_form = guardar_observaciones_resueltas_ppf_tarea_pendiente_programa_proyecto_propuesta_path(@tarea_pendiente,@programa_proyecto_propuesta)
		@resolviendo = true
	end


	def set_visitas_y_cargadores
		contribuyente_visita_id = params[:institucion_visita_id].present? ? params[:institucion_visita_id].to_i : nil
		contribuyente_carga_id = params[:institucion_carga_datos_id].present? ? params[:institucion_carga_datos_id].to_i : nil
		@visitas = @programa_proyecto_propuesta.usuarios_para_lista(Rol::RESPONSABLE_ENTREGABLES, contribuyente_visita_id)
		@programa_proyecto_propuesta.institucion_visitas_id = contribuyente_visita_id if !contribuyente_visita_id.blank?
		@cargadores = @programa_proyecto_propuesta.usuarios_para_lista(Rol::CARGADOR_DATOS_ACUERDO,contribuyente_carga_id)
		@programa_proyecto_propuesta.institucion_carga_datos_id = contribuyente_carga_id if !contribuyente_carga_id.blank?
	end

	def campos_form
		[
			:temporal, 
			:current_tab,
			#:proponente,

			:tipo_instrumento_id,
			#:proponente_id,
			#:descripcion,

			:institucion_que_solicita_apoyo_id,
			:rut_institucion_que_solicita_apoyo,
			:direccion_institucion_que_solicita_apoyo,
			:lugar_institucion_que_solicita_apoyo,
			:ubicacion_exacta_institucion_que_solicita_apoyo,
			:tipo_contribuyente_institucion_que_solicita_apoyo,
			:representante_institucion_para_solicitud_id,
			:nombre_representante_institucion_para_solicitud,
			:rut_representante_institucion_para_solicitud,
			:telefono_representante_institucion_para_solicitud,
			:email_representante_institucion_para_solicitud,

			:nombre_propuesta,
			:motivacion_y_objetivos,
			:equipo_de_trabajo_comprometido,
			:instituciones_participantes_propuesta,
			:monto_aproximado_a_solicitar,
			:fecha_aproximada_postulacion,
			:fecha_aproximada_decision,
			:motivos_relevantes_para_postular,
			:institucion_a_la_cual_se_presentara_la_propuesta_id,
			:sucursal_institucion_a_la_cual_se_presentara_la_propuesta_id,
			:nombre_del_fondo_al_cual_se_esta_postulando,
			:documento_con_programa_proyecto_existente,
			:documento_con_programa_proyecto_existente_cache,
			:programa_proyecto_propuesta_base_id
		]
	end

	def programa_proyecto_propuesta_params(campos=[])
		campos = campos.blank? ? campos_form : campos
		parameters = params.require(:programa_proyecto_propuesta).permit(*campos)
		parameters[:proponente]     = current_user.nombre_completo
		parameters[:proponente_id]  = current_user.id
		parameters[:monto_aproximado_a_solicitar] = parameters[:monto_aproximado_a_solicitar].gsub('.','') unless parameters[:monto_aproximado_a_solicitar].blank?
		parameters
	end

	def programa_proyecto_propuesta_asignar_revisor_params
		parameters = params.require(:programa_proyecto_propuesta).permit(
			:revisor_id,
			:comentario_al_asignar_revisor
		)
		parameters[:temporal] = true
		parameters[:forzar_validacion_en] = :asignar_revisor
		parameters 
	end

	def programa_proyecto_propuesta_revision_params
		parameters = params.require(:programa_proyecto_propuesta).permit(
			:current_tab,
			:resultado_de_la_revision,
			:actual_observaciones_y_comentarios_revision,
			:responsable_coordinacion_postulacion_y_seguimiento_id,
			:responsable_elaboracion_propuesta_y_seguimiento_id,
			secciones_observadas_revision: []
		)
		parameters[:forzar_validacion_en] = :revision
		parameters[:revisada] = true
		parameters[:resuelta] = false
		parameters
	end

	 def programa_proyecto_propuesta_resolver_observaciones_params
			campos = campos_form + [
				:actual_respuesta_proponente_revision,
				:documento_proponente_revision,
				:documento_proponente_revision_cache
			]
			parameters = programa_proyecto_propuesta_params(campos)
			parameters[:forzar_validacion_en] = :resolver_observaciones
			parameters[:resuelta] = true
			parameters[:revisada] = false
			parameters
	 end

	 def programa_proyecto_propuesta_seguimiento_a_terceros_params
			parameters = params.require(:programa_proyecto_propuesta).permit(
				:proyecto_adjudicado,
				:motivos_adjudicacion,
				:fecha_adjudicacion,
				:monto_adjudicado,
				:documento_proyecto,
				:documento_proyecto_cache,
				:fecha_inicio,
				:enlace_proyecto,
				:participacion_agencia,
				:instrumento_asociados_id,
				:productos_y_resultados,
				:documento_resultados,
				:documento_resultados_cache,
				:fecha_finalizacion,
				:temporal
			)
			parameters[:forzar_validacion_en] = :seguimiento_a_terceros
			parameters[:monto_adjudicado] = parameters[:monto_adjudicado].gsub('.','') unless parameters[:monto_adjudicado].blank?
			parameters
	 end

	 def programa_proyecto_propuesta_finalizar_params
			parameters = params.require(:programa_proyecto_propuesta).permit()
			parameters[:proyecto_adjudicado] = nil
			parameters[:motivos_adjudicacion] = nil
			parameters[:fecha_adjudicacion] = nil
			parameters[:monto_adjudicado] = nil
			parameters[:documento_proyecto] = nil
			parameters[:fecha_inicio] = nil
			parameters[:enlace_proyecto] = nil
			parameters[:participacion_agencia] = nil
			parameters[:instrumento_asociados_id] = nil
			parameters[:productos_y_resultados] = nil
			parameters[:documento_resultados] = nil

			parameters[:fecha_finalizacion] = Date.today
			parameters[:forzar_validacion_en] = :finalizar
			parameters[:finalizado] = true
			parameters
	 end

	 def programa_proyecto_propuesta_elaboracion_inicial_propuesta_params
			parameters = params.require(:programa_proyecto_propuesta).permit(
				:archivo_propuesta_elaboracion,
				:archivo_propuesta_elaboracion_cache
			)
			# parameters[:temporal] = true
			parameters[:forzar_validacion_en] = :elaboracion_inicial_propuesta # DZC 2018-10-08 15:36:27 permite forzar la validación al pasar la variable adecuada
			parameters
	 end

	 def programa_proyecto_propuesta_observaciones_tecnicas_params
			parameters = params.require(:programa_proyecto_propuesta).permit(
				:actual_comentarios_observaciones_tecnicas,
				:archivo_observaciones_tecnicas,
				:archivo_observaciones_tecnicas_cache,
				:fecha_observaciones_tecnicas,
				:resultado_observaciones_tecnicas,
			)
			parameters[:temporal] = true
			parameters[:forzar_validacion_en] = :observaciones_tecnicas
			parameters
	 end

	 def programa_proyecto_propuesta_datos_postulacion_params
			parameters = params.require(:programa_proyecto_propuesta).permit(
				:fecha_postulacion,
				:documento_recepcion_postulacion,
				:documento_recepcion_postulacion_cache,
				:resultado_postulacion,
				:fecha_entrega_resultados,
				:motivos_resultado,
				:monto_aprobado,
				:organismo_ejecutor_id,
				:responsable_coordinacion_ejecucion_seguimiento_id,
				:documentos_administrativos_aprobando_el_proyecto,
				:documentos_administrativos_aprobando_el_proyecto_cache,
				:fecha_inicio_legal_proyecto,
				:codigo_bip,
				:plazo_ejecucion_legal,
			)
			parameters[:temporal] = true
			parameters[:fecha_adjudicacion] = Date.today
			parameters[:forzar_validacion_en] = :datos_postulacion
			parameters[:monto_aprobado] = parameters[:monto_aprobado].gsub('.','') unless parameters[:monto_aprobado].blank?
			parameters
	 end

	 def programa_proyecto_propuesta_seguimiento_proyecto_params
			parameters = params.require(:programa_proyecto_propuesta).permit(
				:url_enlace,
				:participacion_agencia,
				:productos_y_resultados,
				:fecha_inicio_efectiva,
				:fecha_finalizacion_efectiva
			)
			parameters[:temporal] = true
			parameters[:forzar_validacion_en] = :seguimiento_proyecto
			parameters
	 end

	 def programa_proyecto_propuesta_asignar_usuarios_a_cargo_ejecucion_programa_params
			parameters = params.require(:programa_proyecto_propuesta).permit(
				:institucion_visitas_id,
				:usuario_visitas_id,
				:comentarios_visitas,
				:institucion_carga_datos_id,
				:usuario_carga_datos_id,
				:comentarios_carga_datos,
			)
			parameters[:temporal] = true
			parameters[:forzar_validacion_en] = :asignar_usuarios_a_cargo_ejecucion_programa
			parameters
	 end

	 def programa_proyecto_propuesta_datos_ejecucion_presupuestaria_anual_params
			parameters = params.require(:programa_proyecto_propuesta).permit(
				:proyecto_con_atencion_directa_a_beneficiarios,
				ejecucion_presupuestarias_attributes: [
					:id,
					:centro_de_costo_id,
					:año,
					:fecha_transferencia,
					:montos_transferidos,
					:montos_ejecutados,
					:_destroy
				],
				sectores_economicos:{},
			)
			parameters[:temporal] = true
			pepas = []
			if parameters[:ejecucion_presupuestarias_attributes].present?
				parameters[:ejecucion_presupuestarias_attributes].each do |i,pepa|
					pepa["montos_transferidos"] = pepa["montos_transferidos"].gsub('.','') unless pepa["montos_transferidos"].blank?
					pepa["montos_ejecutados"] = pepa["montos_ejecutados"].gsub('.','') unless pepa["montos_ejecutados"].blank?
					pepas << pepa
				end
			end
			parameters[:ejecucion_presupuestarias_attributes] = pepas
			parameters[:forzar_validacion_en] = :datos_ejecucion_presupuestaria_anual
			ap parameters
			parameters
	 end

	 def programa_proyecto_propuesta_agenda_params
			parameters = params.require(:programa_proyecto_propuesta).permit(
			)
			parameters[:temporal] = true
			parameters[:forzar_validacion_en] = :agenda
			parameters
	 end

	 #DZC parámetros para PPF-005
		def programa_proyecto_propuesta_carta_de_apoyo_params
			parameters = params.require(:programa_proyecto_propuesta).permit(
				:carta_de_apoyo_coordinador,
				:carta_de_apoyo_coordinador_cache
			)
			# parameters[:forzar_validacion_en] = :carta_de_apoyo
			parameters
		end 
	def set_representantes
		usuario = User.find_by_id(@programa_proyecto_propuesta.representante_institucion_para_solicitud_id)
		resultado = Persona.por_institucion_cargo(@programa_proyecto_propuesta.institucion_que_solicita_apoyo_id, Cargo::ENCARGADO_INS, usuario, true)
		@representantes = resultado[0]
		@nuevo_usuario = resultado[1]
	end  

end
