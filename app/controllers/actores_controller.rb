class ActoresController < ApplicationController
  before_action :authenticate_user!
  before_action :set_tarea_pendiente
  before_action :set_flujo
  before_action :set_obtiene_mapa_actual_y_actores
  before_action :set_mapa_de_actores_data, only: [:actualizacion,:actualizar,:revision,:enviar_revision]
  before_action :set_crea_archivo, only: [:actualizacion,:actualizar,:descargar] #agregar demás métodos si es necesario
  before_action :set_mapa_actores
  before_action :set_listado_actores_temporal
  before_action :set_contribuyentes
  before_action :set_usuario_actor

  # DZC 2018-10-04 16:16:04 se agrega creación de archivo a efecto de que las tareas sin revisión se pueda descargar el archivo directamente construido desde las tablas
  # before_action :set_crea_archivo, if: -> {action_name.to_sym == :actualizacion || action_name.to_sym == :actualizar || action_name.to_sym == :descargar || (action_name.to_sym == :revision && !@tarea.requiere_revision?)}

  def actualizacion #DZC APL-009, APL-013
    # sobrescribimos la lista de actores, agrupando roles que tenga mismo rut persona e institucion
    @actores = MapaDeActor.adecua_actores_unidos_rut_persona_institucion(@actores)
    @descargables = @tarea_pendiente.get_descargables
  end

  def actualizar #DZC APL-009, APL-013
    @descargables = @tarea_pendiente.get_descargables
    mapa_antiguo =  @actores_desde_tablas #DZC se reemplaza con lectura de los actores desde tablas
    #DZC se obtiene desde archivo confeccionado al acceder a la vista

    #Si es distinto de lsita ejecutala asignacion de documentos
    if params[:from] != 'lista'
      @manifestacion_de_interes.assign_attributes(actualizar_mapa_de_actores_manifestacion_de_interes_params)
    end

    warning = nil
    success = nil
    @manifestacion_de_interes.temporal = true #DZC sirve para evitar las validaciones. En este caso es necesario que sea true para que se valide
    # @manifestacion_de_interes.tarea_codigo = @tarea.codigo

    #valida si viene de listado de mapa de actores
    @manifestacion_de_interes.listado_mapa_actores = false
    if params[:from] == 'lista'
      @manifestacion_de_interes.listado_mapa_actores = true
    end

    @manifestacion_de_interes.revisar_y_actualizar_mapa_de_actores = true
    if @manifestacion_de_interes.save #DZC Gino usó esta línea para validar el guardar los archivos correspondientes
      # DZC ingresar lectura de archivo excel serializado de manifestación, aplicando validaciones
      @actores = @manifestacion_de_interes.mapa_de_actores_data
      if mapa_antiguo == @actores
        warning = "Mapa de actores subido es idéntico al subido anteriormente"
      else
        success = "Mapa de actores correctamente actualizado"
      end
      @tarea_pendiente.update(data: {primera_ejecucion: false})
      continua_flujo_segun_tipo_tarea
    end
  
    if params[:from] == 'lista'
      if @tarea.codigo != Tarea::COD_APL_013 && @tarea.codigo != Tarea::COD_APL_037 
        @manifestacion_de_interes.data_mapa_de_actores
        @actores = @manifestacion_de_interes.mapa_de_actores_data
      else
        @actores = @actores_desde_campo
      end
    end

    @actores = MapaDeActor.adecua_actores_unidos_rut_persona_institucion(@actores)
    respond_to do |format|
      #format.html { redirect_to current_path, notice: success }
      format.js { 
        flash[:success] = success if success.present?
        
        flash[:error] = @manifestacion_de_interes.errors.messages if @manifestacion_de_interes.errors.messages.present?
        flash[:warning] = warning if warning.present?

        if params[:from] == 'lista' && success.present? && @tarea.codigo != Tarea::COD_APL_009 && @tarea.codigo != Tarea::COD_APL_013
          ListadoActoresTemporal.actualiza_estado_listado_mapa_actores(@tarea_pendiente.flujo.manifestacion_de_interes_id)        
        end 
        # DZC 2018-10-10 16:07:32 redirecciona a bandeja de entrada si no hay errores y se trata de APL-009
        render js: "window.location='#{root_path}'" if ([Tarea::COD_APL_009].include?(@tarea.codigo) && @manifestacion_de_interes.errors.messages.size == 0)
      }
    end
  end

  def revision #DZC APL-010, APL-014
    # @manifestacion_de_interes.comentarios_y_observaciones_actualizacion_mapa_de_actores = nil
    @actores = MapaDeActor.adecua_actores_unidos_rut_persona_institucion(@actores)
  end

  def enviar_revision #DZC APL-010, APL-014, APL-018 en pestaña
    # DZC 2018-10-04 12:33:50 se modifica el método contemplando tareas que no requieren revisión 
    
    warning = nil
    success = nil
    error = nil
    @manifestacion_de_interes.temporal = true
    if @tarea.requiere_revision?    
      parameters = enviar_revision_mapa_de_actores_manifestacion_de_interes_params()
      # @actores_con_observaciones = parameters[:actores_con_observaciones].blank? ? [] : JSON.parse(parameters[:actores_con_observaciones])
      @actores_con_observaciones = parameters[:actores_con_observaciones].blank? ? nil : JSON.parse(parameters[:actores_con_observaciones])
      @manifestacion_de_interes.mapa_de_actores_correctamente_construido = parameters[:mapa_de_actores_correctamente_construido]
      @manifestacion_de_interes.actores_con_observaciones = @actores_con_observaciones
      # (1) Se asume que la primera vez, no habrá comentarios de este tipo, si los hay guardamos los comentarios anteriores
      # y dejamos la variable con el valor que viene del formulario (sólo string)
      @comentarios_mapa_de_actores = @manifestacion_de_interes.comentarios_y_observaciones_actualizacion_mapa_de_actores.blank? ? [] : @manifestacion_de_interes.comentarios_y_observaciones_actualizacion_mapa_de_actores
      # @manifestacion_de_interes.comentarios_y_observaciones_actualizacion_mapa_de_actores = parameters[:comentarios_y_observaciones_actualizacion_mapa_de_actores]
      texto_observaciones = parameters[:comentarios_y_observaciones_actualizacion_mapa_de_actores]
      
      # (2) creamos un comentario de tipo array, para agregar más información, solo en caso de que existan comentarios
      #DZC 2018-10-02 se corrige error en ingreso de comentarios en blanco
      #if texto_observaciones.present? 
      @comentarios_mapa_de_actores << {
        datetime: DateTime.now,
        user: current_user.nombre_completo,
        actores_con_observaciones: @actores_con_observaciones,
        texto: texto_observaciones
      }
      #end
      # DZC 2018-10-09 19:59:32 Se corrigió un error por el cual si no existían comentarios anteriores los actuales se consideraban en blanco
      # (3) antes de guardar, volvemos a dejar la variable como un array
      @manifestacion_de_interes.comentarios_y_observaciones_actualizacion_mapa_de_actores = @comentarios_mapa_de_actores
      if @manifestacion_de_interes.valid?
        @manifestacion_de_interes.remove_mapa_de_actores_archivo!
        @manifestacion_de_interes.save
        success = "Revisión enviada correctamente"
        continua_flujo_segun_tipo_tarea
      else
        error = @manifestacion_de_interes.errors.messages.first.last
      end

      @comentarios_mapa_de_actores = @manifestacion_de_interes.comentarios_mapa_de_actores_ordenados
    else
      #Si es distinto de lsita ejecutala asignacion de documentos
      if params[:from] != 'lista'
        @manifestacion_de_interes.assign_attributes(enviar_revision_completo_mapa_de_actores_manifestacion_de_interes_params)  
      end 

      @manifestacion_de_interes.tarea_codigo=@tarea.codigo

      #valida si viene de listado de mapa de actores
      @manifestacion_de_interes.listado_mapa_actores = false
      if params[:from] == 'lista'
        @manifestacion_de_interes.listado_mapa_actores = true
      end
      @manifestacion_de_interes.revisar_y_actualizar_mapa_de_actores = true

      if @manifestacion_de_interes.valid?
        @manifestacion_de_interes.save
        success = "Mapa de actores correctamente actualizado"
        continua_flujo_segun_tipo_tarea
      else
        #@manifestacion_de_interes.mapa_de_actores_archivo = actualizar_mapa_de_actores_manifestacion_de_interes_params[:mapa_de_actores_archivo]
        #@manifestacion_de_interes.mapa_de_actores_archivo_cache = actualizar_mapa_de_actores_manifestacion_de_interes_params[:mapa_de_actores_archivo_cache]
        if params[:from] != 'lista'
          error = "Errores en el archivo:\n#{@manifestacion_de_interes.errors[:mapa_de_actores_archivo].to_sentence}"
          error = error.gsub(',',';')
          error = error.gsub('.',',')
          error = error.gsub(';','.')
        else
          error = "Atención:\n#{@manifestacion_de_interes.errors[:mapa_de_actores_archivo].to_sentence}"
          error = error.gsub(',',';')
          error = error.gsub('.',',')
          error = error.gsub(';','.')
        end
      end
    end
    # (4) finalmente dejamos la variable en nulo para no mostrarla en el formulario
    # @manifestacion_de_interes.comentarios_y_observaciones_actualizacion_mapa_de_actores = nil   
    respond_to do |format|
      #format.html { redirect_to current_path, notice: success }
      format.js { 
        flash[:success] = success if success.present?
        flash.now[:error] = error if error.present?
        flash[:warning] = warning if warning.present?
        @manifestacion_de_interes.comentarios_y_observaciones_actualizacion_mapa_de_actores = nil
        
        set_obtiene_mapa_actual_y_actores #DZC 2018-10-29 15:41:55 se agregan valores actuales de variable @actores
        @actores = MapaDeActor.adecua_actores_unidos_rut_persona_institucion(@actores)
        if params[:from] == 'lista' && success.present? && @tarea.codigo != Tarea::COD_APL_009 && @tarea.codigo != Tarea::COD_APL_013
          ListadoActoresTemporal.actualiza_estado_listado_mapa_actores(@tarea_pendiente.flujo.manifestacion_de_interes_id)        
        end 
        # DZC 2018-10-10 16:07:32 redirecciona a bandeja de entrada si no hay errores y se trata de APL-010
        render js: "window.location='#{root_path}'" if ([Tarea::COD_APL_010].include?(@tarea.codigo) && @manifestacion_de_interes.errors.messages.size == 0)
      }
    end
  end

  def continua_flujo_segun_tipo_tarea #DZC generalización de condiciones de continuación de flujo
    case @tarea.codigo
    when Tarea::COD_APL_009 #DZC Actualiza con posible revisión
      @tarea_pendiente.pasar_a_siguiente_tarea 'A'
      # tarea_pendiente.pasar_a_siguiente_tarea 'A', {tarea_pendiente_id: tarea_pendiente.id}, false
    when Tarea::COD_APL_010
      
      if @manifestacion_de_interes.mapa_de_actores_correctamente_construido =="true"    
        MapaDeActor.actualiza_tablas_mapa_actores(@actores_desde_campo, @flujo, @tarea_pendiente)
        @manifestacion_de_interes.mapa_de_actores_data = nil
        @manifestacion_de_interes.comentarios_y_observaciones_actualizacion_mapa_de_actores = nil
        @manifestacion_de_interes.save(validate: false)
        #DZC 2018-10-02 Se programa la revisión de la adherencia a un diagnóstico y/o estandar
        diagnostico = @manifestacion_de_interes.diagnostico_id.blank? ? nil : @manifestacion_de_interes.diagnostico_id
        estandar = @manifestacion_de_interes.estandar_de_certificacion_id.blank? ? nil : @manifestacion_de_interes.estandar_de_certificacion_id
        # diagnostico = nil
        # estandar = nil
        # @manifestacion_de_interes.mapa_de_actores_data
        if (diagnostico.nil? && estandar.nil?)
          @tarea_pendiente.pasar_a_siguiente_tarea 'A', {primera_ejecucion: true}
        else 
          @tarea_pendiente.pasar_a_siguiente_tarea 'C', {primera_ejecucion: true}
        end
      else
        @tarea_pendiente.pasar_a_siguiente_tarea 'B'
      end
      #cambia de estado actores del listado del mapa de actores
      if params[:manifestacion_de_interes][:mapa_de_actores_correctamente_construido] == 'true'
        ListadoActoresTemporal.actualiza_estado_listado_mapa_actores(@tarea_pendiente.flujo.manifestacion_de_interes_id)        
      end
    when Tarea::COD_APL_013 #DZC Actualiza con posible revisión
      @tarea_pendiente.update(data: {}) if @tarea_pendiente.primera_ejecucion
      @tarea_pendiente.pasar_a_siguiente_tarea 'A',{},false #DZC 2018-10-05 11:42:42 se elimina el mantener la tarea pendiente como no terminada
    when Tarea::COD_APL_014 #DZC Revisor envia la vista
      # DZC 2018-10-29 12:08:47 se corrige error que evitaba que se instaciara la tarea pendiente al responsable de APL-013 si no se aprobaba el mapa de actores y no se observaba ningún actor.
      if !@actores_con_observaciones.blank? ||  (@manifestacion_de_interes.mapa_de_actores_correctamente_construido == "false") #DZC No termina pero envia correos, dada la estructura multipestañas (y tareas) asociadas a esta tarea específica
        @tarea_pendiente.pasar_a_siguiente_tarea 'B',{},false
      else
        if @manifestacion_de_interes.mapa_de_actores_data.present?
          MapaDeActor.actualiza_tablas_mapa_actores(@actores_desde_campo, @flujo, @tarea_pendiente)
          @manifestacion_de_interes.mapa_de_actores_data = nil
          @manifestacion_de_interes.save(validate: false)
        end
        #se actualiza mapa de actores con informacion obtenida de el listado de mapa de actores
        @actores_desde_lista = MapaDeActor.construye_data_para_apl_desde_listado(@manifestacion_de_interes.id)
        if @actores_desde_campo != nil
          @actores_desde_campo.concat(@actores_desde_lista)
          MapaDeActor.actualiza_tablas_mapa_actores(@actores_desde_campo, @flujo, @tarea_pendiente)
        end
        #DZC el término de la tarea depende del ḿetodo termina_etapa_diagnostico en el controlador manifestacion_de_interes_controller
      end
      #cambia de estado actores del listado del mapa de actores
      if params[:manifestacion_de_interes][:mapa_de_actores_correctamente_construido] == 'true'
        ListadoActoresTemporal.actualiza_estado_listado_mapa_actores(@tarea_pendiente.flujo.manifestacion_de_interes_id)        
      end
    when Tarea::COD_APL_018, Tarea::COD_APL_020, Tarea::COD_APL_021, Tarea::COD_APL_023
      # DZC 2018-11-02 13:14:12 se corrige error en actualización de variable @actores_desde_campo
      @tarea_pendiente.update(data: {primera_ejecucion: false})
      set_obtiene_mapa_actual_y_actores
      @lista_actores = @actores_desde_campo.nil? ? @actores_desde_tablas : @actores_desde_campo
      MapaDeActor.actualiza_tablas_mapa_actores(@lista_actores, @flujo, @tarea_pendiente)
      @manifestacion_de_interes.mapa_de_actores_data = nil
      @manifestacion_de_interes.temporal = true
      @manifestacion_de_interes.save(validate: false)
      #DZC el término de la tarea depdende de otros controladores
    end
  end

  def descargar
    send_data File.open(@ruta).read, type: 'application/xslx', charset: "iso-8859-1", filename: "mapa_de_actores_base.xlsx"
  end

  def descargar_revisor
    ruta= "#{Rails.root}/public"
    ruta += @manifestacion_de_interes.mapa_de_actores_archivo.to_s
    send_data File.open(ruta).read, type: 'application/xslx', charset: "iso-8859-1", filename: @manifestacion_de_interes.mapa_de_actores_archivo.file.path.split("/").last.to_s
  end

  def actualizacion_actor
    datos = sanitize_rut(listado_actores_temporal_params.to_h)
    @mapa_actor.assign_attributes(datos)
    @mapa_actor.estado = 0
    @mapa_actor.manifestacion_de_interes_id = @flujo.manifestacion_de_interes.id
    @mapa_actor.save

    listado_actores_temporal
  end

  def listado_actores_temporal
    @listado_actores_temporal = ListadoActoresTemporal.where(manifestacion_de_interes_id: @tarea_pendiente.flujo.manifestacion_de_interes_id, estado: 0).order(id: :asc).all
    respond_to do |format|
      format.js { render 'actores/listado_actores_temporal', locals: { manifestacion_de_interes_id: @tarea_pendiente.flujo.manifestacion_de_interes_id } }
    end
  end

  private
  def set_mapa_actores
    @mapa_actor =ListadoActoresTemporal.new
  end

  def set_contribuyentes
    @contribuyente = Contribuyente.new
    @contribuyentes = Contribuyente.where(id: @personas.map{|m|m[:contribuyente_id]}).all
    @contribuyente_actor = Contribuyente.new
  end

  def set_usuario_actor
    @usuario_actor = User.new
  end

  def set_listado_actores_temporal
    @listado_actores_temporal = ListadoActoresTemporal.where(manifestacion_de_interes_id:  @tarea_pendiente.flujo.manifestacion_de_interes_id, estado: 0).order(id: :asc).all
  end

  def set_tarea_pendiente
    @tarea_pendiente = TareaPendiente.find(params[:tarea_pendiente_id])
    
    autorizado? @tarea_pendiente
  end

  #DZC define el flujo y tipo_instrumento, junto con la manifestación o el proyecto según corresponda, para efecto de completar datos. El id de la manifestación se obtiene del flujo correspondiente a la tarea pendiente.
  def set_flujo
    @solo_lectura = @tarea_pendiente.solo_lectura(current_user, @tarea_pendiente)
    @flujo = @tarea_pendiente.flujo
    @tarea = @tarea_pendiente.tarea
    @tipo_instrumento=@flujo.tipo_instrumento
    @manifestacion_de_interes = @flujo.manifestacion_de_interes_id.blank? ? nil : ManifestacionDeInteres.find(@flujo.manifestacion_de_interes_id)
    @manifestacion_de_interes.update(tarea_codigo: @tarea.codigo) unless @manifestacion_de_interes.blank?
    @proyecto = @flujo.proyecto_id.blank? ? nil : Proyecto.find(@flujo.proyecto_id)
    @ppp = @flujo.programa_proyecto_propuesta_id.blank? ? nil : ProgramaProyectoPropuesta.find(@flujo.programa_proyecto_propuesta_id)
  end

  #DZC leo las tablas y campo de la manifestación
  def set_obtiene_mapa_actual_y_actores
    #DZC convierto el hash con string keys a hash_with_indiferent_access, y de vuelta a hash con key simbólicas, o nil, según corresponda
    @actores_desde_campo = @manifestacion_de_interes.mapa_de_actores_data.blank? ? nil : @manifestacion_de_interes.mapa_de_actores_data.map{|i| i.transform_keys!(&:to_sym).to_h}
    @actores_desde_tablas = MapaDeActor.construye_data_para_apl(@flujo)

    if params[:from] == 'lista' || @tarea.codigo == Tarea::COD_APL_010 || @tarea.requiere_revision?
      @actores_desde_lista = MapaDeActor.construye_data_para_apl_desde_listado(@manifestacion_de_interes.id)
      if @actores_desde_tablas != nil
        @actores_desde_tablas.concat(@actores_desde_lista)
        #se igualan los arreglos para la insercion a través de el listado
        @actores_desde_campo = @actores_desde_tablas
      end
    end
    
    if @tarea_pendiente.data == {primera_ejecucion: true} || @tarea.codigo =='APL-001'
      @actores = MapaDeActor.adecua_actores_para_vista(@actores_desde_tablas)
    else
      @actores = (@actores_desde_campo.blank? ? MapaDeActor.adecua_actores_para_vista(@actores_desde_tablas) : MapaDeActor.adecua_actores_para_vista(@actores_desde_campo))
    end
  end

  def set_mapa_de_actores_data
    if action_name.to_sym == :actualizacion ||action_name.to_sym == :actualizar
      accion = :actualizacion
    elsif action_name.to_sym == :revision ||action_name.to_sym == :enviar_revision
      accion = :revision
    end
    @manifestacion_de_interes.accion_en_mapa_de_actores = accion
    @manifestacion_de_interes.mapa_de_actores_correctamente_construido = true
    @manifestacion_de_interes.temporal = true
    unless @manifestacion_de_interes.comentarios_y_observaciones_actualizacion_mapa_de_actores.blank?
      comentarios = @manifestacion_de_interes.comentarios_y_observaciones_actualizacion_mapa_de_actores.last
      @actores_con_observaciones = comentarios[:actores_con_observaciones]
    end
  end

  #DZC se crea archivo excel desde las tablas (primera vez), y luego desde el campo
  def set_crea_archivo
    titulos = MapaDeActor.columnas_excel
    actores = MapaDeActor.adecua_actores_para_vista(@actores_desde_tablas)
    datos = MapaDeActor.construye_datos_actores_para_excel(actores)
    dominios = MapaDeActor.dominios
    @ruta = "#{Rails.root}/public/uploads/manifestacion_de_interes/mapa_de_actores_archivo/#{@manifestacion_de_interes.id}/"
    FileUtils.mkdir_p(@ruta) unless File.exist?(@ruta) #DZC crea las carpetas pertinentes para la ruta
    @ruta += "mapa_de_actores_base.xlsx"
    ExportaExcel.formato(@ruta, titulos, dominios, datos, "Mapa de Actores" )
  end

  def actualizar_mapa_de_actores_manifestacion_de_interes_params
    params.require(:manifestacion_de_interes).permit(
      :mapa_de_actores_archivo,
      :mapa_de_actores_archivo_cache
    )
  end

  def enviar_revision_mapa_de_actores_manifestacion_de_interes_params
    params.require(:manifestacion_de_interes).permit(
      :actores_con_observaciones,
      :mapa_de_actores_correctamente_construido,
      :comentarios_y_observaciones_actualizacion_mapa_de_actores
    )
  end

  def enviar_revision_completo_mapa_de_actores_manifestacion_de_interes_params
    params.require(:manifestacion_de_interes).permit(
      :mapa_de_actores_archivo,
      :mapa_de_actores_archivo_cache,
      :actores_con_observaciones,
      :mapa_de_actores_correctamente_construido,
      :comentarios_y_observaciones_actualizacion_mapa_de_actores
    )
  end

  def listado_actores_temporal_params
    params.require(:listado_actores_temporal).permit(
      :actor_id, :rol_en_acuerdo_id, :cargo_institucion_id, :contribuyente_id, :tipo_institucion_id, :rol_en_acuerdo, 
      :nombre_actor, :rut_actor, :cargo_institucion, :email_institucional, :telefono_institucional, 
      :razon_social_institucion, :rut_institucion, :tipo_institucion, :comuna_institucion, :estado,
      :manifestacion_de_interes, :direccion, :codigo_ciiuv4
    )
  end

  def sanitize_rut(params)
    params["rut_actor"]&.gsub!('.', '')
    params["rut_institucion"]&.gsub!('.', '')
    params
  end
end
