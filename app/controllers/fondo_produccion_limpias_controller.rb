class FondoProduccionLimpiasController < ApplicationController
    include ApplicationHelper
    before_action :authenticate_user!, unless: proc { action_name == 'google_map_kml' }
    before_action :set_tarea_pendiente, except: [:iniciar_flujo, :lista_usuarios_entregables, :get_sub_lineas_seleccionadas, :guardar_duracion, :buscador, :update_modal, 
    :insert_modal, :insert_modal_contribuyente, :insert_plan_actividades,
    :new_plan_actividades, :eliminar_objetivo_especifico, :update_objetivo_especifico, :guardar_fondo_temporal, :subir_documento, :get_revisor, :descargar_pdf, :insert_registro_proveedores_equipo,
    :descargar_admisibilidad_juridica_pdf]
    before_action :set_flujo, except: [:iniciar_flujo, :lista_usuarios_entregables, :get_sub_lineas_seleccionadas, :guardar_duracion, :buscador, :update_modal, 
    :insert_modal, :insert_modal_contribuyente, :insert_plan_actividades,
    :new_plan_actividades, :eliminar_objetivo_especifico, :update_objetivo_especifico, :guardar_fondo_temporal, :subir_documento, :get_revisor, :descargar_pdf, :insert_registro_proveedores_equipo,
    :descargar_admisibilidad_juridica_pdf]
    before_action :set_fondo_produccion_limpia, only: [:edit, :update, :revisor, :get_sub_lineas_seleccionadas, :admisibilidad, :admisibilidad_tecnica, 
    :admisibilidad_juridica, :pertinencia_factibilidad, :observaciones_admisibilidad, :observaciones_admisibilidad_tecnica, :observaciones_admisibilidad_juridica,
    :evaluacion_general, :guardar_duracion, :buscador, :usuario_entregables, :guardar_usuario_entregables, :guardar_fondo_temporal, :asignar_revisor, 
    :revisar_admisibilidad_tecnica, :revisar_admisibilidad, :revisar_admisibilidad_juridica, :revisar_pertinencia_factibilidad, :subir_documento, :get_revisor, 
    :resolucion_contrato, :adjuntar_resolucion_contrato, :insert_recursos_humanos_propios, :insert_recursos_humanos_externos, :insert_gastos_operacion, :eliminar_gasto_operacion,
    :insert_gastos_administracion, :eliminar_gasto_administracion, :eliminar_recursos_humanos]
    before_action :set_lineas, only: [:edit, :update, :revisor]
    before_action :set_sub_lineas, only: [:edit, :update, :revisor] 
    before_action :set_manifestacion_de_interes, only: [:edit, :update, :destroy, :descargable,
      :revisor, :asignar_revisor, :admisibilidad, :revisar_admisibilidad, :admisibilidad_tecnica,
                                        :admisibilidad_juridica, :revisar_admisibilidad_tecnica, :revisar_admisibilidad_juridica,
                                        :observaciones_admisibilidad, :resolver_observaciones_admisibilidad,
                                        :observaciones_admisibilidad_juridica, :resolver_observaciones_admisibilidad_juridica,
                                        :observaciones_admisibilidad_tecnica, :evaluacion_general,
                                        :pertinencia_factibilidad, :revisar_pertinencia_factibilidad,
                                        :responder_pertinencia_factibilidad, :responder_cond_obs_pertinencia_factibilidad,
                                        :usuario_entregables, :guardar_usuario_entregables,
                                        :firma, :actualizar_firma,
                                        :carga_auditoria, :enviar_carga_auditoria,:cargar_actualizar_entregable_diagnostico,
                                        :revisar_entregable_diagnostico,
                                        :evaluacion_negociacion, :actualizar_acuerdos_actores,:actualizar_comite_acuerdos,
                                        :eliminar_contribuyente_temporal, :observaciones_informe, :responder_observaciones_informe, :descargar_compilado, 
                                        :guardar_fondo_temporal]
    before_action :set_representantes, only: [:edit, :update, :destroy, :descargable,
      :revisor, :asignar_revisor, :admisibilidad, :revisar_admisibilidad, :admisibilidad_tecnica,
                                        :admisibilidad_juridica, :revisar_admisibilidad_tecnica, :revisar_admisibilidad_juridica,
                                        :observaciones_admisibilidad, :resolver_observaciones_admisibilidad,
                                        :observaciones_admisibilidad_juridica, :resolver_observaciones_admisibilidad_juridica,
                                        :observaciones_admisibilidad_tecnica, :evaluacion_general,
                                        :pertinencia_factibilidad, :revisar_pertinencia_factibilidad,
                                        :responder_pertinencia_factibilidad, :responder_cond_obs_pertinencia_factibilidad,
                                        :guardar_usuario_entregables,
                                        :firma, :actualizar_firma,
                                        :carga_auditoria, :enviar_carga_auditoria,:cargar_actualizar_entregable_diagnostico,
                                        :revisar_entregable_diagnostico,
                                        :evaluacion_negociacion, :actualizar_acuerdos_actores,:actualizar_comite_acuerdos]
    before_action :set_contribuyentes, only: [:edit,:update,
                                        :revisor, :asignar_revisor,
                                        :admisibilidad, :revisar_admisibilidad, :admisibilidad_tecnica,
                                        :admisibilidad_juridica, :revisar_admisibilidad_tecnica, :revisar_admisibilidad_juridica,
                                        :observaciones_admisibilidad, :resolver_observaciones_admisibilidad,
                                        :observaciones_admisibilidad_juridica, :resolver_observaciones_admisibilidad_juridica,
                                        :observaciones_admisibilidad_tecnica, :evaluacion_general,
                                        :pertinencia_factibilidad, :revisar_pertinencia_factibilidad,
                                        :responder_pertinencia_factibilidad, :responder_cond_obs_pertinencia_factibilidad,
                                        :usuario_entregables, :guardar_usuario_entregables,
                                        :firma, :actualizar_firma,
                                        :carga_auditoria, :enviar_carga_auditoria]
    before_action :set_tipo_instrumentos, only: [:edit,:update,
                                        :revisor, :asignar_revisor,
                                        :admisibilidad, :revisar_admisibilidad, :admisibilidad_tecnica,
                                        :admisibilidad_juridica, :revisar_admisibilidad_tecnica, :revisar_admisibilidad_juridica,
                                        :observaciones_admisibilidad, :resolver_observaciones_admisibilidad,
                                        :observaciones_admisibilidad_tecnica, :evaluacion_general,
                                        :observaciones_admisibilidad_juridica, :resolver_observaciones_admisibilidad_juridica,
                                        :pertinencia_factibilidad, :revisar_pertinencia_factibilidad,
                                        :responder_pertinencia_factibilidad, :responder_cond_obs_pertinencia_factibilidad,
                                        :usuario_entregables, :guardar_usuario_entregables,
                                        :firma, :actualizar_firma,
                                        :carga_auditoria, :enviar_carga_auditoria]

    before_action :set_informe, only: [:evaluacion_negociacion, :observaciones_informe, :actualizar_acuerdos_actores, :responder_observaciones_informe]
    before_action :set_comentario_informe, only: [:evaluacion_negociacion, :observaciones_informe]
  
  
    before_action :set_objetivos_especificos, only: [:edit, :revisor, :admisibilidad, :admisibilidad_tecnica, 
    :admisibilidad_juridica, :pertinencia_factibilidad, :observaciones_admisibilidad, :observaciones_admisibilidad_tecnica, :observaciones_admisibilidad_juridica,
    :evaluacion_general, :get_valida_campos_nulos]

    before_action :set_registro_proveedores, only: [:edit, :revisor, :admisibilidad, :admisibilidad_tecnica, 
    :admisibilidad_juridica, :pertinencia_factibilidad, :observaciones_admisibilidad, :observaciones_admisibilidad_tecnica, :observaciones_admisibilidad_juridica,
    :evaluacion_general, :get_valida_campos_nulos]

    before_action :set_descargables, only: [:edit,  :revisor, :admisibilidad, :admisibilidad_tecnica, 
    :admisibilidad_juridica, :pertinencia_factibilidad, :observaciones_admisibilidad, :observaciones_admisibilidad_tecnica, :observaciones_admisibilidad_juridica,
    :evaluacion_general, :get_valida_campos_nulos]
  
    before_action :set_regiones, only: [:edit,  :revisor, :admisibilidad, :admisibilidad_tecnica, 
    :admisibilidad_juridica, :pertinencia_factibilidad, :observaciones_admisibilidad, :observaciones_admisibilidad_tecnica, :observaciones_admisibilidad_juridica,
    :evaluacion_general]

    before_action :set_tipo_instrumento_valores
  
    def initialize
      super
      @solo_lectura = false # Asigna el valor predeterminado que desees
    end

    def iniciar_flujo #TAREA FPL-01 al iniciar proceso
      @fondo_produccion_limpia = FondoProduccionLimpia.where(flujo_id: @tarea_pendiente.flujo_id)
    end

    # Graba las postulaciones de las distintas fases del FPL
    def grabar_postulacion
      informe_acuerdo = params[:informe_acuerdo]
      fondo_produccion_limpia = informe_acuerdo[:fondo_produccion_limpia] == "true"
      fondo_produccion_limpia_l13 = informe_acuerdo[:fondo_produccion_limpia_l13] == "true"
   
      if fondo_produccion_limpia || fondo_produccion_limpia_l13
        tarea_pendiente = TareaPendiente.find(params[:id])
        flujo_apl = Flujo.find(tarea_pendiente.flujo_id)
        @manifestacion_de_interes = ManifestacionDeInteres.find(flujo_apl.manifestacion_de_interes_id)

        #obtengo el user_id del postulante de la manifestacion de interes
        tarea_fondo = Tarea.find_by_codigo(Tarea::COD_APL_001)
        postulante = TareaPendiente.find_by(tarea_id: tarea_fondo.id, flujo_id: flujo_apl)

        tipo_instrumento_id = fondo_produccion_limpia ? informe_acuerdo[:tipo_linea_seleccionada] : informe_acuerdo[:tipo_linea_seleccionada_l13]
        flujo = Flujo.new(contribuyente_id: @manifestacion_de_interes.contribuyente_id, tipo_instrumento_id: tipo_instrumento_id)

        if flujo.save
          tarea_fondo = Tarea.find_by_codigo(Tarea::COD_FPL_00)
          flujo.tarea_pendientes.create(
            tarea_id: tarea_fondo.id,
            estado_tarea_pendiente_id: EstadoTareaPendiente::NO_INICIADA,
            user_id: postulante.user_id,
            data: {}
          )

          send_message(tarea_fondo, postulante.user_id)

          codigo_proyecto = determine_codigo_proyecto(flujo.tipo_instrumento_id)

          fpl = FondoProduccionLimpia.create(
            flujo_id: flujo.id,
            flujo_apl_id: tarea_pendiente.flujo_id,
            codigo_proyecto: codigo_proyecto
          )

          flujo.update(fondo_produccion_limpia_id: fpl.id)

          msj = 'Flujo fondo de producción limpia creado correctamente.'
          respond_to do |format|
            format.js { flash.now[:success] = msj; render js: "window.location='#{root_path}'" }
            format.html { redirect_to root_path, flash: { notice: msj } }
          end
        end
      else
        msj = 'Usted NO puede iniciar Flujo FPL.'
        respond_to do |format|
          format.js { flash.now[:error] = msj; render js: "window.location='#{root_path}'" }
          format.html { redirect_to root_path, flash: { notice: msj } }
        end
      end
    end

    def get_valida_campos_nulos
      # Obtener el fondo_produccion_limpia
      @fondo_produccion_limpia = FondoProduccionLimpia.find_by(flujo_id: params[:flujo_id])

      set_equipo_trabajo
      set_actividades_x_linea
      set_costos
      
      @total_de_errores_por_tab = {}
   
      # Crear un arreglo para almacenar los campos nulos y los campos completos
      campos_completos = []
      campos_nulos = []

      propuesta_tecnica = []
      equipo_trabajo = []
      plan_de_actividades = []
      documentacion_legal = []
      costos = []

      #Campos Propuesta Tecnica

      propuesta_tecnica << @objetivos.count if @objetivos.count == 0
      # Verificar si los campos están nulos y agregarlos a los arreglos correspondientes
      campos_completos << :cantidad_micro_empresa if @fondo_produccion_limpia.cantidad_micro_empresa.present?
      campos_nulos << :cantidad_micro_empresa if @fondo_produccion_limpia.cantidad_micro_empresa.nil?
      propuesta_tecnica << :cantidad_micro_empresa if @fondo_produccion_limpia.cantidad_micro_empresa.nil?

      campos_completos << :cantidad_pequeña_empresa if @fondo_produccion_limpia.cantidad_pequeña_empresa.present?
      campos_nulos << :cantidad_pequeña_empresa if @fondo_produccion_limpia.cantidad_pequeña_empresa.nil?
      propuesta_tecnica << :cantidad_pequeña_empresa if @fondo_produccion_limpia.cantidad_pequeña_empresa.nil?

      campos_completos << :cantidad_mediana_empresa if @fondo_produccion_limpia.cantidad_mediana_empresa.present?
      campos_nulos << :cantidad_mediana_empresa if @fondo_produccion_limpia.cantidad_mediana_empresa.nil?
      propuesta_tecnica << :cantidad_mediana_empresa if @fondo_produccion_limpia.cantidad_mediana_empresa.nil?

      campos_completos << :cantidad_grande_empresa if @fondo_produccion_limpia.cantidad_grande_empresa.present?
      campos_nulos << :cantidad_grande_empresa if @fondo_produccion_limpia.cantidad_grande_empresa.nil?
      propuesta_tecnica << :cantidad_grande_empresa if @fondo_produccion_limpia.cantidad_grande_empresa.nil?

      if @flujo.tipo_instrumento_id == TipoInstrumento::FPL_LINEA_1_1 || @flujo.tipo_instrumento_id == TipoInstrumento::FPL_LINEA_5_1 || @flujo.tipo_instrumento_id == TipoInstrumento::FPL_EXTRAPRESUPUESTARIO_DIAGNOSTICO 
        
        comuna_flujo = ComunasFlujo.where(flujo_id: @tarea_pendiente.flujo_id).count
        if comuna_flujo == 0
          campos_nulos << "manifestacion_de_interes_comunas_ids".to_sym
          propuesta_tecnica << "manifestacion_de_interes_comunas_ids".to_sym
        else
          campos_completos << "manifestacion_de_interes_comunas_ids".to_sym
        end

        campos_completos << :empresas_asociadas_ag if @fondo_produccion_limpia.empresas_asociadas_ag.present?
        campos_nulos << :empresas_asociadas_ag if @fondo_produccion_limpia.empresas_asociadas_ag.nil?
        propuesta_tecnica << :empresas_asociadas_ag if @fondo_produccion_limpia.empresas_asociadas_ag.nil?

        campos_completos << :empresas_no_asociadas_ag if @fondo_produccion_limpia.empresas_no_asociadas_ag.present?
        campos_nulos << :empresas_no_asociadas_ag if @fondo_produccion_limpia.empresas_no_asociadas_ag.nil?
        propuesta_tecnica << :empresas_no_asociadas_ag if @fondo_produccion_limpia.empresas_no_asociadas_ag.nil?

      else   

        campos_completos << :elementos_micro_empresa if @fondo_produccion_limpia.elementos_micro_empresa.present?
        propuesta_tecnica << :elementos_micro_empresa if @fondo_produccion_limpia.elementos_micro_empresa.nil?
        campos_nulos << :elementos_micro_empresa if @fondo_produccion_limpia.elementos_micro_empresa.nil?

        campos_completos << :elementos_pequena_empresa if @fondo_produccion_limpia.elementos_pequena_empresa.present?
        campos_nulos << :elementos_pequena_empresa if @fondo_produccion_limpia.elementos_pequena_empresa.nil?
        propuesta_tecnica << :elementos_pequena_empresa if @fondo_produccion_limpia.elementos_pequena_empresa.nil?

        campos_completos << :elementos_mediana_empresa if @fondo_produccion_limpia.elementos_mediana_empresa.present?
        campos_nulos << :elementos_mediana_empresa if @fondo_produccion_limpia.elementos_mediana_empresa.nil?
        propuesta_tecnica << :elementos_mediana_empresa if @fondo_produccion_limpia.elementos_mediana_empresa.nil?

        campos_completos << :elementos_grande_empresa if @fondo_produccion_limpia.elementos_grande_empresa.present?
        campos_nulos << :elementos_grande_empresa if @fondo_produccion_limpia.elementos_grande_empresa.nil?
        propuesta_tecnica << :elementos_grande_empresa if @fondo_produccion_limpia.elementos_grande_empresa.nil?
        
      end
      
      campos_completos << :duracion if @fondo_produccion_limpia.duracion.present?
      campos_nulos << :duracion if @fondo_produccion_limpia.duracion.nil?
      propuesta_tecnica << :duracion if @fondo_produccion_limpia.duracion.nil?

      @total_de_errores_por_tab[:"propuesta-tecnica"] = propuesta_tecnica.count if propuesta_tecnica.count != 0

      #Campos Equipo Trabajo

      equipo_trabajo << @user_equipo.count if @user_equipo.count == 0

      equipo_trabajo << @postulantes.count if @postulantes.count == 0

      if @flujo.tipo_instrumento_id == TipoInstrumento::FPL_LINEA_1_3 || @flujo.tipo_instrumento_id == TipoInstrumento::FPL_EXTRAPRESUPUESTARIO_EVALUACION 
        equipo_trabajo << @auditores.count if @auditores.count == 0
      end

      if @count_empresa_equipo == 0 && @user_equipo.count == 0
        equipo_trabajo << 1
      end   
  
      campos_completos << :fortalezas_consultores if @fondo_produccion_limpia.fortalezas_consultores.present?
      campos_nulos << :fortalezas_consultores if (@fondo_produccion_limpia.fortalezas_consultores == "" || @fondo_produccion_limpia.fortalezas_consultores.nil?)
      equipo_trabajo << :fortalezas_consultores if (@fondo_produccion_limpia.fortalezas_consultores == "" || @fondo_produccion_limpia.fortalezas_consultores.nil?)

      @total_de_errores_por_tab[:"equipo-trabajo"] = equipo_trabajo.count if equipo_trabajo.count != 0

      #Campos Plan de Actividades
      @count_plan_actividades = PlanActividad.where(flujo_id: @tarea_pendiente.flujo_id).count  
      
      #consulta si el numero de plan es igual al numero de actividades
      plan_de_actividades = nil
      if @count_plan_actividades != @actividad_x_linea.length
        plan_de_actividades = @actividad_x_linea.length - @count_plan_actividades
        @total_de_errores_por_tab[:"plan-de-actividades"] = plan_de_actividades
      end 

      #Campos Documentación

      # Verificar si los campos están nulos y agregarlos al arreglo
      @descargables_postulante.each do |descargable|
        campo = descargable.nombre_campo.to_sym
        documentacion_legal << campo if @fondo_produccion_limpia.public_send(campo).blank?
        campos_nulos << campo if @fondo_produccion_limpia.public_send(campo).blank?
        campos_completos << campo if @fondo_produccion_limpia.public_send(campo).present?
      end

      @descargables_receptor.each do |descargable|
        campo = descargable.nombre_campo.to_sym
        documentacion_legal << campo if @fondo_produccion_limpia.public_send(campo).blank?
        campos_nulos << campo if @fondo_produccion_limpia.public_send(campo).blank?
        campos_completos << campo if @fondo_produccion_limpia.public_send(campo).present? 
      end

      @descargables_ejecutor.each do |descargable|
        campo = descargable.nombre_campo.to_sym
        documentacion_legal << campo if @fondo_produccion_limpia.public_send(campo).blank?
        campos_nulos << campo if @fondo_produccion_limpia.public_send(campo).blank?
        campos_completos << campo if @fondo_produccion_limpia.public_send(campo).present?
      end

      @total_de_errores_por_tab[:"documentacion-legal"] = documentacion_legal.count if documentacion_legal.count != 0

      @tipo = params['tipo']

      #Costos
      #@total_de_errores_por_tab[:"costos"] = 1 if @response_costos == 1
      
      if @total_de_errores_por_tab == {} && @response_costos == 0
        respond_to do |format|
          format.js { render js: "window.location='#{enviar_postulacion_fondo_produccion_limpia_path(@tarea_pendiente.id)}'" }
        end
      else
        respond_to do |format|
          if (@response_costos == 1 && @total_de_errores_por_tab == {})
            flash[:error] = @mensaje
            format.js { render js: "window.location='#{edit_fondo_produccion_limpia_path(@tarea_pendiente.id)}?total_de_errores_por_tab=#{@total_de_errores_por_tab}&tabs=costos'" }
          else
            flash[:error] = 'Antes de enviar la postulación debe completar todos los campos requeridos'
            format.js { render js: "window.location='#{edit_fondo_produccion_limpia_path(@tarea_pendiente.id)}?total_de_errores_por_tab=#{@total_de_errores_por_tab}'" }
          end

          #format.js { render js: "window.location='#{edit_fondo_produccion_limpia_path(@tarea_pendiente.id)}?total_de_errores_por_tab=#{@total_de_errores_por_tab}'" }
          format.html { redirect_to edit_fondo_produccion_limpia_path(@tarea_pendiente.id), notice: success }
        end
      end
    end
    
    def usuario_entregables #FPL-00
      tipo_instrumento = TipoInstrumento::FONDO_DE_PRODUCCION_LIMPIA

      #postulante
      rol_tarea = Tarea::find_by(codigo: Tarea::COD_FPL_00).rol_id
      responsables = Responsable.__personas_responsables(rol_tarea, tipo_instrumento)
      contribuyentes_ids = responsables.map{|p| p.contribuyente_id }.uniq
      @contribuyentes = Contribuyente.where(id: contribuyentes_ids)

      #entregables
      rol_tarea2 = Tarea::find_by(codigo: Tarea::COD_FPL_015).rol_id
      responsables2 = Responsable.__personas_responsables(rol_tarea2, tipo_instrumento)
      contribuyentes_ids_2 = responsables2.map{|p| p.contribuyente_id }.uniq
      @contribuyentes_entregables = Contribuyente.where(id: contribuyentes_ids_2)
    end

    def lista_usuarios_entregables
      tipo_instrumento = TipoInstrumento::FONDO_DE_PRODUCCION_LIMPIA 
      rol_tarea = Tarea::find_by(codigo: Tarea::COD_FPL_00).rol_id
      personas_responsables = Responsable::__personas_responsables_v2(rol_tarea, tipo_instrumento, params[:contribuyente_id])
      @usuarios = personas_responsables.map { |e| e.user  }
    end

    def guardar_usuario_entregables #FPL-00
      respond_to do |format|
        #SE CREA FPL-01
        institucion_postulante = ""
        postulante = ""
        institucion_receptora = ""
 
        contribuyente = Contribuyente.unscoped.find(@manifestacion_de_interes.contribuyente_id)
         
        if params[:manifestacion_de_interes][:nombre_acuerdo] == "opcion_1"
          institucion_postulante =  contribuyente.id
          postulante = @tarea_pendiente.user_id
        else
          institucion_postulante = params[:manifestacion_de_interes][:institucion_entregables_id]
          postulante = params[:manifestacion_de_interes][:usuario_entregables_id]
        end  
 
        if params[:manifestacion_de_interes][:proponente] == ""
          institucion_receptora = contribuyente.id
        else
          institucion_receptora = params[:manifestacion_de_interes][:proponente]
        end  
        tarea_fondo = Tarea.find_by_codigo(Tarea::COD_FPL_01)
        pers = Persona.where(user_id: postulante).first
        
        custom_params_tarea_pendiente = {
          tarea_pendientes: {
            flujo_id: @flujo.id,
            tarea_id: tarea_fondo.id,
            estado_tarea_pendiente_id: EstadoTareaPendiente::NO_INICIADA,
            user_id:  postulante,
            persona_id: pers.id,
            data: { }
          }
        }

        @tarea_pendientes = TareaPendiente.new(custom_params_tarea_pendiente[:tarea_pendientes])
        @tarea_pendientes.save 
        
        #Se inserta en el mapa de actores al nuevo postulante
        mapa = MapaDeActor.find_or_create_by({
          flujo_id: @flujo.id,
          rol_id: Rol::PROPONENTE, 
          persona_id: pers.id
        })

        #SE ENVIAR EL MAIL AL RESPONSABLE
        mdi = @manifestacion_de_interes
        send_message(tarea_fondo, postulante)

        #SE CAMBIA EL ESTADO DEL FPL-00 A 2
        tarea_fondo_FPL_00 = Tarea.find_by_codigo(Tarea::COD_FPL_00)
        tarea_pendiente_FPL_00 = TareaPendiente.find_by(tarea_id: tarea_fondo_FPL_00.id, flujo_id: @flujo.id)

        tarea_pendiente_FPL_00.estado_tarea_pendiente_id = EstadoTareaPendiente::ENVIADA
        tarea_pendiente_FPL_00.save 
        
        #Se asigna duracion en meses segun tipo de instrumento
        if @flujo.tipo_instrumento_id == TipoInstrumento::FPL_LINEA_1_1 || @flujo.tipo_instrumento_id == TipoInstrumento::FPL_LINEA_5_1 
          meses = FondoProduccionLimpia::DURACION_FPL_LINEA_1_1
        elsif @flujo.tipo_instrumento_id == TipoInstrumento::FPL_LINEA_1_2_1 || @flujo.tipo_instrumento_id == TipoInstrumento::FPL_LINEA_1_2_2 
          meses = FondoProduccionLimpia::DURACION_FPL_LINEA_1_2
        elsif @flujo.tipo_instrumento_id == TipoInstrumento::FPL_LINEA_1_3
          meses = FondoProduccionLimpia::DURACION_FPL_LINEA_1_3
        elsif @flujo.tipo_instrumento_id == TipoInstrumento::FPL_EXTRAPRESUPUESTARIO_DIAGNOSTICO || @flujo.tipo_instrumento_id == TipoInstrumento::FPL_EXTRAPRESUPUESTARIO_SEGUIMIENTO || @flujo.tipo_instrumento_id == TipoInstrumento::FPL_EXTRAPRESUPUESTARIO_SEGUIMIENTO_2 || @flujo.tipo_instrumento_id == TipoInstrumento::FPL_EXTRAPRESUPUESTARIO_EVALUACION
          meses = FondoProduccionLimpia::DURACION_FPL_EXTRAPRESUPUESTARIO
        else
          meses = FondoProduccionLimpia::DURACION_FPL_LINEA_1_1
        end

        custom_params = {
          fondo_produccion_limpia: {
            institucion_entregables_id: institucion_postulante,
            usuario_entregables_id: postulante,
            institucion_receptor_cof_fpl_id: institucion_receptora,
            duracion: meses
          }
        }
        @fondo_produccion_limpia.update(custom_params[:fondo_produccion_limpia])

        msj = 'Asignacion postulante y encargado de financiamiento guardado correctamente'
        format.js { flash.now[:success] = msj
          render js: "window.location='#{root_path}'"}
        format.html { redirect_to root_path, flash: {notice: msj }}
      end
    end

    def guardar_duracion
      @duracion = params[:duracion]
      @fondo_produccion_limpia.update(duracion:@duracion)
      success = "La duración se ha actualizado exitosamente."
      error = "Hubo un error al actualizar la duración."
      link = edit_fondo_produccion_limpia_path(params[:id])

      respond_to do |format|
        format.js { render js: "window.location='#{edit_fondo_produccion_limpia_path(params[:id])}?tabs=propuesta-tecnica'" }
        format.html { redirect_to link, flash: { success: success, error: error }; return }
      end
    end
  
    def destroy
      @fondo_produccion_limpia.destroy
      redirect_to root_path, notice: 'Postulación FPL correctamente eliminada.'
    end
  
    def create #TAREA FPL-01 al iniciar proceso
      success         = nil
      error           = nil
      link            = root_url
      tp = params[:tarea_pendiente_id] ? params[:id] : @t_pendiente
      tarea_pendiente = TareaPendiente.find(tp) rescue nil
      link = edit_fondo_produccion_limpia_path(params[:id])
      respond_to do |format|
        format.html { redirect_to link, flash: { success: success, error: error }}
      end
    end

    def get_value_from_hash_string_manually(hash_string, key)
      # Limpia el string eliminando llaves y espacios innecesarios
      cleaned_string = hash_string.gsub(/[{}]/, '')
 
      # Divide el string en pares clave-valor
      pairs = cleaned_string.split(',').map do |pair|
        k, v = pair.split('=>').map(&:strip)
        # Maneja los casos en que las claves están entre comillas
        k = k.gsub(/:\s*|"/, '').to_sym
        v = v.to_i
        [k, v]
      end
   
      # Convierte los pares en un hash
      hash = Hash[pairs]

      # Accede al valor usando la clave proporcionada
      value = hash[key.to_sym]

      value
    end
    

    def edit 
      @solo_lectura = false
      @recuerde_guardar_minutos = FondoProduccionLimpia::MINUTOS_MENSAJE_GUARDAR
      @mantener_temporal = 'true'
      @es_para_seleccion = 'true'
      @tipo_aporte = TipoAporte.all
      @contribuyentes = nil
      @custom_id = 'fpl'
      @adm_juridica = true

      #Obtiene el numero de campos nulos por tab para renderizar
      if params[:total_de_errores_por_tab].present?
        hash_string = params[:total_de_errores_por_tab]
        @total_de_errores_por_tab = {}
        @total_de_errores_por_tab[:"propuesta-tecnica"] = get_value_from_hash_string_manually(hash_string, "propuesta-tecnica")
        @total_de_errores_por_tab[:"equipo-trabajo"] = get_value_from_hash_string_manually(hash_string, "equipo-trabajo")
        @total_de_errores_por_tab[:"plan-de-actividades"] = get_value_from_hash_string_manually(hash_string, "plan-de-actividades")
        @total_de_errores_por_tab[:"documentacion-legal"] = get_value_from_hash_string_manually(hash_string, "documentacion-legal")
        @total_de_errores_por_tab[:"costos"] = get_value_from_hash_string_manually(hash_string, "costos")
      else
        @total_de_errores_por_tab = {}
      end

      #Obtenie empresas adheridas Linea 1.3
      if @flujo.tipo_instrumento_id == TipoInstrumento::FPL_LINEA_1_3 || @flujo.tipo_instrumento_id == TipoInstrumento::FPL_EXTRAPRESUPUESTARIO_EVALUACION
        obtiene_y_graba_empresas_adheridas(false)
      end

      count_user_persona = EquipoTrabajo.where(flujo_id: @tarea_pendiente.flujo_id, tipo_equipo: 1).count
      count_user_empresa =  EquipoEmpresa.where(flujo_id: @tarea_pendiente.flujo_id).count
      @objetivo_especificos = ObjetivosEspecifico.where(flujo_id: @tarea_pendiente.flujo_id).all
      @comuna_flujo = ComunasFlujo.where(flujo_id: @tarea_pendiente.flujo_id).all

      set_actividades_x_linea
      set_plan_actividades
      set_costos

      @tipo = 0
      if count_user_persona > 0 
        @tipo = 1
      end 

      if @tipo == 0
        if count_user_empresa > 0 
          @tipo = 2
        else 
          @tipo = 0
        end
      end
     
      #ESTE ID SE OBTIENE DESDE EL FPL00, CONSIDERAR ID_CONTRIBUYENTE EN LA TABLA FONDO PRODUCCION LIMPIA
      @flujo = @tarea_pendiente.flujo
      set_equipo_trabajo

      unless @manifestacion_de_interes.contribuyente_id.nil?
        #Elimino todos los que no sean el id guardado
        Contribuyente.unscoped.where(flujo_id: @manifestacion_de_interes.flujo.id).where.not(id: @manifestacion_de_interes.contribuyente_id).destroy_all
        #Ahora segun si tiene contribuyente_id lo paso a variable
        @contribuyente_temporal = Contribuyente.unscoped.find(@manifestacion_de_interes.contribuyente_id)
        if @contribuyente_temporal.contribuyente_id.nil?
          @contribuyente_nuevo = @contribuyente_temporal
          @contribuyente_editado = Contribuyente.new
        else
          @contribuyente_nuevo = Contribuyente.new
          @contribuyente_editado = @contribuyente_temporal
        end
      else
        Contribuyente.unscoped.where(flujo_id: @manifestacion_de_interes.flujo.id).destroy_all
        @contribuyente_temporal = @contribuyente_nuevo = @contribuyente_editado = Contribuyente.new
      end
      @contribuyente_nuevo.temporal = true
      @contribuyente_editado.temporal = true
      @contribuyente_nuevo.flujo_id = @manifestacion_de_interes.flujo.id
      @contribuyente_editado.flujo_id = @manifestacion_de_interes.flujo.id
  
      unless @manifestacion_de_interes.representante_institucion_para_solicitud_id.nil?
        #Elimino todos los que no sean el id guardado
        User.unscoped.where(flujo_id: @manifestacion_de_interes.flujo.id).where.not(id: @manifestacion_de_interes.representante_institucion_para_solicitud_id).destroy_all
        #Ahora segun si tiene representante_institucion_para_solicitud_id lo paso a variable
        @usuario_temporal = User.unscoped.find(@manifestacion_de_interes.representante_institucion_para_solicitud_id)
        if @usuario_temporal.user_id.nil?
          @usuario_nuevo = @usuario_temporal
          @usuario_editado = User.new
        else
          @usuario_nuevo = User.new
          @usuario_editado = @usuario_temporal
        end
      else
        User.unscoped.where(flujo_id: @manifestacion_de_interes.flujo.id).destroy_all
        @usuario_temporal = @usuario_nuevo = @usuario_editado = User.new
      end
      @usuario_nuevo.temporal = true
      @usuario_editado.temporal = true
      @usuario_nuevo.flujo_id = @manifestacion_de_interes.flujo.id
      @usuario_editado.flujo_id = @manifestacion_de_interes.flujo.id
      carga_de_representantes
    end

    def insert_objetivo_especifico
      custom_params = {
        objetivos_especifico: {
          flujo_id: params['flujo_id'],
          descripcion: normalize_string(params['descripcion']),
          metodologia: normalize_string(params['metodologia']),
          resultado: normalize_string(params['resultado']),
          indicadores: normalize_string(params['indicadores'])
        }
      }
      @objetivo_especifico = ObjetivosEspecifico.new(custom_params[:objetivos_especifico])
      respond_to do |format|
        if @objetivo_especifico.save
          @objetivo = ObjetivosEspecifico.where(flujo_id: params['flujo_id']).select(:descripcion, :id)
          @objetivos_options = @objetivo.map { |objetivo| [objetivo.descripcion, objetivo.id] }
          format.js { render 'insert_objetivo_especifico', locals: { objetivo_especifico: @objetivo_especifico, tarea_pendiente: params['id'], objetivos_options: @objetivos_options } }
        end
      end
    end

    def edit_objetivo_especifico
      @objetivo_especifico = ObjetivosEspecifico.find(params[:objetivo_id])
      respond_to do |format|
        format.js { render 'edit_objetivo_especifico', locals: { objetivo_especifico: @objetivo_especifico } }
      end
    end

    def update_objetivo_especifico
      @objetivo_especifico = ObjetivosEspecifico.find(params[:objetivo_id])
      custom_params = {
        objetivos_especifico: {
          id: params['objetivo_id'],
          flujo_id: params['flujo_id'],
          descripcion: normalize_string(params['descripcion']),
          metodologia: normalize_string(params['metodologia']),
          resultado: normalize_string(params['resultado']),
          indicadores: normalize_string(params['indicadores'])
        }
      }
      respond_to do |format|
        if @objetivo_especifico.update(custom_params[:objetivos_especifico])
          @objetivo = ObjetivosEspecifico.where(flujo_id: params['flujo_id']).select(:descripcion, :id)
          @objetivos_options = @objetivo.map { |objetivo| [objetivo.descripcion, objetivo.id] }
          format.js { render 'update_objetivo_especifico', locals: { objetivo_especifico: @objetivo_especifico, objetivos_options: @objetivos_options } }
        end
      end
    end

    def get_objetivo_especifico
      @solo_lectura = params['solo_lectura'] == "true" ? true : false
      @objetivo_especificos = ObjetivosEspecifico.where(flujo_id: params['flujo_id'])
      set_costos
      respond_to do |format|
        format.js { render 'get_objetivo_especifico', locals: { objetivo_especificos: @objetivo_especificos, solo_lectura: @solo_lectura } }
      end
    end

    def new_objetivo_especifico
        @objetivo_especifico = ObjetivosEspecifico.new
        respond_to do |format|
          format.html
          format.js
        end
	  end

    def eliminar_objetivo_especifico
      objetivo_especifico = ObjetivosEspecifico.find(params[:id])
      respond_to do |format|
        if objetivo_especifico.destroy
          @objetivo = ObjetivosEspecifico.where(flujo_id: objetivo_especifico['flujo_id']).select(:descripcion, :id)
          @objetivos_options = @objetivo.map { |objetivo| [objetivo.descripcion, objetivo.id] }
          format.js { render 'eliminar_objetivo_especifico', locals: { objetivo_especifico: objetivo_especifico.id, objetivos_options: @objetivos_options } }
        else
          format.js { render 'eliminar_objetivo_especifico', status: :unprocessable_entity }
        end
      end
    end

    def objetivo_especifico_existente?(objetivos_especifico_id)
      PlanActividad.exists?(objetivos_especifico_id: objetivos_especifico_id)
    end

    helper_method :objetivo_especifico_existente?

    def tope_maximo_solicitar_diagnostico(flujo_id)
      flujo = Flujo.find_by(id: flujo_id)
      if flujo
        case flujo.tipo_instrumento_id
        when TipoInstrumento::FPL_LINEA_1_1
          Gasto::TOPE_MAXIMO_SOLICITAR_DIAGNOSTICO
        when TipoInstrumento::FPL_LINEA_5_1
          Gasto::TOPE_MAXIMO_SOLICITAR_DIAGNOSTICO_L5
        when TipoInstrumento::FPL_EXTRAPRESUPUESTARIO_DIAGNOSTICO
          Gasto::TOPE_MAXIMO_SOLICITAR_DIAGNOSTICO
        when TipoInstrumento::FPL_LINEA_1_2_1
          Gasto::TOPE_MAXIMO_SOLICITAR_SEGUIMIENTO_L1_1
        when TipoInstrumento::FPL_LINEA_1_2_2
          Gasto::TOPE_MAXIMO_SOLICITAR_SEGUIMIENTO_L1_2  
        when TipoInstrumento::FPL_LINEA_1_3
          Gasto::TOPE_MAXIMO_SOLICITAR_EVALUACION_L1_3  
        when TipoInstrumento::FPL_EXTRAPRESUPUESTARIO_SEGUIMIENTO
          Gasto::TOPE_MAXIMO_SOLICITAR_SEGUIMIENTO_L1_1 
        when TipoInstrumento::FPL_EXTRAPRESUPUESTARIO_SEGUIMIENTO_2
          Gasto::TOPE_MAXIMO_SOLICITAR_SEGUIMIENTO_L1_2   
        when TipoInstrumento::FPL_EXTRAPRESUPUESTARIO_EVALUACION
          Gasto::TOPE_MAXIMO_SOLICITAR_EVALUACION_L1_3   
        else
          nil
        end
      else
        nil
      end
    end
   
    helper_method :tope_maximo_solicitar_diagnostico
  
    def buscador
      rut = buscador_params[:rut]
      nombre = buscador_params[:nombre_completo]
      @usuarios = User
      if rut.present?
        rut = rut.upcase
        @usuarios = @usuarios.where("rut = ?", rut)
        @filtro_utilizado = "Rut: #{rut}"
      end
      if nombre.present?
        @usuarios = @usuarios.where("nombre_completo ILIKE '%#{nombre}%'")
        filtro = "Nombre: #{nombre}"
        if @filtro_utilizado.blank?
          @filtro_utilizado = filtro
        else
          @filtro_utilizado += " Y #{filtro}"
        end
      end
      @modal_id = buscador_params[:modal_id]
      @tipo_equipo = buscador_params[:tipo_equipo]
    end

    def edit_modal
      if params[:tipo_equipo] == "2"
        empresa = EquipoEmpresa.find_by(flujo_id: params[:flujo_id])
        @equipo = EquipoTrabajo.where(user_id: params[:user_id], flujo_id: params[:flujo_id], tipo_equipo: params[:tipo_equipo], contribuyente_id: empresa.contribuyente_id).count
      else
        @equipo = EquipoTrabajo.where(user_id: params[:user_id], flujo_id: params[:flujo_id], tipo_equipo: params[:tipo_equipo]).count
      end

      if @equipo > 0
        render json: { success: false, errors: "La combinación de user_id, flujo_id, tipo_equipo y contribuyente_id ya está en uso" }, status: :unprocessable_entity
      else  
        @equipo_temporal = EquipoTrabajo.new
        if params[:estado] == 'new' 
          @usuario_temporal = User.new
        else
          @usuario_temporal =  User.unscoped.find(params[:user_id])
        end
        @usuario_temporal.temporal = true
        @usuario_temporal.flujo_id = params[:flujo_id]
        @usuario_temporal.user_id = params[:user_id] unless params[:user_id].blank?
        @equipo_temporal.flujo_id = params[:flujo_id]
        @equipo_temporal.user_id = params[:user_id] unless params[:user_id].blank?
        @equipo_temporal.tipo_equipo = params[:tipo_equipo]
        render layout: false
      end 
    end

    def insert
      @equipo_temporal = EquipoTrabajo.new
      @usuario_temporal = User.new
      @usuario_temporal.temporal = true
      @usuario_temporal.flujo_id = params[:flujo_id]
      @equipo_temporal.tipo_equipo = params[:tipo_equipo]
      render layout: false
    end 

    def insert_modal
      tarea = Tarea.where(codigo: Tarea::COD_FPL_01).first 
      @tarea_pendiente = TareaPendiente.find_by(tarea_id: tarea.id, flujo_id: params[:user][:flujo_id])
      @user = User.new(create_user_params)

      @usuarios = User
      if @user.rut.present?
        rut = @user.rut.upcase
        @usuarios = @usuarios.where("rut = ?", rut)
      end

      if @usuarios.count > 0
         # Usuario ya existe
        format.js { render js: "alert('El usuario con el RUT #{rut} ya existe.');" }
        format.html { redirect_to some_path, alert: "El usuario con el RUT #{rut} ya existe." }
      else
        # Verificación de archivos
        unless valid_extensions?(params[:archivos_copia_ci]) && valid_extensions?(params[:archivos_curriculum])
          respond_to do |format|
            format.js { render js: "alert('La extensión de uno o más archivos no es válida. Las extensiones permitidas son: pdf, jpg, png, tiff, zip, rar, doc y docx.');" }
            format.html { redirect_to edit_fondo_produccion_limpia_path(@tarea_pendiente.id), alert: "La extensión de uno o más archivos no es válida. Las extensiones permitidas son: pdf, jpg, png, tiff, zip, rar, doc y docx." }
          end
          return
        end

        #SETEO PARAMETROS EQUIPO
        custom_params_equipo = {
          equipo_trabajo: {
            profesion: params[:equipo_trabajo][:profesion],
            funciones_proyecto: params[:equipo_trabajo][:funciones_proyecto],
            valor_hh: params[:equipo_trabajo][:valor_hh],
            copia_ci: params[:archivos_copia_ci],
            curriculum: params[:archivos_curriculum],
            tipo_equipo: params[:equipo_trabajo][:tipo_equipo],
            flujo_id: params[:user][:flujo_id],
            user_id: params[:user][:user_id]
          }
        }
        tipo_proveedor = TipoProveedor.find(FondoProduccionLimpia::TIPO_CONSULTOR_FPL)

        #SETEO PARAMETROS PROVEEDOR
        @registro_proveedor = RegistroProveedor.new()
        @registro_proveedor.rut = @user.rut
        @registro_proveedor.nombre = @user.nombre_completo
        @registro_proveedor.email = @user.email
        @registro_proveedor.telefono = @user.telefono
        @registro_proveedor.profesion = params[:equipo_trabajo][:profesion]
        @registro_proveedor.tipo_proveedor_id = FondoProduccionLimpia::TIPO_CONSULTOR_FPL
        @registro_proveedor.calificado = false
        @registro_proveedor.apellido = '.'
        @registro_proveedor.direccion = '.'
        @registro_proveedor.region = '.'
        @registro_proveedor.comuna = '.'
        @registro_proveedor.ciudad = '.'
        @registro_proveedor.terminos_y_servicion = true

        # Si el tipo de equipo es diferente de 1, asigna el contribuyente_id
        empresa = EquipoEmpresa.find_by(flujo_id: params[:user][:flujo_id])

        if params[:equipo_trabajo][:tipo_equipo].to_i == 2
          custom_params_equipo[:equipo_trabajo][:contribuyente_id] = empresa.contribuyente_id
          @registro_proveedor.contribuyente_id = empresa.contribuyente_id
        end
        respond_to do |format|
          if @user.user_id.nil?
            if @user.save
              usuario_temporal = User.unscoped.find(@user.id)
              usuario_final = usuario_temporal.confirmar_temporal
              if(create_user_params[:temporal] == "true")
                @usuario_temporal = @user
                custom_params_equipo[:equipo_trabajo][:user_id] =  @user.id
                @equipo_temporal = EquipoTrabajo.new(custom_params_equipo[:equipo_trabajo])
                if @equipo_temporal.save  
                  if RegistroProveedor.unscoped.where(rut: @user.rut).count == 0
                    if @registro_proveedor.save
                      #flash[:success] = 'Consultor creado exitosamente.'
                      format.js { render js: "window.location='#{edit_fondo_produccion_limpia_path(@tarea_pendiente.id)}?tabs=equipo-trabajo'" }
                      format.html { redirect_to edit_fondo_produccion_limpia_path(@tarea_pendiente.id), notice: success }
                    end
                  else
                    #flash[:success] = 'Consultor creado exitosamente.'
                    format.js { render js: "window.location='#{edit_fondo_produccion_limpia_path(@tarea_pendiente.id)}?tabs=equipo-trabajo'" }
                    format.html { redirect_to edit_fondo_produccion_limpia_path(@tarea_pendiente.id), notice: success }
                  end  
                end  
              else
                message = t(:m_successfully_created, m: t(:user))
                format.js { flash.now[:success] = message }
                format.html { redirect_to admin_users_url, notice: message }
              end
            end
          else
            @user.save(validate: false)
            #Metodo devuelve el registro final (sea nuevo o editado)
            @usuario_temporal = @user
            format.js {}
          end
        end
      end
    end

    def subir_documento_equipo()
      equipo = EquipoTrabajo.find_by(id: params[:equipo_id], flujo_id: params[:flujo_id])
      nombre_campo = params[:nombre_campo]
      archivo = params[:archivo]
      custom_params = {
        equipo_trabajo: {
          nombre_campo => archivo
        }
      }
      equipo.update(custom_params[:equipo_trabajo])
    end

    def new_equipo_trabajo
      @equipo_consultor = EquipoTrabajo.new
      respond_to do |format|
        format.html
        format.js
      end
    end

    def insert_registro_proveedores_equipo
      custom_params_equipo = {
        equipo_trabajo: {
          tipo_equipo: params[:tipo_equipo],
          valor_hh: params[:valor_hh],
          flujo_id: params[:flujo_id],
          registro_proveedores_id: params[:auditor_id]
        }
      }
  
      @equipo = EquipoTrabajo.where(tipo_equipo: params[:tipo_equipo], flujo_id: params[:flujo_id], registro_proveedores_id: params[:auditor_id]).first
    
      @flag = 0
      if @equipo.present?
        @equipo.update(custom_params_equipo[:equipo_trabajo])
        @flag = 1
      else
        @equipo = EquipoTrabajo.new(custom_params_equipo[:equipo_trabajo])
        @equipo.save
      end
   
      @auditor = RegistroProveedor.find(params[:auditor_id])

      respond_to do |format|
        format.js { render 'insert_registro_proveedores_equipo', locals: { auditor: @auditor, tarea_pendiente: params[:tarea_pendiente_id], equipo: @equipo, flag: @flag } }
      end
    end

    def update_modal
      tarea = Tarea.where(codigo: Tarea::COD_FPL_01).first 
      @tarea_pendiente = TareaPendiente.find_by(tarea_id: tarea.id, flujo_id: params[:user][:flujo_id])
      #SETEO PARAMETROS USUARIO
      @user = User.find(params[:user][:user_id])
      custom_params = {
        user: {
          id: params[:user][:user_id],
          nombre_completo: params[:user][:nombre_completo],
          telefono: params[:user][:telefono],
          email: params[:user][:email]
        }
      }

      # Verificación de archivos
      unless valid_extensions?(params[:archivos_copia_ci]) && valid_extensions?(params[:archivos_curriculum])
        respond_to do |format|
          format.js { render js: "alert('Las extensiones de los archivos no son válidas. Las permitidas son: (pdf jpg png tiff zip rar doc docx)');" }
          format.html { redirect_to edit_fondo_produccion_limpia_path(@tarea_pendiente.id), alert: "Las extensiones de archivo no son válidas." }
        end
        return
      end

      #SETEO PARAMETROS EQUIPO
      custom_params_equipo = {
        equipo_trabajo: {
          profesion: params[:equipo_trabajo][:profesion],
          funciones_proyecto: params[:equipo_trabajo][:funciones_proyecto],
          valor_hh: params[:equipo_trabajo][:valor_hh],
          copia_ci: params[:archivos_copia_ci],
          curriculum: params[:archivos_curriculum],
          tipo_equipo: params[:equipo_trabajo][:tipo_equipo],
          flujo_id: params[:user][:flujo_id],
          user_id: params[:user][:user_id]
        }
      }
      tipo_proveedor = TipoProveedor.find(FondoProduccionLimpia::TIPO_CONSULTOR_FPL)

      #SETEO PARAMETROS PROVEEDOR
      @registro_proveedor = RegistroProveedor.new()
      @registro_proveedor.rut = @user.rut
      @registro_proveedor.nombre = @user.nombre_completo
      @registro_proveedor.email = @user.email
      @registro_proveedor.telefono = @user.telefono
      @registro_proveedor.profesion = params[:equipo_trabajo][:profesion]
      @registro_proveedor.tipo_proveedor_id = FondoProduccionLimpia::TIPO_CONSULTOR_FPL
      @registro_proveedor.calificado = false
      @registro_proveedor.apellido = '.'
      @registro_proveedor.direccion = '.'
      @registro_proveedor.region = '.'
      @registro_proveedor.comuna = '.'
      @registro_proveedor.ciudad = '.'
      @registro_proveedor.terminos_y_servicion = true

      # Si el tipo de equipo es diferente de 1, asigna el contribuyente_id
      empresa = EquipoEmpresa.find_by(flujo_id: params[:user][:flujo_id])
      if params[:equipo_trabajo][:tipo_equipo].to_i == 2
        custom_params_equipo[:equipo_trabajo][:contribuyente_id] = empresa.contribuyente_id
        @registro_proveedor.contribuyente_id = empresa.contribuyente_id
      end
      @equipo_temporal = EquipoTrabajo.new(custom_params_equipo[:equipo_trabajo])

      @contribuyente = Contribuyente
        .unscoped
        .joins(:equipo_empresas)
        .select("contribuyentes.id, contribuyentes.rut, contribuyentes.dv, contribuyentes.razon_social")
        .where(equipo_empresas: {flujo_id: @tarea_pendiente.flujo_id})
        .all
     
        respond_to do |format|
        if @user.update(custom_params[:user]) && @equipo_temporal.save
          if RegistroProveedor.unscoped.where(rut: @user.rut).count == 0
            if params[:equipo_trabajo][:tipo_equipo].to_i != 3
              if @registro_proveedor.save
                #flash[:success] = 'Consultor creado exitosamente.'
                format.js { render 'update_modal', locals: { user: @user, equipo: @equipo_temporal, tarea_pendiente: @tarea_pendiente } }
              end
            else
              format.js { render 'update_modal', locals: { user: @user, equipo: @equipo_temporal, tarea_pendiente: @tarea_pendiente } }
            end
          else
            #flash[:success] = 'Consultor creado exitosamente.'
            format.js { render 'update_modal', locals: { user: @user, equipo: @equipo_temporal, tarea_pendiente: @tarea_pendiente } }
          end  
        else
          flash[:error] = 'Hubo un problema al crear al Consultor.'
          render 'edit'
        end
      end
    end

    def eliminar_equipo
      equipo_trabajo = EquipoTrabajo.find(params[:user_id])
      if equipo_trabajo.destroy
        @count_equipo = EquipoTrabajo.where(flujo_id: @tarea_pendiente.flujo_id, tipo_equipo: [1,2]).count
        respond_to do |format|
          format.js { render 'eliminar_equipo', locals: { user: equipo_trabajo.id, count_equipo: @count_equipo } }
        end
      else
      end
    end

    def eliminar_equipo_postulante
      equipo_trabajo = EquipoTrabajo.find(params[:user_id])
      if equipo_trabajo.destroy  
        respond_to do |format|
          format.js { render 'eliminar_equipo_postulante', locals: { user: equipo_trabajo.id } }
        end
      else
        flash[:error] = 'El consultor no puede ser eliminado ya que se encuentra asociado a alguna actividad.'
      end
    end

    def eliminar_equipo_auditor
      equipo_trabajo = EquipoTrabajo.find(params[:user_id])
      if equipo_trabajo.destroy  
        respond_to do |format|
          format.js { render 'eliminar_equipo_auditor', locals: { user: equipo_trabajo.id } }
        end
      else
        flash[:error] = 'El auditor no puede ser eliminado ya que se encuentra asociado a alguna actividad.'
      end
    end

    def eliminar_recursos_humanos
      eliminar = RecursoHumano.find_by(id: params[:rr_hh_id])

      if eliminar.destroy  
        respond_to do |format|
          set_costos
           
          ### se obtiene el valor de la suma de los recursos internos, externos, gastos adm, gastos ope por id y se renderiza al dashboard principal
          @valor_hh_tipo_3 = PlanActividad.valor_hh_tipo_3(@tarea_pendiente.flujo_id, params[:plan_id])
          @valor_hh_tipos_1_2_ = PlanActividad.valor_hh_tipos_1_2_(@tarea_pendiente.flujo_id, params[:plan_id])
          @total_gastos_tipo_1 = PlanActividad.total_gastos_tipo_1_insert(@tarea_pendiente.flujo_id, params[:plan_id])
          @total_gastos_tipo_2 = PlanActividad.total_gastos_tipo_2_insert(@tarea_pendiente.flujo_id, params[:plan_id])

          #Totales generales
          @total_valor_hh_tipo_3 = PlanActividad.total_valor_hh_tipo_3(@tarea_pendiente.flujo_id)
          @total_valor_hh_tipos_1_2 = PlanActividad.total_valor_hh_tipos_1_2(@tarea_pendiente.flujo_id)
          @total_total_gastos_tipo_1 = PlanActividad.total_total_gastos_tipo_1(@tarea_pendiente.flujo_id)
          @total_total_gastos_tipo_2 = PlanActividad.total_total_gastos_tipo_2(@tarea_pendiente.flujo_id)

          format.js { render 'eliminar_recursos_humanos', locals: { rr_hh_id: params[:rr_hh_id] } }
        end
      else
        flash[:error] = 'El recurso propio no puede ser eliminado ya que se encuentra asociado a alguna actividad.'
      end
    end

    def obtiene_contribuyente(id)
      Contribuyente.find(id)
    end

    helper_method :obtiene_contribuyente

    def recurso_humano_existente?(equipo_trabajo_id, flujo_id)
      RecursoHumano.exists?(equipo_trabajo_id: equipo_trabajo_id, flujo_id: flujo_id)
    end

    helper_method :recurso_humano_existente?

    def verificar_auditor_existente
      exists = EquipoTrabajo.where(flujo_id: params[:flujo_id], tipo_equipo: 4, registro_proveedores_id: params[:auditor_id]).count
      render json: { exists: exists }
    end

    ###CONTRIBUYENTES
    def insert_modal_contribuyente
      tarea = Tarea.where(codigo: Tarea::COD_FPL_01).first #Tarea::COD_FPL_01
      @tarea_pendiente = TareaPendiente.find_by(tarea_id: tarea.id, flujo_id: params[:flujo_id])
     
      #SETEO PARAMETROS EQUIPO
      custom_params_empresa = {
        equipo_empresa: {
          flujo_id: params[:flujo_id],
          contribuyente_id: params[:id]
        }
      }

      @empresa_temporal = EquipoEmpresa.new(custom_params_empresa[:equipo_empresa])
      respond_to do |format|
        if @empresa_temporal.save  
              @contribuyente = Contribuyente
              .unscoped
              .joins(:equipo_empresas)
              .select("contribuyentes.id, contribuyentes.rut, contribuyentes.dv, contribuyentes.razon_social")
              .where(equipo_empresas: {flujo_id: @tarea_pendiente.flujo_id})
              .all

              #Obtiene descargables actualizados
              set_descargables

              #flash[:success] = 'Contribuyente creado exitosamente.'
              format.js { render 'insert_modal_contribuyente', locals: { contribuyente: @contribuyente, tarea_pendiente: @tarea_pendiente, empresa_temporal: @empresa_temporal, descargables_ejecutor: @descargables_ejecutor} }
        end    
      end
    end

    def search
      # Inicializar variables
      @contribuyentes = Contribuyente.all
      @filtro_utilizado = ''
      @es_para_seleccion = false #( @contribuyente.es_para_seleccion == "true" )
      @seleccion_basica = true #@contribuyente.seleccion_basica
      @tipo_instrumento = 4 #@contribuyente.tipo_instrumento
      @es_maquinaria = false #( @contribuyente.es_maquinaria == "true" )
      @buscar_por_actividad_economica = false#( @contribuyente.buscar_por_actividad_economica == "true" )
      @resultado_mostrados = 25 #@contribuyente.resultado_mostrados
      @data_table = true #(@contribuyente.data_table == "true")
    
      # Filtrar por razón social si el parámetro no está en blanco
      if params[:razon_social].present?
        @contribuyentes = @contribuyentes.where("razon_social ILIKE ?", "%#{params[:razon_social]}%")
        @filtro_utilizado = "Razón Social: #{params[:razon_social]}"
      end

      # Filtrar por RUT si el parámetro no está en blanco
      if params[:rut].present?
        @contribuyentes = @contribuyentes.where(rut: params[:rut])
        filtro = "RUT: #{params[:rut]}"
        @filtro_utilizado = @filtro_utilizado.blank? ? filtro : "Y #{filtro}"
      end

      # Manejar la respuesta
      respond_to do |format|
        format.js { render 'fondo_produccion_limpias/contribuyentes/search', locals: { contribuyentes: @contribuyentes, filtro_utilizado: @filtro_utilizado } }
      end
    end
    
    def eliminar_empresa
      equipo_empresa = EquipoEmpresa.find(params[:contribuyente_id])
      equipo_trabajo = EquipoTrabajo.where(flujo_id: equipo_empresa.flujo_id, contribuyente_id: equipo_empresa.contribuyente_id)
      if equipo_empresa.destroy
          equipo_trabajo.each do |equipo|
            equipo.destroy
          end
          respond_to do |format|
            #flash[:success] = 'Contribuyente eliminado exitosamente.'
            format.js { render 'eliminar_empresa', locals: { user: equipo_empresa.id } }
          end 
      else
        flash[:error] = 'Hubo un problema al eliminar al contribuyente.'
      end
    end

    def eliminar_consultor_empresa
      equipo_trabajo = EquipoTrabajo.find(params[:user_id])
      if equipo_trabajo.destroy  
        set_equipo_empresa
        respond_to do |format|
          #flash[:success] = 'Consultor eliminado exitosamente.'
          format.js { render 'eliminar_consultor_empresa', locals: { user: equipo_trabajo.id, tarea_pendiente_id: params[:id] } }
        end
      else
      end
    end

    def equipo_consultores_existente?(contribuyente_id, flujo_id)
      EquipoTrabajo.exists?(contribuyente_id: contribuyente_id, flujo_id: flujo_id, tipo_equipo: [1,2])
    end

    helper_method :equipo_consultores_existente?

    def update #TAREA FPL-01
        respond_to do |format|
          
          if @fondo_produccion_limpia.update(fondo_produccion_limpia_params)
            format.js {
              render js: "window.location='#{root_path}'"
              flash[:success] = "Fondo enviado correctamente"
            }
            link = edit_fondo_produccion_limpia_path(params[:id])
            format.html { redirect_to link, flash: { success: success, error: error }}

          else
            format.html { render :new }
            format.js
          end
        end
        
    end

    def get_plan_actividades
      @plan_actividades = PlanActividad.includes(:actividad).find_by(flujo_id: @tarea_pendiente.flujo_id, actividad_id: params['plan_id'])
      @duracion_general = FondoProduccionLimpia.where(flujo_id: @tarea_pendiente.flujo_id).first
      arreglo = []
      @existe_plan = nil
      @tipo_permiso = 0
      
      if @plan_actividades.nil?
        @actividad = Actividad.find_by(id: params['plan_id'])
        @nombre_actividad = @actividad.nombre if @actividad&.present?  
        @objetivos_especifico_id = nil
        @tipo_actividad = nil
        @existe_plan = 0
  
        maximo = @duracion_general.duracion
        1.upto(maximo) do |numero|
          arreglo << numero
        end

        ###GENERA TD DE CHECK DINAMICAMENTE
        newRowDuracion = ""
        arreglo.each do |mes|  
          newRowDuracion += "<td class='sub-contenido-form'>" +
                            "<input type='checkbox' name='descripcion' class='required-field' id='#{mes}' style='border: 1px solid #ced4da; border-radius: 0.25rem;'>" +
                            "</td>"
        end
        @duracion = newRowDuracion
      else
        @nombre_actividad = @plan_actividades.actividad.nombre if @plan_actividades&.actividad.present?  
        @objetivos_especifico_id = @plan_actividades.objetivos_especifico_id if @plan_actividades.objetivos_especifico_id.present?
        @tipo_act = @plan_actividades.actividad.actividad_por_lineas.first&.tipo_actividad if @plan_actividades.actividad.actividad_por_lineas.first&.tipo_actividad?
        @tipo_perm = @plan_actividades.actividad.actividad_por_lineas.first&.tipo_permiso if @plan_actividades.actividad.actividad_por_lineas.first&.tipo_permiso?

        if @tipo_perm == "nueva"
          @tipo_permiso = 1
        end    

        if @tipo_act == "tipo_a"
          @tipo_actividad = 0
        else
          @tipo_actividad = 1
        end

        @existe_plan = 1
        maximo = @duracion_general.duracion
        1.upto(maximo) do |numero|
          arreglo << numero
        end
  
        # Asegúrate de que @duracion tenga un formato adecuado
        @duracion = @plan_actividades.duracion.present? ? @plan_actividades.duracion.to_s : ""
     
        # Crear un Set con los códigos FPL
        fpl_codes = Set.new(['FPL-01', 'FPL-07', 'FPL-08'])

        # Comenzar con una cadena vacía para el resultado
        newRowDuracion = ""
        
        # Iterar sobre cada mes en arreglo
        arreglo.each do |mes|
          # Verificar si la tarea es FPL
          is_fpl_task = fpl_codes.include?(@tarea_pendiente.tarea.codigo)
    
          # Verificar si @duracion está presente y si el mes está dentro de la duración
          # Convertir @duracion a un arreglo de números si es necesario
          duracion_array = @duracion.split(",").map(&:to_i)
          is_checked = duracion_array.include?(mes)
          is_disabled = !is_fpl_task || @duracion.blank?

          checked = ''
          if is_checked
            checked = "checked='checked'"
          end

          # Construir el HTML del checkbox
          checkbox_html = "<input type='checkbox' name='descripcion' class='required-field' id='#{mes}' style='border: 1px solid #ced4da; border-radius: 0.25rem;' #{checked} #{'disabled' if is_disabled}>"

          # Añadir la celda con el checkbox al HTML final
          newRowDuracion += "<td class='sub-contenido-form'>#{checkbox_html}</td>"
        end

        # Asignar el resultado generado a @duracion
        @duracion = newRowDuracion

      end   

      ###OBTIENE RECURSOS Y GASTOS
      @recursos_internos = PlanActividad.recursos_internos(@tarea_pendiente.flujo_id, params['plan_id'])
    
      @recursos_externos = PlanActividad.recursos_externos(@tarea_pendiente.flujo_id, params['plan_id'])
    
      @gastos_operaciones = PlanActividad.gastos_operaciones(@tarea_pendiente.flujo_id, params['plan_id'])
 
      @gastos_administraciones = PlanActividad.gastos_administraciones(@tarea_pendiente.flujo_id, params['plan_id'])
     
      @plan = params['plan_id']

      if @tarea_pendiente.tarea.codigo == 'FPL-01' ||  @tarea_pendiente.tarea.codigo == 'FPL-07' ||  @tarea_pendiente.tarea.codigo == 'FPL-08'
        @solo_lectura = @tarea_pendiente.estado_tarea_pendiente_id == 2 ? true : false
      else
        @solo_lectura = true
      end  

      respond_to do |format|
        format.js { render 'get_plan_actividades', locals: { recursos_internos: @recursos_internos, recursos_externos: @recursos_externos, plan_id: params['plan_id'], plan_actividades: @plan_actividades, nombre_actividad: @nombre_actividad, gastos_operaciones: @gastos_operaciones, gastos_administraciones: @gastos_administraciones, duracion: @duracion, solo_lectura: @solo_lectura, existe_plan: @existe_plan, tipo_actividad: @tipo_actividad, tipo_permiso: @tipo_permiso  } } 
      end
    end
    
    def get_recursos_propios
      @postulantes_faltantes = EquipoTrabajo.postulantes_faltantes(params['actividad_id'], @tarea_pendiente.flujo_id)
      respond_to do |format|
        format.js { render 'get_recursos_propios', locals: { postulantes_faltantes: @postulantes_faltantes } }
      end
    end  

    def get_recursos_externos
      @consultor_faltantes = EquipoTrabajo.consultor_faltantes(params['actividad_id'], @tarea_pendiente.flujo_id)
      respond_to do |format|
        format.js { render 'get_recursos_externos', locals: { consultor_faltantes: @consultor_faltantes } }
      end
    end

    def insert_gastos_operacion
      @plan_actividades = PlanActividad.find_by(flujo_id: params[:flujo_id], actividad_id: params[:plan_id])
      custom_params = {
        gasto: {
          nombre: params[:nombre],
          valor_unitario: params[:valor_unitario],
          cantidad: params[:cantidad],
          tipo_aporte_id: params[:tipo_aporte_id],
          flujo_id: params[:flujo_id],
          plan_actividad_id: @plan_actividades.id,
          tipo_gasto: 1,
          unidad_medida: params[:unidad_medida]
        }  
      }
      
      @gastos_operaciones = Gasto.new(custom_params[:gasto])
        if @gastos_operaciones.save 
           # se obtiene el valor de la suma de los gastos ope, recursos internos, ecternos y gastos adm por id y se renderiza al dashboard principal
           @total_gastos_tipo_1 = PlanActividad.total_gastos_tipo_1_insert(params[:flujo_id], params['plan_id'])
           @valor_hh_tipos_1_2_ = PlanActividad.valor_hh_tipos_1_2_(params[:flujo_id], params['plan_id'])
           @valor_hh_tipo_3 = PlanActividad.valor_hh_tipo_3(params[:flujo_id], params['plan_id'])
           @total_gastos_tipo_2 = PlanActividad.total_gastos_tipo_2_insert(params[:flujo_id], params['plan_id'])

          #Totales generales
          @total_valor_hh_tipo_3 = PlanActividad.total_valor_hh_tipo_3(params[:flujo_id])
          @total_valor_hh_tipos_1_2 = PlanActividad.total_valor_hh_tipos_1_2(params[:flujo_id])
          @total_total_gastos_tipo_1 = PlanActividad.total_total_gastos_tipo_1(params[:flujo_id])
          @total_total_gastos_tipo_2 = PlanActividad.total_total_gastos_tipo_2(params[:flujo_id])

          #Actualiza costos
          set_costos 

          @plan_id = params['plan_id']
          respond_to do |format|
            format.js { render 'insert_gastos_operacion', locals: { gastos_operaciones: @gastos_operaciones, tarea_pendiente: @tarea_pendiente, 
            valor_hh_tipo_3: @valor_hh_tipo_3, valor_hh_tipos_1_2_: @valor_hh_tipos_1_2_, total_gastos_tipo_1: @total_gastos_tipo_1, total_gastos_tipo_2:@total_gastos_tipo_2,
            total_valor_hh_tipo_3: @total_valor_hh_tipo_3, total_valor_hh_tipos_1_2: @total_valor_hh_tipos_1_2, total_total_gastos_tipo_1: @total_total_gastos_tipo_1, total_total_gastos_tipo_2: @total_total_gastos_tipo_2 } }
          end
        end
    end

    def eliminar_gasto_operacion
      gasto = Gasto.find(params[:gastos_id])
      if gasto.destroy
        respond_to do |format|
          # se obtiene el valor de la suma de los recursos internos por id y se renderiza al dashboard principal
          @total_gastos_tipo_2 = PlanActividad.total_gastos_tipo_2(gasto['flujo_id'], gasto['plan_actividad_id'])
          @total_gastos_tipo_1 = PlanActividad.total_gastos_tipo_1(gasto['flujo_id'], gasto['plan_actividad_id'])
          @valor_hh_tipos_1_2_ = PlanActividad.valor_hh_tipos_1_2_(gasto['flujo_id'], params['plan_id'])
          @valor_hh_tipo_3 = PlanActividad.valor_hh_tipo_3(gasto['flujo_id'], params['plan_id'])
 
          #Totales generales
          @total_valor_hh_tipo_3 = PlanActividad.total_valor_hh_tipo_3(gasto['flujo_id'])
          @total_valor_hh_tipos_1_2 = PlanActividad.total_valor_hh_tipos_1_2(gasto['flujo_id'])
          @total_total_gastos_tipo_1 = PlanActividad.total_total_gastos_tipo_1(gasto['flujo_id'])
          @total_total_gastos_tipo_2 = PlanActividad.total_total_gastos_tipo_2(gasto['flujo_id'])
 
          #Actualiza costos
          set_costos 
          format.js { render 'eliminar_gasto_operacion', locals: { gasto: gasto.id, total_gastos_tipo_1: @total_gastos_tipo_1, plan_id: params['plan_id'] } }
        end 
      else
        flash[:error] = 'Hubo un problema al eliminar el gasto.'
      end
    end

    def insert_gastos_administracion
      @plan_actividades = PlanActividad.find_by(flujo_id: params[:flujo_id], actividad_id: params[:plan_id])
      custom_params = {
        gasto: {
          nombre: params[:nombre],
          valor_unitario: params[:valor_unitario],
          cantidad: params[:cantidad],
          tipo_aporte_id: params[:tipo_aporte_id],
          flujo_id: params[:flujo_id],
          plan_actividad_id: @plan_actividades.id,
          tipo_gasto: 2,
          unidad_medida: params[:unidad_medida]
        }  
      }
      
      @gastos_administraciones = Gasto.new(custom_params[:gasto])
        if @gastos_administraciones.save 
          # se obtiene el valor de la suma de los gastos adm, recursos internos, externos y gastos ope por id y se renderiza al dashboard principal
          @total_gastos_tipo_2 = PlanActividad.total_gastos_tipo_2_insert(params[:flujo_id], params['plan_id'])
          @total_gastos_tipo_1 = PlanActividad.total_gastos_tipo_1_insert(params[:flujo_id], params['plan_id'])
          @valor_hh_tipos_1_2_ = PlanActividad.valor_hh_tipos_1_2_(params[:flujo_id], params['plan_id'])
          @valor_hh_tipo_3 = PlanActividad.valor_hh_tipo_3(params[:flujo_id], params['plan_id'])

          #Totales generales
          @total_valor_hh_tipo_3 = PlanActividad.total_valor_hh_tipo_3(params[:flujo_id])
          @total_valor_hh_tipos_1_2 = PlanActividad.total_valor_hh_tipos_1_2(params[:flujo_id])
          @total_total_gastos_tipo_1 = PlanActividad.total_total_gastos_tipo_1(params[:flujo_id])
          @total_total_gastos_tipo_2 = PlanActividad.total_total_gastos_tipo_2(params[:flujo_id])

          #Actualiza costos
          set_costos 
          @plan_id = params['plan_id']
          respond_to do |format|
            format.js { render 'insert_gastos_administracion', locals: { gastos_administraciones: @gastos_administraciones, tarea_pendiente: @tarea_pendiente, plan: @plan, 
            valor_hh_tipo_3: @valor_hh_tipo_3, valor_hh_tipos_1_2_: @valor_hh_tipos_1_2_, total_gastos_tipo_1: @total_gastos_tipo_1, total_gastos_tipo_2:@total_gastos_tipo_2,
            total_valor_hh_tipo_3: @total_valor_hh_tipo_3, total_valor_hh_tipos_1_2: @total_valor_hh_tipos_1_2, total_total_gastos_tipo_1: @total_total_gastos_tipo_1, total_total_gastos_tipo_2: @total_total_gastos_tipo_2 } }
          end
        end
    end

    def eliminar_gasto_administracion
      gasto = Gasto.find(params[:gastos_id])
      if gasto.destroy
        respond_to do |format|
          # se obtiene el valor de la suma de los recursos internos por id y se renderiza al dashboard principal
          @total_gastos_tipo_2 = PlanActividad.total_gastos_tipo_2(gasto['flujo_id'], gasto['plan_actividad_id'])
          @total_gastos_tipo_1 = PlanActividad.total_gastos_tipo_1(gasto['flujo_id'], gasto['plan_actividad_id'])
          @valor_hh_tipos_1_2_ = PlanActividad.valor_hh_tipos_1_2_(gasto['flujo_id'], params['plan_id'])
          @valor_hh_tipo_3 = PlanActividad.valor_hh_tipo_3(gasto['flujo_id'], params['plan_id'])

          #Totales generales
          @total_valor_hh_tipo_3 = PlanActividad.total_valor_hh_tipo_3(gasto['flujo_id'])
          @total_valor_hh_tipos_1_2 = PlanActividad.total_valor_hh_tipos_1_2(gasto['flujo_id'])
          @total_total_gastos_tipo_1 = PlanActividad.total_total_gastos_tipo_1(gasto['flujo_id'])
          @total_total_gastos_tipo_2 = PlanActividad.total_total_gastos_tipo_2(gasto['flujo_id'])

          #Actualiza costos
          set_costos 

          format.js { render 'eliminar_gasto_administracion', locals: { gasto: gasto.id, plan_id: params['plan_id']} }
        end 
      else
        flash[:error] = 'Hubo un problema al eliminar el gasto.'
      end
    end

    def insert_recursos_humanos_propios
      data = JSON.parse(params[:data])
      @plan_actividades = PlanActividad.find_by(flujo_id: params[:flujo_id], actividad_id: params[:plan_id])
      rrhh_propio_ids = []  # Array para almacenar los IDs de rrhhPropioId
    
      data.each do |clave, valor|
        custom_params = {
          recursos: {
            hh: clave['hh'],
            equipo_trabajo_id: clave['rrhhPropioId'],
            flujo_id: params[:flujo_id],
            plan_actividad_id: @plan_actividades.id,
            tipo_aporte_id: 1
          }  
        }
        if (clave['rhhEquipoId'] == "")
          #se inserta un nuevo usuario
          @recursos_propios = RecursoHumano.new(custom_params[:recursos])
          @recursos_propios.save 
        else
          #se actualiza un usuario
          @recursos_propios = RecursoHumano.find_by(flujo_id: params[:flujo_id], plan_actividad_id: @plan_actividades.id, equipo_trabajo_id: clave['rrhhPropioId'])
          @recursos_propios.update(custom_params[:recursos])
        end

        if (clave['hh'] == "")
          eliminar_rrhh_propios = RecursoHumano.find_by(flujo_id: params[:flujo_id], plan_actividad_id: @plan_actividades.id, equipo_trabajo_id: clave['rrhhPropioId'])
          eliminar_rrhh_propios.destroy
        else
          rrhh_propio_ids << clave['rrhhPropioId']  # Agregar el ID a la lista  
        end  
      
      end
    
      ### Utilizar rrhh_propio_ids como necesites fuera del bucle
      @recursos_internos = PlanActividad.recursos_x_ids(params[:flujo_id], params['plan_id'], rrhh_propio_ids)

      ### se obtiene el valor de la suma de los recursos internos, externos, gastos adm, gastos ope por id y se renderiza al dashboard principal
      @valor_hh_tipo_3 = PlanActividad.valor_hh_tipo_3(params[:flujo_id], params['plan_id'])
      @valor_hh_tipos_1_2_ = PlanActividad.valor_hh_tipos_1_2_(params[:flujo_id], params['plan_id'])
      @total_gastos_tipo_1 = PlanActividad.total_gastos_tipo_1_insert(params[:flujo_id], params['plan_id'])
      @total_gastos_tipo_2 = PlanActividad.total_gastos_tipo_2_insert(params[:flujo_id], params['plan_id'])

      #Totales generales
      @total_valor_hh_tipo_3 = PlanActividad.total_valor_hh_tipo_3(params[:flujo_id])
      @total_valor_hh_tipos_1_2 = PlanActividad.total_valor_hh_tipos_1_2(params[:flujo_id])
      @total_total_gastos_tipo_1 = PlanActividad.total_total_gastos_tipo_1(params[:flujo_id])
      @total_total_gastos_tipo_2 = PlanActividad.total_total_gastos_tipo_2(params[:flujo_id])

      ###Actualiza costos
      set_costos  

      @plan_id =  params['plan_id']

      @recursos_propios_no_asignados = EquipoTrabajo.left_outer_joins(:recurso_humanos)
             .where(recurso_humanos: { equipo_trabajo_id: nil })
             .where(flujo_id: params[:flujo_id], tipo_equipo: 3)

      #@solo_lectura = false
      respond_to do |format|
        format.js { render 'insert_recursos_humanos_propios', locals: { recursos_internos: @recursos_internos, tarea_pendiente: @tarea_pendiente, plan_id: @plan_id, flujo_id: params[:flujo_id], 
        valor_hh_tipo_3: @valor_hh_tipo_3, valor_hh_tipos_1_2_: @valor_hh_tipos_1_2_, total_gastos_tipo_1: @total_gastos_tipo_1, total_gastos_tipo_2:@total_gastos_tipo_2, 
        total_valor_hh_tipo_3: @total_valor_hh_tipo_3, total_valor_hh_tipos_1_2: @total_valor_hh_tipos_1_2, total_total_gastos_tipo_1: @total_total_gastos_tipo_1, total_total_gastos_tipo_2: @total_total_gastos_tipo_2 } }
      end
    end

    def insert_recursos_humanos_externos
      data = JSON.parse(params[:data])
      @plan_actividades = PlanActividad.find_by(flujo_id: params[:flujo_id], actividad_id: params[:plan_id])
    
      rrhh_externo_ids = []  # Array para almacenar los IDs de rrhhPropioId
     
      data.each do |clave, valor|
        #if clave['hh'] != ""
          if clave['nombreUsuario'] != ""
            custom_params = {
              recursos: {
                hh: clave['hh'],
                equipo_trabajo_id: clave['rrhhExternoId'],
                flujo_id: params[:flujo_id],
                plan_actividad_id: @plan_actividades.id,
                  tipo_aporte_id: params['tipoAporte']
                }  
              }

            if (clave['rhhEquipoId'] == "")
              #se inserta un nuevo usuario
              @recursos = RecursoHumano.new(custom_params[:recursos])
              @recursos.save 
            else
              #se actualiza un usuario
              @recursos = RecursoHumano.find_by(flujo_id: params[:flujo_id], plan_actividad_id: @plan_actividades.id, equipo_trabajo_id: clave['rrhhExternoId'])
              @recursos.update(custom_params[:recursos])
            end
      
            if (clave['hh'] == "")
              eliminar_rrhh_externos = RecursoHumano.find_by(flujo_id: params[:flujo_id], plan_actividad_id: @plan_actividades.id, equipo_trabajo_id: clave['rrhhExternoId'])
              eliminar_rrhh_externos.destroy
            else
              rrhh_externo_ids << clave['rrhhExternoId']  # Agregar el ID a la lista
            end

          end
        #end
      end
      ### Utilizar rrhh_externo_ids como necesites fuera del bucle
      @recursos_externos = PlanActividad.recursos_x_ids(params[:flujo_id], params['plan_id'], rrhh_externo_ids)

      ### se obtiene el valor de la suma de los recursos internos, externos, gastos adm y gastos ope por id y se renderiza al dashboard principal
      @valor_hh_tipos_1_2_ = PlanActividad.valor_hh_tipos_1_2_(params[:flujo_id], params['plan_id'])
      @valor_hh_tipo_3 = PlanActividad.valor_hh_tipo_3(params[:flujo_id], params['plan_id'])
      @total_gastos_tipo_1 = PlanActividad.total_gastos_tipo_1_insert(params[:flujo_id], params['plan_id'])
      @total_gastos_tipo_2 = PlanActividad.total_gastos_tipo_2_insert(params[:flujo_id], params['plan_id'])

      #Totales generales
      @total_valor_hh_tipo_3 = PlanActividad.total_valor_hh_tipo_3(params[:flujo_id])
      @total_valor_hh_tipos_1_2 = PlanActividad.total_valor_hh_tipos_1_2(params[:flujo_id])
      @total_total_gastos_tipo_1 = PlanActividad.total_total_gastos_tipo_1(params[:flujo_id])
      @total_total_gastos_tipo_2 = PlanActividad.total_total_gastos_tipo_2(params[:flujo_id])

      ###Actualiza costos
      set_costos 

      @plan_id =  params['plan_id']

      @recursos_externos_no_asignados = EquipoTrabajo.left_outer_joins(:recurso_humanos)
             .where(recurso_humanos: { equipo_trabajo_id: nil })
             .where(flujo_id: params[:flujo_id], tipo_equipo: [1,2])
     
      respond_to do |format|
        format.js { render 'insert_recursos_humanos_externos', locals: { recursos_externos: @recursos_externos, tarea_pendiente: @tarea_pendiente, plan_id: @plan_id, flujo_id: params[:flujo_id], 
        valor_hh_tipo_3: @valor_hh_tipo_3, valor_hh_tipos_1_2_: @valor_hh_tipos_1_2_, total_gastos_tipo_1: @total_gastos_tipo_1, total_gastos_tipo_2:@total_gastos_tipo_2, 
        total_valor_hh_tipo_3: @total_valor_hh_tipo_3, total_valor_hh_tipos_1_2: @total_valor_hh_tipos_1_2, total_total_gastos_tipo_1: @total_total_gastos_tipo_1, total_total_gastos_tipo_2: @total_total_gastos_tipo_2 } }
      end
    end
    
    def insert_plan_actividades
      @plan_actividades = PlanActividad.find_by(flujo_id: params[:flujo_id], actividad_id: params[:plan_id])
      @duracion_general = FondoProduccionLimpia.where(flujo_id: params['flujo_id']).first
      arreglo = []

      maximo = @duracion_general.duracion
      1.upto(maximo) do |numero|
        arreglo << numero
      end
      @duracion = arreglo

        custom_params = {
          plan_actividades: {
            duracion: params['duracion'].join(','),
            actividad_id: params['plan_id'],
            flujo_id: params['flujo_id'],
            objetivos_especifico_id: params['objetivos_especifico_id']
          }
        }
        @valida_ceros = false
        if @plan_actividades.present?
          @plan_actividades.update(custom_params[:plan_actividades])       
        else
          @plan_actividades = PlanActividad.new(custom_params[:plan_actividades])
          @plan_actividades.save
          @valida_ceros = true
        end

        #Actualiza nombre de actividad, solo para cuando sea una actividad nueva
        @tipo_permiso = @plan_actividades.actividad.actividad_por_lineas.first&.tipo_permiso if @plan_actividades.actividad.actividad_por_lineas.first&.tipo_permiso?
        @tipo_perm = 0
        if @tipo_permiso == "nueva"
          custom_params_actividades = {
            actividades: {
              nombre: params['nombre_actividad']
            }
          }
          @actividad = Actividad.find(params[:plan_id])
          @actividad.update(custom_params_actividades[:actividades])
          @nombre_actividad = params['nombre_actividad']
          @tipo_perm = 1
        end

        @plan_id = params['plan_id']
        @duracion_x = params['duracion'].join(',')
        respond_to do |format|
          format.js { render 'insert_plan_actividades', locals: { valida_ceros: @valida_ceros }}
        end
      
    end  

    def new_plan_actividades
      @fondo_produccion_limpia = FondoProduccionLimpia.where(flujo_id: params['flujo_id']).first
      arreglo = []

      if params['opcion'] == 'create'

        maximo = @fondo_produccion_limpia.duracion
        1.upto(maximo) do |numero|
          arreglo << numero
        end
        newRowDuracion = ""
        arreglo.each do |mes|  
          newRowDuracion += "<td class='sub-contenido-form'>" +
                            "<input type='checkbox' name='descripcion' class='required-field' id='#{mes}' style='border: 1px solid #ced4da; border-radius: 0.25rem;'>" +
                            "</td>"
        end
        @duracion = newRowDuracion
        respond_to do |format|
          format.js { render 'new_plan_actividades', locals: { duracion: @duracion, plan_id: params['plan_id'] } }
        end
      else
        maximo = @fondo_produccion_limpia.duracion
        1.upto(maximo) do |numero|
          arreglo << numero
        end
        @duracion = arreglo

        #inserta en tabla actividades la actividad nueva, se debe agregar un estado o ver como se identidica
        custom_params_actividades = {
          actividades: {
            nombre: params['nombre_actividad'],
            descripcion: params['nombre_actividad']
          }
        }
        
        @actividad = Actividad.new(custom_params_actividades[:actividades])
        @actividad.save

        if params['tipo_actividad_id'] == ""
          tipo_actividad = nil
        else
          tipo_actividad = params['tipo_actividad_id'].to_i
        end

        #inserta en tabla actividades la actividad_por_linea
        custom_params_actividad_por_linea = {
          actividad_por_linea: {
            actividad_id: @actividad.id,
            tipo_instrumento_id: @fondo_produccion_limpia.flujo.tipo_instrumento_id,
            tipo_permiso: 3,
            tipo_actividad: tipo_actividad
          }
        }
        @actividad_por_linea = ActividadPorLinea.new(custom_params_actividad_por_linea [:actividad_por_linea])
        @actividad_por_linea.save

        #inserta en tabla plan_actividades
        custom_params_plan_actividades = {
          plan_actividades: {
            duracion: params['duracion'].join(','),
            actividad_id: @actividad.id,
            flujo_id: params['flujo_id'],
            objetivos_especifico_id: params['objetivos_especifico_id']
          }
        }
        
        @plan_actividades = PlanActividad.new(custom_params_plan_actividades[:plan_actividades])
        @plan_actividades.save
        @solo_lectura = false                                            
        @duracion_x = params['duracion'].join(',')

        respond_to do |format|
          format.js { render js: "window.location='#{edit_fondo_produccion_limpia_path(params['tarea_pendiente_id'])}?tabs=plan-de-actividades'" }
          format.html { redirect_to edit_fondo_produccion_limpia_path(params['tarea_pendiente_id']), notice: success }
        end
      end
    end 
    
    def guardar_fondo_temporal
      respond_to do |format|
        custom_params = {
            fondo_produccion_limpia: {
              cantidad_micro_empresa: params[:cantidad_micro_empresa],
              cantidad_pequeña_empresa: params[:cantidad_pequeña_empresa],
              cantidad_mediana_empresa: params[:cantidad_mediana_empresa],
              cantidad_grande_empresa: params[:cantidad_grande_empresa],
              empresas_asociadas_ag: params[:empresas_asociadas_ag],
              empresas_no_asociadas_ag: params[:empresas_no_asociadas_ag],
              duracion: params[:duracion],
              fortalezas_consultores: normalize_string(params[:fortalezas_consultores]),
              elementos_micro_empresa: params[:elementos_micro_empresa],
              elementos_pequena_empresa: params[:elementos_pequena_empresa],
              elementos_mediana_empresa: params[:elementos_mediana_empresa],
              elementos_grande_empresa: params[:elementos_grande_empresa],
              empresas_adheridas: params[:empresas_adheridas]
            }
          }
          @fondo_produccion_limpia.update(custom_params[:fondo_produccion_limpia])

          #ingresa solo cuand el linea 1.3, para grabar empresas adheridad seleccionadas en el APL-028
          if params[:tipo_instrumento_id] == TipoInstrumento::FPL_LINEA_1_3.to_s || params[:tipo_instrumento_id] == TipoInstrumento::FPL_EXTRAPRESUPUESTARIO_EVALUACION.to_s
            obtiene_y_graba_empresas_adheridas(true)
          end

          set_flujo

          # Convierte la cadena JSON a un array de hashes
          comunas = JSON.parse(params[:comunasIds])
          
          if params[:comunasIds].present?
            # Eliminar todas las entradas para el flujo actual
            ComunasFlujo.where(flujo_id: @flujo.id).destroy_all
            
            # Recorre el array de comunas
            comunas = JSON.parse(params[:comunasIds]) # Asegúrate de parsear el JSON aquí
            comunas.each do |comuna|
              tipo = comuna["tipo"]
              
              if tipo == 'región'
                region_id = comuna["id"]
                # Busca o crea la región
                region = Region.find_or_create_by(id: region_id) do |r|
                  r.nombre = comuna["nombre"] # Ajusta según tu modelo
                end
                
                # Almacena las comunas de esta región en ComunasFlujo
                region.comunas.each do |comuna_de_region|
                  comuna_flujo = ComunasFlujo.new(comuna_id: comuna_de_region.id, flujo_id: @flujo.id)
                  if comuna_flujo.save
                    puts "Comuna de región guardada: #{comuna_de_region.id} en flujo #{@flujo.id}"
                  else
                    puts "Error al guardar comuna de región: #{comuna_flujo.errors.full_messages.join(', ')}"
                  end
                end
          
              elsif tipo == 'provincia'
                provincia_id = comuna["id"]
                # Busca o crea la provincia
                provincia = Provincia.find_or_create_by(id: provincia_id) do |p|
                  p.nombre = comuna["nombre"] # Ajusta según tu modelo
                end
                
                # Almacena las comunas de esta provincia en ComunasFlujo
                provincia.comunas.each do |comuna_de_provincia|
                  comuna_flujo = ComunasFlujo.new(comuna_id: comuna_de_provincia.id, flujo_id: @flujo.id)
                  if comuna_flujo.save
                    puts "Comuna de provincia guardada: #{comuna_de_provincia.id} en flujo #{@flujo.id}"
                  else
                    puts "Error al guardar comuna de provincia: #{comuna_flujo.errors.full_messages.join(', ')}"
                  end
                end
          
              elsif tipo == 'comuna'
                comuna_id = comuna["id"]
                comuna_flujo = ComunasFlujo.new(comuna_id: comuna_id, flujo_id: @flujo.id)
                if comuna_flujo.save
                  puts "Comuna guardada: #{comuna_id} en flujo #{@flujo.id}"
                else
                  puts "Error al guardar comuna: #{comuna_flujo.errors.full_messages.join(', ')}"
                end
              end
            end
          else
            # Si no se seleccionó ninguna comuna, eliminar todas las que correspondan al flujo_id
            ComunasFlujo.where(flujo_id: @flujo.id).destroy_all 
            puts "No se seleccionó ninguna comuna"
          end
          
          flash[:success] = 'Datos guardados correctamente'
          format.js { render js: "window.location='#{edit_fondo_produccion_limpia_path(@tarea_pendiente.id)}'" }
          format.html { redirect_to edit_fondo_produccion_limpia_path(@tarea_pendiente.id), notice: success }  
        end
    end

    def subir_documento
      nombre_campo = params[:nombre_campo]
      archivo = params[:archivo]
    
      unless valid_extensions?(archivo)
        respond_to do |format|
          format.json { render json: { error: 'La extensión del archivo no es válida. Las extensiones permitidas son: pdf, jpg, png, tiff, zip, rar, doc y docx.' }, status: :unprocessable_entity }
          format.html { redirect_to edit_fondo_produccion_limpia_path(@tarea_pendiente.id), alert: "La extensión del archivo no es válida." }
        end
        return
      end
    
      custom_params = {
        fondo_produccion_limpia: {
          nombre_campo => archivo
        }
      }
    
      if @fondo_produccion_limpia.update(custom_params[:fondo_produccion_limpia])
        respond_to do |format|
          format.json { render json: { success: true, message: 'Archivo subido correctamente.' } }
        end
      else
        respond_to do |format|
          format.json { render json: { error: 'No se pudo actualizar el archivo.' }, status: :unprocessable_entity }
        end
      end
    end     

    def enviar_postulacion
      respond_to do |format|
        #SE CREA FPL-02 Y SE LE ENVIA A TODOS LOS JEFES DE LINEA
        jefes_de_linea = Responsable::__personas_responsables(Rol::JEFE_DE_LINEA, 11) 
        jefes_de_linea.each do |responsable|
          tarea_fondo = Tarea.find_by_codigo(Tarea::COD_FPL_02)
          custom_params_tarea_pendiente = {
            tarea_pendientes: {
              flujo_id: @flujo.id,
              tarea_id: tarea_fondo.id,
              estado_tarea_pendiente_id: EstadoTareaPendiente::NO_INICIADA,
              user_id: responsable.user_id,
              persona_id: responsable.id,
              data: { }
            }
          }
          TareaPendiente.new(custom_params_tarea_pendiente[:tarea_pendientes]).save
          #SE ENVIAR EL MAIL AL RESPONSABLE
          mdi = @manifestacion_de_interes
          send_message(tarea_fondo, responsable.user_id)
        end  

        #SE CAMBIA EL ESTADO DEL FPL-01 A 2
        tarea_fondo_FPL_01 = Tarea.find_by_codigo(Tarea::COD_FPL_01)
        tarea_pendiente_FPL_01 = TareaPendiente.find_by(tarea_id: tarea_fondo_FPL_01.id, flujo_id: @flujo.id)

        tarea_pendiente_FPL_01.estado_tarea_pendiente_id = EstadoTareaPendiente::ENVIADA
        tarea_pendiente_FPL_01.save  

        msj = 'Postulación a Fondo de Producción Limpia enviada correctamente'
        format.js { flash.now[:success] = msj
          render js: "window.location='#{root_path}'"}
        format.html { redirect_to root_path, flash: {notice: msj }}
      end
    end

    def get_sub_lineas_seleccionadas
      @sub_lineas = SubLinea.where(linea_id: params[:id])
      respond_to do |format|
        format.json { render json: { sublineas: @sub_lineas } }
      end
    end
  
    def revisor #TAREA FPL-02  
      @recuerde_guardar_minutos = FondoProduccionLimpia::MINUTOS_MENSAJE_GUARDAR #DZC 2019-04-04 18:33:08 corrige requerimiento 2019-04-03
      @revisores_juridicos = Responsable.__personas_responsables(Rol::REVISOR_JURIDICO, TipoInstrumento.find_by(nombre: 'Fondo de Producción Limpia').id)
      @revisores_financieros = Responsable.__personas_responsables(Rol::REVISOR_FINANCIERO, TipoInstrumento.find_by(nombre: 'Fondo de Producción Limpia').id)
      @revisores_tecnicos = Responsable.__personas_responsables(Rol::REVISOR_TECNICO, TipoInstrumento.find_by(nombre: 'Fondo de Producción Limpia').id)
      @revisor = true
      @adm_juridica = false

      #Obtenie empresas adheridas Linea 1.3
      if @flujo.tipo_instrumento_id == TipoInstrumento::FPL_LINEA_1_3 || @flujo.tipo_instrumento_id == TipoInstrumento::FPL_EXTRAPRESUPUESTARIO_EVALUACION
        obtiene_y_graba_empresas_adheridas(false)
      end

      #Carga tabs de postulación
      set_equipo_trabajo
      set_actividades_x_linea
      set_plan_actividades
      set_costos 

      @solo_lectura = true
    end

    def get_revisor
      @solo_lectura = true
      @revisor = true

      year = Date.today.year.to_s
      correlativo = Correlativo.obtener_correlativo 
      linea = ''
      if @fondo_produccion_limpia.flujo.tipo_instrumento_id == TipoInstrumento::FPL_LINEA_1_1 || @fondo_produccion_limpia.flujo.tipo_instrumento_id == TipoInstrumento::FPL_LINEA_5_1
        linea = TipoInstrumento::L1
      else
        linea = TipoInstrumento::L5
      end

      #Se concatenan las variables para formar el codigo del proyecto
      @codigo_proyecto = linea + "-" + correlativo + "/" + year
      
      @objetivo_especificos = ObjetivosEspecifico.where(flujo_id: @tarea_pendiente.flujo_id).all
      @postulantes = EquipoTrabajo.where(flujo_id: @tarea_pendiente.flujo_id, tipo_equipo: 3)
      @consultores = EquipoTrabajo.where(flujo_id: @tarea_pendiente.flujo_id, tipo_equipo:[1,2])
      @empresas = EquipoEmpresa.where(flujo_id: @tarea_pendiente.flujo_id)
      @actividades = Actividad.actividad_x_linea(@tarea_pendiente.flujo_id, @tarea_pendiente.flujo.tipo_instrumento_id)
      
      respond_to do |format|
        format.js { render 'get_revisor', locals: { objetivo_especificos: @objetivo_especificos, postulantes: @postulantes, consultores: @consultores, empresas: @empresas, actividades: @actividades, codigo_proyecto: @codigo_proyecto} }
      end
    end

    def asignar_revisor #TAREA FPL-02
      @revisor = true
    
      respond_to do |format|
        custom_params = {
          fondo_produccion_limpia: {
            codigo_proyecto: params[:codigo_proyecto],
            revisor_tecnico_id: params[:revisor_tecnico_id],
            revisor_financiero_id: params[:revisor_financiero_id],
            revisor_juridico_id: params[:revisor_juridico_id],
            comentario_asignar_revisor: normalize_string(params[:comentario_asignar_revisor])
          }
        }

        if @fondo_produccion_limpia.update(custom_params[:fondo_produccion_limpia])
          mapa = MapaDeActor.find_or_create_by({
            flujo_id: @tarea_pendiente.flujo_id,
            rol_id: Rol::REVISOR_TECNICO, 
            persona_id: Persona.find_by(user_id: params[:revisor_tecnico_id]).id
          })
          mapa = MapaDeActor.find_or_create_by({
            flujo_id: @tarea_pendiente.flujo_id,
            rol_id: Rol::REVISOR_FINANCIERO,
            persona_id: Persona.find_by(user_id: params[:revisor_financiero_id]).id
          })
          mapa = MapaDeActor.find_or_create_by({
            flujo_id: @tarea_pendiente.flujo_id,
            rol_id: Rol::REVISOR_JURIDICO,
            persona_id: Persona.find_by(user_id: params[:revisor_juridico_id]).id
          })          
          mapa = MapaDeActor.find_or_create_by({
            flujo_id: @tarea_pendiente.flujo_id,
            rol_id: Rol::JEFE_DE_LINEA, 
            persona_id: @tarea_pendiente.persona_id
          })

          #SE CREA FPL-03
          tarea_fondo_FPL_03 = Tarea.find_by_codigo(Tarea::COD_FPL_03)
          custom_params_tarea_pendiente_FPL_03 = {
            tarea_pendientes: {
              flujo_id: @flujo.id,
              tarea_id: tarea_fondo_FPL_03.id,
              estado_tarea_pendiente_id: EstadoTareaPendiente::NO_INICIADA,
              user_id: params[:revisor_financiero_id],
              data: { }
            }
          }
          TareaPendiente.new(custom_params_tarea_pendiente_FPL_03[:tarea_pendientes]).save

          #SE ENVIAR EL MAIL AL RESPONSABLE
          mdi = @manifestacion_de_interes
          send_message(tarea_fondo_FPL_03, params[:revisor_financiero_id])

          #SE CREA FPL-04
          tarea_fondo_FPL_04 = Tarea.find_by_codigo(Tarea::COD_FPL_04)
          custom_params_tarea_pendiente_FPL_04 = {
            tarea_pendientes: {
              flujo_id: @flujo.id,
              tarea_id: tarea_fondo_FPL_04.id,
              estado_tarea_pendiente_id: EstadoTareaPendiente::NO_INICIADA,
              user_id: params[:revisor_tecnico_id],
              data: { }
            }
          }
          TareaPendiente.new(custom_params_tarea_pendiente_FPL_04[:tarea_pendientes]).save

          #SE ENVIAR EL MAIL AL RESPONSABLE
          mdi = @manifestacion_de_interes
          send_message(tarea_fondo_FPL_04, params[:revisor_tecnico_id])

          #SE CREA FPL-05
          tarea_fondo_FPL_05 = Tarea.find_by_codigo(Tarea::COD_FPL_05)
          custom_params_tarea_pendiente_FPL_05 = {
            tarea_pendientes: {
              flujo_id: @flujo.id,
              tarea_id: tarea_fondo_FPL_05.id,
              estado_tarea_pendiente_id: EstadoTareaPendiente::NO_INICIADA,
              user_id: params[:revisor_juridico_id],
              data: { }
            }
          }
          TareaPendiente.new(custom_params_tarea_pendiente_FPL_05[:tarea_pendientes]).save

          #SE ENVIAR EL MAIL AL RESPONSABLE
          mdi = @manifestacion_de_interes
          send_message(tarea_fondo_FPL_05, params[:revisor_juridico_id])

          #SE CAMBIA EL ESTADO DEL FPL-02 A 2
          tarea_fondo = Tarea.find_by_codigo(Tarea::COD_FPL_02)
          jefes_de_linea_fpl = Responsable::__personas_responsables(Rol::JEFE_DE_LINEA, 11) 
          
          jefes_de_linea_fpl.each do |responsable|
            tarea_pendiente = TareaPendiente.find_by(tarea_id: tarea_fondo.id, flujo_id: @flujo.id, user_id: responsable.user_id)
            
            if tarea_pendiente.present?
              tarea_pendiente.estado_tarea_pendiente_id = EstadoTareaPendiente::ENVIADA
              tarea_pendiente.save  
            end
          end   

          msj = 'Revisores asignados correctamente'
          format.js { flash.now[:success] = msj
            render js: "window.location='#{root_path}'"}
          format.html { redirect_to root_path, flash: {notice: msj }}
        end
      end
    end

    def new_cuestionario_fpl
      @cuestionario_fpl = CuestionarioFpl.new
      respond_to do |format|
        format.html
        format.js
      end
    end

    def get_admisibilidad_financiera #TAREA FPL-03

      @cuestionario_fpl = CuestionarioFpl.where(flujo_id: @tarea_pendiente.flujo_id, tipo_cuestionario_id: 1).order(:criterio_id)
      
      respond_to do |format|
        format.js { render 'get_admisibilidad_financiera', locals: { cuestionario_fpl: @cuestionario_fpl } }
      end
      
    end
  
    def admisibilidad #TAREA FPL-03
      @recuerde_guardar_minutos = ManifestacionDeInteres::MINUTOS_MENSAJE_GUARDAR #DZC 2019-04-04 18:33:08 corrige requerimiento 2019-04-03

      @manifestacion_de_interes.temp_siguientes = "true"
      @manifestacion_de_interes.seleccion_de_radios

      @admisibilidad = true
      @solo_lectura = true
      @adm_juridica = false

      #Obtenie empresas adheridas Linea 1.3
      if @flujo.tipo_instrumento_id == TipoInstrumento::FPL_LINEA_1_3 || @flujo.tipo_instrumento_id == TipoInstrumento::FPL_EXTRAPRESUPUESTARIO_EVALUACION
        obtiene_y_graba_empresas_adheridas(false)
      end

      #Carga tabs de postulación
      set_equipo_trabajo
      set_actividades_x_linea
      set_plan_actividades
      set_costos 
    end

    def revisar_admisibilidad  #TAREA FPL-003
      jsonData = params['jsonData']

      jsonData.each do |key, value|
        custom_params = {
          cuestionario_fpl: {
            flujo_id: params['flujo_id'],
            criterio_id: value['criterio_id'],
            nota: value['nota'],
            justificacion: normalize_string(value['justificacion']),
            tipo_cuestionario_id: 1
          }
        }
        
        @cuestionario_fpl = CuestionarioFpl.where(flujo_id: params[:flujo_id], criterio_id: value['criterio_id'], tipo_cuestionario_id: 1).order(:criterio_id)
        if @cuestionario_fpl.present?
          @cuestionario_fpl.update(custom_params[:cuestionario_fpl])
        else
          @cuestionario_fpl = CuestionarioFpl.new(custom_params[:cuestionario_fpl])
          @cuestionario_fpl.save
        end
      end
      respond_to do |format|
        flash[:success] = 'Datos guardados correctamente'
        format.js { render js: "window.location='#{admisibilidad_fondo_produccion_limpia_path(@tarea_pendiente.id)}'" }
        format.html { redirect_to admisibilidad_fondo_produccion_limpia_path(@tarea_pendiente.id), notice: success }
      end
    end

    def enviar_admisibilidad_financiera  #TAREA FPL-003
      jsonData = params['jsonData']

      jsonData.each do |key, value|
        custom_params = {
          cuestionario_fpl: {
            flujo_id: params['flujo_id'],
            criterio_id: value['criterio_id'],
            nota: value['nota'],
            justificacion: normalize_string(value['justificacion']),
            tipo_cuestionario_id: 1,
            revision: 1
          }
        }
        
        @cuestionario_fpl = CuestionarioFpl.where(flujo_id: params[:flujo_id], criterio_id: value['criterio_id'], tipo_cuestionario_id: 1).order(:criterio_id)
        if @cuestionario_fpl.present?
          @cuestionario_fpl.update(custom_params[:cuestionario_fpl])
        else
          @cuestionario_fpl = CuestionarioFpl.new(custom_params[:cuestionario_fpl])
          @cuestionario_fpl.save
        end
      end

      #consulta si FPL_04 existe en estado enviada
      tarea_fondo_fpl_04 = Tarea.find_by_codigo(Tarea::COD_FPL_04)
      tarea_pendiente_fpl_04 = TareaPendiente.where(tarea_id: tarea_fondo_fpl_04.id, flujo_id: @tarea_pendiente.flujo_id).last
         
      
      #SE CAMBIA EL ESTADO DEL FPL-03 A 2
      tarea_fondo_fpl_03 = Tarea.find_by_codigo(Tarea::COD_FPL_03)
      tarea_pendiente_fpl_03 = TareaPendiente.where(tarea_id: tarea_fondo_fpl_03.id, flujo_id: @tarea_pendiente.flujo_id, user_id: @tarea_pendiente.user_id).last
      if tarea_pendiente_fpl_03.present?
        tarea_pendiente_fpl_03.estado_tarea_pendiente_id = EstadoTareaPendiente::ENVIADA
        tarea_pendiente_fpl_03.save  
      end

      #SE CREA FPL-06
      if tarea_pendiente_fpl_04.estado_tarea_pendiente_id == 2
        #obtengo el usuario del jefe de linea
        mapa = MapaDeActor.where(flujo_id: @tarea_pendiente.flujo_id,rol_id: Rol::JEFE_DE_LINEA)
 
        #obtengo el user_id del jefe de linea
        tarea_fondo = Tarea.find_by_codigo(Tarea::COD_FPL_02)
        tarea_pendiente_jefe_de_linea = TareaPendiente.where(tarea_id: tarea_fondo.id, flujo_id: @tarea_pendiente.flujo_id, persona_id: mapa.first.persona_id).last

    
        tarea_fondo = Tarea.find_by_codigo(Tarea::COD_FPL_06)
        custom_params_tarea_pendiente = {
          tarea_pendientes: {
            flujo_id: @flujo.id,
            tarea_id: tarea_fondo.id,
            estado_tarea_pendiente_id: EstadoTareaPendiente::NO_INICIADA,
            user_id: tarea_pendiente_jefe_de_linea.user_id,
            persona_id: tarea_pendiente_jefe_de_linea.persona_id,
            data: { }
          }
        }
        TareaPendiente.new(custom_params_tarea_pendiente[:tarea_pendientes]).save

        #SE ENVIAR EL MAIL AL RESPONSABLE
        mdi = @manifestacion_de_interes
        send_message(tarea_fondo, tarea_pendiente_jefe_de_linea.user_id)
      end
  
      respond_to do |format|
        flash[:success] = 'Admisibilidad Financiera enviada correctamente'
        format.js { render js: "window.location='#{root_path}'" }
        format.html { redirect_to root_path, notice: success }
      end
    end

    def get_admisibilidad_tecnica #TAREA FPL-04
      @cuestionario_fpl = CuestionarioFpl.where(flujo_id: @tarea_pendiente.flujo_id, tipo_cuestionario_id: 2).order(:criterio_id)
      respond_to do |format|
        format.js { render 'get_admisibilidad_tecnica', locals: { cuestionario_fpl: @cuestionario_fpl } }
      end
    end

    def admisibilidad_tecnica #TAREA FPL-04
      @recuerde_guardar_minutos = ManifestacionDeInteres::MINUTOS_MENSAJE_GUARDAR #DZC 2019-04-04 18:33:08 corrige requerimiento 2019-04-03
      @solo_lectura = true
      @adm_juridica = false

      #Obtenie empresas adheridas Linea 1.3
      if @flujo.tipo_instrumento_id == TipoInstrumento::FPL_LINEA_1_3 || @flujo.tipo_instrumento_id == TipoInstrumento::FPL_EXTRAPRESUPUESTARIO_EVALUACION
        obtiene_y_graba_empresas_adheridas(false)
      end

      set_equipo_trabajo
      set_actividades_x_linea
      set_plan_actividades
      set_costos 
    end

    def revisar_admisibilidad_tecnica  #TAREA FPL-004
      jsonData = params['jsonData']

      jsonData.each do |key, value|
        custom_params = {
          cuestionario_fpl: {
            flujo_id: params['flujo_id'],
            criterio_id: value['criterio_id'],
            nota: value['nota'],
            justificacion: normalize_string(value['justificacion']),
            tipo_cuestionario_id: 2
          }
        }

        @cuestionario_fpl = CuestionarioFpl.where(flujo_id: params[:flujo_id], criterio_id: value['criterio_id'], tipo_cuestionario_id: 2).order(:criterio_id)
        if @cuestionario_fpl.present?
          @cuestionario_fpl.update(custom_params[:cuestionario_fpl])
        else
          @cuestionario_fpl = CuestionarioFpl.new(custom_params[:cuestionario_fpl])
          @cuestionario_fpl.save
        end
      end
      respond_to do |format|
        flash[:success] = 'Datos guardados correctamente'
        format.js { render js: "window.location='#{admisibilidad_tecnica_fondo_produccion_limpia_path(@tarea_pendiente.id)}'" }
        format.html { redirect_to admisibilidad_tecnica_fondo_produccion_limpia_path(@tarea_pendiente.id), notice: success }
      end
    end

    def enviar_admisibilidad_tecnica
      jsonData = params['jsonData']

      jsonData.each do |key, value|
        custom_params = {
          cuestionario_fpl: {
            flujo_id: params['flujo_id'],
            criterio_id: value['criterio_id'],
            nota: value['nota'],
            justificacion: normalize_string(value['justificacion']),
            tipo_cuestionario_id: 2,
            revision: 1
          }
        }

        @cuestionario_fpl = CuestionarioFpl.where(flujo_id: params[:flujo_id], criterio_id: value['criterio_id'], tipo_cuestionario_id: 2).order(:criterio_id)
        if @cuestionario_fpl.present?
          @cuestionario_fpl.update(custom_params[:cuestionario_fpl])
        else
          @cuestionario_fpl = CuestionarioFpl.new(custom_params[:cuestionario_fpl])
          @cuestionario_fpl.save
        end        
      end

      #consulta si FPL_03 existe en estado enviada
      tarea_fondo_fpl_03 = Tarea.find_by_codigo(Tarea::COD_FPL_03)
      tarea_pendiente_fpl_03 = TareaPendiente.where(tarea_id: tarea_fondo_fpl_03.id, flujo_id: @tarea_pendiente.flujo_id).last
      
      #SE CAMBIA EL ESTADO DEL FPL-04 A 2
      tarea_fondo_fpl_04 = Tarea.find_by_codigo(Tarea::COD_FPL_04)
      tarea_pendiente_fpl_04 = TareaPendiente.where(tarea_id: tarea_fondo_fpl_04.id, flujo_id: @tarea_pendiente.flujo_id, user_id: @tarea_pendiente.user_id).last
     
      if tarea_pendiente_fpl_04.present?
        tarea_pendiente_fpl_04.estado_tarea_pendiente_id = EstadoTareaPendiente::ENVIADA
        tarea_pendiente_fpl_04.save  
      end

      #SE CREA FPL-06
      if tarea_pendiente_fpl_03.estado_tarea_pendiente_id == 2
        #obtengo el usuario del jefe de linea
        mapa = MapaDeActor.where(flujo_id: @tarea_pendiente.flujo_id,rol_id: Rol::JEFE_DE_LINEA)

        #obtengo el user_id del jefe de linea
        tarea_fondo = Tarea.find_by_codigo(Tarea::COD_FPL_02)
        tarea_pendiente_jefe_de_linea = TareaPendiente.where(tarea_id: tarea_fondo.id, flujo_id: @tarea_pendiente.flujo_id, persona_id: mapa.first.persona_id).last

        tarea_fondo = Tarea.find_by_codigo(Tarea::COD_FPL_06)
        custom_params_tarea_pendiente = {
          tarea_pendientes: {
            flujo_id: @flujo.id,
            tarea_id: tarea_fondo.id,
            estado_tarea_pendiente_id: EstadoTareaPendiente::NO_INICIADA,
            user_id: tarea_pendiente_jefe_de_linea.user_id,
            persona_id: tarea_pendiente_jefe_de_linea.persona_id,
            data: { }
          }
        }
        TareaPendiente.new(custom_params_tarea_pendiente[:tarea_pendientes]).save

        #SE ENVIAR EL MAIL AL RESPONSABLE
        mdi = @manifestacion_de_interes
        send_message(tarea_fondo, tarea_pendiente_jefe_de_linea.user_id)
      end

      respond_to do |format|
        flash[:success] = 'Admisibilidad Técnica enviada correctamente'
        format.js { render js: "window.location='#{root_path}'" }
        format.html { redirect_to root_path, notice: success }
      end
    end  

    def get_admisibilidad_juridica #TAREA FPL-05
      @cuestionario_fpl = CuestionarioFpl.where(flujo_id: @tarea_pendiente.flujo_id, tipo_cuestionario_id: 3).order(:criterio_id)
      respond_to do |format|
        format.js { render 'get_admisibilidad_juridica', locals: { cuestionario_fpl: @cuestionario_fpl } }
      end
    end
  
    def admisibilidad_juridica #TAREA FPL-05
      @recuerde_guardar_minutos = ManifestacionDeInteres::MINUTOS_MENSAJE_GUARDAR #DZC 2019-04-04 18:33:08 corrige requerimiento 2019-04-03
      @manifestacion_de_interes.seleccion_de_radios
      @solo_lectura = true
      @adm_juridica = false

      #Obtenie empresas adheridas Linea 1.3
      if @flujo.tipo_instrumento_id == TipoInstrumento::FPL_LINEA_1_3 || @flujo.tipo_instrumento_id == TipoInstrumento::FPL_EXTRAPRESUPUESTARIO_EVALUACION
        obtiene_y_graba_empresas_adheridas(false)
      end

      #Carga tabs de postulación
      set_equipo_trabajo
      set_actividades_x_linea
      set_plan_actividades
      set_costos 
      set_descargables
    end
  
    def revisar_admisibilidad_juridica  #TAREA FPL-05
      jsonData = params['jsonData']

      jsonData.each do |key, value|
        revision = nil
        justificacion = nil
        if value['nota'] == '2'
          revision = 3
          justificacion = normalize_string(value['justificacion'])
        end
        custom_params = {
          cuestionario_fpl: {
            flujo_id: params['flujo_id'],
            criterio_id: value['criterio_id'],
            nota: value['nota'],
            justificacion: justificacion,
            tipo_cuestionario_id: 3,
            revision: revision
          }
        }

        @cuestionario_fpl = CuestionarioFpl.where(flujo_id: params[:flujo_id], criterio_id: value['criterio_id'], tipo_cuestionario_id: 3).order(:criterio_id)
        if @cuestionario_fpl.present?
          @cuestionario_fpl.update(custom_params[:cuestionario_fpl])
        else
          @cuestionario_fpl = CuestionarioFpl.new(custom_params[:cuestionario_fpl])
          @cuestionario_fpl.save
        end  
      end  
      respond_to do |format|
        flash[:success] = 'Datos guardados correctamente'
        format.js { render js: "window.location='#{admisibilidad_juridica_fondo_produccion_limpia_path(@tarea_pendiente.id)}'" }
        format.html { redirect_to admisibilidad_juridica_fondo_produccion_limpia_path(@tarea_pendiente.id), notice: success }
      end
    end

    def enviar_admisibilidad_juridica  #TAREA FPL-05
      jsonData = params['jsonData']

      jsonData.each do |key, value|
        revision = nil
        justificacion = nil
        if value['nota'] == '2'
          revision = 3
          justificacion = normalize_string(value['justificacion'])
        else
          revision = 1 
        end
        custom_params = {
          cuestionario_fpl: {
            flujo_id: params['flujo_id'],
            criterio_id: value['criterio_id'],
            nota: value['nota'],
            justificacion: justificacion,
            tipo_cuestionario_id: 3,
            revision: revision
          }
        }
        @cuestionario_fpl = CuestionarioFpl.where(flujo_id: params[:flujo_id], criterio_id: value['criterio_id'], tipo_cuestionario_id: 3).order(:criterio_id)
        if @cuestionario_fpl.present?
          @cuestionario_fpl.update(custom_params[:cuestionario_fpl])
        else
          @cuestionario_fpl = CuestionarioFpl.new(custom_params[:cuestionario_fpl])
          @cuestionario_fpl.save
        end  
        
      end

      #CONSULTA SI EXISTE ALGUN CUESTIONARIO RECHAZADO O CON OBSERVACIONES
      #EL CODIGO 1 REPRESENTA APROBADO
      #EL CODIGO 2 REPRESENTA CON OBSERVACION
      #EL CODIGO 3 REPRESENTA RECHAZO
      #EL CODIGO 4 REPRESENTA CON OBSERVACION SEGUNDA ITERACION Y FINAL

      #CONSULTA SOBRE LOS CUESTIONARIOS APROBADOS
      cuestionario_fpl_rechazado_jur = CuestionarioFpl.where(flujo_id: params[:flujo_id], revision: [2,3]).group(:tipo_cuestionario_id).count
      cuestionario_fpl_aprobados = CuestionarioFpl.where(flujo_id: params[:flujo_id], revision: 1).group(:tipo_cuestionario_id).count
  
      #SE CAMBIA EL ESTADO DEL FPL-05 A 2
      tarea_fondo_fpl_05 = Tarea.find_by_codigo(Tarea::COD_FPL_05)
      tarea_pendiente_fpl_05 = TareaPendiente.where(tarea_id: tarea_fondo_fpl_05.id, flujo_id: @tarea_pendiente.flujo_id, user_id: @tarea_pendiente.user_id).last

      if tarea_pendiente_fpl_05.present?
        tarea_pendiente_fpl_05.estado_tarea_pendiente_id = EstadoTareaPendiente::ENVIADA
        tarea_pendiente_fpl_05.save  
      end

      #SE CREA FPL-10 
      if cuestionario_fpl_aprobados.count  >= 3 && (cuestionario_fpl_rechazado_jur[3] == 0 || cuestionario_fpl_rechazado_jur[3] == nil)
        #obtengo el usuario del jefe de linea
        #PASA AL PASO FPL-10, CONSULTAR SI LA ADMISIBILIDAD JURIDICA ESTE APROBADA
        tarea_fondo = Tarea.find_by_codigo(Tarea::COD_FPL_06)
        existe_fpl_06 = TareaPendiente.where(tarea_id: tarea_fondo.id, flujo_id: @tarea_pendiente.flujo_id, estado_tarea_pendiente_id: 1).last

        if existe_fpl_06.present?
        else
          mapa = MapaDeActor.where(flujo_id: @tarea_pendiente.flujo_id,rol_id: Rol::JEFE_DE_LINEA)
          #obtengo el user_id del jefe de linea
          tarea_fondo = Tarea.find_by_codigo(Tarea::COD_FPL_02)
          tarea_pendiente_jefe_de_linea = TareaPendiente.where(tarea_id: tarea_fondo.id, flujo_id: @tarea_pendiente.flujo_id, persona_id: mapa.last.persona_id).last

          tarea_fondo = Tarea.find_by_codigo(Tarea::COD_FPL_10)
          custom_params_tarea_pendiente = {
            tarea_pendientes: {
              flujo_id: @flujo.id,
              tarea_id: tarea_fondo.id,
              estado_tarea_pendiente_id: EstadoTareaPendiente::NO_INICIADA,
              user_id: tarea_pendiente_jefe_de_linea.user_id,
              persona_id: tarea_pendiente_jefe_de_linea.persona_id,
              data: { }
            }
          }
          TareaPendiente.new(custom_params_tarea_pendiente[:tarea_pendientes]).save

          #SE ENVIAR EL MAIL AL RESPONSABLE
          mdi = @manifestacion_de_interes
          send_message(tarea_fondo, tarea_pendiente_jefe_de_linea.user_id)
        end
      else
        #consulto si la admisibilidad juridica es distinto a 0 se devuelve la evaluacion al postulante FPL-009, y el postulante debe corregir y volver a enviar al FPL-05
        if cuestionario_fpl_rechazado_jur[3] != nil && cuestionario_fpl_rechazado_jur[3] != 0 
          #OBTENGO USER_ID DEL POSTULANTE
          @fondo_produccion_limpia = FondoProduccionLimpia.find(@flujo.fondo_produccion_limpia_id)
          manifestacion_de_interes_id = Flujo.find(@fondo_produccion_limpia.flujo_apl_id)
          manifestacion_de_interes = ManifestacionDeInteres.find(manifestacion_de_interes_id.manifestacion_de_interes_id)

          mapa = MapaDeActor.where(flujo_id: @tarea_pendiente.flujo_id,rol_id: Rol::PROPONENTE)
          tarea_fondo = Tarea.find_by_codigo(Tarea::COD_FPL_01)
          tarea_pendiente_postulante = TareaPendiente.find_by(tarea_id: tarea_fondo.id, flujo_id: @tarea_pendiente.flujo_id, persona_id: mapa.last.persona_id)

          ##GENERA FOTO CON ENCUESTA
          tarea_fondo = Tarea.find_by_codigo(Tarea::COD_FPL_05)
          revision = TareaPendiente.where(tarea_id: tarea_fondo.id, flujo_id: @tarea_pendiente.flujo_id).count
        
          tipo_contribuyente_id = TipoContribuyente.tipo_contribuyente_id_postulante(@tarea_pendiente.flujo_id)  
          tipo_instrumento = obtiene_nombre_tipo_instrumento(@flujo.tipo_instrumento_id)
          pdf = @fondo_produccion_limpia.generar_admisibilidad_juridica_pdf(revision, @tarea_pendiente.flujo_id, tipo_contribuyente_id[:tipo_contribuyente_id], @fondo_produccion_limpia, manifestacion_de_interes, tipo_instrumento)

          #SE CREA TAREA PARA RESOLVER OBSERVACIONES JURIDICAS
            tarea_fondo = Tarea.find_by_codigo(Tarea::COD_FPL_09)
              custom_params_tarea_pendiente = {
                tarea_pendientes: {
                  flujo_id: @flujo.id,
                  tarea_id: tarea_fondo.id,
                  estado_tarea_pendiente_id: EstadoTareaPendiente::NO_INICIADA,
                  user_id: tarea_pendiente_postulante.user_id,
                  persona_id: tarea_pendiente_postulante.persona_id,
                  data: { }
              }
            }

            TareaPendiente.new(custom_params_tarea_pendiente[:tarea_pendientes]).save

            #SE ENVIAR EL MAIL AL RESPONSABLE
            mdi = @manifestacion_de_interes
            send_message(tarea_fondo, tarea_pendiente_postulante.user_id)
        end
      end
      respond_to do |format|
        flash[:success] = 'Admisibilidad Jurídica enviada correctamente'
        format.js { render js: "window.location='#{root_path}'" }
        format.html { redirect_to root_path, notice: success }
      end
    end

    def get_pertinencia_factibilidad #TAREA FPL-06 paso 2
      @cuestionario_pert_financiera_fpl = CuestionarioFpl.where(flujo_id: @tarea_pendiente.flujo_id, tipo_cuestionario_id: 1).order(:criterio_id)
      @cuestionario_pert_tecnica_fpl = CuestionarioFpl.where(flujo_id: @tarea_pendiente.flujo_id, tipo_cuestionario_id: 2).order(:criterio_id)
      @cuestionario_obs_fpl = CuestionarioFpl.where(flujo_id: @tarea_pendiente.flujo_id, tipo_cuestionario_id: 4).order(:criterio_id).first

      respond_to do |format|
        format.js { render 'get_pertinencia_factibilidad', locals: { cuestionario_pert_financiera_fpl: @cuestionario_pert_financiera_fpl ,cuestionario_pert_tecnica_fpl: @cuestionario_pert_tecnica_fpl, cuestionario_obs_fpl: @cuestionario_obs_fpl} }
      end
    end

    def pertinencia_factibilidad #TAREA FPL-06  paso 1
      @recuerde_guardar_minutos = ManifestacionDeInteres::MINUTOS_MENSAJE_GUARDAR #DZC 2019-04-04 18:33:08 corrige requerimiento 2019-04-03
      @manifestacion_de_interes.seleccion_de_radios
      @solo_lectura = true
      @adm_juridica = false

      #Obtenie empresas adheridas Linea 1.3
      if @flujo.tipo_instrumento_id == TipoInstrumento::FPL_LINEA_1_3 || @flujo.tipo_instrumento_id == TipoInstrumento::FPL_EXTRAPRESUPUESTARIO_EVALUACION
        obtiene_y_graba_empresas_adheridas(false)
      end

      #Carga tabs de postulación
      set_equipo_trabajo
      set_actividades_x_linea
      set_plan_actividades
      set_costos 
      set_comentarios
    end

    def revisar_pertinencia_factibilidad
      case params[:nota_input_pertinencia]
      when "1"
        revision = 1
      when "2"
        revision = 2
      when "3"
        revision = 3
      end

      #GUARDA CORRECCIONES Y OBSERVACIONES ADMISIBILIDAD TECNICA
      jsonDataFinanciera = params['jsonDataFinanciera']
      jsonDataFinanciera.each do |key, value|
        custom_params = {
          cuestionario_fpl: {
            flujo_id: params['flujo_id'],
            criterio_id: value['criterio_id'],
            nota: value['nota'],
            justificacion: normalize_string(value['justificacion']),
            tipo_cuestionario_id: 1,
            revision: revision
            
          }
        }
        
        @cuestionario_financiero_fpl = CuestionarioFpl.where(flujo_id: params[:flujo_id], criterio_id: value['criterio_id'], tipo_cuestionario_id: 1).order(:criterio_id)
        if @cuestionario_financiero_fpl.present?
          @cuestionario_financiero_fpl.update(custom_params[:cuestionario_fpl])
        else
          @cuestionario_financiero_fpl = CuestionarioFpl.new(custom_params[:cuestionario_fpl])
          @cuestionario_financiero_fpl.save
        end
      
      end

      #GUARDA CORRECCIONES Y OBSERVACIONES ADMISIBILIDAD TECNICA
      jsonDataTecnico = params['jsonDataTecnico']
      jsonDataTecnico.each do |key, value|
        custom_params = {
          cuestionario_fpl: {
            flujo_id: params['flujo_id'],
            criterio_id: value['criterio_id'],
            nota: value['nota'],
            justificacion: normalize_string(value['justificacion']),
            tipo_cuestionario_id: 2,
            revision: revision
          }
        }
        
        @cuestionario_tecnico_fpl = CuestionarioFpl.where(flujo_id: params[:flujo_id], criterio_id: value['criterio_id'], tipo_cuestionario_id: 2).order(:criterio_id)
        if @cuestionario_tecnico_fpl.present?
          @cuestionario_tecnico_fpl.update(custom_params[:cuestionario_fpl])
        else
          @cuestionario_tecnico_fpl = CuestionarioFpl.new(custom_params[:cuestionario_fpl])
          @cuestionario_tecnico_fpl.save
        end  
      end

      #GUARDA Resultado de la revision de pertinencia y factibilidad y Observaciones y comentarios
      custom_params = {
        cuestionario_obs_fpl: {
          flujo_id: params['flujo_id'],
          criterio_id: nil,
          nota: params[:nota_input_pertinencia],
          #justificacion: params[:obs_input_pertinencia],
          tipo_cuestionario_id: 4
        }
      }

      ##Graba comentarios en tabla comentario_flujos
      tarea_fondo_fpl_06 = Tarea.find_by_codigo(Tarea::COD_FPL_06)
      custom_params_comentarios = {
        cuestionario_flujos: {
          comentario: params[:obs_input_pertinencia],
          flujo_id: params['flujo_id'],
          user_id: @tarea_pendiente.user_id,
          tarea_id: tarea_fondo_fpl_06.id
        }
      }

      if params[:obs_input_pertinencia] != ""
        comentario = ComentarioFlujo.new(custom_params_comentarios[:cuestionario_flujos])
        comentario.save
      end 

      @cuestionario_obs_fpl = CuestionarioFpl.where(flujo_id: params[:flujo_id], tipo_cuestionario_id: 4).order(:criterio_id)
      if @cuestionario_obs_fpl.present?
        @cuestionario_obs_fpl.update(custom_params[:cuestionario_obs_fpl])
      else
        @cuestionario_obs_fpl = CuestionarioFpl.new(custom_params[:cuestionario_obs_fpl])
        @cuestionario_obs_fpl.save
      end  

      respond_to do |format|
        flash[:success] = 'Datos guardados correctamente'
        format.js { render js: "window.location='#{pertinencia_factibilidad_fondo_produccion_limpia_path(@tarea_pendiente.id)}'" }
        format.html { redirect_to pertinencia_factibilidad_fondo_produccion_limpia_path(@tarea_pendiente.id), notice: success }
      end
  
    end

    def enviar_pertinencia_factibilidad
      #GUARDA CORRECCIONES Y OBSERVACIONES ADMISIBILIDAD TECNICA

      case params[:nota_input_pertinencia]
      when "1"
        revision = 1
      when "2"
        revision = 2
      when "3"
        revision = 3
      end

      jsonDataFinanciera = params['jsonDataFinanciera']
      jsonDataFinanciera.each do |key, value|
        custom_params = {
          cuestionario_fpl: {
            flujo_id: params['flujo_id'],
            criterio_id: value['criterio_id'],
            nota: value['nota'],
            justificacion: normalize_string(value['justificacion']),
            tipo_cuestionario_id: 1,
            revision: revision
          }
        }
        
        @cuestionario_financiero_fpl = CuestionarioFpl.where(flujo_id: params[:flujo_id], criterio_id: value['criterio_id'], tipo_cuestionario_id: 1).order(:criterio_id)
        if @cuestionario_financiero_fpl.present?
          @cuestionario_financiero_fpl.update(custom_params[:cuestionario_fpl])
        else
          @cuestionario_financiero_fpl = CuestionarioFpl.new(custom_params[:cuestionario_fpl])
          @cuestionario_financiero_fpl.save
        end

        #VALIDAR EN EL COMBO BOX SI SE APRUEBA LA PERTINENCIA DE FACTIBILIDA
      end

      #GUARDA CORRECCIONES Y OBSERVACIONES ADMISIBILIDAD TECNICA
      jsonDataTecnico = params['jsonDataTecnico']
      jsonDataTecnico.each do |key, value|
        custom_params = {
          cuestionario_fpl: {
            flujo_id: params['flujo_id'],
            criterio_id: value['criterio_id'],
            nota: value['nota'],
            justificacion: normalize_string(value['justificacion']),
            tipo_cuestionario_id: 2,
            revision: revision
          }
        }
        
        @cuestionario_tecnico_fpl = CuestionarioFpl.where(flujo_id: params[:flujo_id], criterio_id: value['criterio_id'], tipo_cuestionario_id: 2).order(:criterio_id)
        if @cuestionario_tecnico_fpl.present?
          @cuestionario_tecnico_fpl.update(custom_params[:cuestionario_fpl])
        else
          @cuestionario_tecnico_fpl = CuestionarioFpl.new(custom_params[:cuestionario_fpl])
          @cuestionario_tecnico_fpl.save
        end  
      end

      #GUARDA Resultado de la revision de pertinencia y factibilidad y Observaciones y comentarios
      custom_params = {
        cuestionario_obs_fpl: {
          flujo_id: params['flujo_id'],
          criterio_id: nil,
          nota: params[:nota_input_pertinencia],
          justificacion: normalize_string(params[:obs_input_pertinencia]),
          tipo_cuestionario_id: 4
        }
      }
               
      @cuestionario_obs_fpl = CuestionarioFpl.where(flujo_id: params[:flujo_id], tipo_cuestionario_id: 4).order(:criterio_id)
      if @cuestionario_obs_fpl.present?
        @cuestionario_obs_fpl.update(custom_params[:cuestionario_obs_fpl])
      else
        @cuestionario_obs_fpl = CuestionarioFpl.new(custom_params[:cuestionario_obs_fpl])
        @cuestionario_obs_fpl.save
      end 

      cuestionario_fpl_rechazado = CuestionarioFpl.where(flujo_id: params[:flujo_id], nota: [1,2,3,4], tipo_cuestionario_id: [1,2]).group(:tipo_cuestionario_id).count

      ##Graba comentarios en tabla comentario_flujos
      tarea_fondo_fpl_06 = Tarea.find_by_codigo(Tarea::COD_FPL_06)
      custom_params_comentarios = {
        cuestionario_flujos: {
           comentario: params[:obs_input_pertinencia],
           flujo_id: params['flujo_id'],
           user_id: @tarea_pendiente.user_id,
           tarea_id: tarea_fondo_fpl_06.id
        }
      }
 
      if params[:obs_input_pertinencia] != ""
        comentario = ComentarioFlujo.new(custom_params_comentarios[:cuestionario_flujos])
        comentario.save
      end 

      #SE CAMBIA EL ESTADO DEL FPL-05 A 2
      tarea_fondo_fpl_06 = Tarea.find_by_codigo(Tarea::COD_FPL_06)
      tarea_pendiente_fpl_06 = TareaPendiente.where(tarea_id: tarea_fondo_fpl_06.id, flujo_id: @tarea_pendiente.flujo_id, user_id: @tarea_pendiente.user_id).last
      if tarea_pendiente_fpl_06.present?
        tarea_pendiente_fpl_06.estado_tarea_pendiente_id = EstadoTareaPendiente::ENVIADA
        tarea_pendiente_fpl_06.save  
      end
 
      if params[:nota_input_pertinencia] == '1'
        #PASA AL PASO FPL-10, CONSULTAR SI LA ADMISIBILIDAD JURIDICA ESTE APROBADA
        tarea_fondo = Tarea.find_by_codigo(Tarea::COD_FPL_05)
        existe_fpl_05 = TareaPendiente.where(tarea_id: tarea_fondo.id, flujo_id: @tarea_pendiente.flujo_id, estado_tarea_pendiente_id: 1).last

        if existe_fpl_05.present?
          #existe
        else
          #OBTENGO USER_ID DEL JEFE DE LINEA
          #CONSULTO SI EXISTE ALGUNA TAREA FPL-09 PENDIENTE
          tarea_fondo_fpl_09 = Tarea.find_by_codigo(Tarea::COD_FPL_09)
          existe_fpl_09 = TareaPendiente.where(tarea_id: tarea_fondo_fpl_09.id, flujo_id: @tarea_pendiente.flujo_id, estado_tarea_pendiente_id: 1).last
          if existe_fpl_09.present?
            #existe
          else
            mapa = MapaDeActor.where(flujo_id: @tarea_pendiente.flujo_id,rol_id: Rol::JEFE_DE_LINEA)
            tarea_fondo = Tarea.find_by_codigo(Tarea::COD_FPL_06)
            tarea_pendiente_postulante = TareaPendiente.where(tarea_id: tarea_fondo.id, flujo_id: @tarea_pendiente.flujo_id, persona_id: mapa.last.persona_id).last
           
            #SE CREA TAREA PARA RESOLVER OBSERVACIONES JURIDICAS
              tarea_fondo = Tarea.find_by_codigo(Tarea::COD_FPL_10)
                custom_params_tarea_pendiente = {
                  tarea_pendientes: {
                    flujo_id: @flujo.id,
                    tarea_id: tarea_fondo.id,
                    estado_tarea_pendiente_id: EstadoTareaPendiente::NO_INICIADA,
                    user_id: tarea_pendiente_postulante.user_id,
                    persona_id: tarea_pendiente_postulante.persona_id,
                    data: { }
                }
              }
              TareaPendiente.new(custom_params_tarea_pendiente[:tarea_pendientes]).save

              #SE ENVIAR EL MAIL AL RESPONSABLE
              mdi = @manifestacion_de_interes
              send_message(tarea_fondo, tarea_pendiente_postulante.user_id)
          end
        end
          
      else
        #GENERA FOTO DE DIAGNOSTICO Y LA CONVIERTE EN PDF
        @fondo_produccion_limpia = FondoProduccionLimpia.find(@flujo.fondo_produccion_limpia_id)
        cuestionario_observacion = CuestionarioFpl.where(flujo_id: params[:flujo_id], tipo_cuestionario_id: 4).first 

        if cuestionario_observacion
          revision = cuestionario_observacion.revision || 0
          puts revision + 1  
        else
          puts "No se encontró ningún cuestionario."
        end
        
        custom_params_update = {
          cuestionario_obs_fpl: {
            revision: revision + 1
          }
        }
               
        if cuestionario_observacion.present?
          cuestionario_observacion.update(custom_params_update[:cuestionario_obs_fpl])
        end 


        objetivo_especificos = ObjetivosEspecifico.where(flujo_id: @tarea_pendiente.flujo_id).all
        postulantes = EquipoTrabajo.where(flujo_id: @tarea_pendiente.flujo_id, tipo_equipo: 3)
        consultores = EquipoTrabajo.where(flujo_id: @tarea_pendiente.flujo_id, tipo_equipo:[1,2])
        empresas = EquipoEmpresa.where(flujo_id: @tarea_pendiente.flujo_id)
        actividades = PlanActividad.actividad_detalle(@tarea_pendiente.flujo_id)
        costos = PlanActividad.costos(@tarea_pendiente.flujo_id)
        tipo_instrumento = @flujo.tipo_instrumento_id
        costos_seguimiento = PlanActividad.costos_seguimiento(@tarea_pendiente.flujo_id, @flujo.tipo_instrumento_id)

        aporte_micro = 0
        aporte_pequena = 0
        aporte_mediana = 0
        tope_maximo = 0
        confinanciamiento_empresa = nil

        if @flujo.tipo_instrumento_id != TipoInstrumento::FPL_LINEA_1_1 || @flujo.tipo_instrumento_id != TipoInstrumento::FPL_LINEA_5_1 

          if @flujo.tipo_instrumento_id == TipoInstrumento::FPL_LINEA_1_3 || @flujo.tipo_instrumento_id == TipoInstrumento::FPL_EXTRAPRESUPUESTARIO_EVALUACION
            aporte_micro = FondoProduccionLimpia::APORTE_MICRO_EMPRESA_L13
            aporte_pequena = FondoProduccionLimpia::APORTE_PEQUEÑA_EMPRESA_L13
            aporte_mediana = FondoProduccionLimpia::APORTE_MEDIANA_EMPRESA_L13
            tope_maximo = Gasto::TOPE_MAXIMO_SOLICITAR_EVALUACION_L1_3
          else
            aporte_micro = FondoProduccionLimpia::APORTE_MICRO_EMPRESA
            aporte_pequena = FondoProduccionLimpia::APORTE_PEQUEÑA_EMPRESA
            aporte_mediana = FondoProduccionLimpia::APORTE_MEDIANA_EMPRESA

            if @flujo.tipo_instrumento_id == TipoInstrumento::FPL_LINEA_1_2_1 || @flujo.tipo_instrumento_id == TipoInstrumento::FPL_EXTRAPRESUPUESTARIO_SEGUIMIENTO
              tope_maximo = Gasto::TOPE_MAXIMO_SOLICITAR_SEGUIMIENTO_L1_1
            elsif @flujo.tipo_instrumento_id == TipoInstrumento::FPL_LINEA_1_2_2 || @flujo.tipo_instrumento_id == TipoInstrumento::FPL_EXTRAPRESUPUESTARIO_SEGUIMIENTO_2
              tope_maximo = Gasto::TOPE_MAXIMO_SOLICITAR_SEGUIMIENTO_L1_2
            end
          end

          if @fondo_produccion_limpia.present?
            if @fondo_produccion_limpia.cantidad_micro_empresa != 0 || 
              @fondo_produccion_limpia.cantidad_pequeña_empresa != 0 || 
              @fondo_produccion_limpia.cantidad_mediana_empresa != 0
                confinanciamiento_empresa = FondoProduccionLimpia.calcular_suma_y_porcentaje(@tarea_pendiente.flujo_id,aporte_micro,aporte_pequena,aporte_mediana,tope_maximo)
            end
          end

        end

        manifestacion_de_interes_id = Flujo.find(@fondo_produccion_limpia.flujo_apl_id)
        manifestacion_de_interes = ManifestacionDeInteres.find(manifestacion_de_interes_id.manifestacion_de_interes_id)
        nombre_tipo_instrumento = obtiene_nombre_tipo_instrumento(@flujo.tipo_instrumento_id)
        tarea_fondo = Tarea.find_by_codigo(Tarea::COD_FPL_06)
        comentarios = ComentarioFlujo.includes(:user).where(flujo_id: @tarea_pendiente.flujo_id, tarea_id: tarea_fondo.id)
        
        pdf = @fondo_produccion_limpia.generar_pdf(cuestionario_observacion.revision, objetivo_especificos, postulantes, consultores, empresas, actividades, costos, tipo_instrumento, 
                                                   costos_seguimiento, confinanciamiento_empresa, @fondo_produccion_limpia, manifestacion_de_interes, nombre_tipo_instrumento, comentarios)
        
        #SE ACTIVA EL FLUJO FPL-07, FPL-08 O AMBOS DEPENDIENDO DE LAS OBSERVACIONES ENCONTRADA SEN CADA UNA DE LAS PERTINENCIAS
        #consulto si la pertinencia financiera es distinto a 0 se devuelve la evaluacion al postulante FPL-001, y el postulante debe corregir y volver a enviar al FPL-03
        if cuestionario_fpl_rechazado[1] != nil && cuestionario_fpl_rechazado[1] != 0
          #OBTENGO USER_ID DEL POSTULANTE
          mapa = MapaDeActor.where(flujo_id: @tarea_pendiente.flujo_id,rol_id: Rol::PROPONENTE)
          tarea_fondo = Tarea.find_by_codigo(Tarea::COD_FPL_01)
          tarea_pendiente_postulante = TareaPendiente.find_by(tarea_id: tarea_fondo.id, flujo_id: @tarea_pendiente.flujo_id, persona_id: mapa.last.persona_id)
          
          #SE CREA TAREA PARA RESOLVER OBSERVACIONES FINANCIERAS
            tarea_fondo = Tarea.find_by_codigo(Tarea::COD_FPL_07)
              custom_params_tarea_pendiente = {
                tarea_pendientes: {
                  flujo_id: @flujo.id,
                  tarea_id: tarea_fondo.id,
                  estado_tarea_pendiente_id: EstadoTareaPendiente::NO_INICIADA,
                  user_id: tarea_pendiente_postulante.user_id,
                  persona_id: tarea_pendiente_postulante.persona_id,
                  data: { }
              }
            }
            TareaPendiente.new(custom_params_tarea_pendiente[:tarea_pendientes]).save

            #SE ENVIAR EL MAIL AL RESPONSABLE
            mdi = @manifestacion_de_interes
            send_message(tarea_fondo, tarea_pendiente_postulante.user_id)
        end  

        #consulto si la pertinencia tecnica es distinto a 0 se devuelve la evaluacion al postulante FPL-001, y el postulante debe corregir y volver a enviar al FPL-04
        if cuestionario_fpl_rechazado[2] != nil && cuestionario_fpl_rechazado[2] != 0
          #OBTENGO USER_ID DEL POSTULANTE
          mapa = MapaDeActor.where(flujo_id: @tarea_pendiente.flujo_id,rol_id: Rol::PROPONENTE)
          tarea_fondo = Tarea.find_by_codigo(Tarea::COD_FPL_01)
          tarea_pendiente_postulante = TareaPendiente.find_by(tarea_id: tarea_fondo.id, flujo_id: @tarea_pendiente.flujo_id, persona_id: mapa.last.persona_id)
          #SE CREA TAREA PARA RESOLVER OBSERVACIONES JURIDICAS
            tarea_fondo = Tarea.find_by_codigo(Tarea::COD_FPL_08)
              custom_params_tarea_pendiente = {
                tarea_pendientes: {
                  flujo_id: @flujo.id,
                  tarea_id: tarea_fondo.id,
                  estado_tarea_pendiente_id: EstadoTareaPendiente::NO_INICIADA,
                  user_id: tarea_pendiente_postulante.user_id,
                  persona_id: tarea_pendiente_postulante.persona_id,
                  data: { }
              }
            }
            TareaPendiente.new(custom_params_tarea_pendiente[:tarea_pendientes]).save

            #SE ENVIAR EL MAIL AL RESPONSABLE
            mdi = @manifestacion_de_interes
            send_message(tarea_fondo, tarea_pendiente_postulante.user_id)
        end  
      end 
      
      respond_to do |format|
        format.js { flash.now[:success] = 'Evaluación del Proyecto enviada correctamente'
          render js: "window.location='#{root_path}'"}
        format.html { redirect_to root_path, flash: {notice: 'Evaluación del Proyecto enviada correctamente' }}
      end

    end

    def get_observaciones_admisibilidad #TAREA FPL-07
      @cuestionario_fpl = CuestionarioFpl.where(flujo_id: @tarea_pendiente.flujo_id, tipo_cuestionario_id: 1).order(:criterio_id)
      
      respond_to do |format|
        format.js { render 'get_observaciones_admisibilidad', locals: { cuestionario_fpl: @cuestionario_fpl } }
      end
      
    end
  

    def observaciones_admisibilidad #TAREA FPL-07
      @recuerde_guardar_minutos = ManifestacionDeInteres::MINUTOS_MENSAJE_GUARDAR #DZC 2019-04-04 18:33:08 corrige requerimiento 2019-04-03

      @manifestacion_de_interes.temp_siguientes = "true"
      @manifestacion_de_interes.seleccion_de_radios

      @tipo_aporte = TipoAporte.all

      #Obtenie empresas adheridas Linea 1.3
      if @flujo.tipo_instrumento_id == TipoInstrumento::FPL_LINEA_1_3 || @flujo.tipo_instrumento_id == TipoInstrumento::FPL_EXTRAPRESUPUESTARIO_EVALUACION
        obtiene_y_graba_empresas_adheridas(false)
      end

      @admisibilidad = true
      @solo_lectura = false
      @adm_juridica = false
      
      count_user_persona = EquipoTrabajo.where(flujo_id: @tarea_pendiente.flujo_id, tipo_equipo: 1).count
      count_user_empresa =  EquipoEmpresa.where(flujo_id: @tarea_pendiente.flujo_id).count

      @tipo = 0
      if count_user_persona > 0 
        @tipo = 1
      end 

      if @tipo == 0
        if count_user_empresa > 0 
          @tipo = 2
        else 
          @tipo = 0
        end
      end

      #Carga tabs de postulación
      set_equipo_trabajo
      set_actividades_x_linea
      set_plan_actividades
      set_costos 
    end

    def revisar_observaciones_admisibilidad  #TAREA FPL-07
      jsonData = params['jsonData']

      jsonData.each do |key, value|
        custom_params = {
          cuestionario_fpl: {
            flujo_id: params['flujo_id'],
            criterio_id: value['criterio_id'],
            nota: value['nota'],
            justificacion: normalize_string(value['justificacion']),
            tipo_cuestionario_id: 1
          }
        }
        
        @cuestionario_fpl = CuestionarioFpl.where(flujo_id: params[:flujo_id], criterio_id: value['criterio_id'], tipo_cuestionario_id: 1).order(:criterio_id)
        if @cuestionario_fpl.present?
          @cuestionario_fpl.update(custom_params[:cuestionario_fpl])
        else
          @cuestionario_fpl = CuestionarioFpl.new(custom_params[:cuestionario_fpl])
          @cuestionario_fpl.save
        end
      end
    end

    def enviar_observaciones_admisibilidad  #TAREA FPL-07
      custom_params = {
        fondo_produccion_limpia: {
          cantidad_micro_empresa: params[:cantidad_micro_empresa],
          cantidad_pequeña_empresa: params[:cantidad_pequeña_empresa],
          cantidad_mediana_empresa: params[:cantidad_mediana_empresa],
          cantidad_grande_empresa: params[:cantidad_grande_empresa],
          empresas_asociadas_ag: params[:empresas_asociadas_ag],
          empresas_no_asociadas_ag: params[:empresas_no_asociadas_ag],
          duracion: params[:duracion],
          fortalezas_consultores: normalize_string(params[:fortalezas_consultores]),
          elementos_micro_empresa: params[:elementos_micro_empresa],
          elementos_pequena_empresa: params[:elementos_pequena_empresa],
          elementos_mediana_empresa: params[:elementos_mediana_empresa],
          elementos_grande_empresa: params[:elementos_grande_empresa],
          empresas_adheridas: params[:empresas_adheridas]
        }
      }

      fondo_produccion_limpia = FondoProduccionLimpia.where(flujo_id: @tarea_pendiente.flujo_id).first
      fondo_produccion_limpia.update(custom_params[:fondo_produccion_limpia])

      #ingresa solo cuand el linea 1.3, para grabar empresas adheridad seleccionadas en el APL-028
      if params[:tipo_instrumento_id] == TipoInstrumento::FPL_LINEA_1_3.to_s || params[:tipo_instrumento_id] == TipoInstrumento::FPL_EXTRAPRESUPUESTARIO_EVALUACION.to_s
        obtiene_y_graba_empresas_adheridas(true)
      end

      set_flujo

      # Convierte la cadena JSON a un array de hashes
      comunas = JSON.parse(params[:comunasIds])
      
      if params[:comunasIds].present?
        # Eliminar todas las entradas para el flujo actual
        ComunasFlujo.where(flujo_id: @flujo.id).destroy_all
        
        # Recorre el array de comunas
        comunas = JSON.parse(params[:comunasIds]) # Asegúrate de parsear el JSON aquí
        comunas.each do |comuna|
          tipo = comuna["tipo"]
          
          if tipo == 'región'
            region_id = comuna["id"]
            # Busca o crea la región
            region = Region.find_or_create_by(id: region_id) do |r|
              r.nombre = comuna["nombre"] # Ajusta según tu modelo
            end
            
            # Almacena las comunas de esta región en ComunasFlujo
            region.comunas.each do |comuna_de_region|
              comuna_flujo = ComunasFlujo.new(comuna_id: comuna_de_region.id, flujo_id: @flujo.id)
              if comuna_flujo.save
                puts "Comuna de región guardada: #{comuna_de_region.id} en flujo #{@flujo.id}"
              else
                puts "Error al guardar comuna de región: #{comuna_flujo.errors.full_messages.join(', ')}"
              end
            end
      
          elsif tipo == 'provincia'
            provincia_id = comuna["id"]
            # Busca o crea la provincia
            provincia = Provincia.find_or_create_by(id: provincia_id) do |p|
              p.nombre = comuna["nombre"] # Ajusta según tu modelo
            end
            
            # Almacena las comunas de esta provincia en ComunasFlujo
            provincia.comunas.each do |comuna_de_provincia|
              comuna_flujo = ComunasFlujo.new(comuna_id: comuna_de_provincia.id, flujo_id: @flujo.id)
              if comuna_flujo.save
                puts "Comuna de provincia guardada: #{comuna_de_provincia.id} en flujo #{@flujo.id}"
              else
                puts "Error al guardar comuna de provincia: #{comuna_flujo.errors.full_messages.join(', ')}"
              end
            end
      
          elsif tipo == 'comuna'
            comuna_id = comuna["id"]
            comuna_flujo = ComunasFlujo.new(comuna_id: comuna_id, flujo_id: @flujo.id)
            if comuna_flujo.save
              puts "Comuna guardada: #{comuna_id} en flujo #{@flujo.id}"
            else
              puts "Error al guardar comuna: #{comuna_flujo.errors.full_messages.join(', ')}"
            end
          end
        end
      else
        # Si no se seleccionó ninguna comuna, eliminar todas las que correspondan al flujo_id
        ComunasFlujo.where(flujo_id: @flujo.id).destroy_all 
        puts "No se seleccionó ninguna comuna"
      end

      #SE CAMBIA EL ESTADO DEL FPL-07 A 2
      tarea_fondo_fpl_07 = Tarea.find_by_codigo(Tarea::COD_FPL_07)
      tarea_pendiente_fpl_07 = TareaPendiente.where(tarea_id: tarea_fondo_fpl_07.id, flujo_id: @tarea_pendiente.flujo_id, user_id: @tarea_pendiente.user_id).last
      if tarea_pendiente_fpl_07.present?
        tarea_pendiente_fpl_07.estado_tarea_pendiente_id = EstadoTareaPendiente::ENVIADA
        tarea_pendiente_fpl_07.save  
      end
 
      #obtengo el usuario del jefe de linea
      mapa = MapaDeActor.where(flujo_id: @tarea_pendiente.flujo_id,rol_id: Rol::REVISOR_FINANCIERO)

      #obtengo el user_id del jefe de linea
      tarea_fondo = Tarea.find_by_codigo(Tarea::COD_FPL_03)
      tarea_pendiente = TareaPendiente.where(tarea_id: tarea_fondo.id, flujo_id: @tarea_pendiente.flujo_id).last
     
      tarea_fondo = Tarea.find_by_codigo(Tarea::COD_FPL_03)
      custom_params_tarea_pendiente = {
        tarea_pendientes: {
          flujo_id: @flujo.id,
          tarea_id: tarea_fondo.id,
          estado_tarea_pendiente_id: EstadoTareaPendiente::NO_INICIADA,
          user_id: tarea_pendiente.user_id,
          data: { }
        }
      }
  
      TareaPendiente.new(custom_params_tarea_pendiente[:tarea_pendientes]).save 

      #SE ENVIAR EL MAIL AL RESPONSABLE
      mdi = @manifestacion_de_interes
      send_message(tarea_fondo, tarea_pendiente.user_id)

      respond_to do |format|
        format.js { flash.now[:success] = 'Correción Admisibilidad Financiera enviada correctamente'
          render js: "window.location='#{root_path}'"}
        format.html { redirect_to root_path, flash: {notice: 'Correción Admisibilidad Financiera enviada correctamente' }}
      end
    end

    def get_observaciones_admisibilidad_tecnica #TAREA FPL-04
      @cuestionario_fpl = CuestionarioFpl.where(flujo_id: @tarea_pendiente.flujo_id, tipo_cuestionario_id: 2).order(:criterio_id)
      respond_to do |format|
        format.js { render 'get_observaciones_admisibilidad_tecnica', locals: { cuestionario_fpl: @cuestionario_fpl } }
      end
    end

    def observaciones_admisibilidad_tecnica #TAREA FPL-08
      @recuerde_guardar_minutos = ManifestacionDeInteres::MINUTOS_MENSAJE_GUARDAR #DZC 2019-04-04 18:33:08 corrige requerimiento 2019-04-03
      @solo_lectura = false

      @tipo_aporte = TipoAporte.all

      #Obtenie empresas adheridas Linea 1.3
      if @flujo.tipo_instrumento_id == TipoInstrumento::FPL_LINEA_1_3 || @flujo.tipo_instrumento_id == TipoInstrumento::FPL_EXTRAPRESUPUESTARIO_EVALUACION
        obtiene_y_graba_empresas_adheridas(false)
      end

      @adm_juridica = false
      count_user_persona = EquipoTrabajo.where(flujo_id: @tarea_pendiente.flujo_id, tipo_equipo: 1).count
      count_user_empresa =  EquipoEmpresa.where(flujo_id: @tarea_pendiente.flujo_id).count

      @tipo = 0
      if count_user_persona > 0 
        @tipo = 1
      end 

      if @tipo == 0
        if count_user_empresa > 0 
          @tipo = 2
        else 
          @tipo = 0
        end
      end

      #Carga tabs de postulación
      set_equipo_trabajo
      set_actividades_x_linea
      set_plan_actividades
      set_costos 
    end

    def revisar_observaciones_admisibilidad_tecnica  #TAREA FPL-08
      jsonData = params['jsonData']

      jsonData.each do |key, value|
        custom_params = {
          cuestionario_fpl: {
            flujo_id: params['flujo_id'],
            criterio_id: value['criterio_id'],
            nota: value['nota'],
            justificacion: normalize_string(value['justificacion']),
            tipo_cuestionario_id: 2
          }
        }

        @cuestionario_fpl = CuestionarioFpl.where(flujo_id: params[:flujo_id], criterio_id: value['criterio_id'], tipo_cuestionario_id: 2).order(:criterio_id)
        if @cuestionario_fpl.present?
          @cuestionario_fpl.update(custom_params[:cuestionario_fpl])
        else
          @cuestionario_fpl = CuestionarioFpl.new(custom_params[:cuestionario_fpl])
          @cuestionario_fpl.save
        end
      end
    end

    #FPL-08
    def enviar_observaciones_admisibilidad_tecnica 
      custom_params = {
        fondo_produccion_limpia: {
          cantidad_micro_empresa: params[:cantidad_micro_empresa],
          cantidad_pequeña_empresa: params[:cantidad_pequeña_empresa],
          cantidad_mediana_empresa: params[:cantidad_mediana_empresa],
          cantidad_grande_empresa: params[:cantidad_grande_empresa],
          empresas_asociadas_ag: params[:empresas_asociadas_ag],
          empresas_no_asociadas_ag: params[:empresas_no_asociadas_ag],
          duracion: params[:duracion],
          fortalezas_consultores: normalize_string(params[:fortalezas_consultores]),
          elementos_micro_empresa: params[:elementos_micro_empresa],
          elementos_pequena_empresa: params[:elementos_pequena_empresa],
          elementos_mediana_empresa: params[:elementos_mediana_empresa],
          elementos_grande_empresa: params[:elementos_grande_empresa],
          empresas_adheridas: params[:empresas_adheridas]
        }
      }

      fondo_produccion_limpia = FondoProduccionLimpia.where(flujo_id: @tarea_pendiente.flujo_id).first
      fondo_produccion_limpia.update(custom_params[:fondo_produccion_limpia])

      #ingresa solo cuand el linea 1.3, para grabar empresas adheridad seleccionadas en el APL-028
      if params[:tipo_instrumento_id] == TipoInstrumento::FPL_LINEA_1_3.to_s || params[:tipo_instrumento_id] == TipoInstrumento::FPL_EXTRAPRESUPUESTARIO_EVALUACION.to_s
        obtiene_y_graba_empresas_adheridas(true)
      end

      set_flujo

      # Convierte la cadena JSON a un array de hashes
      comunas = JSON.parse(params[:comunasIds])
      
      if params[:comunasIds].present?
        # Eliminar todas las entradas para el flujo actual
        ComunasFlujo.where(flujo_id: @flujo.id).destroy_all
        
        # Recorre el array de comunas
        comunas = JSON.parse(params[:comunasIds]) # Asegúrate de parsear el JSON aquí
        comunas.each do |comuna|
          tipo = comuna["tipo"]
          
          if tipo == 'región'
            region_id = comuna["id"]
            # Busca o crea la región
            region = Region.find_or_create_by(id: region_id) do |r|
              r.nombre = comuna["nombre"] # Ajusta según tu modelo
            end
            
            # Almacena las comunas de esta región en ComunasFlujo
            region.comunas.each do |comuna_de_region|
              comuna_flujo = ComunasFlujo.new(comuna_id: comuna_de_region.id, flujo_id: @flujo.id)
              if comuna_flujo.save
                puts "Comuna de región guardada: #{comuna_de_region.id} en flujo #{@flujo.id}"
              else
                puts "Error al guardar comuna de región: #{comuna_flujo.errors.full_messages.join(', ')}"
              end
            end
      
          elsif tipo == 'provincia'
            provincia_id = comuna["id"]
            # Busca o crea la provincia
            provincia = Provincia.find_or_create_by(id: provincia_id) do |p|
              p.nombre = comuna["nombre"] # Ajusta según tu modelo
            end
            
            # Almacena las comunas de esta provincia en ComunasFlujo
            provincia.comunas.each do |comuna_de_provincia|
              comuna_flujo = ComunasFlujo.new(comuna_id: comuna_de_provincia.id, flujo_id: @flujo.id)
              if comuna_flujo.save
                puts "Comuna de provincia guardada: #{comuna_de_provincia.id} en flujo #{@flujo.id}"
              else
                puts "Error al guardar comuna de provincia: #{comuna_flujo.errors.full_messages.join(', ')}"
              end
            end
      
          elsif tipo == 'comuna'
            comuna_id = comuna["id"]
            comuna_flujo = ComunasFlujo.new(comuna_id: comuna_id, flujo_id: @flujo.id)
            if comuna_flujo.save
              puts "Comuna guardada: #{comuna_id} en flujo #{@flujo.id}"
            else
              puts "Error al guardar comuna: #{comuna_flujo.errors.full_messages.join(', ')}"
            end
          end
        end
      else
        # Si no se seleccionó ninguna comuna, eliminar todas las que correspondan al flujo_id
        ComunasFlujo.where(flujo_id: @flujo.id).destroy_all 
        puts "No se seleccionó ninguna comuna"
      end
      
      #SE CAMBIA EL ESTADO DEL FPL-07 A 2
      tarea_fondo_fpl_08 = Tarea.find_by_codigo(Tarea::COD_FPL_08)
      tarea_pendiente_fpl_08 = TareaPendiente.where(tarea_id: tarea_fondo_fpl_08.id, flujo_id: @tarea_pendiente.flujo_id, user_id: @tarea_pendiente.user_id).last
      if tarea_pendiente_fpl_08.present?
        tarea_pendiente_fpl_08.estado_tarea_pendiente_id = EstadoTareaPendiente::ENVIADA
        tarea_pendiente_fpl_08.save  
      end

      #obtengo el usuario del jefe de linea
      mapa = MapaDeActor.where(flujo_id: @tarea_pendiente.flujo_id,rol_id: Rol::REVISOR_TECNICO)

      #obtengo el user_id del jefe de linea
      tarea_fondo = Tarea.find_by_codigo(Tarea::COD_FPL_04)
      tarea_pendiente = TareaPendiente.where(tarea_id: tarea_fondo.id, flujo_id: @tarea_pendiente.flujo_id).last

  
      tarea_fondo = Tarea.find_by_codigo(Tarea::COD_FPL_04)
      custom_params_tarea_pendiente = {
        tarea_pendientes: {
          flujo_id: @flujo.id,
          tarea_id: tarea_fondo.id,
          estado_tarea_pendiente_id: EstadoTareaPendiente::NO_INICIADA,
          user_id: tarea_pendiente.user_id,
          data: { }
        }
      }
      TareaPendiente.new(custom_params_tarea_pendiente[:tarea_pendientes]).save 

      #SE ENVIAR EL MAIL AL RESPONSABLE
      mdi = @manifestacion_de_interes
      send_message(tarea_fondo, tarea_pendiente.user_id)
  
      respond_to do |format|
        format.js { flash.now[:success] = 'Correción Admisibilidad Técnica enviada correctamente'
          render js: "window.location='#{root_path}'"}
        format.html { redirect_to root_path, flash: {notice: 'Correción Admisibilidad Técnica enviada correctamente' }}
      end
    end  
    
    def get_observaciones_admisibilidad_juridica #TAREA FPL-09
      @cuestionario_fpl = CuestionarioFpl.where(flujo_id: @tarea_pendiente.flujo_id, tipo_cuestionario_id: 3).order(:criterio_id)
      respond_to do |format|
        format.js { render 'get_observaciones_admisibilidad_juridica', locals: { cuestionario_fpl: @cuestionario_fpl } }
      end
    end
  
    def observaciones_admisibilidad_juridica #TAREA FPL-09
      @recuerde_guardar_minutos = ManifestacionDeInteres::MINUTOS_MENSAJE_GUARDAR #DZC 2019-04-04 18:33:08 corrige requerimiento 2019-04-03
      @manifestacion_de_interes.seleccion_de_radios
      @solo_lectura = true
      @adm_juridica = true

      #Obtenie empresas adheridas Linea 1.3
      if @flujo.tipo_instrumento_id == TipoInstrumento::FPL_LINEA_1_3 || @flujo.tipo_instrumento_id == TipoInstrumento::FPL_EXTRAPRESUPUESTARIO_EVALUACION
        obtiene_y_graba_empresas_adheridas(false)
      end

      count_user_persona = EquipoTrabajo.where(flujo_id: @tarea_pendiente.flujo_id, tipo_equipo: 1).count
      count_user_empresa =  EquipoEmpresa.where(flujo_id: @tarea_pendiente.flujo_id).count

      @tipo = 0
      if count_user_persona > 0 
        @tipo = 1
      end 

      if @tipo == 0
        if count_user_empresa > 0 
          @tipo = 2
        else 
          @tipo = 0
        end
      end

      #Carga tabs de postulación
      set_equipo_trabajo
      set_actividades_x_linea
      set_plan_actividades
      set_costos 
      set_descargables
    end
  
    def resolver_observaciones_admisibilidad_juridica  #TAREA FPL-09
      jsonData = params['jsonData']

      jsonData.each do |key, value|
        revision = nil
        if value['nota'] == '2'
          revision = 2
        end
        custom_params = {
          cuestionario_fpl: {
            flujo_id: params['flujo_id'],
            criterio_id: value['criterio_id'],
            nota: value['nota'],
            justificacion: normalize_string(value['justificacion']),
            tipo_cuestionario_id: 3,
            revision: revision
          }
        }

        @cuestionario_fpl = CuestionarioFpl.where(flujo_id: params[:flujo_id], criterio_id: value['criterio_id'], tipo_cuestionario_id: 3).order(:criterio_id)
        if @cuestionario_fpl.present?
          @cuestionario_fpl.update(custom_params[:cuestionario_fpl])
        else
          @cuestionario_fpl = CuestionarioFpl.new(custom_params[:cuestionario_fpl])
          @cuestionario_fpl.save
        end  
      end  
    end

    def enviar_observaciones_admisibilidad_juridica  #TAREA FPL-09
      #SE CAMBIA EL ESTADO DEL FPL-09 A 2
      tarea_fondo_fpl_09 = Tarea.find_by_codigo(Tarea::COD_FPL_09)
      
      tarea_pendiente_fpl_09 = TareaPendiente.where(tarea_id: tarea_fondo_fpl_09.id, flujo_id: @tarea_pendiente.flujo_id, user_id: @tarea_pendiente.user_id).last
      if tarea_pendiente_fpl_09.present?
        tarea_pendiente_fpl_09.estado_tarea_pendiente_id = EstadoTareaPendiente::ENVIADA
        tarea_pendiente_fpl_09.save  
      end

      #APERTURA NUEVAMENTE LA TAREA FPL-05
      #obtengo el user_id del revisor juridico
      mapa = MapaDeActor.where(flujo_id: @tarea_pendiente.flujo_id,rol_id: Rol::REVISOR_JURIDICO)
      tarea_fondo = Tarea.find_by_codigo(Tarea::COD_FPL_05)
      tarea_pendiente_admisibilidad_juridica = TareaPendiente.where(tarea_id: tarea_fondo.id, flujo_id: @tarea_pendiente.flujo_id).last
      
      custom_params_tarea_pendiente = {
        tarea_pendientes: {
          flujo_id: @flujo.id,
          tarea_id: tarea_fondo.id,
          estado_tarea_pendiente_id: EstadoTareaPendiente::NO_INICIADA,
          user_id: tarea_pendiente_admisibilidad_juridica.user_id,
          data: { }
        }
      }
      TareaPendiente.new(custom_params_tarea_pendiente[:tarea_pendientes]).save

      #SE ENVIAR EL MAIL AL RESPONSABLE
      mdi = @manifestacion_de_interes
      send_message(tarea_fondo, tarea_pendiente_admisibilidad_juridica.user_id)
     
      respond_to do |format|
        format.js { flash.now[:success] = 'Correcciones de Admisibilidad Jurídica enviadas correctamente'
          render js: "window.location='#{root_path}'"}
        format.html { redirect_to root_path, flash: {notice: 'Correcciones de Admisibilidad Jurídica enviadas correctamente' }}
      end    
    end

    def get_evaluacion_general #TAREA FPL-10
      @cuestionario_pert_financiera_fpl = CuestionarioFpl.where(flujo_id: @tarea_pendiente.flujo_id, tipo_cuestionario_id: 1).order(:criterio_id)
      @cuestionario_pert_tecnica_fpl = CuestionarioFpl.where(flujo_id: @tarea_pendiente.flujo_id, tipo_cuestionario_id: 2).order(:criterio_id)
      @cuestionario_pert_juridica_fpl = CuestionarioFpl.where(flujo_id: @tarea_pendiente.flujo_id, tipo_cuestionario_id: 3).order(:criterio_id)
      @cuestionario_obs_fpl = CuestionarioFpl.where(flujo_id: @tarea_pendiente.flujo_id, tipo_cuestionario_id: 4).order(:criterio_id).first
      respond_to do |format|
        format.js { render 'get_evaluacion_general', locals: { cuestionario_pert_financiera_fpl: @cuestionario_pert_financiera_fpl ,cuestionario_pert_tecnica_fpl: @cuestionario_pert_tecnica_fpl, cuestionario_pert_juridica_fpl: @cuestionario_pert_juridica_fpl, cuestionario_obs_fpl: @cuestionario_obs_fpl} }
      end
    end

    def evaluacion_general #TAREA FPL-10
      @recuerde_guardar_minutos = ManifestacionDeInteres::MINUTOS_MENSAJE_GUARDAR
      @manifestacion_de_interes.seleccion_de_radios
      @solo_lectura = true

      #Obtenie empresas adheridas Linea 1.3
      if @flujo.tipo_instrumento_id == TipoInstrumento::FPL_LINEA_1_3 || @flujo.tipo_instrumento_id == TipoInstrumento::FPL_EXTRAPRESUPUESTARIO_EVALUACION
        obtiene_y_graba_empresas_adheridas(false)
      end

      #Carga tabs de postulación
      set_equipo_trabajo
      set_actividades_x_linea
      set_plan_actividades
      set_costos 
      set_descargables
    end

    def enviar_evaluacion_general
      ##Graba comentarios en tabla comentario_flujos
      tarea_fondo_fpl_10 = Tarea.find_by_codigo(Tarea::COD_FPL_10)
      custom_params_comentarios = {
        cuestionario_flujos: {
          comentario: params[:obs_input_pertinencia],
          flujo_id: @tarea_pendiente.flujo_id,
          user_id: @tarea_pendiente.user_id,
          tarea_id: tarea_fondo_fpl_10.id
        }
      }

      #GUARDA Resultado de la revision de pertinencia y factibilidad y Observaciones y comentarios
      custom_params = {
        cuestionario_obs_fpl: {
          flujo_id: params['flujo_id'],
          criterio_id: nil,
          nota: params[:nota_input_pertinencia],
          justificacion: normalize_string(params[:obs_input_pertinencia]),
          tipo_cuestionario_id: 4
        }
      }

      @cuestionario_obs_fpl = CuestionarioFpl.where(flujo_id: params[:flujo_id], tipo_cuestionario_id: 4).order(:criterio_id)
      if @cuestionario_obs_fpl.present?
        @cuestionario_obs_fpl.update(custom_params[:cuestionario_obs_fpl])
      else
        @cuestionario_obs_fpl = CuestionarioFpl.new(custom_params[:cuestionario_obs_fpl])
        @cuestionario_obs_fpl.save
      end 

      if params[:nota_input_pertinencia] == '1'
        #SE CAMBIA EL ESTADO DEL FPL-10 A 2
        tarea_fondo_fpl_10 = Tarea.find_by_codigo(Tarea::COD_FPL_10)
        
        tarea_pendiente_fpl_10 = TareaPendiente.find_by(tarea_id: tarea_fondo_fpl_10.id, flujo_id: @tarea_pendiente.flujo_id, user_id: @tarea_pendiente.user_id)
        if tarea_pendiente_fpl_10.present?
          tarea_pendiente_fpl_10.estado_tarea_pendiente_id = EstadoTareaPendiente::ENVIADA
          tarea_pendiente_fpl_10.save  
        end

        tarea_fondo = Tarea.find_by_codigo(Tarea::COD_FPL_05)
        tarea_pendiente_juridica = TareaPendiente.where(tarea_id: tarea_fondo.id, flujo_id: @tarea_pendiente.flujo_id).last

        tarea_fondo = Tarea.find_by_codigo(Tarea::COD_FPL_11)
        custom_params_tarea_pendiente = {
          tarea_pendientes: {
            flujo_id: @flujo.id,
            tarea_id: tarea_fondo.id,
            estado_tarea_pendiente_id: EstadoTareaPendiente::NO_INICIADA,
            user_id: tarea_pendiente_juridica.user_id,
            persona_id: tarea_pendiente_juridica.persona_id,
            data: { }
          }
        }
        TareaPendiente.new(custom_params_tarea_pendiente[:tarea_pendientes]).save 
        #SE ENVIAR EL MAIL AL RESPONSABLE
        mdi = @manifestacion_de_interes
        send_message(tarea_fondo, tarea_pendiente_juridica.user_id)

        respond_to do |format|
          format.js { flash.now[:success] = 'Evaluación General enviada correctamente'
            render js: "window.location='#{root_path}'"}
          format.html { redirect_to root_path, flash: {notice: 'Evaluación General enviada correctamente' }}
        end
      
      else
        respond_to do |format|
          flash[:error] = "La postulación debe estar en estado Aprobada para su envio"
          format.js { render js: "window.location='#{evaluacion_general_fondo_produccion_limpia_path(@tarea_pendiente.id)}'" }
          format.html { redirect_to evaluacion_general_fondo_produccion_limpia_path(@tarea_pendiente.id), notice: error }
        end
      end
    end

    def resolucion_contrato
    end

    def adjuntar_resolucion_contrato
      respond_to do |format|
        if @fondo_produccion_limpia.update(fondo_produccion_limpia_archivos_params)

          #SE CAMBIA EL ESTADO DEL FPL-11 A 2
          tarea_fondo_fpl_11 = Tarea.find_by_codigo(Tarea::COD_FPL_11)
          tarea_pendiente_fpl_11 = TareaPendiente.find_by(tarea_id: tarea_fondo_fpl_11.id, flujo_id: @tarea_pendiente.flujo_id, user_id: @tarea_pendiente.user_id)

          if tarea_pendiente_fpl_11.present?
            tarea_pendiente_fpl_11.estado_tarea_pendiente_id = EstadoTareaPendiente::ENVIADA
            tarea_pendiente_fpl_11.save  
          end

          format.js { flash.now[:success] = 'Documentos ingresados correctamente'
            render js: "window.location='#{root_path}'"}
          format.html { redirect_to root_path, flash: {notice: 'Documentos ingresados correctamente' }}
       
        else
          flash[:error] = "Error al actualizar: #{@fondo_produccion_limpia.errors.full_messages.join(', ')}"
          format.js { render js: "window.location='#{resolucion_contrato_fondo_produccion_limpia_path(@tarea_pendiente.id)}'" }
          format.html { redirect_to resolucion_contrato_fondo_produccion_limpia_path(@tarea_pendiente.id), notice: error }
        end
      end
    end
    
    def descargar_pdf
      flujo = Flujo.find(params[:id])
      @fondo_produccion_limpia = FondoProduccionLimpia.find(flujo.fondo_produccion_limpia_id)

      pdf_file_path = Rails.root.join('public', 'uploads', 'fondo_produccion_limpia', 'pdf', "fondo_produccion_limpia_#{flujo.fondo_produccion_limpia_id}_#{params[:revision]}.pdf")
      if File.exist?(pdf_file_path)
        send_file pdf_file_path, type: 'application/pdf', disposition: 'attachment', filename: "fondo_produccion_limpia_#{flujo.fondo_produccion_limpia_id}_#{params[:revision]}.pdf"
      else
        flash[:alert] = "El archivo solicitado no se encuentra disponible."
        redirect_to request.referer || root_path
      end
    end

    def descargar_contrato_pdf
      flujo = Flujo.find(params[:id])
      @fondo_produccion_limpia = FondoProduccionLimpia.find(flujo.fondo_produccion_limpia_id)
     
      # Obtener la ruta completa del archivo
      archivo_contrato_ruta = @fondo_produccion_limpia.archivo_contrato.file.path

      # Extraer el nombre del archivo
      archivo_contrato = File.basename(archivo_contrato_ruta)

      pdf_file_path = Rails.root.join('public', 'uploads', 'fondo_produccion_limpia', 'archivo_contrato', "#{flujo.fondo_produccion_limpia_id}", "#{archivo_contrato}")
      if File.exist?(pdf_file_path)
        send_file pdf_file_path, type: 'application/pdf', disposition: 'attachment', filename: "#{archivo_contrato}"
      else
        flash[:alert] = "El archivo solicitado no se encuentra disponible."
        redirect_to request.referer || root_path
      end
    end

    def descargar_resolucion_pdf
      flujo = Flujo.find(params[:id])
      @fondo_produccion_limpia = FondoProduccionLimpia.find(flujo.fondo_produccion_limpia_id)
 
      # Obtener la ruta completa del archivo
      archivo_resolucion_ruta = @fondo_produccion_limpia.archivo_resolucion.file.path

      # Extraer el nombre del archivo
      archivo_resolucion = File.basename(archivo_resolucion_ruta)

      pdf_file_path = Rails.root.join('public', 'uploads', 'fondo_produccion_limpia', 'archivo_resolucion', "#{flujo.fondo_produccion_limpia_id}", "#{archivo_resolucion}")
      if File.exist?(pdf_file_path)
        send_file pdf_file_path, type: 'application/pdf', disposition: 'attachment', filename: "#{archivo_resolucion}"
      else
        flash[:alert] = "El archivo solicitado no se encuentra disponible."
        redirect_to request.referer || root_path
      end
    end

    def descargar_admisibilidad_juridica_pdf
      flujo = Flujo.find(params[:id])
      @fondo_produccion_limpia = FondoProduccionLimpia.find(flujo.fondo_produccion_limpia_id)

      pdf_file_path = Rails.root.join('public', 'uploads', 'fondo_produccion_limpia', 'admisibilidad', "admisibilidad_juridica_#{flujo.fondo_produccion_limpia_id}_#{params[:revision]}.pdf")
      if File.exist?(pdf_file_path)
        send_file pdf_file_path, type: 'application/pdf', disposition: 'attachment', filename: "admisibilidad_juridica_#{flujo.fondo_produccion_limpia_id}_#{params[:revision]}.pdf"
      else
        flash[:alert] = "El archivo solicitado no se encuentra disponible."
        redirect_to request.referer || root_path
      end
    end
    

    def lista_usuarios_carga_datos
      manif_de_interes = TareaPendiente.find(params[:tarea_pendiente_id]).flujo.manifestacion_de_interes
      tipo_instrumento = manif_de_interes.tipo_instrumento_id.nil? ? TipoInstrumento::ACUERDO_DE_PRODUCCION_LIMPIA : manif_de_interes.tipo_instrumento_id
      rol_tarea = Rol::CARGADOR_DATOS_ACUERDO
      personas_responsables = Responsable::__personas_responsables_v2(rol_tarea, tipo_instrumento, params[:contribuyente_id])
      @usuarios = personas_responsables.map { |e| e.user  }
    end
  
    def cargar_actualizar_entregable_diagnostico #DZC APL-013
      if params[:tab_metas].present?
        @tab_metas = params[:tab_metas]
      end
      # DZC 2018-10-26 16:11:53 se modifica lectura de datos
      @actores_desde_campo = @manifestacion_de_interes.mapa_de_actores_data.blank? ? nil : @manifestacion_de_interes.mapa_de_actores_data.map{|i| i.transform_keys!(&:to_sym).to_h}
      @actores_desde_tablas = MapaDeActor.construye_data_para_apl(@flujo)
      if @tarea_pendiente.data == {primera_ejecucion: true} || @tarea.codigo =='APL-001'
        @actores = MapaDeActor.adecua_actores_para_vista(@actores_desde_tablas)
      else
        @actores = (@actores_desde_campo.blank? ? MapaDeActor.adecua_actores_para_vista(@actores_desde_tablas) : MapaDeActor.adecua_actores_para_vista(@actores_desde_campo))
      end
      @actores = MapaDeActor.adecua_actores_unidos_rut_persona_institucion(@actores)
  
      @manifestacion_de_interes.accion_en_mapa_de_actores = :actualizacion
      @manifestacion_de_interes.accion_en_documento_diagnostico = :actualizacion
      @manifestacion_de_interes.accion_en_set_metas_accion = :actualizacion
      @manifestacion_de_interes.mapa_de_actores_correctamente_construido = true
      @manifestacion_de_interes.temporal = true
      unless @manifestacion_de_interes.comentarios_y_observaciones_actualizacion_mapa_de_actores.blank?
        comentarios = @manifestacion_de_interes.comentarios_y_observaciones_actualizacion_mapa_de_actores.last
        @actores_con_observaciones = comentarios[:actores_con_observaciones]
      end
      @comentarios = @manifestacion_de_interes.comentarios_diagnostico_ordenados
      @manifestacion_de_interes.setear_documento_diagnosticos
      @set_metas_acciones = SetMetasAccion.de_la_manifestacion_de_interes_(@manifestacion_de_interes.id)
      @set_metas_accion = SetMetasAccion.new
      if params[:tab_metas].present? # DZC 2018-11-05 09:50:57 permite focalizar la vista en la pestaña set metas y acciones
        @tab_metas = params[:tab_metas]
      end
      @informe=InformeAcuerdo.find_by(manifestacion_de_interes_id: @manifestacion_de_interes.id)
      unless @manifestacion_de_interes.comentarios_y_observaciones_set_metas_acciones.blank?
        comentarios = @manifestacion_de_interes.comentarios_y_observaciones_set_metas_acciones.last
        @propuestas_con_observaciones = comentarios[:requiere_correcciones]
      end
      @origenes = {}
      @set_metas_acciones.each do |sma|
        if !sma.modelo_referencia.blank? && !@origenes.key?(sma.llave_origen)
          nombre = ""
          if sma.modelo_referencia == "EstandarSetMetasAccion"
            nombre = "<b>Estándar:</b> "+EstandarSetMetasAccion.find(sma.id_referencia).estandar_homologacion.nombre
          else
            nombre = "<b>Acuerdo:</b> "+SetMetasAccion.find(sma.id_referencia).flujo.manifestacion_de_interes.nombre_acuerdo
          end
          @origenes[sma.llave_origen] = {
            nombre: nombre,
            color: "%06x" % (rand * 0xffffff)
          }
        end
      end
      @total_de_errores_por_tab = {}
      @total_de_errores_por_tab[:"listado-de-actores"] = @actores_con_observaciones.uniq if !@actores_con_observaciones.blank?
      @total_de_errores_por_tab[:"cargar-documentos-diagnostico"] = @manifestacion_de_interes.documento_diagnosticos.where(requiere_correcciones: true).pluck(:id) if @manifestacion_de_interes.documento_diagnosticos.where(requiere_correcciones: true).count > 0
      @total_de_errores_por_tab[:"set-metas-accion"] = @propuestas_con_observaciones.uniq if !@propuestas_con_observaciones.blank?
  
    end
  
    def revisar_entregable_diagnostico #DZC APL-014
      #DZC convierto el hash con string keys a hash_with_indiferent_access, y de vuelta a hash con key simbólicas, o nil, según corresponda
      @actores_desde_campo = @manifestacion_de_interes.mapa_de_actores_data.blank? ? nil : @manifestacion_de_interes.mapa_de_actores_data.map{|i| i.transform_keys!(&:to_sym).to_h}
      @actores_desde_tablas = MapaDeActor.construye_data_para_apl(@flujo)
      @actores = (@actores_desde_campo.blank? ? MapaDeActor.adecua_actores_para_vista(@actores_desde_tablas) : MapaDeActor.adecua_actores_para_vista(@actores_desde_campo))
      @actores = MapaDeActor.adecua_actores_unidos_rut_persona_institucion(@actores)
      # if @manifestacion_de_interes.mapa_de_actores_data.blank?
      #   @actores = []
      # else
      #   @actores = @manifestacion_de_interes.mapa_de_actores_data
      # end
      @manifestacion_de_interes.accion_en_mapa_de_actores = :revision
      @manifestacion_de_interes.accion_en_documento_diagnostico = :revision
      @manifestacion_de_interes.accion_en_set_metas_accion = :revision
      @manifestacion_de_interes.mapa_de_actores_correctamente_construido = true
      @manifestacion_de_interes.temporal = true
      unless @manifestacion_de_interes.comentarios_y_observaciones_actualizacion_mapa_de_actores.blank?
        @comentarios_mapa_de_actores = @manifestacion_de_interes.comentarios_mapa_de_actores_ordenados
        @actores_con_observaciones = @comentarios_mapa_de_actores.first[:actores_con_observaciones]
        @manifestacion_de_interes.comentarios_y_observaciones_actualizacion_mapa_de_actores = nil
      end
  
      @comentarios = @manifestacion_de_interes.comentarios_diagnostico_ordenados
      @manifestacion_de_interes.setear_documento_diagnosticos
      # DZC 2018-10-09 14:37:00 se borran los comentarios anteriores
      @manifestacion_de_interes.comentarios_y_observaciones_documento_diagnosticos = nil
      @set_metas_acciones = SetMetasAccion.de_la_manifestacion_de_interes_(@manifestacion_de_interes.id)
      @set_metas_accion = SetMetasAccion.new
      unless @manifestacion_de_interes.comentarios_y_observaciones_set_metas_acciones.blank?
        @comentarios_set_metas_acciones = @manifestacion_de_interes.comentarios_set_metas_acciones_ordenados
        @propuestas_con_observaciones = @comentarios_set_metas_acciones.first[:requiere_correcciones]
        @manifestacion_de_interes.comentarios_y_observaciones_set_metas_acciones = nil
      end
      @origenes = {}
      @set_metas_acciones.each do |sma|
        if !sma.modelo_referencia.blank? && !@origenes.key?(sma.llave_origen)
          nombre = ""
          if sma.modelo_referencia == "EstandarSetMetasAccion"
            nombre = "<b>Estándar:</b> "+EstandarSetMetasAccion.find(sma.id_referencia).estandar_homologacion.nombre
          else
            nombre = "<b>Acuerdo:</b> "+SetMetasAccion.find(sma.id_referencia).flujo.manifestacion_de_interes.nombre_acuerdo
          end
          @origenes[sma.llave_origen] = {
            nombre: nombre,
            color: "%06x" % (rand * 0xffffff)
          }
        end
      end
    end
  
    def termina_etapa_diagnostico #DZC APL-014 TERMINA TODAS LAS TAREAS DESDE APL-014 HACIA ATRAS
      respond_to do |format|
  
        #DZC agrega el comentario sobre el término al campo respectivo de la manifestación
        @manifestacion = @flujo.manifestacion_de_interes
        @manifestacion.observaciones_documentos_diagnostico = params[:tarea_pendiente][:observaciones_documentos_diagnostico] #DZC se agregan los parametros de esta forma para agregar el id de la manifestación en la URL
        @manifestacion.temporal = true
  
        # DZC 2018-10-11 13:14:21 se modifica el método para considerar como aprobada la información ingresada en las tres pestañas de la tarea APL-013
        # DZC 2018-10-11 13:15:06 Mapa de actores:
        comentarios_anteriores = @manifestacion.comentarios_y_observaciones_actualizacion_mapa_de_actores.blank? ? [] : @manifestacion.comentarios_y_observaciones_actualizacion_mapa_de_actores
        comentarios_anteriores << {
            datetime: DateTime.now,
            user: current_user.nombre_completo,
            actores_con_observaciones: nil,
            texto: "Listado de actores aprobado por #{current_user.nombre_completo}"
          }
        @manifestacion.comentarios_y_observaciones_actualizacion_mapa_de_actores = comentarios_anteriores
  
        # DZC 2018-10-11 13:15:22 Documentos de diagnóstico:
        @manifestacion.documento_diagnosticos.update_all(requiere_correcciones: false)
  
        # DZC 2018-10-11 13:16:27 Set de metas y acciones:
        comentarios_anteriores = @manifestacion.comentarios_y_observaciones_set_metas_acciones.blank? ? [] : @manifestacion.comentarios_y_observaciones_set_metas_acciones
        comentarios_anteriores << {
          datetime: DateTime.now,
          # user: current_user.nombre_completo(),
          user: current_user.nombre_completo,
          requiere_correcciones: nil,
          texto: "Set de metas y acciones aprobado por #{current_user.nombre_completo}"
        }
        @manifestacion.comentarios_y_observaciones_set_metas_acciones = comentarios_anteriores
  
        # DZC 2018-10-11 13:16:27 Set de metas y acciones:
        comentarios_anteriores = @manifestacion.comentarios_y_observaciones_documento_diagnosticos.blank? ? [] : @manifestacion.comentarios_y_observaciones_documento_diagnosticos
        comentarios_anteriores << {
          datetime: DateTime.now,
          # user: current_user.nombre_completo(),
          user: current_user.nombre_completo,
          requiere_correcciones: nil,
          texto: "Documentos diagóstico aprobado por #{current_user.nombre_completo}"
        }
        @manifestacion.comentarios_y_observaciones_documento_diagnosticos = comentarios_anteriores
        
        @manifestacion.diagnostico_fecha_termino = Time.now.utc
        @manifestacion.tarea_codigo = @tarea.codigo
        # DZC 2018-10-30 10:23:33 se agrega poblamiento de tablas en virtud del contenido del campo mapa_de_actores_data
  
        if @manifestacion.save && @manifestacion.mapa_de_actores_data.present?
          actores_desde_campo = @manifestacion.mapa_de_actores_data.map{|i| i.transform_keys!(&:to_sym).to_h}
          MapaDeActor.actualiza_tablas_mapa_actores(actores_desde_campo, @flujo, @tarea_pendiente)
          @manifestacion.update(mapa_de_actores_data: nil)
        end
  
        #DZC da por terminadas las tareas APL-011, APL-012, APL-013
        TareaPendiente.where(flujo_id: @flujo.id).includes([:tarea]).where({"tareas.codigo" => [Tarea::COD_APL_011.to_s, Tarea::COD_APL_012.to_s, Tarea::COD_APL_013.to_s]}).update(estado_tarea_pendiente_id: 2)
        # @tarea_pendiente.pasar_a_siguiente_tarea 'A'
        continua_flujo_segun_tipo_tarea
        format.js {
          flash[:success] = 'Se puso término a la etapa de diagnóstico'; render js: "window.location='#{root_path}'"
        }
        format.html { redirect_to root_path, flash: {notice: 'Se puso término a la etapa de diagnóstico' }}
      end
    end
  
    def termina_etapa_negociacion #DZC APL-016 TERMINA TODAS LAS TAREAS DESDE APL-016 HACIA ATRAS
      respond_to do |format|
        #DZC agrega el comentario sobre el término al campo respectivo de la manifestación
        @manifestacion = @flujo.manifestacion_de_interes
        @manifestacion.temporal = true #DZC eliminar cuando se pase a produccion
        @manifestacion.update(manifestacion_terminar_negociacion_params)
  
        unless @manifestacion.comentarios_y_observaciones_negociacion_acuerdo.blank?
          #DZC da por terminadas las tareas APL-01, APL-012, APL-013
          TareaPendiente.where(flujo_id: @flujo.id).includes([:tarea]).where({"tareas.codigo" => [Tarea::COD_APL_017.to_s]}).update(estado_tarea_pendiente_id: 2)
          # @tarea_pendiente.pasar_a_siguiente_tarea 'B'
          continua_flujo_segun_tipo_tarea
          format.js { flash.now[:success] = 'Se puso término a la etapa de negociación'; render js: "window.location='#{root_path}'" }
          format.html { redirect_to root_path, flash: {notice: 'Se puso término a la etapa de negociación' }}
        else
          format.js {
            flash[:error] = 'Por favor ingrese los comentarios que justifican el termino de la etapa de negociación.'
            render js: "window.location='#{tarea_pendiente_convocatorias_path(@tarea_pendiente)}'" }
          format.html { redirect_to tarea_pendiente_convocatorias_path(@tarea_pendiente), flash: {error: 'Por favor ingrese los comentarios que justifican el termino de la etapa de negociación' }}
        end
      end
    end
  
    def evaluacion_negociacion #DZC APL-019 Encuesta y Set de metas y acciones
      @manifestacion_de_interes.temporal = true
      @encuesta = Encuesta.find(params[:encuesta_id])
      if @tarea_pendiente.blank? || @tarea_pendiente.no_esta_pendiente?
        #encuesta_no_encontrada
        @desactivado = true
        @encuesta_user_respuesta = EncuestaUserRespuesta.new
      else
        @desactivado = (EncuestaUserRespuesta.where(flujo_id: @flujo.id, encuesta_id: @encuesta.id, user_id: current_user.id).size >= @encuesta.encuesta_preguntas.where(obligatorio: true).size)
        @encuesta_user_respuesta = EncuestaUserRespuesta.new
      end
      @manifestacion_de_interes.accion_en_set_metas_accion = :observacion
      @set_metas_acciones = SetMetasAccion.de_la_manifestacion_de_interes_(@manifestacion_de_interes.id)
      # DZC 2018-11-02 18:01:16 se agrega para posicionar la vista en la pestaña "set metas y acciones"
      if params[:tab_metas].present?
        @tab_metas = params[:tab_metas]
      else
        @tab_metas = true
      end
      # @set_metas_accion = SetMetasAccion.new
      # unless @manifestacion_de_interes.comentarios_y_observaciones_set_metas_acciones.blank?
      #   comentarios = @manifestacion_de_interes.comentarios_y_observaciones_set_metas_acciones.last
      #   @propuestas_con_observaciones = comentarios[:requiere_correcciones]
      # end
  
      # identificamos si tarea 20 se envio o no, para mostrar respuestas
      tarea_20 = TareaPendiente.where(flujo_id: @flujo.id, tarea_id: Tarea::ID_APL_020).first
      @tarea_20_finalizada = !tarea_20.nil? && tarea_20.estado_tarea_pendiente_id == EstadoTareaPendiente::ENVIADA
      @tarea_20_no_enviada = !tarea_20.nil? && tarea_20.estado_tarea_pendiente_id == EstadoTareaPendiente::NO_INICIADA
      
      @origenes = {}
      @set_metas_acciones.each do |sma|
        if !sma.modelo_referencia.blank? && !@origenes.key?(sma.llave_origen)
          nombre = ""
          if sma.modelo_referencia == "EstandarSetMetasAccion"
            nombre = "<b>Estándar:</b> "+EstandarSetMetasAccion.find(sma.id_referencia).estandar_homologacion.nombre
          else
            nombre = "<b>Acuerdo:</b> "+SetMetasAccion.find(sma.id_referencia).flujo.manifestacion_de_interes.nombre_acuerdo
          end
          @origenes[sma.llave_origen] = {
            nombre: nombre,
            color: "%06x" % (rand * 0xffffff)
          }
        end
      end
  
    end
    # APL-019 agregar comentarios al informe
    def observaciones_informe 
      @comentarios_informe_acuerdo = ComentariosInformeAcuerdo.new(observaciones_informe_params)
      @encuesta = Encuesta.find(params[:encuesta_id])
      respond_to do |format|
        r_to = evaluacion_negociacion_manifestacion_de_interes_path(@tarea_pendiente, @manifestacion_de_interes, @tarea_pendiente.tarea.encuesta)
        if @comentarios_informe_acuerdo.save
          tipo_flash = :success
          mensaje_flash = 'Observación agregada correctamente'
          set_comentario_informe
        else
          tipo_flash = :error
          mensaje_flash = 'No se pudo agregar observaciones al informe'
        end
        format.js { flash.now[tipo_flash] = mensaje_flash
          # render js: "window.location='#{r_to}'"
        }
      end
    end
    # APL-019 envia observaciones
    def envia_observaciones_metas_acciones_informe # APL-019 TERMINA TAREA APL-019
      respond_to do |format|
        continua_flujo_segun_tipo_tarea #'A', {primera_ejecucion: true}
        mensaje = "Muchas gracias por tus observaciones. Las observaciones serán compartidas con los miembros del Comité Negociador, quienes elaborarán una nueva propuesta de Acuerdo que recoja las observaciones que consideren pertinentes, dando además respuesta a las observaciones recogidas. Una vez acordada la versión definitiva del Acuerdo, esta se publicará junto a las respuestas respectivas que podrás ver en el menú <a href='#{consulta_publica_propuestas_acuerdo_path}'>\"Consulta Pública Propuestas de Acuerdo\"</a>"
        format.js { flash[:success] = mensaje; render js: "window.location='#{root_path}'" }
        format.html { redirect_to root_path, flash: { notice: mensaje } }
      end
    end
  
    def actualizar_acuerdos_actores #DZC APL-020
      #ToDo: revisar si quitar eso o no
      actores_desde_tablas = MapaDeActor.construye_data_para_apl (@flujo)
      @actores = (!MapaDeActor.adecua_actores_para_vista(actores_desde_tablas).blank? ? MapaDeActor.adecua_actores_para_vista(actores_desde_tablas) : [])#DZC se cambia la lectura de actores a la tabla
      
      @manifestacion_de_interes.temporal = true
      @manifestacion_de_interes.accion_en_mapa_de_actores = :revision #DZC consultar con Stefano y/o cambiar a :actualizacion
      @manifestacion_de_interes.accion_en_set_metas_accion = :respuesta
      @set_metas_acciones = SetMetasAccion.de_la_manifestacion_de_interes_(@manifestacion_de_interes.id)
      # DZC 2018-11-02 18:54:37 se agrega para posicionar la vista en la pestaña "set metas y acciones"
      if params[:tab_metas].present?
        @tab_metas = params[:tab_metas]
      else
        @tab_metas = true
      end
      # @set_metas_accion = SetMetasAccion.new
      unless @manifestacion_de_interes.comentarios_y_observaciones_actualizacion_mapa_de_actores.blank?
        comentarios = @manifestacion_de_interes.comentarios_y_observaciones_actualizacion_mapa_de_actores.last
        @actores_con_observaciones = comentarios[:actores_con_observaciones]
      end
      # unless @manifestacion_de_interes.comentarios_y_observaciones_set_metas_acciones.blank?
      #   comentarios = @manifestacion_de_interes.comentarios_y_observaciones_set_metas_acciones.last
      #   @propuestas_con_observaciones = comentarios[:requiere_correcciones]
      # end
  
      
      @origenes = {}
      @set_metas_acciones.each do |sma|
        if !sma.modelo_referencia.blank? && !@origenes.key?(sma.llave_origen)
          nombre = ""
          if sma.modelo_referencia == "EstandarSetMetasAccion"
            nombre = "<b>Estándar:</b> "+EstandarSetMetasAccion.find(sma.id_referencia).estandar_homologacion.nombre
          else
            nombre = "<b>Acuerdo:</b> "+SetMetasAccion.find(sma.id_referencia).flujo.manifestacion_de_interes.nombre_acuerdo
          end
          @origenes[sma.llave_origen] = {
            nombre: nombre,
            color: "%06x" % (rand * 0xffffff)
          }
        end
      end
    end
  
    # APL-020 agregar responder comentarios al informe
    def responder_observaciones_informe 
      #llenamos variables para saltar otras validaciones
      @informe.solo_respuesta_observaciones = true
      @informe.tarea_codigo = Tarea::COD_APL_020
      @informe.respuesta_observaciones = informe_acuerdo_params[:respuesta_observaciones]
      
      respond_to do |format|
        r_to = actualizar_acuerdos_actores_manifestacion_de_interes_path(@tarea_pendiente, @manifestacion_de_interes)
        if @informe.save
          tipo_flash = :success
          mensaje_flash = 'Respuesta agregada correctamente'
          set_comentario_informe
        else
          tipo_flash = :error
          mensaje_flash = 'No se pudo agregar respuesta.'
        end
        format.js { flash.now[tipo_flash] = mensaje_flash
          # render js: "window.location='#{r_to}'"
        }
      end
    end
  
    def termina_actualizacion_actores_resuelve_comentarios_propuestas #DZC APL-020 TERMINA TAREA APL-020
      # tratamos de actualizar la manifestacion de interes
      @manifestacion = @flujo.manifestacion_de_interes
      @manifestacion.temporal = true
      @manifestacion.envia_termino_proceso = true
      @manifestacion.observaciones_propuesta_acuerdo = observaciones_propuesta_acuerdo_params[:observaciones_propuesta_acuerdo]
      respond_to do |format|
        # si envia comentario dejamos continuar flujo
        if @manifestacion.save
          continua_flujo_segun_tipo_tarea# 'A', {primera_ejecucion: true}
          format.js { flash.now[:success] = 'Se terminó actualización de mapa de actores y resolución de comentarios en propuestas de Acuerdo'; render js: "window.location='#{root_path}'" }
          format.html { redirect_to root_path, flash: {notice: 'Se terminó actualización de mapa de actores y resolución de comentarios en propuestas de Acuerdo' }}
        else
          # do nothing
          format.js {}
        end
      end
    end
  
    def terminar_acuerdo #DZC APL-023 TERMINA TODAS LAS TAREAS DESDE APL-023 HACIA ATRAS
      respond_to do |format|
  
        #DZC agrega el comentario sobre el término al campo respectivo de la manifestación
        @manifestacion = @flujo.manifestacion_de_interes
        @manifestacion.temporal = true #DZC eliminar cuando se pase a produccion
        @manifestacion.update(manifestacion_terminar_acuerdo_params)
  
        #DZC da por terminadas TODAS las tareas tareas del flujo
        TareaPendiente.where(flujo_id: @flujo.id).includes([:tarea]).all.update(estado_tarea_pendiente_id: 2)
        @flujo.update(terminado: true) #DZC termina el flujo
        format.js { flash[:success] = 'Se puso término al Acuerdo'; render js: "window.location='#{root_path}'" }
        format.html { redirect_to root_path, flash: {notice: 'Se puso término al Acuerdo' }}
      end
    end
  
    def detener_acuerdo #DZC APL-016 y APL-023 pausa acuerdo y tareas no se cierran
      respond_to do |format|
  
        #DZC agrega el comentario sobre el término al campo respectivo de la manifestación
        @manifestacion = @flujo.manifestacion_de_interes
        @manifestacion.temporal = true #DZC eliminar cuando se pase a produccion
        @manifestacion.fecha_detencion_acuerdo = Time.now.utc
        @manifestacion.detenido = true
        @manifestacion.assign_attributes(manifestacion_detiene_acuerdo_params)
        @manifestacion.save
        #al guardar esto las funciones encargadas de cerrar tareas segun su programación se pausa
  
        format.js { flash[:success] = 'Se detuvo el Acuerdo correctamente'; render js: "window.location='#{root_path}'" }
        format.html { redirect_to root_path, flash: {notice: 'Se detuvo el Acuerdo correctamente' }}
      end
    end
  
    def google_map_kml
      @content = nil#{}"<?xml version='1.0' encoding='UTF-8'?><kml xmlns='http://www.opengis.net/kml/2.2'><Document></Document></kml>"
      manifestacion_de_interes = ManifestacionDeInteres.find(params[:id]) rescue nil
      unless manifestacion_de_interes.blank?
  
        if params[:file] == 'area-influencia-proyecto' && ! manifestacion_de_interes.area_influencia_proyecto_data.blank?
          @content = manifestacion_de_interes.area_influencia_proyecto_data.file.read
        elsif params[:file] == 'alternativas-instalacion' && ! manifestacion_de_interes.alternativas_instalacion_data.blank?
          @content = manifestacion_de_interes.alternativas_instalacion_data.file.read
        end
      end
      unless false
        send_data @content, type: 'application/vnd.google-earth.kml+xml', charset: "iso-8859-1", filename: "archivo_google_map.kml"
      else
        render layout: false
        respond_to do |format|
          format.html
        end
      end
    end
  
    def descargable
      director = Variable.where(nombre: :nombre_director_ascc).first
      descargable = DescargableTarea.find(params[:descargable_tarea_id])
      mdi = @manifestacion_de_interes
      metodos = {
        "[campo_acuerdo]": mdi.nombre_proyecto.blank? ? '--' : mdi.nombre_proyecto,
        "[nombre_director_ascc]": director.blank? ? '--' : director[:valor],
        "[fecha_hoy]": (l(Date.today,format: "%A, %d de %B %Y")),
        "[representante_entidad_cogestora]": mdi.nombre_representante_para_acuerdo.blank? ? '--' : mdi.nombre_representante_para_acuerdo,
        "[nombre_entidad_cogestora]": mdi.institucion_gestora_acuerdo.blank? ? '--' : mdi.institucion_gestora_acuerdo,
      }
      file = descargable.file(metodos)
      send_data file[:content], type: "application/#{file[:format]}", charset: "iso-8859-1", filename: file[:filename]
    end
    def descargar_compilado
      require 'zip'
      archivo_zip = Zip::OutputStream.write_buffer do |stream|
        @manifestacion_de_interes.documento_diagnosticos.each do |doc|
            if File.exists?(doc.archivo.path)
              # add file to zip
              stream.put_next_entry(doc.archivo.file.identifier)
              archivo_data = IO.read((doc.archivo.current_path rescue doc.archivo.path))
              stream.write archivo_data
          end
        end
      end
      archivo_zip.rewind
      #enviamos el archivo para ser descargado
      send_data archivo_zip.sysread, type: 'application/zip', charset: "iso-8859-1", filename: "documentacion.zip"
    end
  
    def descargar_mapa_de_actores
      ruta = "#{Rails.root}/public/uploads/manifestacion_de_interes/mapa_de_actores_archivo/#{@manifestacion_de_interes.id}/"
      ruta += ""
      send_data File.open("#{Rails.root}/files/mapa_de_actores.xlsx").read, type: 'application/xslx', charset: "iso-8859-1", filename: "mapa_de_actores.xlsx"
    end
  
    def firma
      @firmantes = MapaDeActor.where(flujo_id: @tarea_pendiente.flujo_id, rol_id: Rol::FIRMANTE).includes(persona: :user).all
      @descargables = @tarea_pendiente.get_descargables
    end
  
    def actualizar_firma
      @manifestacion_de_interes.assign_attributes(manifestacion_firma_params)
      @firmantes = MapaDeActor.where(flujo_id: @tarea_pendiente.flujo_id, rol_id: Rol::FIRMANTE).includes(persona: :user).all
      @descargables = @tarea_pendiente.get_descargables
      respond_to do |format|
        if @manifestacion_de_interes.valid?
          @manifestacion_de_interes.tarea_codigo = @tarea.codigo
          @manifestacion_de_interes.save
          #enviar correo?
  
          format.js { flash.now[:success] = 'Convocatoria de firma enviada correctamente' }
          format.html { redirect_to firma_manifestacion_de_interes_path(@tarea_pendiente,@manifestacion_de_interes), flash: {notice: 'Convocatoria de firma enviada correctamente' }}
        else
          format.js { }
          format.html { redirect_to firma_manifestacion_de_interes_path(@tarea_pendiente,@manifestacion_de_interes), flash: {error: 'Problema al enviar convocatoria de firma' }}
        end
      end
    end
  
    def carga_auditoria #DZC APL-032 method: :get
    end
  
    def enviar_carga_auditoria #DZC APL-032 method: :patch
      @manifestacion_de_interes.assign_attributes(manifestacion_carga_audit_params)
      @descargables = @tarea_pendiente.get_descargables
      respond_to do |format|
        if @manifestacion_de_interes.valid?
          @manifestacion_de_interes.tarea_codigo = @tarea.codigo
          @manifestacion_de_interes.save
  
          format.js { flash.now[:success] = 'Carga de auditoría enviada correctamente' }
          format.html { redirect_to carga_auditoria_manifestacion_de_interes_path(@tarea_pendiente,@manifestacion_de_interes), flash: {notice: 'Carga de auditoría enviada correctamente' }}
        else
          format.js { }
          format.html { redirect_to carga_auditoria_manifestacion_de_interes_path(@tarea_pendiente,@manifestacion_de_interes), flash: {error: 'Problema al enviar carga de auditoría' }}
        end
      end
    end
  
    def continua_flujo_segun_tipo_tarea #DZC generalización de condiciones de continuación de flujo
      case @tarea.codigo
      when Tarea::COD_APL_001
        @tarea_pendiente.pasar_a_siguiente_tarea
      when Tarea::COD_APL_002
        #@manifestacion_de_interes.temporal = true
        #@manifestacion_de_interes.update(mapa_de_actores_data: nil) #DZC resetea el valor del campo, para que se contruyan archivos desde las tablas
        @tarea_pendiente.pasar_a_siguiente_tarea ['A','B']
      when Tarea::COD_APL_003_1
        case @manifestacion_de_interes.resultado_admisibilidad
        when "aceptado"
          @tarea_pendiente.pasar_a_siguiente_tarea 'A' 
        when "en_observación"
          @tarea_pendiente.pasar_a_siguiente_tarea 'B'
        when "rechazado"
          #DZC se agrega la validación de la condición 'C', para ser coherente con el método continuar_flujo
          @tarea_pendiente.pasar_a_siguiente_tarea 'C'
        end
      when Tarea::COD_APL_003_2
        case @manifestacion_de_interes.resultado_admisibilidad_juridica
        when "aceptado"
          @tarea_pendiente.pasar_a_siguiente_tarea 'A' 
        when "en_observación"
          @tarea_pendiente.pasar_a_siguiente_tarea 'B'
        when "rechazado"
          #DZC se agrega la validación de la condición 'C', para ser coherente con el método continuar_flujo
          @tarea_pendiente.pasar_a_siguiente_tarea 'C'
        end
      when Tarea::COD_APL_014 # corresponde a la pestaña "Cargar documentos diagnóstico" de la APL-014
        @tarea_pendiente.pasar_a_siguiente_tarea 'A', {primera_ejecucion: true}
      when Tarea::COD_APL_016
        @tarea_pendiente.pasar_a_siguiente_tarea 'B', {}, true, true
      when Tarea::COD_APL_019
        @tarea_pendiente.pasar_a_siguiente_tarea 'A', {}, false
      when Tarea::COD_APL_020
        @tarea_pendiente.pasar_a_siguiente_tarea 'A'
      end
    end
  
    private
  
      def set_tarea_pendiente
        @tarea_pendiente = TareaPendiente.includes([:flujo]).find(params[:id])
        @tarea = @tarea_pendiente.tarea
        autorizado? @tarea_pendiente if @tarea.codigo != Tarea::COD_APL_019
      end
      
      def set_flujo
        @flujo = @tarea_pendiente.flujo
        @tipo_instrumento=@flujo.tipo_instrumento
      end
  
      def set_manifestacion_de_interes
        @solo_lectura = params[:q]
        flujo_apl = Flujo.find(@fondo_produccion_limpia.flujo_apl_id)
        @manifestacion_de_interes = ManifestacionDeInteres.find(flujo_apl.manifestacion_de_interes_id)
        @tarea = @tarea_pendiente.tarea
        @manifestacion_de_interes.tarea_id = @tarea.id if @tarea.present?
        @validaciones = @manifestacion_de_interes.get_campos_validaciones
        @manifestacion_de_interes.current_user = current_user
        @manifestacion_de_interes.tarea_codigo = @tarea.codigo
        @manifestacion_de_interes.temporal = true
        @manifestacion_de_interes.temp_siguientes = true
        @manifestacion_de_interes.save
        checked = @manifestacion_de_interes.set_checked
        @rpc_checked = checked[:rpc_checked]
        @actecos_checked = checked[:actecos_checked]
        @descargables = @tarea_pendiente.get_descargables
        @area_influencia_proyecto_kml   = @manifestacion_de_interes.area_influencia_proyecto_archivo.blank? ? nil : google_map_kml_url(@manifestacion_de_interes,'area-influencia-proyecto')
        @alternativas_instalacion_kml   = @manifestacion_de_interes.alternativas_instalacion_archivo.blank? ? nil : google_map_kml_url(@manifestacion_de_interes,'alternativas-instalacion')
        @area_influencia_proyecto_data  = @manifestacion_de_interes.area_influencia_proyecto_data.blank? ? nil :  @manifestacion_de_interes.area_influencia_proyecto_data
        @alternativas_instalacion_data  = @manifestacion_de_interes.alternativas_instalacion_data.blank? ? nil :  @manifestacion_de_interes.alternativas_instalacion_data
        
      end
  
      def set_contribuyentes
        #se agrega contribuyente del proponente
        @contribuyente = Contribuyente.new
        personas_proponentes = current_user.personas & Responsable.responsables_solo_rol_fast(Rol::PROPONENTE)
  
        #se modifica para que no hayan contribuyentes precargados
        #se modifica para cargar el contribuyente escogido
        if @tarea.codigo == Tarea::COD_FPL_00
          @contribuyentes_del_proponente = Contribuyente.where(id: personas_proponentes.pluck(:contribuyente_id))
        else
          #@contribuyentes_del_proponente = [@flujo.proponente_institucion]
          @contribuyentes_del_proponente = @fondo_produccion_limpia[:institucion_entregables_id]
        end
        #revisar impacto y eliminar si corresponde
          @contribuyentes = Contribuyente.where(id: @personas.map{|m|m[:contribuyente_id]}).all
      end
  
      def set_tipo_instrumentos
        tiid = TipoInstrumento::ACUERDO_DE_PRODUCCION_LIMPIA
        # DZC 2018-11-16 15:30:03 se modifica para excluir el tipo de acuerdo padre de la selección
        @tipo_instrumentos = TipoInstrumento.where("tipo_instrumento_id = (?)",tiid).all
        # @tipo_instrumentos = TipoInstrumento.where("tipo_instrumento_id = (?) OR id = (?)",tiid,tiid).all
  
      end
  
  
      def manifestacion_params
        parameters = params.require(:manifestacion_de_interes).permit(
            :current_tab,:tipo_instrumento_id,:descripcion_acuerdo,:proponente,:contribuyente_id,:institucion_proponente,:institucion_gestora_acuerdo,:rut_institucion_gestora_acuerdo,:direccion_institucion_gestora_acuerdo,:lugar_institucion_gestora_acuerdo,
          :ubicacion_exacta,:tipo_contribuyente_de_institucion_gestora,:numero_de_socios_institucion_gestora,:experiencia_en_gestion_de_proyectos,:fecha_creacion_institucion,:nombre_representante_para_acuerdo,:rut_representante_para_acuerdo,
          :sexo_representante_para_acuerdo,:telefono_representante_para_acuerdo,:email_representante_para_acuerdo,:carta_de_interes_institucion_gestora_firmada,:carta_de_interes_institucion_gestora_firmada_cache,:elegir_territorios,:representacion_en_mapa_selecciones,
          :caracterizacion_sector_territorio,:principales_actores,:mapa_de_actores_archivo,:mapa_de_actores_archivo_cache,:numero_empresas,:porcentaje_mipymes,:produccion,:ventas,:porcentaje_exportaciones,:principales_mercados,:numero_trabajadores,:vulnerabilidad_al_cambio_climatico_del_sector,
          :principales_impactos_socioambientales_del_sector,:principales_problemas_y_desafios,:principales_conflictos,:estudios_sectoriales_territoriales_relevantes,:estudios_sectoriales_territoriales_relevantes_cache,:otro_contexto_sector,:nombre_proyecto,:descripcion_proyecto,
          :justificacion_proyecto,:area_influencia_proyecto_archivo,:area_influencia_proyecto_archivo_cache,:area_influencia_proyecto_data,:area_influencia_proyecto_archivo,:area_influencia_proyecto_archivo_cache,:alternativas_instalacion_archivo,
          :alternativas_instalacion_archivo_cache,:alternativas_instalacion_data,:monto_inversion,:tecnologia,:estado_proyecto,:estudio_de_mercado,:estudio_de_mercado_cache,:anteproyecto,:anteproyecto_cache,:gantt_proyecto,:gantt_proyecto_cache,:operador,:otros_proyectos_en_territorios_cercanos,:otros_estudios,
          :otros_estudios_cache,:otro_datos_proyecto,:nombre_acuerdo,:motivacion_y_objetivos,:equipo_de_trabajo_comprometido,:organigrama,:organigrama_cache,:patrocinadores,:monto_total_comprometido,:otros_recursos_comprometidos,:carta_de_apoyo_y_compromiso,:carta_de_apoyo_y_compromiso_cache,
          :numero_participantes,:lista_participantes,:priorizacion,:otras_iniciativas_relacionadas_en_ejecucion,:diagnostico_id,:estandar_de_certificacion_id,:otros_objetivos_acuerdo,:otros_estudios_relevantes,:otros_estudios_relevantes_cache,:coordernadas_territorios,:temporal, :current_user, :representante_institucion_para_solicitud_id, :proponente_institucion_id,
          :relacion_de_politicas,:fuente_de_fondos,:justificacion_de_estimacion_de_fondos_requeridos,:nombre_de_estandar_certificable, :estandar_certificable, :estandar_certificable_cache, :diagnostico_de_acuerdo_propuesto,
          :diagnostico_de_acuerdo_anterior, :diagnostico_de_acuerdo_anterior_cache, :informe_de_acuerdo_anterior, :informe_de_acuerdo_anterior_cache, :acuerdo_previo_con_informe_id, 
          :radio_estandar, :radio_diagnostico, :radio_informe, :cadena_de_valor, :otras_caracteristicas_relevantes, :acuerdo_de_alcance_nacional, :comentarios_cifras,
          :detalle_de_localizacion, :detalle_de_alternativa_de_instalacion,
            :sucursal_ligada,:justificacion_de_seleccion,:registro_en_linea,:proponente,:proponente_institucion_id,
          :unidad_de_medida_volumen,
          :anulado,
          actividad_economicas_ids: [], comunas_ids: [], cuencas_ids: [],
          programas_o_proyectos_relacionados_ids: [],
          sectores_economicos:{},territorios_regiones:{},territorios_provincias:{},territorios_comunas:{},
        )
        #Permite parsear el formato de nùmero para que el motor de base datos pueda almacenar nùmeros con punto (ex. 1.000). al momento se realiza para los montos de tipo moneda.-
        parameters[:monto_total_comprometido] = parameters[:monto_total_comprometido].gsub('.','') unless parameters[:monto_total_comprometido].nil?
        #parameters[:ventas] = parameters[:ventas].gsub(/[\.$]/,'') unless parameters[:ventas].nil?
        parameters[:monto_inversion] = parameters[:monto_inversion].gsub(/[\.$]/,'') unless parameters[:monto_inversion].nil?
        #parameters[:numero_empresas] = parameters[:numero_empresas].gsub('.','') unless parameters[:numero_empresas].nil?
        parameters[:numero_de_socios_institucion_gestora] = parameters[:numero_de_socios_institucion_gestora].gsub('.','') unless parameters[:numero_de_socios_institucion_gestora].nil?
        #parameters[:produccion] = parameters[:produccion].gsub('.','') unless parameters[:produccion].nil?
        #parameters[:numero_trabajadores] = parameters[:numero_trabajadores].gsub('.','') unless parameters[:numero_trabajadores].nil?
        parameters
      end
  
      def manifestacion_revisor_params
        params.require(:manifestacion_de_interes).permit(
          :revisor_tecnico_id,
          :revisor_juridico_id,
          :comentario_jefe_de_linea,
          :temporal
        )
      end
  
      def manifestacion_usuario_entregables_params
        params.require(:manifestacion_de_interes).permit(
          :institucion_entregables_id,
          :institucion_entregables_name,
          :usuario_entregables_id,
          :usuario_entregable_name,
          :archivo_usuario_entregables,
          :usuario_entregables_comentario,
          :usuario_entregables_otros
          # :archivo_usuario_entregables,
          # :update_usuario_entregables,
          # :temporal
        )
      end
  
      def manifestacion_admisibilidad_params #DZC se modifica para agregar fecha de las observaciones y posteriormente comprobar cumplimiento plazo para evacuar dichas observaciones
        parametros=params.require(:manifestacion_de_interes).permit(
          :resultado_admisibilidad,
          :tipo_instrumento_id,
          :observaciones_admisibilidad,
          :temporal,
          :update_admisibilidad,
          :temp_siguientes,
          secciones_observadas_admisibilidad: []
        )
        if @manifestacion_de_interes.fecha_observaciones_admisibilidad.nil?
          parametros[:fecha_observaciones_admisibilidad]=Time.now.utc
        end
        parametros
      end
  
      def manifestacion_admisibilidad_juridica_params 
        parametros=params.require(:manifestacion_de_interes).permit(
          :resultado_admisibilidad_juridica,
          :observaciones_admisibilidad_juridica,
          :temporal,
          :temp_siguientes,
          :update_admisibilidad_juridica,
          secciones_observadas_admisibilidad_juridica: []
        )
        if @manifestacion_de_interes.fecha_observaciones_admisibilidad_juridica.nil?
          parametros[:fecha_observaciones_admisibilidad_juridica]=Time.now.utc
        end
        parametros
      end
  
      def manifestacion_obs_admisibilidad_params
        parameters = params.require(:manifestacion_de_interes).permit(
          :current_tab,:tipo_instrumento_id,:descripcion_acuerdo,:proponente,:contribuyente_id,:institucion_proponente,:institucion_gestora_acuerdo,:rut_institucion_gestora_acuerdo,:direccion_institucion_gestora_acuerdo,:lugar_institucion_gestora_acuerdo,
          :ubicacion_exacta,:tipo_contribuyente_de_institucion_gestora,:numero_de_socios_institucion_gestora,:experiencia_en_gestion_de_proyectos,:fecha_creacion_institucion,:nombre_representante_para_acuerdo,:rut_representante_para_acuerdo,
          :sexo_representante_para_acuerdo,:telefono_representante_para_acuerdo,:email_representante_para_acuerdo,:carta_de_interes_institucion_gestora_firmada,:carta_de_interes_institucion_gestora_firmada_cache,:elegir_territorios,:representacion_en_mapa_selecciones,
          :caracterizacion_sector_territorio,:principales_actores,:mapa_de_actores_archivo,:mapa_de_actores_archivo_cache,:numero_empresas,:porcentaje_mipymes,:produccion,:ventas,:porcentaje_exportaciones,:principales_mercados,:numero_trabajadores,:vulnerabilidad_al_cambio_climatico_del_sector,
          :principales_impactos_socioambientales_del_sector,:principales_problemas_y_desafios,:principales_conflictos,:estudios_sectoriales_territoriales_relevantes,:estudios_sectoriales_territoriales_relevantes_cache,:otro_contexto_sector,:nombre_proyecto,:descripcion_proyecto,
          :justificacion_proyecto,:area_influencia_proyecto_archivo,:area_influencia_proyecto_archivo_cache,:area_influencia_proyecto_data,:area_influencia_proyecto_archivo,:area_influencia_proyecto_archivo_cache,:alternativas_instalacion_archivo,
          :alternativas_instalacion_archivo_cache,:alternativas_instalacion_data,:monto_inversion,:tecnologia,:estado_proyecto,:estudio_de_mercado,:estudio_de_mercado_cache,:anteproyecto,:anteproyecto_cache,:gantt_proyecto,:gantt_proyecto_cache,:operador,:otros_proyectos_en_territorios_cercanos,:otros_estudios,
          :otros_estudios_cache,:otro_datos_proyecto,:nombre_acuerdo,:motivacion_y_objetivos,:equipo_de_trabajo_comprometido,:organigrama,:organigrama_cache,:patrocinadores,:monto_total_comprometido,:otros_recursos_comprometidos,:carta_de_apoyo_y_compromiso,:carta_de_apoyo_y_compromiso_cache,
          :numero_participantes,:lista_participantes,:priorizacion,:otras_iniciativas_relacionadas_en_ejecucion,:diagnostico_id,:estandar_de_certificacion_id,:otros_objetivos_acuerdo,:otros_estudios_relevantes,:otros_estudios_relevantes_cache,:coordernadas_territorios,:temporal, :current_user, :representante_institucion_para_solicitud_id, :proponente_institucion_id,
          :relacion_de_politicas,:fuente_de_fondos,:justificacion_de_estimacion_de_fondos_requeridos,:nombre_de_estandar_certificable, :estandar_certificable, :estandar_certificable_cache, :diagnostico_de_acuerdo_propuesto,
          :diagnostico_de_acuerdo_anterior, :diagnostico_de_acuerdo_anterior_cache, :informe_de_acuerdo_anterior, :informe_de_acuerdo_anterior_cache, :acuerdo_previo_con_informe_id, 
          :radio_estandar, :radio_diagnostico, :radio_informe, :cadena_de_valor, :otras_caracteristicas_relevantes, :acuerdo_de_alcance_nacional, :comentarios_cifras,
          :detalle_de_localizacion, :detalle_de_alternativa_de_instalacion,
          :sucursal_ligada,:justificacion_de_seleccion,:registro_en_linea,:proponente,:proponente_institucion_id,
          :unidad_de_medida_volumen,
          :respuesta_observaciones_admisibilidad,:archivo_admisibilidad,:archivo_admisibilidad_cache,:update_obs_admisibilidad,
          :temp_siguientes,
          actividad_economicas_ids: [], comunas_ids: [], cuencas_ids: [],
          programas_o_proyectos_relacionados_ids: [],
          sectores_economicos:{},territorios_regiones:{},territorios_provincias:{},territorios_comunas:{},
        )
        #Permite parsear el formato de nùmero para que el motor de base datos pueda almacenar nùmeros con punto (ex. 1.000). al momento se realiza para los montos de tipo moneda.-
        parameters[:monto_total_comprometido] = parameters[:monto_total_comprometido].gsub('.','') unless parameters[:monto_total_comprometido].nil?
        #parameters[:ventas] = parameters[:ventas].gsub(/[\.$]/,'') unless parameters[:ventas].nil?
        parameters[:monto_inversion] = parameters[:monto_inversion].gsub(/[\.$]/,'') unless parameters[:monto_inversion].nil?
        #parameters[:numero_empresas] = parameters[:numero_empresas].gsub('.','') unless parameters[:numero_empresas].nil?
        parameters[:numero_de_socios_institucion_gestora] = parameters[:numero_de_socios_institucion_gestora].gsub('.','') unless parameters[:numero_de_socios_institucion_gestora].nil?
        #parameters[:produccion] = parameters[:produccion].gsub('.','') unless parameters[:produccion].nil?
        #parameters[:numero_trabajadores] = parameters[:numero_trabajadores].gsub('.','') unless parameters[:numero_trabajadores].nil?
        parameters
      end
  
      def manifestacion_obs_admisibilidad_juridica_params
        parameters = params.require(:manifestacion_de_interes).permit(
          :current_tab,:tipo_instrumento_id,:descripcion_acuerdo,:proponente,:contribuyente_id,:institucion_proponente,:institucion_gestora_acuerdo,:rut_institucion_gestora_acuerdo,:direccion_institucion_gestora_acuerdo,:lugar_institucion_gestora_acuerdo,
          :ubicacion_exacta,:tipo_contribuyente_de_institucion_gestora,:numero_de_socios_institucion_gestora,:experiencia_en_gestion_de_proyectos,:fecha_creacion_institucion,:nombre_representante_para_acuerdo,:rut_representante_para_acuerdo,
          :sexo_representante_para_acuerdo,:telefono_representante_para_acuerdo,:email_representante_para_acuerdo,:carta_de_interes_institucion_gestora_firmada,:carta_de_interes_institucion_gestora_firmada_cache,:elegir_territorios,:representacion_en_mapa_selecciones,
          :caracterizacion_sector_territorio,:principales_actores,:mapa_de_actores_archivo,:mapa_de_actores_archivo_cache,:numero_empresas,:porcentaje_mipymes,:produccion,:ventas,:porcentaje_exportaciones,:principales_mercados,:numero_trabajadores,:vulnerabilidad_al_cambio_climatico_del_sector,
          :principales_impactos_socioambientales_del_sector,:principales_problemas_y_desafios,:principales_conflictos,:estudios_sectoriales_territoriales_relevantes,:estudios_sectoriales_territoriales_relevantes_cache,:otro_contexto_sector,:nombre_proyecto,:descripcion_proyecto,
          :justificacion_proyecto,:area_influencia_proyecto_archivo,:area_influencia_proyecto_archivo_cache,:area_influencia_proyecto_data,:area_influencia_proyecto_archivo,:area_influencia_proyecto_archivo_cache,:alternativas_instalacion_archivo,
          :alternativas_instalacion_archivo_cache,:alternativas_instalacion_data,:monto_inversion,:tecnologia,:estado_proyecto,:estudio_de_mercado,:estudio_de_mercado_cache,:anteproyecto,:anteproyecto_cache,:gantt_proyecto,:gantt_proyecto_cache,:operador,:otros_proyectos_en_territorios_cercanos,:otros_estudios,
          :otros_estudios_cache,:otro_datos_proyecto,:nombre_acuerdo,:motivacion_y_objetivos,:equipo_de_trabajo_comprometido,:organigrama,:organigrama_cache,:patrocinadores,:monto_total_comprometido,:otros_recursos_comprometidos,:carta_de_apoyo_y_compromiso,:carta_de_apoyo_y_compromiso_cache,
          :numero_participantes,:lista_participantes,:priorizacion,:otras_iniciativas_relacionadas_en_ejecucion,:diagnostico_id,:estandar_de_certificacion_id,:otros_objetivos_acuerdo,:otros_estudios_relevantes,:otros_estudios_relevantes_cache,:coordernadas_territorios,:temporal, :current_user, :representante_institucion_para_solicitud_id, :proponente_institucion_id,
          :relacion_de_politicas,:fuente_de_fondos,:justificacion_de_estimacion_de_fondos_requeridos,:nombre_de_estandar_certificable, :estandar_certificable, :estandar_certificable_cache, :diagnostico_de_acuerdo_propuesto,
          :diagnostico_de_acuerdo_anterior, :diagnostico_de_acuerdo_anterior_cache, :informe_de_acuerdo_anterior, :informe_de_acuerdo_anterior_cache, :acuerdo_previo_con_informe_id, 
          :radio_estandar, :radio_diagnostico, :radio_informe, :cadena_de_valor, :otras_caracteristicas_relevantes, :acuerdo_de_alcance_nacional, :comentarios_cifras,
          :detalle_de_localizacion, :detalle_de_alternativa_de_instalacion,
          :sucursal_ligada,:justificacion_de_seleccion,:registro_en_linea,:proponente,:proponente_institucion_id,
          :unidad_de_medida_volumen,
          :respuesta_observaciones_admisibilidad_juridica,:archivo_admisibilidad_juridica,:archivo_admisibilidad_juridica_cache,:update_obs_admisibilidad_juridica,
          :temp_siguientes,
          actividad_economicas_ids: [], comunas_ids: [], cuencas_ids: [],
          programas_o_proyectos_relacionados_ids: [],
          sectores_economicos:{},territorios_regiones:{},territorios_provincias:{},territorios_comunas:{},
        )
        #Permite parsear el formato de nùmero para que el motor de base datos pueda almacenar nùmeros con punto (ex. 1.000). al momento se realiza para los montos de tipo moneda.-
        parameters[:monto_total_comprometido] = parameters[:monto_total_comprometido].gsub('.','') unless parameters[:monto_total_comprometido].nil?
        #parameters[:ventas] = parameters[:ventas].gsub(/[\.$]/,'') unless parameters[:ventas].nil?
        parameters[:monto_inversion] = parameters[:monto_inversion].gsub(/[\.$]/,'') unless parameters[:monto_inversion].nil?
        #parameters[:numero_empresas] = parameters[:numero_empresas].gsub('.','') unless parameters[:numero_empresas].nil?
        parameters[:numero_de_socios_institucion_gestora] = parameters[:numero_de_socios_institucion_gestora].gsub('.','') unless parameters[:numero_de_socios_institucion_gestora].nil?
        #parameters[:produccion] = parameters[:produccion].gsub('.','') unless parameters[:produccion].nil?
        #parameters[:numero_trabajadores] = parameters[:numero_trabajadores].gsub('.','') unless parameters[:numero_trabajadores].nil?
        parameters
      end
  
  
  
      def manifestacion_pertinencia_params #DZC se modifica para agregar fecha de las observaciones y posteriormente comprobar cumplimiento plazo para evacuar dichas observaciones
        parametros=params.require(:manifestacion_de_interes).permit(
          :resultado_pertinencia,
          :tipo_instrumento_id,
          :observaciones_pertinencia_factibilidad,
          :compromiso_pertinencia_factibilidad,
          :coordinador_subtipo_instrumento_id,
          :encargado_hitos_prensa_id,
          :archivo_pertinencia_factibilidad,
          :archivo_pertinencia_factibilidad_cache,
          :temporal,
          :temp_siguientes,
          :update_pertinencia,
          :fondo_produccion_limpia,
          secciones_observadas_pertinencia_factibilidad: []
        )
        if @manifestacion_de_interes.fecha_observaciones_admisibilidad.nil?
          parametros[:fecha_observaciones_admisibilidad]=Time.now.utc
        end
        parametros
      end
  
      def manifestacion_responder_pertinencia_params
        parameters = params.require(:manifestacion_de_interes).permit(
          :current_tab,:tipo_instrumento_id,:descripcion_acuerdo,:proponente,:contribuyente_id,:institucion_proponente,:institucion_gestora_acuerdo,:rut_institucion_gestora_acuerdo,:direccion_institucion_gestora_acuerdo,:lugar_institucion_gestora_acuerdo,
          :ubicacion_exacta,:tipo_contribuyente_de_institucion_gestora,:numero_de_socios_institucion_gestora,:experiencia_en_gestion_de_proyectos,:fecha_creacion_institucion,:nombre_representante_para_acuerdo,:rut_representante_para_acuerdo,
          :sexo_representante_para_acuerdo,:telefono_representante_para_acuerdo,:email_representante_para_acuerdo,:carta_de_interes_institucion_gestora_firmada,:carta_de_interes_institucion_gestora_firmada_cache,:elegir_territorios,:representacion_en_mapa_selecciones,
          :caracterizacion_sector_territorio,:principales_actores,:mapa_de_actores_archivo,:mapa_de_actores_archivo_cache,:numero_empresas,:porcentaje_mipymes,:produccion,:ventas,:porcentaje_exportaciones,:principales_mercados,:numero_trabajadores,:vulnerabilidad_al_cambio_climatico_del_sector,
          :principales_impactos_socioambientales_del_sector,:principales_problemas_y_desafios,:principales_conflictos,:estudios_sectoriales_territoriales_relevantes,:estudios_sectoriales_territoriales_relevantes_cache,:otro_contexto_sector,:nombre_proyecto,:descripcion_proyecto,
          :justificacion_proyecto,:area_influencia_proyecto_archivo,:area_influencia_proyecto_archivo_cache,:area_influencia_proyecto_data,:area_influencia_proyecto_archivo,:area_influencia_proyecto_archivo_cache,:alternativas_instalacion_archivo,
          :alternativas_instalacion_archivo_cache,:alternativas_instalacion_data,:monto_inversion,:tecnologia,:estado_proyecto,:estudio_de_mercado,:estudio_de_mercado_cache,:anteproyecto,:anteproyecto_cache,:gantt_proyecto,:gantt_proyecto_cache,:operador,:otros_proyectos_en_territorios_cercanos,:otros_estudios,
          :otros_estudios_cache,:otro_datos_proyecto,:nombre_acuerdo,:motivacion_y_objetivos,:equipo_de_trabajo_comprometido,:organigrama,:organigrama_cache,:patrocinadores,:monto_total_comprometido,:otros_recursos_comprometidos,:carta_de_apoyo_y_compromiso,:carta_de_apoyo_y_compromiso_cache,
          :numero_participantes,:lista_participantes,:priorizacion,:otras_iniciativas_relacionadas_en_ejecucion,:diagnostico_id,:estandar_de_certificacion_id,:otros_objetivos_acuerdo,:otros_estudios_relevantes,:otros_estudios_relevantes_cache,:coordernadas_territorios,:temporal, :current_user, :representante_institucion_para_solicitud_id, :proponente_institucion_id,
          :relacion_de_politicas,:fuente_de_fondos,:justificacion_de_estimacion_de_fondos_requeridos,:nombre_de_estandar_certificable, :estandar_certificable, :estandar_certificable_cache, :diagnostico_de_acuerdo_propuesto,
          :diagnostico_de_acuerdo_anterior, :diagnostico_de_acuerdo_anterior_cache, :informe_de_acuerdo_anterior, :informe_de_acuerdo_anterior_cache, :acuerdo_previo_con_informe_id, 
          :radio_estandar, :radio_diagnostico, :radio_informe, :cadena_de_valor, :otras_caracteristicas_relevantes, :acuerdo_de_alcance_nacional, :comentarios_cifras,
          :detalle_de_localizacion, :detalle_de_alternativa_de_instalacion,
          :sucursal_ligada,:justificacion_de_seleccion,:registro_en_linea,:proponente,:proponente_institucion_id,
          :unidad_de_medida_volumen,
          :acepta_condiciones_pertinencia, :respuesta_observaciones_pertinencia_factibilidad, :respuesta_otros_pertinencia_factibilidad, :archivo_respuesta_pertinencia_factibilidad, :archivo_respuesta_pertinencia_factibilidad_cache, :update_respuesta_pertinencia,
          :temp_siguientes,
          actividad_economicas_ids: [], comunas_ids: [], cuencas_ids: [],
          programas_o_proyectos_relacionados_ids: [],
          sectores_economicos:{},territorios_regiones:{},territorios_provincias:{},territorios_comunas:{},
        )
        #Permite parsear el formato de nùmero para que el motor de base datos pueda almacenar nùmeros con punto (ex. 1.000). al momento se realiza para los montos de tipo moneda.-
        parameters[:monto_total_comprometido] = parameters[:monto_total_comprometido].gsub('.','') unless parameters[:monto_total_comprometido].nil?
        #parameters[:ventas] = parameters[:ventas].gsub(/[\.$]/,'') unless parameters[:ventas].nil?
        parameters[:monto_inversion] = parameters[:monto_inversion].gsub(/[\.$]/,'') unless parameters[:monto_inversion].nil?
        #parameters[:numero_empresas] = parameters[:numero_empresas].gsub('.','') unless parameters[:numero_empresas].nil?
        parameters[:numero_de_socios_institucion_gestora] = parameters[:numero_de_socios_institucion_gestora].gsub('.','') unless parameters[:numero_de_socios_institucion_gestora].nil?
        #parameters[:produccion] = parameters[:produccion].gsub('.','') unless parameters[:produccion].nil?
        #parameters[:numero_trabajadores] = parameters[:numero_trabajadores].gsub('.','') unless parameters[:numero_trabajadores].nil?
        parameters
      end
  
      def manifestacion_firma_params
        params.require(:manifestacion_de_interes).permit(
          :fecha_firma,
          :direccion_firma,
          :lat_firma,
          :lng_firma,
          :temporal,
          firma_archivo: [],
          firmantes: []
        )
      end
  
  
      def manifestacion_carga_audit_params
        params.require(:manifestacion_de_interes).permit(
          :archivo_carga_auditoria,
          :temporal
        )
      end
  
      #DZC
      def manifestacion_terminar_diagnostico_params
        parametros=params(
          :observaciones_documentos_diagnostico
        )
        parametros[:diagnostico_fecha_termino]=Time.now.utc #agrega nuevo campo al hash, lo que permite instanciar ese campo en la tabla al momento de ejecutar el patch (update)
        parametros
      end
  
      # DZC APL-016 TERMINA TAREA Y ETAPA
      def manifestacion_terminar_negociacion_params
        parametros=params.require(:manifestacion_de_interes).permit(
          :comentarios_y_observaciones_negociacion_acuerdo
        )
        parametros[:fecha_termino_negociacion]=Time.now.utc #agrega nuevo campo al hash, lo que permite instanciar ese campo en la tabla al momento de ejecutar el patch (update)
        parametros
      end
  
      # DZC APL-023 TERMINA TAREA Y ETAPA
      def manifestacion_terminar_acuerdo_params
        parametros=params.require(:manifestacion_de_interes).permit(
          :comentarios_y_observaciones_termino_acuerdo
        )
        parametros[:fecha_termino_acuerdo]=Time.now.utc #agrega nuevo campo al hash, lo que permite instanciar ese campo en la tabla al momento de ejecutar el patch (update)
        parametros
      end
  
      # DZC APL-016 y APL-023 PAUSA
      def manifestacion_detiene_acuerdo_params
        parametros=params.require(:manifestacion_de_interes).permit(
          :comentarios_y_observaciones_detencion_acuerdo
        )
        parametros
      end
  
      def set_representantes
        usuario = User.unscoped.find_by_id(@manifestacion_de_interes.representante_institucion_para_solicitud_id)
        resultado = Persona.por_institucion_cargo(@manifestacion_de_interes.contribuyente_id, Cargo::ENCARGADO_INS, usuario, true)
        @representantes = resultado[0]
        @nuevo_usuario = resultado[1]
      end
  
      def carga_de_representantes
        if(! @manifestacion_de_interes.contribuyente_id.nil?)

          contribuyente_temp = Contribuyente.unscoped.find(@manifestacion_de_interes.contribuyente_id)
          cargo_ids = Responsable.where(rol_id: Rol::PROPONENTE, tipo_instrumento_id: TipoInstrumento::ACUERDO_DE_PRODUCCION_LIMPIA, contribuyente_id: [nil, contribuyente_temp.contribuyente_id]).pluck(:cargo_id)
          @usuarios = User.includes(personas: :persona_cargos).where(personas: {contribuyente_id: contribuyente_temp.contribuyente_id}).where(persona_cargos: {cargo_id: cargo_ids})
        end
      end
  
      def set_informe
        # cargamos el informe
        @informe = @manifestacion_de_interes.informe_acuerdo
        if @informe.nil?
          @informe = InformeAcuerdo.new({manifestacion_de_interes_id: @manifestacion_de_interes.id})
          @informe.save(validate: false)
        end
        @auditorias = Auditoria.where(flujo_id: @flujo.id).all
        @datos = @informe.nil? ? {} : @informe._a_datos(@auditorias)
        @actores_mapa = MapaDeActor.where(flujo_id: @tarea_pendiente.flujo_id, rol_id: Rol::FIRMANTE).includes([:rol, persona: [:user,:contribuyente, persona_cargos: [:cargo]]]).all
      end
  
      def set_comentario_informe
        # inicializamos el comentarios_informe_acuerdo
        parametros_comentario = {
          user_id: @current_user.id,
          nombre: @current_user.nombre_completo,
          rut: @current_user.rut,
          email: @current_user.email,
          informe_acuerdo_id: @informe.id
        }
        @comentarios_informe_acuerdo = ComentariosInformeAcuerdo.new(parametros_comentario)
      end
      def observaciones_informe_params
        parametros = params.require(:comentarios_informe_acuerdo).permit(
          :id, :user_id, :informe_acuerdo_id, :nombre, :rut, :email, :comentario
        )
        parametros
      end
  
      def observaciones_propuesta_acuerdo_params
        parametros = params.require(:tarea_pendiente).permit(:observaciones_propuesta_acuerdo)
        parametros
      end
      def informe_acuerdo_params
        parametros = params.require(:informe_acuerdo).permit(:respuesta_observaciones)
        parametros
      end
  
      def set_lineas
        @lineas = Linea.order(id: :asc).all
      end
  
      def set_sub_lineas
        @sub_lineas = SubLinea.where(linea_id: @fondo_produccion_limpia.linea_id)
      end
    
      def set_fondo_produccion_limpia
        @tarea_pendiente = TareaPendiente.includes([:flujo]).find(params[:id])
        @fondo_produccion_limpia = FondoProduccionLimpia.where(flujo_id: @tarea_pendiente.flujo_id).first
        @duracion =  @fondo_produccion_limpia.duracion
        @meses = [1,2,3,4,5,6]
      end  

      def send_message(tarea, user)
        u = User.find(user)
        mensajes = FondoProduccionLimpiaMensaje.where(tarea_id: tarea.id)
        fpl = FondoProduccionLimpia.where(flujo_id: @tarea_pendiente.flujo_id).first

        flujo_apl = Flujo.find(fpl.flujo_apl_id)
        mdi = ManifestacionDeInteres.find(flujo_apl.manifestacion_de_interes_id)

        metodo = FondoProduccionLimpiaMensaje.metodos(u,mdi,fpl)
        mensajes.each do |mensaje|
          FondoProduccionLimpiaMailer.paso_de_tarea(mensaje.asunto, mensaje.body, u).deliver_now
        end
      end

      def fondo_produccion_limpia_params
        params.require(:fondo_produccion_limpia).permit(:proponente, :nombre_acuerdo, :linea_id, :sub_linea_id)
      end

      def set_objetivos_especificos
        @objetivos = ObjetivosEspecifico.where(flujo_id: @tarea_pendiente.flujo_id).all
        @objetivo = ObjetivosEspecifico.where(flujo_id: @tarea_pendiente.flujo_id).select(:descripcion, :id)
        @objetivos_options = @objetivo.map { |objetivo| [objetivo.descripcion, objetivo.id] }
      end

      def set_registro_proveedores
        @registro_proveedores = RegistroProveedor.where(estado: 4)
        @registro_proveedor = RegistroProveedor.where(estado: 4).select(:nombre, :apellido, :id)
        @registro_options = @registro_proveedor.map { |registro_proveedor| [registro_proveedor.nombre + ' ' + registro_proveedor.apellido, registro_proveedor.id] }
      end  

      def set_equipo_trabajo
        set_equipo_empresa

        @count_user_equipo = EquipoTrabajo.where(flujo_id: @tarea_pendiente.flujo_id, tipo_equipo: 1).count
        @user_equipo = EquipoTrabajo.where(flujo_id: @tarea_pendiente.flujo_id, tipo_equipo: [1, 2])
        @postulantes = EquipoTrabajo.where(flujo_id: @tarea_pendiente.flujo_id, tipo_equipo: 3)
        
        # Obtener los equipos de trabajo que coinciden
        equipo_trabajos = EquipoTrabajo.where(flujo_id: @tarea_pendiente.flujo_id, tipo_equipo: 4)

        # Crear un hash para acceder rápidamente a los IDs de EquipoTrabajo por registro_proveedores_id
        equipo_trabajo_hash = equipo_trabajos.group_by(&:registro_proveedores_id)

        @auditor_all = RegistroProveedor.where(id: equipo_trabajo_hash.keys)

        # Ahora iteramos sobre @auditores y obtenemos los IDs de EquipoTrabajo
        @auditores = @auditor_all.map do |auditor|
          {
            auditor: auditor,
            equipo_trabajo_ids: equipo_trabajo_hash[auditor.id].map(&:id), # Obtener los IDs de EquipoTrabajo
            valor_hh: equipo_trabajo_hash[auditor.id].map(&:valor_hh) # Obtener el valor_hh
          }
        end

        if @count_user_equipo > 0
          @show_consultor_div = true
        else
          @show_consultor_div = false
        end
      end

      def set_plan_actividades
        @plan_actividades = PlanActividad.includes(:actividad).find_by(flujo_id: @tarea_pendiente.flujo_id)
        @nombre_actividad = @plan_actividades.actividad.nombre if @plan_actividades&.actividad.present?  
      end

      def set_equipo_empresa
        @count_empresa_equipo = EquipoEmpresa.where(flujo_id: @tarea_pendiente.flujo_id).count
        @count_user_empresa = EquipoTrabajo.where(flujo_id: @tarea_pendiente.flujo_id, tipo_equipo: 2).count
     
        @empresa_equipo = Contribuyente
        .unscoped
        .joins(:equipo_empresas)
        .select("contribuyentes.id, contribuyentes.rut || \'\' || contribuyentes.dv AS rut, contribuyentes.razon_social, equipo_empresas.id, equipo_empresas.contribuyente_id, equipo_empresas.flujo_id")
        .where(equipo_empresas: {flujo_id: @tarea_pendiente.flujo_id})
        .all

        if @count_empresa_equipo > 0
          @show_empresa_div = true
        else
          @show_empresa_div = false
        end 
      end

      def set_actividades_x_linea
        @actividad_x_linea = Actividad.actividad_x_linea(@tarea_pendiente.flujo_id, @tarea_pendiente.flujo.tipo_instrumento_id)
        @actividad_detalle = PlanActividad.actividad_detalle(@tarea_pendiente.flujo_id)
      end

      def set_costos
        @costos = PlanActividad.costos(@tarea_pendiente.flujo_id)
        if @flujo.tipo_instrumento_id != TipoInstrumento::FPL_LINEA_1_1 || @flujo.tipo_instrumento_id != TipoInstrumento::FPL_LINEA_5_1 
          @costos_seguimiento = PlanActividad.costos_seguimiento(@tarea_pendiente.flujo_id, @flujo.tipo_instrumento_id)

          aporte_micro = 0
          aporte_pequena = 0
          aporte_mediana = 0
          tope_maximo = 0

          if @flujo.tipo_instrumento_id == TipoInstrumento::FPL_LINEA_1_3 || @flujo.tipo_instrumento_id == TipoInstrumento::FPL_EXTRAPRESUPUESTARIO_EVALUACION
            aporte_micro = FondoProduccionLimpia::APORTE_MICRO_EMPRESA_L13
            aporte_pequena = FondoProduccionLimpia::APORTE_PEQUEÑA_EMPRESA_L13
            aporte_mediana = FondoProduccionLimpia::APORTE_MEDIANA_EMPRESA_L13
            tope_maximo = Gasto::TOPE_MAXIMO_SOLICITAR_EVALUACION_L1_3
          else
            aporte_micro = FondoProduccionLimpia::APORTE_MICRO_EMPRESA
            aporte_pequena = FondoProduccionLimpia::APORTE_PEQUEÑA_EMPRESA
            aporte_mediana = FondoProduccionLimpia::APORTE_MEDIANA_EMPRESA

            if @flujo.tipo_instrumento_id == TipoInstrumento::FPL_LINEA_1_2_1 || @flujo.tipo_instrumento_id == TipoInstrumento::FPL_EXTRAPRESUPUESTARIO_SEGUIMIENTO
              tope_maximo = Gasto::TOPE_MAXIMO_SOLICITAR_SEGUIMIENTO_L1_1
            elsif @flujo.tipo_instrumento_id == TipoInstrumento::FPL_LINEA_1_2_2 || @flujo.tipo_instrumento_id == TipoInstrumento::FPL_EXTRAPRESUPUESTARIO_SEGUIMIENTO_2
              tope_maximo = Gasto::TOPE_MAXIMO_SOLICITAR_SEGUIMIENTO_L1_2
            end
          end
          
          @confinanciamiento_empresa = nil
          if @fondo_produccion_limpia.present?
            if @fondo_produccion_limpia.cantidad_micro_empresa != 0 || 
              @fondo_produccion_limpia.cantidad_pequeña_empresa != 0 || 
              @fondo_produccion_limpia.cantidad_mediana_empresa != 0
                @confinanciamiento_empresa = FondoProduccionLimpia.calcular_suma_y_porcentaje(@tarea_pendiente.flujo_id,aporte_micro,aporte_pequena,aporte_mediana,tope_maximo)
            end
          end
        end  
        
        # Modifica mensaje y envia flag para permitir seguir con el proceso de diagnostico, en donde en la validación debe ir todo en SI
        mensaje_success = "La estructura de costos cumple con las Bases Técnicas y Administrativas del Fondo de Producción Limpia"   
        mensaje_error = "El costo total del proyecto no es válido, porque hay criterios que no cumplen con los límites de costos."
        @mensaje = mensaje_error
        @response_costos = 1

        if @flujo.tipo_instrumento_id == TipoInstrumento::FPL_LINEA_1_1 || @flujo.tipo_instrumento_id == TipoInstrumento::FPL_LINEA_5_1 
          if @costos.present?
            if @costos.costo_total_de_la_propuesta.present? && (
                @costos.aporte_propio_liquido >= (((@costos.costo_total_de_la_propuesta * Gasto::PORCENTAJE_APORTE_LIQUIDO_MINIMO_DIAGNOSTICO) / 100)) &&
                (@costos.aporte_propio_liquido + @costos.aporte_propio_valorado) >= (((@costos.costo_total_de_la_propuesta * Gasto::PORCENTAJE_APORTE_PROPIO_MINIMO_DIAGNOSTICO) / 100)) &&
                @costos.gastos_administrativos <= (((@costos.costo_total_de_la_propuesta * Gasto::PORCENTAJE_GASTO_ADMINISTRACION_DIAGNOSTICO) / 100)) &&
                @costos.aporte_solicitado_al_fondo <= tope_maximo_solicitar_diagnostico(@tarea_pendiente.flujo_id)
              )
              @mensaje = mensaje_success
              @response_costos = 0
            else
              @mensaje = mensaje_error
              @response_costos = 1
            end
          end  
        elsif @flujo.tipo_instrumento_id == TipoInstrumento::FPL_LINEA_1_2_1 || @flujo.tipo_instrumento_id == TipoInstrumento::FPL_LINEA_1_2_2 || @flujo.tipo_instrumento_id == TipoInstrumento::FPL_LINEA_1_3
          
          @confinanciamiento_empresa = nil
          @fondo_produccion_limpia = FondoProduccionLimpia.find_by(flujo_id: @tarea_pendiente.flujo_id)
          if @fondo_produccion_limpia.present?
            if @fondo_produccion_limpia.cantidad_micro_empresa != 0 || 
              @fondo_produccion_limpia.cantidad_pequeña_empresa != 0 || 
              @fondo_produccion_limpia.cantidad_mediana_empresa != 0
                @confinanciamiento_empresa = FondoProduccionLimpia.calcular_suma_y_porcentaje(@tarea_pendiente.flujo_id,aporte_micro,aporte_pequena,aporte_mediana,tope_maximo)
            end
          end
          
          if @costos.present? && @costos_seguimiento[0].present? && @costos_seguimiento[1].present?
            if @costos.costo_total_de_la_propuesta.present? && (
                @costos_seguimiento[0]['aporte_propio_valorado'].to_f + @costos_seguimiento[0]['aporte_propio_liquido'].to_f >= ((((@costos_seguimiento[0]['aporte_solicitado_al_fondo'].to_f + @costos_seguimiento[0]['aporte_propio_valorado'].to_f + @costos_seguimiento[0]['aporte_propio_liquido'].to_f) * Gasto::PORCENTAJE_APORTE_PROPIO_MINIMO_DIAGNOSTICO)/100)) && 
                @costos_seguimiento[0]['aporte_solicitado_al_fondo'].to_f <= tope_maximo_solicitar_diagnostico(@tarea_pendiente.flujo_id) && 
                @costos_seguimiento[1]['aporte_propio_valorado'].to_f + @costos_seguimiento[1]['aporte_propio_liquido'].to_f >= ((((@costos_seguimiento[1]['aporte_solicitado_al_fondo'].to_f + @costos_seguimiento[1]['aporte_propio_valorado'].to_f + @costos_seguimiento[1]['aporte_propio_liquido'].to_f) * @confinanciamiento_empresa[1])/100)) && 
                @costos_seguimiento[1]['aporte_propio_valorado'].to_f <= tope_maximo_solicitar_diagnostico(@tarea_pendiente.flujo_id) &&
                @costos['aporte_propio_liquido'].to_f >= (((@costos['costo_total_de_la_propuesta'].to_f * Gasto::PORCENTAJE_APORTE_LIQUIDO_MINIMO_DIAGNOSTICO)/100)) &&
                @costos['gastos_administrativos'].to_f <= (((@costos['costo_total_de_la_propuesta'].to_f * Gasto::PORCENTAJE_GASTO_ADMINISTRACION_DIAGNOSTICO)/100))
              )
              @mensaje = mensaje_success
              @response_costos = 0
            else
              @mensaje = mensaje_error
              @response_costos = 1
            end
          end
        elsif @flujo.tipo_instrumento_id == TipoInstrumento::FPL_EXTRAPRESUPUESTARIO_DIAGNOSTICO || @flujo.tipo_instrumento_id == TipoInstrumento::FPL_EXTRAPRESUPUESTARIO_SEGUIMIENTO || @flujo.tipo_instrumento_id == TipoInstrumento::FPL_EXTRAPRESUPUESTARIO_SEGUIMIENTO_2 || @flujo.tipo_instrumento_id == TipoInstrumento::FPL_EXTRAPRESUPUESTARIO_EVALUACION
          @mensaje = mensaje_success
          @response_costos = 0
        end
      end

      def set_admisibilidad_financiera
        @cuestionario_fpl = CuestionarioFpl.where(flujo_id: @tarea_pendiente.flujo_id, tipo_cuestionario_id: 1)
      end

      def set_descargables
        tipo_contribuyente_id_postulante = TipoContribuyente.tipo_contribuyente_id_postulante(@tarea_pendiente.flujo_id)                     
        @descargables_postulante = DocumentacionLegal.descargables_postulante(tipo_contribuyente_id_postulante[:tipo_contribuyente_id])

        tipo_contribuyente_id_receptor = TipoContribuyente.tipo_contribuyente_id_receptor(@tarea_pendiente.flujo_id)   
        @descargables_receptor = DocumentacionLegal.descargables_receptor(tipo_contribuyente_id_receptor[:tipo_contribuyente_id])

        @descargables_ejecutor = DocumentacionLegal.descargables_ejecutor(@tarea_pendiente.flujo_id)      
      end

      def set_regiones
        @regiones = Region.order(id: :asc).all
      end

      def set_comentarios
        tarea_fondo = Tarea.find_by_codigo(Tarea::COD_FPL_06)
        @comentarios = ComentarioFlujo.includes(:user).where(flujo_id: @tarea_pendiente.flujo_id, tarea_id: tarea_fondo.id)   
      end


      def update_user_params
        params.require(:user).permit(:nombre_completo, :telefono, :email, :temporal, :flujo_id, :user_id, :rut)
      end

      def common_params
        [
          :nombre_completo,
          :telefono,
          :email,
          :web_o_red_social_1,
          :web_o_red_social_2,
          :password,
          :password_confirmation,
          :temporal,
          :flujo_id,
          :user_id,
          personas_attributes: [
            :id,
            :user_id,
            :contribuyente_id,
            :establecimiento_contribuyente_id,
            :email_institucional,
            :telefono_institucional,
            :_destroy,
            persona_cargos_attributes: [
              :id,
              :persona_id,
              :establecimiento_contribuyente_id,
              :cargo_id,
              :_destroy,
            ]
          ]
        ]
      end

      def buscador_params
        params.require(:buscador).permit(
          :rut,
          :nombre_completo,
          :flujo_id,
          :modal_id,
          :tipo_equipo)
      end

      def registro_proveedores_params
        params.require(:registro_proveedor).permit(:rut, :nombre, :email, :telefono, :profesion, :tipo_proveedor_id, :calificado)
      end

      def common_params
        [
          :nombre_completo,
          :telefono,
          :email,
          :web_o_red_social_1,
          :web_o_red_social_2,
          :password,
          :password_confirmation,
          :temporal,
          :flujo_id,
          :user_id,
          personas_attributes: [
            :id,
            :user_id,
            :contribuyente_id,
            :establecimiento_contribuyente_id,
            :email_institucional,
            :telefono_institucional,
            :_destroy,
            persona_cargos_attributes: [
              :id,
              :persona_id,
              :establecimiento_contribuyente_id,
              :cargo_id,
              :_destroy,
            ]
          ]
        ]
      end
  
      def create_user_params
        params.require(:user).permit((common_params << :rut))
      end

      def create_fondo_produccion_limpia_params
        params.require(:fondo_produccion_limpia).permit(:flujo_id, :flujo_apl_id, :codigo_proyecto)
      end

      def fondo_produccion_limpia_archivos_params
        params.require(:fondo_produccion_limpia).permit(:archivo_resolucion, :archivo_contrato)
      end

      def set_tipo_instrumento_valores
        @tipo_instrumento_valores = {
          linea_1_1: TipoInstrumento::FPL_LINEA_1_1,
          linea_5_1: TipoInstrumento::FPL_LINEA_5_1,
          linea_1_2_1: TipoInstrumento::FPL_LINEA_1_2_1,
          linea_1_2_2: TipoInstrumento::FPL_LINEA_1_2_2,
          linea_1_3: TipoInstrumento::FPL_LINEA_1_3,
          extrapresupuestario_diagnostico: TipoInstrumento::FPL_EXTRAPRESUPUESTARIO_DIAGNOSTICO,
          extrapresupuestario_seguimiento: TipoInstrumento::FPL_EXTRAPRESUPUESTARIO_SEGUIMIENTO,
          extrapresupuestario_seguimiento_2: TipoInstrumento::FPL_EXTRAPRESUPUESTARIO_SEGUIMIENTO_2,
          extrapresupuestario_evaluacion: TipoInstrumento::FPL_EXTRAPRESUPUESTARIO_EVALUACION
        }
      end

      def determine_codigo_proyecto(tipo_instrumento_id)
        case tipo_instrumento_id
        when TipoInstrumento::FPL_LINEA_1_1, TipoInstrumento::FPL_LINEA_5_1, TipoInstrumento::FPL_EXTRAPRESUPUESTARIO_DIAGNOSTICO
          "Proyecto DyAPL"
        when TipoInstrumento::FPL_LINEA_1_2_1, TipoInstrumento::FPL_LINEA_1_2_2, TipoInstrumento::FPL_EXTRAPRESUPUESTARIO_SEGUIMIENTO, TipoInstrumento::FPL_EXTRAPRESUPUESTARIO_SEGUIMIENTO_2
          "Proyecto SyC"
        when TipoInstrumento::FPL_LINEA_1_3, TipoInstrumento::FPL_EXTRAPRESUPUESTARIO_EVALUACION
          "Proyecto EdC"
        else
          "Unknown"
        end
      end

      def obtiene_y_graba_empresas_adheridas(flag_guarda_datos)
      #Obtenie empresas adheridas FASE 3
        @empresas_adheridas_ids = ''
        if @fondo_produccion_limpia.empresas_adheridas.present?
          @empresas_adheridas_ids = JSON.parse(@fondo_produccion_limpia.empresas_adheridas)
        end
        @adhesiones = Adhesion.unscoped.where(flujo_id: @fondo_produccion_limpia.flujo_apl_id)
        
        @empresas_adheridas = {}
        @adhesiones.each do |adh|
          puts "adhesion: #{adh}"
          @empresas_adheridas[adh.id] = adh.adhesiones_aceptadas.map do |empresa|
            tamano = empresa["tamaño_empresa"].split('-')
            tamano_empresa = RangoVentaContribuyente.find_by('venta_anual_en_uf ILIKE ?', tamano[2])
            empresa.merge(
              'tamano_empresa_id' => tamano_empresa.tamano_contribuyente_id,
              'tamano_contribuyente_nombre' => tamano_empresa.tamano_contribuyente.nombre,
              'seleccionada' => @empresas_adheridas_ids.include?(empresa['id'].to_s)
            )
          end
        end
        @empresas_adheridas = @empresas_adheridas.values.flatten

        if flag_guarda_datos == true
          # Filtrar empresas seleccionadas
          empresas_seleccionadas = @empresas_adheridas.select { |empresa| empresa["seleccionada"] }
          
          # Obtener la cantidad de empresas únicas por rut_institucion
          empresas_unicas = empresas_seleccionadas.uniq { |empresa| empresa["rut_institucion"] }
          
          # Contar el número de empresas
          numero_empresas = empresas_unicas.count
          
          # Contar el número de tamaños de empresa por elementos (tamano_empresa_id)
          tamano_elementos_count = empresas_seleccionadas.group_by { |empresa| empresa["tamano_empresa_id"] }
          numero_tamanos = tamano_elementos_count.count
          
          # Para obtener específicamente el conteo por tamaño de elementos
          tamanos_detalle_elementos = tamano_elementos_count.transform_values(&:count)
      
          # Contar el número de tamaños de empresa (tamano_empresa_id)
          tamano_empresas_count = empresas_unicas.group_by { |empresa| empresa["tamano_empresa_id"] }
          
          # Para obtener específicamente el conteo por tamaño de empresa
          tamanos_detalle_empresas = tamano_empresas_count.transform_values(&:count)
          
          custom_params = {
            fondo_produccion_limpia: {
              cantidad_micro_empresa: (tamanos_detalle_empresas[2].nil? ? 0 : tamanos_detalle_empresas[2]),
              cantidad_pequeña_empresa: (tamanos_detalle_empresas[3].nil? ? 0 : tamanos_detalle_empresas[3]),
              cantidad_mediana_empresa: (tamanos_detalle_empresas[4].nil? ? 0 : tamanos_detalle_empresas[4]),
              cantidad_grande_empresa: (tamanos_detalle_empresas[5].nil? ? 0 : tamanos_detalle_empresas[5]),
              elementos_micro_empresa: (tamanos_detalle_elementos[2].nil? ? 0 : tamanos_detalle_elementos[2]),
              elementos_pequena_empresa: (tamanos_detalle_elementos[3].nil? ? 0 : tamanos_detalle_elementos[3]),
              elementos_mediana_empresa: (tamanos_detalle_elementos[4].nil? ? 0 : tamanos_detalle_elementos[4]),
              elementos_grande_empresa: (tamanos_detalle_elementos[5].nil? ? 0 : tamanos_detalle_elementos[5])
            }
          }
          @fondo_produccion_limpia.update(custom_params[:fondo_produccion_limpia])
        
        end

      end
      
      def normalize_string(string)
        return string unless string.is_a?(String)  # Verifica que sea un string
        string.gsub(/\n+/, ' ').strip  # Reemplaza saltos de línea por un espacio y elimina espacios en exceso
      end

      def valid_extensions?(archivo)
        return true if archivo.nil? # Si no hay archivo, considera válido
      
        # Extensiones permitidas
        extension = File.extname(archivo.original_filename).delete('.').downcase
        extensiones_permitidas = %w[pdf jpg png tiff zip rar doc docx]
        extensiones_permitidas.include?(extension)
      end

      def obtiene_nombre_tipo_instrumento(tipo_instrumento_id)
        TipoInstrumento.find(tipo_instrumento_id).nombre
      end  
end
