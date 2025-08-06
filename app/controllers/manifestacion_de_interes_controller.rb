class ManifestacionDeInteresController < ApplicationController
  before_action :authenticate_user!, unless: proc { action_name == 'google_map_kml' }
  before_action :set_tarea_pendiente, except: [:iniciar_flujo, :lista_usuarios_entregables, :nombre_apl, :editar_nombre_apl, :cambio_nombre_apl, :index]
  before_action :set_flujo, except: [:iniciar_flujo, :lista_usuarios_entregables, :nombre_apl, :editar_nombre_apl, :cambio_nombre_apl, :index]

  before_action :set_manifestacion_de_interes, only: [:edit, :update, :destroy, :descargable,
    :revisor, :asignar_revisor, :admisibilidad, :revisar_admisibilidad,
                                      :admisibilidad_juridica, :revisar_admisibilidad_juridica,
                                      :observaciones_admisibilidad, :resolver_observaciones_admisibilidad,
                                      :observaciones_admisibilidad_juridica, :resolver_observaciones_admisibilidad_juridica,
                                      :pertinencia_factibilidad, :revisar_pertinencia_factibilidad,
                                      :responder_pertinencia_factibilidad, :responder_cond_obs_pertinencia_factibilidad,
                                      :usuario_entregables, :guardar_usuario_entregables,
                                      :firma, :actualizar_firma,
                                      :carga_auditoria, :enviar_carga_auditoria,:cargar_actualizar_entregable_diagnostico,
                                      :revisar_entregable_diagnostico,
                                      :evaluacion_negociacion, :actualizar_acuerdos_actores,:actualizar_comite_acuerdos,
                                      :eliminar_contribuyente_temporal, :observaciones_informe, :responder_observaciones_informe, :descargar_compilado]
  before_action :set_representantes, only: [:edit, :update, :destroy, :descargable,
    :revisor, :asignar_revisor, :admisibilidad, :revisar_admisibilidad,
                                      :admisibilidad_juridica, :revisar_admisibilidad_juridica,
                                      :observaciones_admisibilidad, :resolver_observaciones_admisibilidad,
                                      :observaciones_admisibilidad_juridica, :resolver_observaciones_admisibilidad_juridica,
                                      :pertinencia_factibilidad, :revisar_pertinencia_factibilidad,
                                      :responder_pertinencia_factibilidad, :responder_cond_obs_pertinencia_factibilidad,
                                      :usuario_entregables, :guardar_usuario_entregables,
                                      :firma, :actualizar_firma,
                                      :carga_auditoria, :enviar_carga_auditoria,:cargar_actualizar_entregable_diagnostico,
                                      :revisar_entregable_diagnostico,
                                      :evaluacion_negociacion, :actualizar_acuerdos_actores,:actualizar_comite_acuerdos]
  before_action :set_contribuyentes, only: [:edit,:update,
                                      :revisor, :asignar_revisor,
                                      :admisibilidad, :revisar_admisibilidad,
                                      :admisibilidad_juridica, :revisar_admisibilidad_juridica,
                                      :observaciones_admisibilidad, :resolver_observaciones_admisibilidad,
                                      :observaciones_admisibilidad_juridica, :resolver_observaciones_admisibilidad_juridica,
                                      :pertinencia_factibilidad, :revisar_pertinencia_factibilidad,
                                      :responder_pertinencia_factibilidad, :responder_cond_obs_pertinencia_factibilidad,
                                      :usuario_entregables, :guardar_usuario_entregables,
                                      :firma, :actualizar_firma,
                                      :carga_auditoria, :enviar_carga_auditoria,:cargar_actualizar_entregable_diagnostico]
  before_action :set_tipo_instrumentos, only: [:edit,:update,
                                      :revisor, :asignar_revisor,
                                      :admisibilidad, :revisar_admisibilidad,
                                      :admisibilidad_juridica, :revisar_admisibilidad_juridica,
                                      :observaciones_admisibilidad, :resolver_observaciones_admisibilidad,
                                      :observaciones_admisibilidad_juridica, :resolver_observaciones_admisibilidad_juridica,
                                      :pertinencia_factibilidad, :revisar_pertinencia_factibilidad,
                                      :responder_pertinencia_factibilidad, :responder_cond_obs_pertinencia_factibilidad,
                                      :usuario_entregables, :guardar_usuario_entregables,
                                      :firma, :actualizar_firma,
                                      :carga_auditoria, :enviar_carga_auditoria]
  before_action :set_archivo_mapa_actores, only: [:edit]
  before_action :set_informe, only: [:evaluacion_negociacion, :observaciones_informe, :actualizar_acuerdos_actores, :responder_observaciones_informe]
  before_action :set_comentario_informe, only: [:evaluacion_negociacion, :observaciones_informe]

  before_action :set_mapa_actores, only: [:cargar_actualizar_entregable_diagnostico]
  before_action :set_listado_actores_temporal, only: [:cargar_actualizar_entregable_diagnostico]
  before_action :set_usuario_actor, only: [:cargar_actualizar_entregable_diagnostico]
  before_action :set_contribuyentes_actor, only: [:cargar_actualizar_entregable_diagnostico]

  def index
    if params[:query].present?
      if params[:query].to_i == 0
        manifestacion_de_intereses = ManifestacionDeInteres.where("nombre_acuerdo ILIKE ?", "%#{params[:query]}%")
        @acuerdos = manifestacion_de_intereses.select { |f| f.resultado_admisibilidad? }.paginate(page: params[:page], per_page: 15)
      else
        manifestacion_de_intereses = ManifestacionDeInteres.where(id: params[:query].to_i)
        @acuerdos = manifestacion_de_intereses.select { |f| f.resultado_admisibilidad? }.paginate(page: params[:page], per_page: 15)
      end
    else
      manifestacion_de_intereses = ManifestacionDeInteres.all
      @acuerdos = manifestacion_de_intereses.select { |f| f.resultado_admisibilidad? }.paginate(page: params[:page], per_page: 15)
    end
  end

  def iniciar_flujo #DZC TAREA APL-001 al iniciar proceso
    warning   = nil
    success   = nil
    errors    = nil

    if @personas.blank?
      warning = 'Este usuario no esta asociado a ninguna institución, por lo tanto no puede iniciar el proceso.'
    else
      personas_proponentes = current_user.personas & Responsable.responsables_por_rol(Rol::PROPONENTE,nil,TipoInstrumento::ACUERDO_DE_PRODUCCION_LIMPIA)
      if personas_proponentes.blank?
        warning = 'Usted NO puede iniciar Acuerdos ya que no cumple con los requisitos para ser PROPONENTE.'
      else
        flujo = Flujo.new({
          contribuyente_id: personas_proponentes.first[:contribuyente_id],
          tipo_instrumento_id: TipoInstrumento::ACUERDO_DE_PRODUCCION_LIMPIA
        })
        if flujo.save
          tarea_manifestacion = Tarea.find_by_codigo(Tarea::COD_APL_001)
          flujo.tarea_pendientes.create([{
              tarea_id: tarea_manifestacion.id,
              estado_tarea_pendiente_id: EstadoTareaPendiente::NO_INICIADA,
              user_id: current_user.id,
              data: { }
            }]
          )
          success = 'Flujo manifestación de interés creado correctamente.'
        else
          warning = 'Usted NO puede iniciar Acuerdos ya que no cumple con los requisitos para ser PROPONENTE.'

        end
      end
    end
    if warning.present?
      respond_to do |format|
        format.html { redirect_to root_path, flash: { warning: warning, success: success, error: errors } }
      end
    else
      @t_pendiente = flujo.tarea_pendientes.first.id
      create
    end
  end

  def destroy
    @manifestacion_de_interes.destroy
    redirect_to root_path, notice: 'Manifestación correctamente eliminada.'
  end

  def create #DZC TAREA APL-001 al iniciar proceso
    success         = nil
    error           = nil
    link            = root_url
    tp = params[:tarea_pendiente_id] ? params[:tarea_pendiente_id] : @t_pendiente
    tarea_pendiente = TareaPendiente.find(tp) rescue nil
    autorizado? tarea_pendiente

    if tarea_pendiente.blank?
      error = 'Acceso inválido a tarea seleccionada'
    else
      if tarea_pendiente.data.blank? || ! tarea_pendiente.data.has_key?(:manifestacion_de_interes_id)
        manifestacion_de_interes = ManifestacionDeInteres.new
        if manifestacion_de_interes.save
          tarea_pendiente.data = { manifestacion_de_interes_id: manifestacion_de_interes.id }
          if tarea_pendiente.save
            flujo = tarea_pendiente.flujo
            flujo.manifestacion_de_interes_id = manifestacion_de_interes.id
            flujo.save
            success = 'Manifestación correctamente creada.'
          end
        else
          p manifestacion_de_interes.errors.messages
          error = 'Problema al generar manifestacion'
        end
      else
        manifestacion_de_interes = ManifestacionDeInteres.find(tarea_pendiente.data[:manifestacion_de_interes_id]) rescue nil
      end
      unless manifestacion_de_interes.blank?
        p manifestacion_de_interes
        link = edit_manifestacion_de_interes_path(tarea_pendiente,manifestacion_de_interes)
      end
    end

    respond_to do |format|
      format.html { redirect_to link, flash: { success: success, error: error }}
    end
  end

  def edit #DZC TAREA APL-001 una vez instanciada la manifestación
    # DZC 2019-02-28 18:03:15 se setean las varibles relativas al mensaje "Recuerde gradar sus cambios"
    @solo_lectura = @tarea_pendiente.present? ? @tarea_pendiente.solo_lectura(current_user, @tarea_pendiente) : nil
    @recuerde_guardar_minutos = ManifestacionDeInteres::MINUTOS_MENSAJE_GUARDAR
    @manifestacion_de_interes.seleccion_de_radios
    @mantener_temporal = 'true'

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

  def update #DZC TAREA APL-001 una vez instanciada la manifestación
    if manifestacion_params[:anulado]=="true"
      respond_to do |format|
        @tarea_pendiente.pasar_a_siguiente_tarea 'B'
        @tarea_pendiente.update(estado_tarea_pendiente_id: EstadoTareaPendiente::ANULADA)

        format.js { 
          flash[:success] = "Acuerdo anulado correctamente"
          render js: "window.location='#{root_path}'"
        }
        format.html { redirect_to root_path, notice: success }
      end
    else
      unless @manifestacion_de_interes.contribuyente_id.nil?
        @contribuyente_temporal = Contribuyente.unscoped.find(@manifestacion_de_interes.contribuyente_id)
        if @contribuyente_temporal.contribuyente_id.nil?
          @contribuyente_nuevo = @contribuyente_temporal
          @contribuyente_editado = Contribuyente.new
        else
          @contribuyente_nuevo = Contribuyente.new
          @contribuyente_editado = @contribuyente_temporal
        end
      else
        @contribuyente_temporal = @contribuyente_nuevo = @contribuyente_editado = Contribuyente.new
      end
      @contribuyente_nuevo.temporal = true
      @contribuyente_editado.temporal = true
      @contribuyente_nuevo.flujo_id = @manifestacion_de_interes.flujo.id
      @contribuyente_editado.flujo_id = @manifestacion_de_interes.flujo.id

      unless @manifestacion_de_interes.representante_institucion_para_solicitud_id.nil?
        @usuario_temporal = User.unscoped.find(@manifestacion_de_interes.representante_institucion_para_solicitud_id)
        if @usuario_temporal.user_id.nil?
          @usuario_nuevo = @usuario_temporal
          @usuario_editado = User.new
        else
          @usuario_nuevo = User.new
          @usuario_editado = @usuario_temporal
        end
      else
        @usuario_temporal = @usuario_nuevo = @usuario_editado = User.new
      end
      @usuario_nuevo.temporal = true
      @usuario_editado.temporal = true
      @usuario_nuevo.flujo_id = @manifestacion_de_interes.flujo.id
      @usuario_editado.flujo_id = @manifestacion_de_interes.flujo.id

      @manifestacion_de_interes.assign_attributes(manifestacion_params)
      @manifestacion_de_interes[:carta_de_apoyo_y_compromiso] = manifestacion_params[:carta_de_apoyo_y_compromiso] if manifestacion_params[:carta_de_apoyo_y_compromiso].present?
      @manifestacion_de_interes[:estandar_certificable] = manifestacion_params[:estandar_certificable] if manifestacion_params[:estandar_certificable].present?
      @manifestacion_de_interes[:diagnostico_de_acuerdo_anterior] = manifestacion_params[:diagnostico_de_acuerdo_anterior] if  manifestacion_params[:diagnostico_de_acuerdo_anterior].present?
      @manifestacion_de_interes[:informe_de_acuerdo_anterior] = manifestacion_params[:informe_de_acuerdo_anterior] if manifestacion_params[:informe_de_acuerdo_anterior].present?
      @manifestacion_de_interes[:estudios_sectoriales_territoriales_relevantes] = manifestacion_params[:estudios_sectoriales_territoriales_relevantes] if manifestacion_params[:estudios_sectoriales_territoriales_relevantes].present?
      @manifestacion_de_interes[:mapa_de_actores_archivo] = manifestacion_params[:mapa_de_actores_archivo] if manifestacion_params[:mapa_de_actores_archivo].present?
      @manifestacion_de_interes[:carta_de_interes_institucion_gestora_firmada] = manifestacion_params[:carta_de_interes_institucion_gestora_firmada] if manifestacion_params[:carta_de_interes_institucion_gestora_firmada].present?
      @manifestacion_de_interes[:area_influencia_proyecto_archivo] = manifestacion_params[:area_influencia_proyecto_archivo] if manifestacion_params[:area_influencia_proyecto_archivo].present?
      @manifestacion_de_interes[:alternativas_instalacion_archivo] = manifestacion_params[:alternativas_instalacion_archivo] if manifestacion_params[:alternativas_instalacion_archivo].present?
      @manifestacion_de_interes[:gantt_proyecto] = manifestacion_params[:gantt_proyecto] if manifestacion_params[:gantt_proyecto].present?
      @manifestacion_de_interes[:estudio_de_mercado] = manifestacion_params[:estudio_de_mercado] if manifestacion_params[:estudio_de_mercado].present?
      @manifestacion_de_interes[:anteproyecto] = manifestacion_params[:anteproyecto] if manifestacion_params[:anteproyecto].present?
      @manifestacion_de_interes[:otros_estudios] = manifestacion_params[:otros_estudios] if manifestacion_params[:otros_estudios].present?
      @manifestacion_de_interes.completar_informacion!
      set_representantes

      unless @manifestacion_de_interes.tipo_instrumento.blank?
        @manifestacion_de_interes.descripcion_acuerdo = @manifestacion_de_interes.tipo_instrumento.descripcion
      end

      checked = @manifestacion_de_interes.set_checked
      @rpc_checked = checked[:rpc_checked]
      @actecos_checked = checked[:actecos_checked]

      @manifestacion_de_interes[:estandar_certificable] = nil if manifestacion_params[:radio_estandar] == "1"
      @manifestacion_de_interes[:estandar_de_certificacion_id] = nil if manifestacion_params[:radio_estandar] == "0"

      @manifestacion_de_interes[:diagnostico_de_acuerdo_anterior] = nil if manifestacion_params[:radio_diagnostico] == "1"
      @manifestacion_de_interes[:diagnostico_id] = nil if manifestacion_params[:radio_diagnostico] == "0"

      @manifestacion_de_interes[:informe_de_acuerdo_anterior] = nil if manifestacion_params[:radio_informe] == "1"
      @manifestacion_de_interes[:acuerdo_previo_con_informe_id] = nil if manifestacion_params[:radio_informe] == "0" 

      @flujo.actividad_economica_ids = manifestacion_params[:actividad_economicas_ids]
      @flujo.comuna_ids = manifestacion_params[:comunas_ids]
      @flujo.cuenca_ids = manifestacion_params[:cuencas_ids]
      @flujo.save

      respond_to do |format|
        @manifestacion_de_interes.tarea_codigo = @tarea.codigo
        @manifestacion_de_interes.revisar_y_actualizar_mapa_de_actores = true
        if @manifestacion_de_interes.valid?
          if @manifestacion_de_interes.save
            # DZC 2018-10-10 16:47:12 se modifica cambiando el contribuyente en el flujo en concordancia al que se seleccionó en la manifestación
            #@flujo.update(contribuyente_id: @manifestacion_de_interes.contribuyente_id) if !@manifestacion_de_interes.contribuyente_id.blank?
            #Asocia actividades economicas a flujo
            #@flujo.actividad_economica_ids = manifestacion_params[:actividad_economicas_ids]
            #@flujo.comuna_ids = manifestacion_params[:comunas_ids]
            #@flujo.cuenca_ids = manifestacion_params[:cuencas_ids]
            @flujo.contribuyente_id = @manifestacion_de_interes.contribuyente_id if !@manifestacion_de_interes.contribuyente_id.blank?
            @flujo.save

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
              @contribuyente_temporal = @contribuyente_nuevo = @contribuyente_editado = Contribuyente.new
            end
            @contribuyente_nuevo.temporal = true
            @contribuyente_editado.temporal = true
            @contribuyente_nuevo.flujo_id = @manifestacion_de_interes.flujo.id
            @contribuyente_editado.flujo_id = @manifestacion_de_interes.flujo.id

            unless @manifestacion_de_interes.representante_institucion_para_solicitud_id.nil?
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
            
            @manifestacion_de_interes.flujo.reload
            carga_de_representantes
            insertar_mapa_de_actores
            if manifestacion_params[:temporal]=="false" || manifestacion_params[:temporal].blank?
              @tarea_pendiente.pasar_a_siguiente_tarea 'A'
              # @tarea_pendiente.estado_tarea_pendiente_id = EstadoTareaPendiente::ENVIADA
              #revisar para optimizar con método de Adan en modelo tarea_pendiente
              # if @tarea_pendiente.save
              #   flujo_tareas = FlujoTarea.where(tarea_entrada_id: @tarea_pendiente.tarea_id).all
              #   flujo_tareas.each do |ft|
              #     ft.continuar_flujo @tarea_pendiente.flujo_id
              #   end
              # end
              cargo_ids = Responsable.where(rol_id: Rol::PROPONENTE, tipo_instrumento_id: TipoInstrumento::ACUERDO_DE_PRODUCCION_LIMPIA, contribuyente_id: [nil, @contribuyente_temporal.contribuyente_id]).pluck(:cargo_id)
              persona_cogestora = Persona.includes(:persona_cargos).where(personas: {contribuyente_id: @contribuyente_temporal.contribuyente_id}).where(persona_cargos: {cargo_id: cargo_ids}).select{|p| p.user_id == @usuario_temporal.user_id}.first
              persona_cogestora = Persona.where(user_id: @usuario_temporal.user_id).first if persona_cogestora.nil?#si lo cargo buscandolo
              if !persona_cogestora.nil?# si es nuevo usuario, no existe persona
                mapa = MapaDeActor.find_or_create_by({
                  flujo_id: @tarea_pendiente.flujo_id,
                  rol_id: Rol::COGESTOR, #se vuelve a usar el id
                  #rol_id: Rol.find_by(nombre: 'Revisor Técnico').id, #DZC se reemplaza la constante por el valor del registro en la tabla. ESTO NO EVITA QUE SE DEBA MANTENER EL NOMBRE EN LA TABLA
                  persona_id: persona_cogestora.id
                })
              end
              success = 'Manifestación Enviada'
              format.js {
                flash[:success] = success
                render js: "window.location='#{root_path}'"
              }
              format.html { redirect_to root_path, notice: success }
            else
              # DZC 2019-02-28 18:03:15 se setean las varibles relativas al mensaje "Recuerde gradar sus cambios"
              @recuerde_guardar_minutos = ManifestacionDeInteres::MINUTOS_MENSAJE_GUARDAR

              @mantener_temporal = manifestacion_params[:temporal]
              success = 'Manifestación correctamente actualizada.'
              format.js { flash.now[:success] = success }
              format.html { redirect_to root_path, notice: success }
            end
            # if @manifestacion_de_interes.save
            #   procesa_mapa_actores
            # end

            # if @manifestacion_de_interes.save
            #   #DZC pobla las tablas con los datos del excel
            #   #DZC convierto el hash con string keys a hash_with_indiferent_access, y de vuelta a hash con key simbólicas, o nil, según corresponda
            #   actores_desde_campo = @manifestacion_de_interes.mapa_de_actores_data.blank? ? nil : @manifestacion_de_interes.mapa_de_actores_data.map{|i| i.transform_keys!(&:to_sym).to_h}
            #   if !actores_desde_campo.nil?
            #     MapaDeActor.actualiza_tablas_mapa_actores(@actores_desde_campo, @flujo, @tarea_pendiente)
            #   end
            # end
            # format.js { flash.now[:success] = success }
            # format.html { redirect_to root_path, notice: success }
          end
          # if @manifestacion_de_interes.save
          #   # procesa_mapa_actores
          #   # @manifestacion_de_interes.data_mapa_de_actores #DZC no es necesario, por que el modelo lo ejecuta como after_save
          # end
          # if @manifestacion_de_interes.save
          #   #DZC pobla las tablas con los datos del excel
          #   #DZC convierto el hash con string keys a hash_with_indiferent_access, y de vuelta a hash con key simbólicas, o nil, según corresponda
          #   actores_desde_campo = @manifestacion_de_interes.mapa_de_actores_data.blank? ? nil : @manifestacion_de_interes.mapa_de_actores_data.map{|i| i.transform_keys!(&:to_sym).to_h}
          #   if !actores_desde_campo.nil?
          #     MapaDeActor.actualiza_tablas_mapa_actores(@actores_desde_campo, @flujo, @tarea_pendiente)
          #   end
          # end
          format.js { flash.now[:success] = success }
          format.html { redirect_to root_path, notice: success }
        else
          @total_de_errores_por_tab = @manifestacion_de_interes.errores_agrupados
          @recuerde_guardar_minutos = ManifestacionDeInteres::MINUTOS_MENSAJE_GUARDAR
          carga_de_representantes
          if @manifestacion_de_interes.temporal.blank?
            flash.now[:error] = "Antes de enviar la manifestación debe completar todos los campos requeridos"
          end
          if(@manifestacion_de_interes.errors.messages[:mapa_de_actores_archivo].size > 0)
            @manifestacion_de_interes.mapa_de_actores_data = nil
            #@manifestacion_de_interes.mapa_de_actores_archivo.remove!
            @manifestacion_de_interes.mapa_de_actores_archivo = nil
          end
          format.js { }
          format.html { render :edit }
        end
      end
    end
  end

  def revisor #DZC TAREA APL-002
    @recuerde_guardar_minutos = ManifestacionDeInteres::MINUTOS_MENSAJE_GUARDAR #DZC 2019-04-04 18:33:08 corrige requerimiento 2019-04-03
    @revisores_juridicos = Responsable.__personas_responsables(Rol::REVISOR_JURIDICO, TipoInstrumento.find_by(nombre: 'Acuerdo de Producción Limpia').id)

    @manifestacion_de_interes.seleccion_de_radios

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

  def asignar_revisor #DZC TAREA APL-002
    @manifestacion_de_interes.assign_attributes(manifestacion_revisor_params)
    @manifestacion_de_interes.update_asignar_revisor = true
    respond_to do |format|
      @manifestacion_de_interes.tarea_codigo = @tarea.codigo
      if @manifestacion_de_interes.valid?
        @manifestacion_de_interes.save
        mapa = MapaDeActor.find_or_create_by({
          flujo_id: @tarea_pendiente.flujo_id,
          rol_id: Rol::REVISOR_TECNICO, #se vuelve a usar el id
          #rol_id: Rol.find_by(nombre: 'Revisor Técnico').id, #DZC se reemplaza la constante por el valor del registro en la tabla. ESTO NO EVITA QUE SE DEBA MANTENER EL NOMBRE EN LA TABLA
          persona_id: manifestacion_revisor_params[:revisor_tecnico_id]
        })
        mapa = MapaDeActor.find_or_create_by({
          flujo_id: @tarea_pendiente.flujo_id,
          rol_id: Rol::REVISOR_JURIDICO, #se vuelve a usar el id
          #rol_id: Rol.find_by(nombre: 'Revisor Jurídico').id, #DZC se reemplaza la constante por el valor del registro en la tabla. ESTO NO EVITA QUE SE DEBA MANTENER EL NOMBRE EN LA TABLA
          persona_id: manifestacion_revisor_params[:revisor_juridico_id]
        })
        mapa = MapaDeActor.find_or_create_by({
          flujo_id: @tarea_pendiente.flujo_id,
          rol_id: Rol::JEFE_DE_LINEA, #se vuelve a usar el id
          #rol_id: Rol.find_by(nombre: 'Jefe de Línea').id, 
          persona_id: @tarea_pendiente.persona_id
        })
        continua_flujo_segun_tipo_tarea
        # @tarea_pendiente.pasar_a_siguiente_tarea 'A' #hasta el momento solo hay una condición en el flujo de esta tarea
        format.js { flash.now[:success] = 'Revisor asignado correctamente' ; render js: "window.location='#{root_path}'"
        }
        # format.html { redirect_to revisor_manifestacion_de_interes_path(@tarea_pendiente,@manifestacion_de_interes), flash: {notice: 'Revisor asignado correctamente' }}
        format.html { redirect_to root_path(@tarea_pendiente,@manifestacion_de_interes), flash: {notice: 'Revisor asignado correctamente' }}
      else
        @recuerde_guardar_minutos = ManifestacionDeInteres::MINUTOS_MENSAJE_GUARDAR #DZC 2019-04-04 18:33:08 corrige requerimiento 2019-04-03
        flash.now[:error] = "Debe completar todos los campos requeridos"

        @manifestacion_de_interes.seleccion_de_radios

        @revisores_juridicos = Responsable.__personas_responsables(Rol::REVISOR_JURIDICO, TipoInstrumento.find_by(nombre: 'Acuerdo de Producción Limpia').id)

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

        format.js { }
        format.html { render :revisor}
      end
    end
  end

  def admisibilidad #DZC TAREA APL-003
    @recuerde_guardar_minutos = ManifestacionDeInteres::MINUTOS_MENSAJE_GUARDAR #DZC 2019-04-04 18:33:08 corrige requerimiento 2019-04-03

    @manifestacion_de_interes.temp_siguientes = "true"
    @manifestacion_de_interes.seleccion_de_radios

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

  def revisar_admisibilidad  #DZC TAREA APL-003
    @manifestacion_de_interes.assign_attributes(manifestacion_admisibilidad_params)
    @manifestacion_de_interes.tarea_codigo = @tarea.codigo
    respond_to do |format|
      if @manifestacion_de_interes.valid?
        @manifestacion_de_interes.save # Al estar comentada no guardaba los comentarios.-
        #En caso de seleecionar como representante a un usuario que no se encuentra dentro de la institucion cogestora, se debe agreagrar.-
        if @manifestacion_de_interes.temp_siguientes.to_s != "true"
          if @nuevo_usuario
            usuario = User.unscoped.find(@manifestacion_de_interes.representante_institucion_para_solicitud_id)
            contribuyente = @manifestacion_de_interes.contribuyente_id
            persona = usuario.persona_segun_(contribuyente)
            if persona.present?
              persona.persona_cargos.create(cargo_id: Cargo::ENCARGADO_INS)
            else
              persona = Persona.create(user_id: usuario.id, contribuyente_id: contribuyente,email_institucional: @manifestacion_de_interes.email_representante_para_acuerdo,telefono_institucional: @manifestacion_de_interes.telefono_representante_para_acuerdo)
              persona.persona_cargos.create(cargo_id: Cargo::ENCARGADO_INS)
            end
          end
          # @tarea_pendiente.estado_tarea_pendiente_id = EstadoTareaPendiente::ENVIADA
          if @tarea_pendiente.save
            continua_flujo_segun_tipo_tarea
            # #DZC se agrega la validación de la condición 'C', para ser coherente con el método continuar_flujo
            # case @manifestacion_de_interes.resultado_admisibilidad
            # when "aceptado"
            #   @tarea_pendiente.pasar_a_siguiente_tarea 'A'
            # when "en_observación"
            #   @tarea_pendiente.pasar_a_siguiente_tarea 'B'
            # when "rechazado"
            #   @tarea_pendiente.pasar_a_siguiente_tarea 'C'
            # end
          end
          format.js { flash.now[:success] = 'Admisibilidad Técnica enviada correctamente'
            render js: "window.location='#{root_path}'"}
          format.html { redirect_to root_path, flash: {notice: 'Admisibilidad Técnica enviada correctamente' }}
        else
          format.js { flash.now[:success] = 'Admisibilidad Técnica guardada correctamente'
            render js: "window.location='#{admisibilidad_manifestacion_de_interes_path(@tarea_pendiente,@manifestacion_de_interes)}'"}
          format.html { redirect_to admisibilidad_manifestacion_de_interes_path(@tarea_pendiente,@manifestacion_de_interes), flash: {notice: 'Admisibilidad Técnica guardada correctamente' }}
        end
      else
        @recuerde_guardar_minutos = ManifestacionDeInteres::MINUTOS_MENSAJE_GUARDAR #DZC 2019-04-04 18:33:08 corrige requerimiento 2019-04-03
        flash.now[:error] = "Antes de enviar debe completar todos los campos requeridos"

        @manifestacion_de_interes.seleccion_de_radios

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

        format.js { }
        format.html { render :admisibilidad}
      end
    end
  end

  def admisibilidad_juridica #DZC TAREA APL-003.2
    @recuerde_guardar_minutos = ManifestacionDeInteres::MINUTOS_MENSAJE_GUARDAR #DZC 2019-04-04 18:33:08 corrige requerimiento 2019-04-03

    @manifestacion_de_interes.seleccion_de_radios

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

  def revisar_admisibilidad_juridica  #DZC TAREA APL-003
    @manifestacion_de_interes.assign_attributes(manifestacion_admisibilidad_juridica_params)
    @manifestacion_de_interes.tarea_codigo = @tarea.codigo
    respond_to do |format|
      if @manifestacion_de_interes.valid?
        @manifestacion_de_interes.save # Al estar comentada no guardaba los comentarios.-
        #En caso de seleecionar como representante a un usuario que no se encuentra dentro de la institucion cogestora, se debe agreagrar.-
        if @manifestacion_de_interes.temp_siguientes != "true"
          if @nuevo_usuario
            usuario = User.unscoped.find(@manifestacion_de_interes.representante_institucion_para_solicitud_id)
            contribuyente = @manifestacion_de_interes.contribuyente_id
            persona = usuario.persona_segun_(contribuyente)
            if persona.present?
              persona.persona_cargos.create(cargo_id: Cargo::ENCARGADO_INS)
            else
              persona = Persona.create(user_id: usuario.id, contribuyente_id: contribuyente,email_institucional: @manifestacion_de_interes.email_representante_para_acuerdo,telefono_institucional: @manifestacion_de_interes.telefono_representante_para_acuerdo)
              persona.persona_cargos.create(cargo_id: Cargo::ENCARGADO_INS)
            end
          end
          # @tarea_pendiente.estado_tarea_pendiente_id = EstadoTareaPendiente::ENVIADA
          if @tarea_pendiente.save
            continua_flujo_segun_tipo_tarea
            # #DZC se agrega la validación de la condición 'C', para ser coherente con el método continuar_flujo
            # case @manifestacion_de_interes.resultado_admisibilidad
            # when "aceptado"
            #   @tarea_pendiente.pasar_a_siguiente_tarea 'A'
            # when "en_observación"
            #   @tarea_pendiente.pasar_a_siguiente_tarea 'B'
            # when "rechazado"
            #   @tarea_pendiente.pasar_a_siguiente_tarea 'C'
            # end
          end
          format.js { flash.now[:success] = 'Admisibilidad Jurídica enviada correctamente'
            render js: "window.location='#{root_path}'"}
          format.html { redirect_to root_path, flash: {notice: 'Admisibilidad Jurídica enviada correctamente' }}
        else
          format.js { flash.now[:success] = 'Admisibilidad Jurídica guardada correctamente'
            render js: "window.location='#{admisibilidad_juridica_manifestacion_de_interes_path(@tarea_pendiente,@manifestacion_de_interes)}'"}
          format.html { redirect_to admisibilidad_juridica_manifestacion_de_interes_path(@tarea_pendiente,@manifestacion_de_interes), flash: {notice: 'Admisibilidad Jurídica guardada correctamente' }}
        end
      else
        @recuerde_guardar_minutos = ManifestacionDeInteres::MINUTOS_MENSAJE_GUARDAR #DZC 2019-04-04 18:33:08 corrige requerimiento 2019-04-03
        flash.now[:error] = "Antes de enviar debe completar todos los campos requeridos"

        @manifestacion_de_interes.seleccion_de_radios

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

        format.js { }
        format.html { render :admisibilidad_juridica}
      end
    end
  end

  def observaciones_admisibilidad #DZC APL-004

    @recuerde_guardar_minutos = ManifestacionDeInteres::MINUTOS_MENSAJE_GUARDAR #DZC 2019-04-04 18:33:08 corrige requerimiento 2019-04-03
    unless @manifestacion_de_interes.secciones_observadas_admisibilidad.nil?
      @total_de_errores_por_tab = @manifestacion_de_interes.secciones_observadas_admisibilidad.map{|s| [s.to_sym, [""]]}.to_h
    end

    @manifestacion_de_interes.seleccion_de_radios

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

  def resolver_observaciones_admisibilidad #DZC TAREA APL-004

    unless @manifestacion_de_interes.contribuyente_id.nil?
      @contribuyente_temporal = Contribuyente.unscoped.find(@manifestacion_de_interes.contribuyente_id)
      if @contribuyente_temporal.contribuyente_id.nil?
        @contribuyente_nuevo = @contribuyente_temporal
        @contribuyente_editado = Contribuyente.new
      else
        @contribuyente_nuevo = Contribuyente.new
        @contribuyente_editado = @contribuyente_temporal
      end
    else
      @contribuyente_temporal = @contribuyente_nuevo = @contribuyente_editado = Contribuyente.new
    end
    @contribuyente_nuevo.temporal = true
    @contribuyente_editado.temporal = true
    @contribuyente_nuevo.flujo_id = @manifestacion_de_interes.flujo.id
    @contribuyente_editado.flujo_id = @manifestacion_de_interes.flujo.id

    unless @manifestacion_de_interes.representante_institucion_para_solicitud_id.nil?
      @usuario_temporal = User.unscoped.find(@manifestacion_de_interes.representante_institucion_para_solicitud_id)
      if @usuario_temporal.user_id.nil?
        @usuario_nuevo = @usuario_temporal
        @usuario_editado = User.new
      else
        @usuario_nuevo = User.new
        @usuario_editado = @usuario_temporal
      end
    else
      @usuario_temporal = @usuario_nuevo = @usuario_editado = User.new
    end
    @usuario_nuevo.temporal = true
    @usuario_editado.temporal = true
    @usuario_nuevo.flujo_id = @manifestacion_de_interes.flujo.id
    @usuario_editado.flujo_id = @manifestacion_de_interes.flujo.id

    @manifestacion_de_interes.assign_attributes(manifestacion_obs_admisibilidad_params)
    @manifestacion_de_interes[:carta_de_apoyo_y_compromiso] = manifestacion_obs_admisibilidad_params[:carta_de_apoyo_y_compromiso] if manifestacion_obs_admisibilidad_params[:carta_de_apoyo_y_compromiso].present?
    @manifestacion_de_interes[:estandar_certificable] = manifestacion_obs_admisibilidad_params[:estandar_certificable] if manifestacion_obs_admisibilidad_params[:estandar_certificable].present?
    @manifestacion_de_interes[:diagnostico_de_acuerdo_anterior] = manifestacion_obs_admisibilidad_params[:diagnostico_de_acuerdo_anterior] if  manifestacion_obs_admisibilidad_params[:diagnostico_de_acuerdo_anterior].present?
    @manifestacion_de_interes[:informe_de_acuerdo_anterior] = manifestacion_obs_admisibilidad_params[:informe_de_acuerdo_anterior] if manifestacion_obs_admisibilidad_params[:informe_de_acuerdo_anterior].present?
    @manifestacion_de_interes[:estudios_sectoriales_territoriales_relevantes] = manifestacion_obs_admisibilidad_params[:estudios_sectoriales_territoriales_relevantes] if manifestacion_obs_admisibilidad_params[:estudios_sectoriales_territoriales_relevantes].present?
    @manifestacion_de_interes[:mapa_de_actores_archivo] = manifestacion_obs_admisibilidad_params[:mapa_de_actores_archivo] if manifestacion_obs_admisibilidad_params[:mapa_de_actores_archivo].present?
    @manifestacion_de_interes[:carta_de_interes_institucion_gestora_firmada] = manifestacion_obs_admisibilidad_params[:carta_de_interes_institucion_gestora_firmada] if manifestacion_obs_admisibilidad_params[:carta_de_interes_institucion_gestora_firmada].present?
    @manifestacion_de_interes[:area_influencia_proyecto_archivo] = manifestacion_obs_admisibilidad_params[:area_influencia_proyecto_archivo] if manifestacion_obs_admisibilidad_params[:area_influencia_proyecto_archivo].present?
    @manifestacion_de_interes[:alternativas_instalacion_archivo] = manifestacion_obs_admisibilidad_params[:alternativas_instalacion_archivo] if manifestacion_obs_admisibilidad_params[:alternativas_instalacion_archivo].present?
    @manifestacion_de_interes[:gantt_proyecto] = manifestacion_obs_admisibilidad_params[:gantt_proyecto] if manifestacion_obs_admisibilidad_params[:gantt_proyecto].present?
    @manifestacion_de_interes[:estudio_de_mercado] = manifestacion_obs_admisibilidad_params[:estudio_de_mercado] if manifestacion_obs_admisibilidad_params[:estudio_de_mercado].present?
    @manifestacion_de_interes[:anteproyecto] = manifestacion_obs_admisibilidad_params[:anteproyecto] if manifestacion_obs_admisibilidad_params[:anteproyecto].present?
    @manifestacion_de_interes[:otros_estudios] = manifestacion_obs_admisibilidad_params[:otros_estudios] if manifestacion_obs_admisibilidad_params[:otros_estudios].present?
    @manifestacion_de_interes.completar_informacion!
    set_representantes

    unless @manifestacion_de_interes.tipo_instrumento.blank?
      @manifestacion_de_interes.descripcion_acuerdo = @manifestacion_de_interes.tipo_instrumento.descripcion
    end

    checked = @manifestacion_de_interes.set_checked
    @rpc_checked = checked[:rpc_checked]
    @actecos_checked = checked[:actecos_checked]

    @manifestacion_de_interes[:estandar_certificable] = nil if manifestacion_obs_admisibilidad_params[:radio_estandar] == "1"
    @manifestacion_de_interes[:estandar_de_certificacion_id] = nil if manifestacion_obs_admisibilidad_params[:radio_estandar] == "0"

    @manifestacion_de_interes[:diagnostico_de_acuerdo_anterior] = nil if manifestacion_obs_admisibilidad_params[:radio_diagnostico] == "1"
    @manifestacion_de_interes[:diagnostico_id] = nil if manifestacion_obs_admisibilidad_params[:radio_diagnostico] == "0"

    @manifestacion_de_interes[:informe_de_acuerdo_anterior] = nil if manifestacion_obs_admisibilidad_params[:radio_informe] == "1"
    @manifestacion_de_interes[:acuerdo_previo_con_informe_id] = nil if manifestacion_obs_admisibilidad_params[:radio_informe] == "0" 

    @flujo.actividad_economica_ids = manifestacion_obs_admisibilidad_params[:actividad_economicas_ids]
    @flujo.comuna_ids = manifestacion_obs_admisibilidad_params[:comunas_ids]
    @flujo.cuenca_ids = manifestacion_obs_admisibilidad_params[:cuencas_ids]
    @flujo.save

    unless @manifestacion_de_interes.secciones_observadas_admisibilidad.nil?
      @total_de_errores_por_tab = @manifestacion_de_interes.secciones_observadas_admisibilidad.map{|s| [s.to_sym, [""]]}.to_h
    end

    respond_to do |format|
      @manifestacion_de_interes.tarea_codigo = @tarea.codigo
      @manifestacion_de_interes.revisar_y_actualizar_mapa_de_actores = true
      if @manifestacion_de_interes.valid?
      #DZC verifica la vigencia del plazo de 25 días corridos para evacuar las observaciones (condición 'B')
      #se quita validacion,ahora muere en background
        if true
          @manifestacion_de_interes.save

          @flujo.contribuyente_id = @manifestacion_de_interes.contribuyente_id if !@manifestacion_de_interes.contribuyente_id.blank?
          @flujo.save

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
            @contribuyente_temporal = @contribuyente_nuevo = @contribuyente_editado = Contribuyente.new
          end
          @contribuyente_nuevo.temporal = true
          @contribuyente_editado.temporal = true
          @contribuyente_nuevo.flujo_id = @manifestacion_de_interes.flujo.id
          @contribuyente_editado.flujo_id = @manifestacion_de_interes.flujo.id

          unless @manifestacion_de_interes.representante_institucion_para_solicitud_id.nil?
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
          
          @manifestacion_de_interes.flujo.reload
          carga_de_representantes

          #DZC corrige continuación el en flujo por cumplimiento de condición 'A'
          if manifestacion_params[:temporal]=="false" || manifestacion_params[:temporal].blank?
            if manifestacion_obs_admisibilidad_params.key?(:update_obs_admisibilidad) && manifestacion_obs_admisibilidad_params[:update_obs_admisibilidad] == "true"
              @tarea_pendiente.pasar_a_siguiente_tarea 'A' if manifestacion_obs_admisibilidad_params[:update_obs_admisibilidad] == "true"

              format.js { 
                flash[:success] = 'Admisibilidad Técnica Enviada correctamente'
                render js: "window.location='#{root_path}'"
              }
              format.html { redirect_to root_path, flash: {notice: 'Admisibilidad Técnica Enviada correctamente' }}
            end
          else
            @mantener_temporal = manifestacion_params[:temporal]
            success = 'Admisibilidad Técnica Guardada correctamente'
            format.js { flash.now[:success] = success }
            format.html { redirect_to observaciones_admisibilidad_manifestacion_de_interes_path(@tarea_pendiente,@manifestacion_de_interes), notice: success }
          end
          #format.js { 
          #  flash.now[:success] = 'Admisibilidad Actualizada correctamente'
          #  render js: "window.location='#{root_path}'"
          #}
          #format.html { redirect_to root_path, flash: {notice: 'Admisibilidad Actualizada correctamente' }}
        else
          @tarea_pendiente.pasar_a_siguiente_tarea 'B' #DZC pasa a siguiente tarea ejecutando condición 'B' (pone término al flujo)
          format.js { 
            flash.now[:error] = 'Ya se ha vencido el plazo para evacuar las observaciones. Se ha puesto término a la manifestación' 
            render js: "window.location='#{root_path}'" 
          }
          format.html { redirect_to root_path(@tarea_pendiente,@manifestacion_de_interes), flash: {notice: 'Ya se ha vencido el plazo para evacuar las observaciones. Se ha puesto término a la manifestación' }}
        end
      else
        @recuerde_guardar_minutos = ManifestacionDeInteres::MINUTOS_MENSAJE_GUARDAR #DZC 2019-04-04 18:33:08 corrige requerimiento 2019-04-03
        @total_de_errores_por_tab = [] if @manifestacion_de_interes.secciones_observadas_admisibilidad.nil?
        @total_de_errores_por_tab[:"admisibilidad"] = [""]
        carga_de_representantes

        if(@manifestacion_de_interes.errors.messages[:mapa_de_actores_archivo].size > 0)
          @manifestacion_de_interes.mapa_de_actores_data = nil
          #@manifestacion_de_interes.mapa_de_actores_archivo.remove!
          @manifestacion_de_interes.mapa_de_actores_archivo = nil
        end
        format.js { flash.now[:error] = "Antes de enviar debe completar todos los campos requeridos" }
        format.html { render :observaciones_admisibilidad }
      end
    end
  end



  def observaciones_admisibilidad_juridica #DZC APL-004.2
    @recuerde_guardar_minutos = ManifestacionDeInteres::MINUTOS_MENSAJE_GUARDAR #DZC 2019-04-04 18:33:08 corrige requerimiento 2019-04-03
    unless @manifestacion_de_interes.secciones_observadas_admisibilidad_juridica.nil?
      @total_de_errores_por_tab = @manifestacion_de_interes.secciones_observadas_admisibilidad_juridica.map{|s| [s.to_sym, [""]]}.to_h
    end

    @manifestacion_de_interes.seleccion_de_radios

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

  def resolver_observaciones_admisibilidad_juridica #DZC TAREA APL-004.2

    unless @manifestacion_de_interes.contribuyente_id.nil?
      @contribuyente_temporal = Contribuyente.unscoped.find(@manifestacion_de_interes.contribuyente_id)
      if @contribuyente_temporal.contribuyente_id.nil?
        @contribuyente_nuevo = @contribuyente_temporal
        @contribuyente_editado = Contribuyente.new
      else
        @contribuyente_nuevo = Contribuyente.new
        @contribuyente_editado = @contribuyente_temporal
      end
    else
      @contribuyente_temporal = @contribuyente_nuevo = @contribuyente_editado = Contribuyente.new
    end
    @contribuyente_nuevo.temporal = true
    @contribuyente_editado.temporal = true
    @contribuyente_nuevo.flujo_id = @manifestacion_de_interes.flujo.id
    @contribuyente_editado.flujo_id = @manifestacion_de_interes.flujo.id

    unless @manifestacion_de_interes.representante_institucion_para_solicitud_id.nil?
      @usuario_temporal = User.unscoped.find(@manifestacion_de_interes.representante_institucion_para_solicitud_id)
      if @usuario_temporal.user_id.nil?
        @usuario_nuevo = @usuario_temporal
        @usuario_editado = User.new
      else
        @usuario_nuevo = User.new
        @usuario_editado = @usuario_temporal
      end
    else
      @usuario_temporal = @usuario_nuevo = @usuario_editado = User.new
    end
    @usuario_nuevo.temporal = true
    @usuario_editado.temporal = true
    @usuario_nuevo.flujo_id = @manifestacion_de_interes.flujo.id
    @usuario_editado.flujo_id = @manifestacion_de_interes.flujo.id

    @manifestacion_de_interes.assign_attributes(manifestacion_obs_admisibilidad_juridica_params)
    @manifestacion_de_interes[:carta_de_apoyo_y_compromiso] = manifestacion_obs_admisibilidad_juridica_params[:carta_de_apoyo_y_compromiso] if manifestacion_obs_admisibilidad_juridica_params[:carta_de_apoyo_y_compromiso].present?
    @manifestacion_de_interes[:estandar_certificable] = manifestacion_obs_admisibilidad_juridica_params[:estandar_certificable] if manifestacion_obs_admisibilidad_juridica_params[:estandar_certificable].present?
    @manifestacion_de_interes[:diagnostico_de_acuerdo_anterior] = manifestacion_obs_admisibilidad_juridica_params[:diagnostico_de_acuerdo_anterior] if  manifestacion_obs_admisibilidad_juridica_params[:diagnostico_de_acuerdo_anterior].present?
    @manifestacion_de_interes[:informe_de_acuerdo_anterior] = manifestacion_obs_admisibilidad_juridica_params[:informe_de_acuerdo_anterior] if manifestacion_obs_admisibilidad_juridica_params[:informe_de_acuerdo_anterior].present?
    @manifestacion_de_interes[:estudios_sectoriales_territoriales_relevantes] = manifestacion_obs_admisibilidad_juridica_params[:estudios_sectoriales_territoriales_relevantes] if manifestacion_obs_admisibilidad_juridica_params[:estudios_sectoriales_territoriales_relevantes].present?
    @manifestacion_de_interes[:mapa_de_actores_archivo] = manifestacion_obs_admisibilidad_juridica_params[:mapa_de_actores_archivo] if manifestacion_obs_admisibilidad_juridica_params[:mapa_de_actores_archivo].present?
    @manifestacion_de_interes[:carta_de_interes_institucion_gestora_firmada] = manifestacion_obs_admisibilidad_juridica_params[:carta_de_interes_institucion_gestora_firmada] if manifestacion_obs_admisibilidad_juridica_params[:carta_de_interes_institucion_gestora_firmada].present?
    @manifestacion_de_interes[:area_influencia_proyecto_archivo] = manifestacion_obs_admisibilidad_juridica_params[:area_influencia_proyecto_archivo] if manifestacion_obs_admisibilidad_juridica_params[:area_influencia_proyecto_archivo].present?
    @manifestacion_de_interes[:alternativas_instalacion_archivo] = manifestacion_obs_admisibilidad_juridica_params[:alternativas_instalacion_archivo] if manifestacion_obs_admisibilidad_juridica_params[:alternativas_instalacion_archivo].present?
    @manifestacion_de_interes[:gantt_proyecto] = manifestacion_obs_admisibilidad_juridica_params[:gantt_proyecto] if manifestacion_obs_admisibilidad_juridica_params[:gantt_proyecto].present?
    @manifestacion_de_interes[:estudio_de_mercado] = manifestacion_obs_admisibilidad_juridica_params[:estudio_de_mercado] if manifestacion_obs_admisibilidad_juridica_params[:estudio_de_mercado].present?
    @manifestacion_de_interes[:anteproyecto] = manifestacion_obs_admisibilidad_juridica_params[:anteproyecto] if manifestacion_obs_admisibilidad_juridica_params[:anteproyecto].present?
    @manifestacion_de_interes[:otros_estudios] = manifestacion_obs_admisibilidad_juridica_params[:otros_estudios] if manifestacion_obs_admisibilidad_juridica_params[:otros_estudios].present?
    @manifestacion_de_interes.completar_informacion!
    set_representantes

    unless @manifestacion_de_interes.tipo_instrumento.blank?
      @manifestacion_de_interes.descripcion_acuerdo = @manifestacion_de_interes.tipo_instrumento.descripcion
    end

    checked = @manifestacion_de_interes.set_checked
    @rpc_checked = checked[:rpc_checked]
    @actecos_checked = checked[:actecos_checked]

    @manifestacion_de_interes[:estandar_certificable] = nil if manifestacion_obs_admisibilidad_juridica_params[:radio_estandar] == "1"
    @manifestacion_de_interes[:estandar_de_certificacion_id] = nil if manifestacion_obs_admisibilidad_juridica_params[:radio_estandar] == "0"

    @manifestacion_de_interes[:diagnostico_de_acuerdo_anterior] = nil if manifestacion_obs_admisibilidad_juridica_params[:radio_diagnostico] == "1"
    @manifestacion_de_interes[:diagnostico_id] = nil if manifestacion_obs_admisibilidad_juridica_params[:radio_diagnostico] == "0"

    @manifestacion_de_interes[:informe_de_acuerdo_anterior] = nil if manifestacion_obs_admisibilidad_juridica_params[:radio_informe] == "1"
    @manifestacion_de_interes[:acuerdo_previo_con_informe_id] = nil if manifestacion_obs_admisibilidad_juridica_params[:radio_informe] == "0" 

    @flujo.actividad_economica_ids = manifestacion_obs_admisibilidad_juridica_params[:actividad_economicas_ids]
    @flujo.comuna_ids = manifestacion_obs_admisibilidad_juridica_params[:comunas_ids]
    @flujo.cuenca_ids = manifestacion_obs_admisibilidad_juridica_params[:cuencas_ids]
    @flujo.save

    unless @manifestacion_de_interes.secciones_observadas_admisibilidad_juridica.nil?
      @total_de_errores_por_tab = @manifestacion_de_interes.secciones_observadas_admisibilidad_juridica.map{|s| [s.to_sym, [""]]}.to_h
    end

    respond_to do |format|
      @manifestacion_de_interes.tarea_codigo = @tarea.codigo
      @manifestacion_de_interes.revisar_y_actualizar_mapa_de_actores = true
      if @manifestacion_de_interes.valid?
      #DZC verifica la vigencia del plazo de 25 días corridos para evacuar las observaciones (condición 'B')
      #se quita validacion, ahora muere en background
        if true
          @manifestacion_de_interes.save

          @flujo.contribuyente_id = @manifestacion_de_interes.contribuyente_id if !@manifestacion_de_interes.contribuyente_id.blank?
          @flujo.save

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
            @contribuyente_temporal = @contribuyente_nuevo = @contribuyente_editado = Contribuyente.new
          end
          @contribuyente_nuevo.temporal = true
          @contribuyente_editado.temporal = true
          @contribuyente_nuevo.flujo_id = @manifestacion_de_interes.flujo.id
          @contribuyente_editado.flujo_id = @manifestacion_de_interes.flujo.id

          unless @manifestacion_de_interes.representante_institucion_para_solicitud_id.nil?
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
          
          @manifestacion_de_interes.flujo.reload
          carga_de_representantes

          #DZC corrige continuación el en flujo por cumplimiento de condición 'A'
          if manifestacion_params[:temporal]=="false" || manifestacion_params[:temporal].blank?
            if manifestacion_obs_admisibilidad_juridica_params.key?(:update_obs_admisibilidad_juridica)
              @tarea_pendiente.pasar_a_siguiente_tarea 'A' if manifestacion_obs_admisibilidad_juridica_params[:update_obs_admisibilidad_juridica] == "true"
            end
            format.js { 
              flash[:success] = 'Admisibilidad Jurídica Enviada correctamente'
              render js: "window.location='#{root_path}'"
            }
            format.html { redirect_to root_path, flash: {notice: 'Admisibilidad Jurídica Enviada correctamente' }}
          else
            @mantener_temporal = manifestacion_params[:temporal]
            success = 'Admisibilidad Jurídica Guardada correctamente'
            format.js { flash.now[:success] = success }
            format.html { redirect_to observaciones_admisibilidad_juridica_manifestacion_de_interes_path(@tarea_pendiente, @manifestacion_de_interes), notice: success }
          end
          #format.js { 
          #  flash.now[:success] = 'Admisibilidad Actualizada correctamente'
          #  render js: "window.location='#{root_path}'"
          #}
          #format.html { redirect_to root_path, flash: {notice: 'Admisibilidad Actualizada correctamente' }}
        else
          @tarea_pendiente.pasar_a_siguiente_tarea 'B' #DZC pasa a siguiente tarea ejecutando condición 'B' (pone término al flujo)
          format.js { 
            flash.now[:error] = 'Ya se ha vencido el plazo para evacuar las observaciones. Se ha puesto término a la manifestación' 
            render js: "window.location='#{root_path}'" 
          }
          format.html { redirect_to root_path(@tarea_pendiente,@manifestacion_de_interes), flash: {notice: 'Ya se ha vencido el plazo para evacuar las observaciones. Se ha puesto término a la manifestación' }}
        end
      else
        @recuerde_guardar_minutos = ManifestacionDeInteres::MINUTOS_MENSAJE_GUARDAR #DZC 2019-04-04 18:33:08 corrige requerimiento 2019-04-03
        @total_de_errores_por_tab = [] if @manifestacion_de_interes.secciones_observadas_admisibilidad_juridica.nil?
        @total_de_errores_por_tab[:"admisibilidad-juridica"] = [""]
        carga_de_representantes

        if(@manifestacion_de_interes.errors.messages[:mapa_de_actores_archivo].size > 0)
          @manifestacion_de_interes.mapa_de_actores_data = nil
          #@manifestacion_de_interes.mapa_de_actores_archivo.remove!
          @manifestacion_de_interes.mapa_de_actores_archivo = nil
        end
        format.js { flash.now[:error] = "Antes de enviar debe completar todos los campos requeridos" }
        format.html { render :observaciones_admisibilidad_juridica }
      end
    end
  end

  def pertinencia_factibilidad #DZC TAREA APL-005
    @recuerde_guardar_minutos = ManifestacionDeInteres::MINUTOS_MENSAJE_GUARDAR #DZC 2019-04-04 18:33:08 corrige requerimiento 2019-04-03
    # @responsables = Responsable.__personas_responsables(Rol::COORDINADOR, TipoInstrumento::ACUERDO_DE_PRODUCCION_LIMPIA)
    @responsables_coordinador = Responsable.__personas_responsables(Rol::COORDINADOR, TipoInstrumento.find_by(nombre: 'Acuerdo de Producción Limpia').id) #DZC se reemplaza la constante por el valor del registro en la tabla. ESTO NO EVITA QUE SE DEBA MANTENER EL NOMBRE EN LA TABLA
    @responsables_prensa = Responsable.__personas_responsables(Rol::PRENSA, TipoInstrumento.find_by(nombre: 'Acuerdo de Producción Limpia').id) #DZC se reemplaza la constante por el valor del registro en la tabla. ESTO NO EVITA QUE SE DEBA MANTENER EL NOMBRE EN LA TABLA
    @manifestacion_de_interes.seleccion_de_radios

    #Obtiene las lineas para el seguimiento del FPL Línea 1.2 - Implementación de APL
    @lineas_fpl = TipoInstrumento.where(id: [TipoInstrumento::FPL_LINEA_1_1,TipoInstrumento::FPL_LINEA_5_1,TipoInstrumento::FPL_EXTRAPRESUPUESTARIO_DIAGNOSTICO])
    @fondo_produccion_limpia_ids = FondoProduccionLimpia.where(flujo_apl_id: @flujo.id).pluck(:flujo_id)
    @flujos_con_tipo_instrumento = Flujo.where(id: @fondo_produccion_limpia_ids, tipo_instrumento_id: [TipoInstrumento::FPL_LINEA_1_1,TipoInstrumento::FPL_LINEA_5_1,TipoInstrumento::FPL_EXTRAPRESUPUESTARIO_DIAGNOSTICO])
   
    @instrumento_seleccionado = []
    if @flujos_con_tipo_instrumento.present?
      @instrumento_seleccionado = Flujo.where(id: @flujos_con_tipo_instrumento).pluck(:tipo_instrumento_id) 
    end
 
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

  def revisar_pertinencia_factibilidad #DZC TAREA APL-005
    @manifestacion_de_interes.assign_attributes(manifestacion_pertinencia_params)
    respond_to do |format|
      @manifestacion_de_interes.tarea_codigo = @tarea.codigo
      ##ToDo: fecha limiteq
      if @manifestacion_de_interes.valid?
        @manifestacion_de_interes.save
        if @tarea_pendiente.save
          if @manifestacion_de_interes.temp_siguientes != "true"
            #DZC se agrega la validación de la condición 'C', para ser coherente con el método continuar_flujo
            case @manifestacion_de_interes.resultado_pertinencia
            when "aceptada"
              MapaDeActor.find_or_create_by({
                flujo_id: @tarea_pendiente.flujo_id,
                rol_id: Rol::COORDINADOR,
                persona_id: manifestacion_pertinencia_params[:coordinador_subtipo_instrumento_id]
              })
              MapaDeActor.find_or_create_by({
                flujo_id: @tarea_pendiente.flujo_id,
                rol_id: Rol::PRENSA,
                persona_id: manifestacion_pertinencia_params[:encargado_hitos_prensa_id]
              })
              actores_desde_campo = @manifestacion_de_interes.mapa_de_actores_data.blank? ? nil : @manifestacion_de_interes.mapa_de_actores_data.map{|i| i.transform_keys!(&:to_sym).to_h}
              MapaDeActor.actualiza_tablas_mapa_actores(actores_desde_campo, @flujo, @tarea_pendiente)

              #paso los temporales de contribuyente y responsable te tarea apl-001 a definitivos
              @manifestacion_de_interes.confirmar_temporales_a_definitivos

              @tarea_pendiente.pasar_a_siguiente_tarea 'A'
              #Cargar set de metas si se adherio a estandar o diagnostico.-
              if @manifestacion_de_interes.estandar_de_certificacion_id.present?
                @flujo.set_metas_acciones_by_estandar @manifestacion_de_interes.estandar_de_certificacion_id
              elsif @manifestacion_de_interes.diagnostico_id.present?
                set_metas_by_antiguo_acuerdo @manifestacion_de_interes.diagnostico_id, @flujo
              end

              #FPL-00 - SE CREA NUEVO FLUJO FPL PARA EL DIAGNOSTICO 
              if manifestacion_pertinencia_params[:fondo_produccion_limpia] == "true"
                #obtengo el user_id del postulante de la manifestacion de interes
                tarea_fondo = Tarea.find_by_codigo(Tarea::COD_APL_001)
                postulante = TareaPendiente.find_by(tarea_id: tarea_fondo.id, flujo_id: @tarea_pendiente.flujo_id)

                flujo = Flujo.new({
                  contribuyente_id: @manifestacion_de_interes.contribuyente_id, 
                  tipo_instrumento_id: manifestacion_pertinencia_params[:tipo_linea_seleccionada] #params[:manifestacion_de_interes][:tipo_instrumento_id] 
                })
                if flujo.save
                  persona_by_user = Persona.where(user_id: postulante.user_id).first

                  #Se inserta en el mapa de actores al postulante
                  mapa = MapaDeActor.find_or_create_by({
                    flujo_id: flujo.id,
                    rol_id: Rol::PROPONENTE, 
                    persona_id: persona_by_user.id 
                  })

                  #SE ENVIAR EL MAIL AL RESPONSABLE  
                  mdi = @manifestacion_de_interes
                  
                  #Inicia el flujo con el nombre Sin nombre
                  codigo_proyecto = "Proyecto DyAPL"

                  fpl = FondoProduccionLimpia.new({
                    flujo_id: flujo.id,
                    flujo_apl_id: @tarea_pendiente.flujo_id,
                    codigo_proyecto: codigo_proyecto
                  })
                  fpl.save 

                    #guarda el fpl id en la tabla flujo
                    flujo.fondo_produccion_limpia_id = fpl.id
                    flujo.save

                    #envio de correo
                    @tarea_pendiente.pasar_a_siguiente_tarea 'D'
                    
                  success = 'Flujo fondo de producción limpia creado correctamente.'
                else
                  warning = 'Usted NO puede iniciar Flujo FPL.'
                end
              end
              
            when "solicita_condiciones", "realiza_observaciones", "solicita_condiciones_y_contiene_observaciones"
              @tarea_pendiente.pasar_a_siguiente_tarea 'B'
            when "no_aceptada"
              @tarea_pendiente.pasar_a_siguiente_tarea 'C'
            end
            format.js { flash.now[:success] = 'Pertinencia-factibilidad enviada correctamente'
              render js: "window.location='#{root_path}'"}
            format.html { redirect_to root_path, flash: {notice: 'Pertinencia-factibilidad enviada correctamente' }}
          else
            msj = 'Pertinencia-factibilidad guardada correctamente'
            format.js { flash.now[:success] = msj
              render js: "window.location='#{pertinencia_factibilidad_manifestacion_de_interes_path(@tarea_pendiente,@manifestacion_de_interes)}'"}
            format.html { redirect_to pertinencia_factibilidad_manifestacion_de_interes_path(@tarea_pendiente,@manifestacion_de_interes), flash: {notice: msj }}
          end
          
        end
      else
        @recuerde_guardar_minutos = ManifestacionDeInteres::MINUTOS_MENSAJE_GUARDAR #DZC 2019-04-04 18:33:08 corrige requerimiento 2019-04-03
        flash.now[:error] = "Antes de enviar debe completar todos los campos requeridos"
        @responsables_coordinador = Responsable.__personas_responsables(Rol::COORDINADOR, TipoInstrumento.find_by(nombre: 'Acuerdo de Producción Limpia').id) 
        @responsables_prensa = Responsable.__personas_responsables(Rol::PRENSA, TipoInstrumento.find_by(nombre: 'Acuerdo de Producción Limpia').id) 
        #Obtiene las lineas para el diagnostico del FPL
        @lineas_fpl = TipoInstrumento.where(id: [TipoInstrumento::FPL_LINEA_1_1,TipoInstrumento::FPL_LINEA_5_1,TipoInstrumento::FPL_EXTRAPRESUPUESTARIO_DIAGNOSTICO])

        @manifestacion_de_interes.seleccion_de_radios

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

        format.js { }
        format.html { render :pertinencia_factibilidad}
      end
    end
  end

  def responder_pertinencia_factibilidad #DZC APL-006
    @recuerde_guardar_minutos = ManifestacionDeInteres::MINUTOS_MENSAJE_GUARDAR #DZC 2019-04-04 18:33:08 corrige requerimiento 2019-04-03
    unless @manifestacion_de_interes.secciones_observadas_pertinencia_factibilidad.nil?
      @total_de_errores_por_tab = @manifestacion_de_interes.secciones_observadas_pertinencia_factibilidad.map{|s| [s.to_sym, [""]]}.to_h
    end
    @manifestacion_de_interes.seleccion_de_radios

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

  def responder_cond_obs_pertinencia_factibilidad #DZC APL-006

    unless @manifestacion_de_interes.contribuyente_id.nil?
      @contribuyente_temporal = Contribuyente.unscoped.find(@manifestacion_de_interes.contribuyente_id)
      if @contribuyente_temporal.contribuyente_id.nil?
        @contribuyente_nuevo = @contribuyente_temporal
        @contribuyente_editado = Contribuyente.new
      else
        @contribuyente_nuevo = Contribuyente.new
        @contribuyente_editado = @contribuyente_temporal
      end
    else
      @contribuyente_temporal = @contribuyente_nuevo = @contribuyente_editado = Contribuyente.new
    end
    @contribuyente_nuevo.temporal = true
    @contribuyente_editado.temporal = true
    @contribuyente_nuevo.flujo_id = @manifestacion_de_interes.flujo.id
    @contribuyente_editado.flujo_id = @manifestacion_de_interes.flujo.id

    unless @manifestacion_de_interes.representante_institucion_para_solicitud_id.nil?
      @usuario_temporal = User.unscoped.find(@manifestacion_de_interes.representante_institucion_para_solicitud_id)
      if @usuario_temporal.user_id.nil?
        @usuario_nuevo = @usuario_temporal
        @usuario_editado = User.new
      else
        @usuario_nuevo = User.new
        @usuario_editado = @usuario_temporal
      end
    else
      @usuario_temporal = @usuario_nuevo = @usuario_editado = User.new
    end
    @usuario_nuevo.temporal = true
    @usuario_editado.temporal = true
    @usuario_nuevo.flujo_id = @manifestacion_de_interes.flujo.id
    @usuario_editado.flujo_id = @manifestacion_de_interes.flujo.id

    @manifestacion_de_interes.assign_attributes(manifestacion_responder_pertinencia_params)
    @manifestacion_de_interes[:carta_de_apoyo_y_compromiso] = manifestacion_responder_pertinencia_params[:carta_de_apoyo_y_compromiso] if manifestacion_responder_pertinencia_params[:carta_de_apoyo_y_compromiso].present?
    @manifestacion_de_interes[:estandar_certificable] = manifestacion_responder_pertinencia_params[:estandar_certificable] if manifestacion_responder_pertinencia_params[:estandar_certificable].present?
    @manifestacion_de_interes[:diagnostico_de_acuerdo_anterior] = manifestacion_responder_pertinencia_params[:diagnostico_de_acuerdo_anterior] if  manifestacion_responder_pertinencia_params[:diagnostico_de_acuerdo_anterior].present?
    @manifestacion_de_interes[:informe_de_acuerdo_anterior] = manifestacion_responder_pertinencia_params[:informe_de_acuerdo_anterior] if manifestacion_responder_pertinencia_params[:informe_de_acuerdo_anterior].present?
    @manifestacion_de_interes[:estudios_sectoriales_territoriales_relevantes] = manifestacion_responder_pertinencia_params[:estudios_sectoriales_territoriales_relevantes] if manifestacion_responder_pertinencia_params[:estudios_sectoriales_territoriales_relevantes].present?
    @manifestacion_de_interes[:mapa_de_actores_archivo] = manifestacion_responder_pertinencia_params[:mapa_de_actores_archivo] if manifestacion_responder_pertinencia_params[:mapa_de_actores_archivo].present?
    @manifestacion_de_interes[:carta_de_interes_institucion_gestora_firmada] = manifestacion_responder_pertinencia_params[:carta_de_interes_institucion_gestora_firmada] if manifestacion_responder_pertinencia_params[:carta_de_interes_institucion_gestora_firmada].present?
    @manifestacion_de_interes[:area_influencia_proyecto_archivo] = manifestacion_responder_pertinencia_params[:area_influencia_proyecto_archivo] if manifestacion_responder_pertinencia_params[:area_influencia_proyecto_archivo].present?
    @manifestacion_de_interes[:alternativas_instalacion_archivo] = manifestacion_responder_pertinencia_params[:alternativas_instalacion_archivo] if manifestacion_responder_pertinencia_params[:alternativas_instalacion_archivo].present?
    @manifestacion_de_interes[:gantt_proyecto] = manifestacion_responder_pertinencia_params[:gantt_proyecto] if manifestacion_responder_pertinencia_params[:gantt_proyecto].present?
    @manifestacion_de_interes[:estudio_de_mercado] = manifestacion_responder_pertinencia_params[:estudio_de_mercado] if manifestacion_responder_pertinencia_params[:estudio_de_mercado].present?
    @manifestacion_de_interes[:anteproyecto] = manifestacion_responder_pertinencia_params[:anteproyecto] if manifestacion_responder_pertinencia_params[:anteproyecto].present?
    @manifestacion_de_interes[:otros_estudios] = manifestacion_responder_pertinencia_params[:otros_estudios] if manifestacion_responder_pertinencia_params[:otros_estudios].present?
    @manifestacion_de_interes.completar_informacion!
    set_representantes

    unless @manifestacion_de_interes.tipo_instrumento.blank?
      @manifestacion_de_interes.descripcion_acuerdo = @manifestacion_de_interes.tipo_instrumento.descripcion
    end

    checked = @manifestacion_de_interes.set_checked
    @rpc_checked = checked[:rpc_checked]
    @actecos_checked = checked[:actecos_checked]

    @manifestacion_de_interes[:estandar_certificable] = nil if manifestacion_responder_pertinencia_params[:radio_estandar] == "1"
    @manifestacion_de_interes[:estandar_de_certificacion_id] = nil if manifestacion_responder_pertinencia_params[:radio_estandar] == "0"

    @manifestacion_de_interes[:diagnostico_de_acuerdo_anterior] = nil if manifestacion_responder_pertinencia_params[:radio_diagnostico] == "1"
    @manifestacion_de_interes[:diagnostico_id] = nil if manifestacion_responder_pertinencia_params[:radio_diagnostico] == "0"

    @manifestacion_de_interes[:informe_de_acuerdo_anterior] = nil if manifestacion_responder_pertinencia_params[:radio_informe] == "1"
    @manifestacion_de_interes[:acuerdo_previo_con_informe_id] = nil if manifestacion_responder_pertinencia_params[:radio_informe] == "0" 

    @flujo.actividad_economica_ids = manifestacion_responder_pertinencia_params[:actividad_economicas_ids]
    @flujo.comuna_ids = manifestacion_responder_pertinencia_params[:comunas_ids]
    @flujo.cuenca_ids = manifestacion_responder_pertinencia_params[:cuencas_ids]
    @flujo.save

    unless @manifestacion_de_interes.secciones_observadas_pertinencia_factibilidad.nil?
      @total_de_errores_por_tab = @manifestacion_de_interes.secciones_observadas_pertinencia_factibilidad.map{|s| [s.to_sym, [""]]}.to_h
    end
    respond_to do |format|
      @manifestacion_de_interes.tarea_codigo = @tarea.codigo
      @manifestacion_de_interes.revisar_y_actualizar_mapa_de_actores = true
      if @manifestacion_de_interes.valid?
        #DZC verifica la vigencia del plazo de 60 días corridos para evacuar las observaciones (condición 'C')
        #se quita validacion, ahora muere en background
        if true
          @manifestacion_de_interes.save

          @flujo.contribuyente_id = @manifestacion_de_interes.contribuyente_id if !@manifestacion_de_interes.contribuyente_id.blank?
          @flujo.save

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
            @contribuyente_temporal = @contribuyente_nuevo = @contribuyente_editado = Contribuyente.new
          end
          @contribuyente_nuevo.temporal = true
          @contribuyente_editado.temporal = true
          @contribuyente_nuevo.flujo_id = @manifestacion_de_interes.flujo.id
          @contribuyente_editado.flujo_id = @manifestacion_de_interes.flujo.id

          unless @manifestacion_de_interes.representante_institucion_para_solicitud_id.nil?
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
          
          @manifestacion_de_interes.flujo.reload
          carga_de_representantes

          if manifestacion_responder_pertinencia_params.key?(:update_respuesta_pertinencia)
            if @tarea_pendiente.save && manifestacion_responder_pertinencia_params[:update_respuesta_pertinencia] == "true" && @manifestacion_de_interes.temporal != "true"
              if @manifestacion_de_interes.resultado_pertinencia == "solicita_condiciones" || @manifestacion_de_interes.resultado_pertinencia == "solicita_condiciones_y_contiene_observaciones"
                case @manifestacion_de_interes.acepta_condiciones_pertinencia
                when true
                  @tarea_pendiente.pasar_a_siguiente_tarea 'A'
                when false
                  @tarea_pendiente.pasar_a_siguiente_tarea 'B'
                end
              else
                @tarea_pendiente.pasar_a_siguiente_tarea 'A'
              end
              format.js { flash.now[:success] = 'Respuesta a las observaciones sobre pertinencia y factibilidad enviada correctamente'
                render js: "window.location='#{root_path}'"}
              format.html { redirect_to root_path, flash: {notice: 'Respuesta a las observaciones sobre pertinencia y factibilidad enviada correctamente' }}
            else #Toma este camino si solo se actualiza la manifestacion
              format.js { flash.now[:success] = 'Respuesta a las observaciones sobre pertinencia y factibilidad guardada correctamente'}
              format.html { redirect_to responder_pertinencia_factibilidad_manifestacion_de_interes_path(@tarea_pendiente,@manifestacion_de_interes), flash: {notice: 'Respuesta a las observaciones sobre pertinencia y factibilidad guardada correctamente' }}
            end
          end
        else
          @tarea_pendiente.pasar_a_siguiente_tarea 'C' #DZC pasa a siguiente tarea ejecutando condición 'C' (pone término al flujo)
          format.js { flash.now[:error] = 'Ya se ha vencido el plazo para evacuar las observaciones sobre pertinencia y factibilidad. Se ha puesto término a la manifestación'; render js: "window.location='#{root_path}'" }
          format.html { redirect_to root_path(@tarea_pendiente, @manifestacion_de_interes), flash: {notice: 'Ya se ha vencido el plazo para evacuar las observaciones sobre pertinencia y factibilidad. Se ha puesto término a la manifestación' }}
        end
      else
        @recuerde_guardar_minutos = ManifestacionDeInteres::MINUTOS_MENSAJE_GUARDAR #DZC 2019-04-04 18:33:08 corrige requerimiento 2019-04-03
        flash.now[:error] = "Antes de enviar debe completar todos los campos requeridos"
        # @responsables = Responsable.__personas_responsables(Rol::COORDINADOR, TipoInstrumento::ACUERDO_DE_PRODUCCION_LIMPIA)
        @responsables = Responsable.__personas_responsables(Rol::COORDINADOR, TipoInstrumento.find_by(nombre: 'Acuerdo de Producción Limpia').id)
        @total_de_errores_por_tab = [] if @manifestacion_de_interes.secciones_observadas_pertinencia_factibilidad.nil?
        @total_de_errores_por_tab[:"pertinencia-factibilidad"] = [""]
        carga_de_representantes

        if(@manifestacion_de_interes.errors.messages[:mapa_de_actores_archivo].size > 0)
          @manifestacion_de_interes.mapa_de_actores_data = nil
          #@manifestacion_de_interes.mapa_de_actores_archivo.remove!
          @manifestacion_de_interes.mapa_de_actores_archivo = nil
        end
        format.js { }
        format.html { render :responder_pertinencia_factibilidad}
      end
    end
  end

  def usuario_entregables #DZC APL-008
    tipo_instrumento = @manifestacion_de_interes.tipo_instrumento_id.nil? ? TipoInstrumento::ACUERDO_DE_PRODUCCION_LIMPIA : @manifestacion_de_interes.tipo_instrumento_id
    rol_tarea = Tarea::find_by(codigo: Tarea::COD_APL_009).rol_id
    responsables = Responsable.__personas_responsables(rol_tarea, tipo_instrumento)
    contribuyentes_ids = responsables.map{|p| p.contribuyente_id }.uniq
    @contribuyentes = Contribuyente.where(id: contribuyentes_ids)
  end

  def lista_usuarios_entregables
    manif_de_interes = TareaPendiente.find(params[:tarea_pendiente_id]).flujo.manifestacion_de_interes
    tipo_instrumento = manif_de_interes.tipo_instrumento_id.nil? ? TipoInstrumento::ACUERDO_DE_PRODUCCION_LIMPIA : manif_de_interes.tipo_instrumento_id
    rol_tarea = Tarea::find_by(codigo: Tarea::COD_APL_009).rol_id
    personas_responsables = Responsable::__personas_responsables_v2(rol_tarea, tipo_instrumento, params[:contribuyente_id])
    @usuarios = personas_responsables.map { |e| e.user  }
  end

  def lista_usuarios_carga_datos
    manif_de_interes = TareaPendiente.find(params[:tarea_pendiente_id]).flujo.manifestacion_de_interes
    tipo_instrumento = manif_de_interes.tipo_instrumento_id.nil? ? TipoInstrumento::ACUERDO_DE_PRODUCCION_LIMPIA : manif_de_interes.tipo_instrumento_id
    rol_tarea = Rol::CARGADOR_DATOS_ACUERDO
    personas_responsables = Responsable::__personas_responsables_v2(rol_tarea, tipo_instrumento, params[:contribuyente_id])
    @usuarios = personas_responsables.map { |e| e.user  }
  end

  def guardar_usuario_entregables #DZC APL-008
    @manifestacion_de_interes.assign_attributes(manifestacion_usuario_entregables_params)
    @manifestacion_de_interes.temporal = true
    @manifestacion_de_interes.update_usuario_entregables = true

    tipo_instrumento = @manifestacion_de_interes.tipo_instrumento_id.nil? ? TipoInstrumento::ACUERDO_DE_PRODUCCION_LIMPIA : @manifestacion_de_interes.tipo_instrumento_id
    rol_tarea = Tarea::find_by(codigo: Tarea::COD_APL_009).rol_id
    respond_to do |format|

      if @manifestacion_de_interes.valid?
        @manifestacion_de_interes.tarea_codigo = @tarea.codigo
        @manifestacion_de_interes.save

        
        persona_by_user = Responsable::__personas_responsables_v2(rol_tarea, tipo_instrumento, @manifestacion_de_interes.institucion_entregables_id).select{|p| p.user_id == @manifestacion_de_interes.usuario_entregables_id }.first

        mapa = MapaDeActor.find_or_create_by({
          flujo_id: @tarea_pendiente.flujo_id,
          rol_id: rol_tarea,
          # rol_id: Rol.find_by(nombre: 'Responsable Entregables').id,
          persona_id: persona_by_user.id
        })
        @manifestacion_de_interes.temporal = true
        @manifestacion_de_interes.update(mapa_de_actores_data: nil) #DZC resetea el valor del campo, para que se contruyan archivos desde las tablas
        # borramos el archivo mapa de actores
        @manifestacion_de_interes.remove_mapa_de_actores_archivo!
        @manifestacion_de_interes.save!
        @tarea_pendiente.pasar_a_siguiente_tarea 'A', {primera_ejecucion: true}
        format.js { flash.now[:success] = 'Usuario encargado de entregables asignado correctamente' }
        format.html { redirect_to root_path, flash: {notice: 'Usuario encargado de entregables asignado correctamente' }}
      else
        flash.now[:error] = "Antes de enviar debe completar todos los campos requeridos"
        responsables = Responsable.__personas_responsables(rol_tarea, tipo_instrumento)
        contribuyentes_ids = responsables.map{|p| p.contribuyente_id }.uniq
        @contribuyentes = Contribuyente.where(id: contribuyentes_ids)
        if @manifestacion_de_interes.institucion_entregables_id.present?
          personas_responsables = Responsable::__personas_responsables_v2(rol_tarea, tipo_instrumento, @manifestacion_de_interes.institucion_entregables_id)
          @usuarios = personas_responsables.map { |e| e.user  }
        end
        format.js { }
        format.html { render :usuario_entregables}
      end
    end
  end

  def cargar_actualizar_entregable_diagnostico #DZC APL-013
    if params[:tab_metas].present?
      @tab_metas = params[:tab_metas]
    end
    # DZC 2018-10-26 16:11:53 se modifica lectura de datos
    @actores_desde_campo = @manifestacion_de_interes.mapa_de_actores_data.blank? ? nil : @manifestacion_de_interes.mapa_de_actores_data.map{|i| i.transform_keys!(&:to_sym).to_h}
    @actores_desde_tablas = MapaDeActor.construye_data_para_apl(@flujo)

    #obtiene actores en estado cero agregados en el APL-013 a traves del mantenedor y se concatenan al @actores_desde_tablas
    @actores_desde_lista = MapaDeActor.construye_data_para_apl_desde_listado(@manifestacion_de_interes.id)
    if @actores_desde_tablas != nil
      @actores_desde_tablas.concat(@actores_desde_lista)
    end

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

    #obtiene actores en estado cero agregados en el APL-013 a traves del mantenedor y se concatenan al @actores_desde_tablas
    @actores_desde_lista = MapaDeActor.construye_data_para_apl_desde_listado(@manifestacion_de_interes.id)
    if @actores_desde_tablas != nil
      @actores_desde_tablas.concat(@actores_desde_lista)
    end
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
    require 'open-uri'
    archivo_zip = Zip::OutputStream.write_buffer do |stream|
      @manifestacion_de_interes.documento_diagnosticos.each do |doc|
        if !doc.archivo.url.nil?
          # add file to zip
          url = doc.archivo.url
          nombre = File.basename(URI.parse(url).path)

          # Open and read the file from S3
          URI.open(url) do |file_data|
            stream.put_next_entry(nombre)
            stream.write file_data.read
          end
        end
      end
    end
    archivo_zip.rewind
    # archivo_zip.read
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

  def editar_nombre_apl

    @apl = ManifestacionDeInteres.find(params[:manifestacion_de_interes_id])
    @flujo = @apl.flujo.id
  end

  def nombre_apl
    if current_user.is_admin? || current_user.is_ascc? #DZC se trata del admin de la ASCC
      @instrumentos = Flujo.order(id: :desc)
    else
      # @instrumentos = Flujo.where(contribuyente_id: contribuyentes.pluck(:id), terminado: [false, nil]).order(id: :asc).all
      @instrumentos = Flujo.where(id: user_actores.pluck(:flujo_id).uniq).order(id: :desc)
    end
    @apls = @instrumentos.where.not(manifestacion_de_interes_id: nil)
    if params[:apl].present?
      instrumento_id = params[:apl].to_i
      flujo = Flujo.find(instrumento_id).manifestacion_de_interes.id
      @acuerdos_de_produccion = ManifestacionDeInteres.where(id: flujo)
    else
      instrumento_id = nil
      @acuerdos_de_produccion = ManifestacionDeInteres.all
    end
  end


  def cambio_nombre_apl
    flujo = Flujo.find(params[:manifestacion_de_interes][:estado_proyecto].to_i)
    @manifestacion_de_interes = flujo.manifestacion_de_interes
    respond_to do |format|
      @manifestacion_de_interes.nombre_acuerdo = params[:manifestacion_de_interes][:nombre_acuerdo]
      if @manifestacion_de_interes.save(validate: false)
        format.js { flash.now[:success] = 'Nombre APL cambiado correctamente' }
        format.html { redirect_to root_path, flash: {notice: 'Nombre APL cambiado correctamente' } }
      end
    end
  end

  def listado_actores_temporal
    @listado_actores_temporal = ListadoActoresTemporal.where(manifestacion_de_interes_id: @tarea_pendiente.flujo.manifestacion_de_interes_id, estado: 0).order(id: :asc).all
    respond_to do |format|
      format.js { render 'actores/listado_actores_temporal', locals: { manifestacion_de_interes_id: @tarea_pendiente.flujo.manifestacion_de_interes_id } }
    end
  end

  private

    def set_tarea_pendiente
      @tarea_pendiente = TareaPendiente.includes([:flujo]).find(params[:tarea_pendiente_id])
      @tarea = @tarea_pendiente.tarea

      autorizado? @tarea_pendiente if @tarea.codigo != Tarea::COD_APL_019
    end
    #DZC define el flujo y tipo_instrumento, junto con la manifestación o el proyecto según corresponda, para efecto de completar datos. El id de la manifestación se obtiene del flujo correspondiente a la tarea pendiente.
    def set_flujo
      @flujo = @tarea_pendiente.flujo
      @tipo_instrumento=@flujo.tipo_instrumento
    end

    def set_manifestacion_de_interes
      @solo_lectura = @tarea_pendiente.present? ? @tarea_pendiente.solo_lectura(current_user, @tarea_pendiente) : nil
      # @manifestacion_de_interes = ManifestacionDeInteres.find(params[:id])
      @manifestacion_de_interes = ManifestacionDeInteres.find(@flujo.manifestacion_de_interes_id)
      # DZC 2019-07-11 17:41:43 se agrega para generalizar las validaciones y tamaños de texto
      @manifestacion_de_interes.tarea_id = @tarea.id if @tarea.present?

      # DZC 2019-07-17 16:24:33 se obtienen las validaciones para campos de texto, tooltips y ayudas desde la tabla
      @validaciones = @manifestacion_de_interes.get_campos_validaciones

      
      # DZC 2019-08-09 se comenta por que ya no es necesario
      #@textos = @manifestacion_de_interes.get_campos_textos



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

    def set_archivo_mapa_actores
      @manifestacion_de_interes.update(tarea_codigo: Tarea::COD_APL_001)
      if @tarea_pendiente.estado_tarea_pendiente_id == EstadoTareaPendiente::NO_INICIADA
        MapaDeActor.find_or_create_by(
            flujo_id: @flujo.id,
            persona_id: current_user.personas.first.id,
            rol_id: Rol::PROPONENTE
        )
      end
    end

    def set_contribuyentes
      # DZC 2018-10-10 16:42:42 se agrega contribuyente del proponente
      @contribuyente = Contribuyente.new
      personas_proponentes = current_user.personas & Responsable.responsables_solo_rol_fast(Rol::PROPONENTE)

      # DZC 2018-11-19 10:27:27 se modifica para que no hayan contribuyentes precargados
      # DZC 2019-06-17 18:07:31 se modifica para cargar el contribuyente escogido
      if @tarea.codigo == Tarea::COD_APL_001
        @contribuyentes_del_proponente = Contribuyente.where(id: personas_proponentes.pluck(:contribuyente_id))
      else
        @contribuyentes_del_proponente = [@manifestacion_de_interes.proponente_institucion]
      end

      #DZC 2018-10-10 16:44:00 TODO: revisar impacto y eliminar si corresponde
    	@contribuyentes = Contribuyente.where(id: @personas.map{|m|m[:contribuyente_id]}).all
    end

    def set_contribuyentes_actor
      @contribuyente_actor = Contribuyente.new
    end

    def set_tipo_instrumentos
      tiid = TipoInstrumento::ACUERDO_DE_PRODUCCION_LIMPIA
      # DZC 2018-11-16 15:30:03 se modifica para excluir el tipo de acuerdo padre de la selección
      @tipo_instrumentos = TipoInstrumento.where("tipo_instrumento_id = (?)",tiid).all
      # @tipo_instrumentos = TipoInstrumento.where("tipo_instrumento_id = (?) OR id = (?)",tiid,tiid).all

    end

    def set_mapa_actores
      @mapa_actor = ListadoActoresTemporal.new
    end

    def set_listado_actores_temporal
      @listado_actores_temporal = ListadoActoresTemporal.where(manifestacion_de_interes_id: @tarea_pendiente.flujo.manifestacion_de_interes_id, estado: 0).order(id: :asc).all
    end

    def set_usuario_actor
      @usuario_actor = User.new
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
        :tipo_linea_seleccionada,
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

    def send_message(tarea, user)
      u = User.find(user)
      mensajes = FondoProduccionLimpiaMensaje.where(tarea_id: tarea.id)
      mensajes.each do |mensaje|
        FondoProduccionLimpiaMailer.paso_de_tarea(mensaje.asunto, mensaje.body, u).deliver_now
      end
    end

    def insertar_mapa_de_actores
      @postulante = MapaDeActor.includes(persona: :user).find_by(flujo_id: @tarea_pendiente.flujo_id, rol_id: Rol::PROPONENTE)
 
      if @manifestacion_de_interes.contribuyente_id.present? && @postulante.persona_id.present?
        @persona_cargos = PersonaCargo.includes(:cargo).where(persona_id: @postulante.persona_id).first
        @cargo = @persona_cargos.cargo

        #Agrega a postulante a mapa de actores
        @listado_actores_temporal =ListadoActoresTemporal.new
        @listado_actores_temporal.rol_en_acuerdo_id = @postulante&.rol.id
        @listado_actores_temporal.cargo_institucion_id = @cargo.id
        @listado_actores_temporal.contribuyente_id = @contribuyente_editado.contribuyente_id
        @listado_actores_temporal.tipo_institucion_id = @contribuyente_editado.dato_anual_contribuyentes.first&.tipo_contribuyente_id
        @listado_actores_temporal.rol_en_acuerdo = @postulante&.rol.nombre
        @listado_actores_temporal.nombre_actor = @postulante&.persona&.user.nombre_completo
        @listado_actores_temporal.rut_actor = @postulante&.persona&.user.rut
        @listado_actores_temporal.cargo_institucion = @cargo.nombre
        @listado_actores_temporal.email_institucional = @postulante&.persona&.user&.session&.dig(:personas, 0, :email_institucional)
        @listado_actores_temporal.telefono_institucional = @postulante&.persona&.user&.session&.dig(:personas, 0, :telefono_institucional) 
        @listado_actores_temporal.razon_social_institucion = @contribuyente_editado.razon_social
        @listado_actores_temporal.rut_institucion = "#{@contribuyente_editado.rut}-#{@contribuyente_editado.dv}"
        @listado_actores_temporal.tipo_institucion =  @contribuyente_editado.dato_anual_contribuyentes.first.tipo_contribuyente.nombre
        @listado_actores_temporal.comuna_institucion = @contribuyente_editado.establecimiento_contribuyentes.first.comuna.nombre
        @listado_actores_temporal.direccion = @contribuyente_editado.establecimiento_contribuyentes.first.direccion
        @listado_actores_temporal.estado = 0
        @listado_actores_temporal.manifestacion_de_interes_id = @flujo.manifestacion_de_interes.id
        @listado_actores_temporal.save

        datos = MapaDeActor.construye_data_para_apl_desde_listado(@flujo.manifestacion_de_interes.id)
        datos = datos.flatten

        datos.map! do |hash|
          hash.each do |key, value|
            if value.is_a?(String)
              # Reemplaza todos los caracteres de salto de línea o retorno de carro con espacio
              # También colapsa múltiples espacios a uno solo (opcional)
              hash[key] = value.gsub(/[\r\n]+/, ' ').squeeze(' ').strip
            end
          end
          hash
        end

        @manifestacion_de_interes.mapa_de_actores_data = datos 
        @manifestacion_de_interes.save

        ListadoActoresTemporal.actualiza_estado_listado_mapa_actores(@flujo.manifestacion_de_interes.id)  
      end
    end
end
