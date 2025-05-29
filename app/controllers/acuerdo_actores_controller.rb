class AcuerdoActoresController < ApplicationController
  before_action :authenticate_user!
  skip_before_action :verify_authenticity_token, only: [:mostrar_informe, :reload_informe]
  before_action :set_tarea_pendiente, except: [:eliminar_actor]
  before_action :set_flujo, except: [:eliminar_actor]
  before_action :set_manifestacion_de_interes, except: [:eliminar_actor]
  before_action :set_obtiene_mapa_actual_y_actores, except: [:eliminar_actor]
  before_action :set_mapa_actores, except: [:eliminar_actor]
  before_action :set_contribuyentes, except: [:eliminar_actor, :crear_actor]
  before_action :set_usuario_actor, except: [:eliminar_actor]
  before_action :set_listado_actores_temporal, except: [:eliminar_actor]

  def index
  end

  def reload_informe
    @auditorias = Auditoria.where(flujo_id: @flujo.id).all
    @datos = @informe._a_datos(@auditorias)

    @set_metas_acciones = SetMetasAccion.de_la_manifestacion_de_interes_(@manifestacion_de_interes.id)
    @estandares_certificacion = []
    estandares_certificacion_ids = []
    @set_metas_acciones.each do |sma|
      if !sma.modelo_referencia.blank?
        if sma.modelo_referencia == "EstandarSetMetasAccion"
          estandar_cert = EstandarSetMetasAccion.find(sma.id_referencia).estandar_homologacion
          if !estandares_certificacion_ids.include?(estandar_cert.id)
            @estandares_certificacion << estandar_cert
            estandares_certificacion_ids << estandar_cert.id
          end
        end
      end
    end

    respond_to do |format|
      format.js
    end
  end

  def mostrar_informe
    @datos = params[:informe]
    # DZC 2019-06-21 17:53:28 se modifica para evitar error por ejecución de método sobre objeto nulo
    # @datos["auditorias"] = @datos["auditorias"].values
    @datos["auditorias"] = @datos["auditorias"].values rescue []
    respond_to do |format|
      format.html{ render partial: 'informe'}
      format.js{ render partial: 'informe'}
    end
  end

  def guardar_informe #DZC APL-018
    # DZC 2018-11-12 18:36:00 se modifica para eliminar archivos seleccionados para su eliminación
    archivos_por_eliminar = params[:por_eliminar]
    archivos_previos =[]
    archivos_nuevos =[]
    @informe.archivos_anexos.each do |archivo|
      
      unless (params[:por_eliminar].present? && params[:por_eliminar].include?(archivo.file.filename))
        archivos_previos << Pathname.new(archivo.path).open
      end
    end
    if !informe_params[:archivos_anexos].blank?
      informe_params[:archivos_anexos].each do |archivo|
        
        unless  (params[:por_eliminar].present? && params[:por_eliminar].include?(archivo.original_filename))
          archivos_nuevos <<  archivo
        end
      end
    end
    @informe.assign_attributes(informe_params)
    # DZC 2019-06-19 17:39:50 se modifica para corregir error en asignación de archivos
    # @informe.assign_attributes(archivos_anexos: archivos_previos+archivos_nuevos)
    @informe.archivos_anexos = archivos_previos+archivos_nuevos
    @informe.tarea_codigo = Tarea::COD_APL_018 # DZC 2018-11-08 14:02:58 se agrega para evitar validación de existencia de archivos_anexos_posteriores_firmas en el modelo
    # DZC 2018-11-12 11:36:06 elimina los archivos seleccionados para eliminacion

    @informe.auditorias = params[:informe_acuerdo][:auditorias].values rescue []
    # @informe.auditorias = [] if @informe.auditorias.nil?

    # DZC 2019-06-19 14:58:54 corrige error en
    # if @informe.auditorias.present? 
    #   @informe.auditorias.map!{|a| a if (a[:nombre].present? && a[:plazo].present?)}
    #   @informe.auditorias = @informe.auditorias.compact
    # else
    #   @informe.auditorias = []
    # end

    @set_metas_acciones = SetMetasAccion.de_la_manifestacion_de_interes_(@manifestacion_de_interes.id)
    @estandares_certificacion = []
    estandares_certificacion_ids = []
    @set_metas_acciones.each do |sma|
      if !sma.modelo_referencia.blank?
        if sma.modelo_referencia == "EstandarSetMetasAccion"
          estandar_cert = EstandarSetMetasAccion.find(sma.id_referencia).estandar_homologacion
          if !estandares_certificacion_ids.include?(estandar_cert.id)
            @estandares_certificacion << estandar_cert
            estandares_certificacion_ids << estandar_cert.id
          end
        end
      end
    end
    respond_to do |format|
      if @informe.valid?
        @informe.save
        audits_ids = []
        Auditoria.where(flujo_id: @flujo.id).where.not(id: @informe.auditorias.map{|a| a[:id]}).delete_all #DZC busca y elimina los audits existentes y relacionados con esta instancia de informe, y que el usuario decidio no mantener
        @informe.auditorias.each do |aud_data|
          
          audits_ids << aud_data[:id] if aud_data[:id] != "no"
          
          aud = (aud_data[:id] == "no") ? Auditoria.new : Auditoria.find(aud_data[:id])
          aud.assign_attributes({
            flujo_id: @flujo.id,
            nombre: aud_data[:nombre],
            plazo_apertura: aud_data[:plazo_apertura],
            plazo_cierre: aud_data[:plazo_cierre],
            con_certificacion: aud_data[:con_certificacion],
            con_validacion: aud_data[:con_validacion],
            final: aud_data[:final],
            con_mantencion: aud_data[:con_mantencion],
            plazo: aud_data[:plazo] #viene de modal vigencia certificacion
          })
          audits_ids << aud.id if aud.save

          #relacionar niveles
          #si no esta en la lista es porque fue eliminado
          if aud.con_certificacion && !aud.final
            niveles = aud_data[:auditoria_niveles].nil? ? [] : aud_data[:auditoria_niveles].keys
            AuditoriaNivel.where(auditoria_id: aud.id).where.not(estandar_nivel_id: niveles).delete_all

            if !aud_data[:auditoria_niveles].nil?
              aud_data[:auditoria_niveles].values.each do |nivel|
                niv = AuditoriaNivel.find_or_initialize_by({
                  auditoria_id: aud.id,
                  estandar_nivel_id: nivel[:id]
                })
                niv.plazo = nivel[:plazo]
                niv.save
              end
            end
          end

        end

        # Auditoria.where("id NOT IN (?)", audits_ids).delete_all
        
        @auditorias = Auditoria.where(flujo_id: @flujo.id).all
        @datos = @informe._a_datos(@auditorias)

        #DZC las condiciones de término se encuentra programdas fuera de este controlador
        format.js{ 
          flash[:success] = "Informe guardado correctamente"
        }
      else
        
        @auditorias = @informe.auditorias
        @datos = @informe._a_datos(@auditorias)
        format.js{ 
          flash[:error] = "Se han detectado los siguientes errores:\n #{@informe.errors.full_messages.to_sentence}"
        }
      end
    end
  end

  def crear_actor
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

  def eliminar_actor
    actor = ListadoActoresTemporal.find(params[:actor_id])
    if actor.destroy
      @listado_actores_temporal = ListadoActoresTemporal.where(manifestacion_de_interes_id: @tarea_pendiente.flujo.manifestacion_de_interes_id, estado: 0)
      respond_to do |format|
        format.js { render 'actores/eliminar_actor', locals: { actor: actor.id } }
      end
    else
      flash[:error] = 'Hubo un problema al eliminar al actor.'
    end
  end
  
  private

  def set_tarea_pendiente
    @tarea_pendiente = TareaPendiente.find(params[:tarea_pendiente_id])
    autorizado? @tarea_pendiente
    @descargables = @tarea_pendiente.get_descargables
  end

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


  #DZC define el flujo y tipo_instrumento, junto con la manifestación o el proyecto según corresponda, para efecto de completar datos. El id de la manifestación se obtiene del flujo correspondiente a la tarea pendiente.
  def set_flujo
    @flujo = @tarea_pendiente.flujo
    @tarea = @tarea_pendiente.tarea
    @tipo_instrumento=@flujo.tipo_instrumento
    @manifestacion_de_interes = @flujo.manifestacion_de_interes_id.blank? ? nil : ManifestacionDeInteres.find(@flujo.manifestacion_de_interes_id)
    @manifestacion_de_interes.update(tarea_codigo: @tarea.codigo) unless @manifestacion_de_interes.blank?
    @proyecto = @flujo.proyecto_id.blank? ? nil : Proyecto.find(@flujo.proyecto_id)
    @ppp = @flujo.programa_proyecto_propuesta_id.blank? ? nil : ProgramaProyectoPropuesta.find(@flujo.programa_proyecto_propuesta_id)
  end

  def set_manifestacion_de_interes
    # @manifestacion_de_interes = ManifestacionDeInteres.find(params[:id])
    @informe = @manifestacion_de_interes.informe_acuerdo.nil? ? @manifestacion_de_interes.build_informe_acuerdo : @manifestacion_de_interes.informe_acuerdo
    #@informe = @manifestacion_de_interes.build_informe_acuerdo if @infome.nil?
    if @informe.nil?
      @informe = InformeAcuerdo.new({manifestacion_de_interes_id: @manifestacion_de_interes.id})
      @informe.save(validate: false)
    end
    @manifestacion_de_interes.temporal = true
    @manifestacion_de_interes.mapa_de_actores_correctamente_construido = true
    @manifestacion_de_interes.accion_en_mapa_de_actores = :revision
    @manifestacion_de_interes.accion_en_set_metas_accion = :actualizacion
    @set_metas_acciones = SetMetasAccion.de_la_manifestacion_de_interes_(@manifestacion_de_interes.id)
    @set_metas_accion = SetMetasAccion.new
    if params[:tab_metas].present? # DZC 2018-11-05 09:50:57 permite focalizar la vista en la pestaña set metas y acciones
      @tab_metas = params[:tab_metas]
    end    
    unless @manifestacion_de_interes.comentarios_y_observaciones_set_metas_acciones.blank?
      comentarios = @manifestacion_de_interes.comentarios_y_observaciones_set_metas_acciones.last
      @propuestas_con_observaciones = comentarios[:requiere_correcciones]
    end
    unless @manifestacion_de_interes.comentarios_y_observaciones_actualizacion_mapa_de_actores.blank?
      comentarios = @manifestacion_de_interes.comentarios_y_observaciones_actualizacion_mapa_de_actores.last
      @actores_con_observaciones = comentarios[:actores_con_observaciones]
    end
    @actores_mapa = MapaDeActor.where(flujo_id: @tarea_pendiente.flujo_id, rol_id: Rol::FIRMANTE).includes([:rol, persona: [:user,:contribuyente, persona_cargos: [:cargo]]]).all
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


  #DZC leo las tablas y campo de la manifestación
  def set_obtiene_mapa_actual_y_actores
    #DZC convierto el hash con string keys a hash_with_indiferent_access, y de vuelta a hash con key simbólicas, o nil, según corresponda
    @actores_desde_campo = @manifestacion_de_interes.mapa_de_actores_data.blank? ? nil : @manifestacion_de_interes.mapa_de_actores_data.map{|i| i.transform_keys!(&:to_sym).to_h}
    @actores_desde_tablas = MapaDeActor.construye_data_para_apl(@flujo)
    if @tarea_pendiente.data == {primera_ejecucion: true}
      @actores = MapaDeActor.adecua_actores_para_vista(@actores_desde_tablas)
    else
      @actores = (@actores_desde_campo.blank? ? MapaDeActor.adecua_actores_para_vista(@actores_desde_tablas) : MapaDeActor.adecua_actores_para_vista(@actores_desde_campo))
    end
    @actores = MapaDeActor.adecua_actores_unidos_rut_persona_institucion(@actores)

  end

  def set_listado_actores_temporal
    @listado_actores_temporal = ListadoActoresTemporal.where(manifestacion_de_interes_id: @tarea_pendiente.flujo.manifestacion_de_interes_id, estado: 0).order(id: :asc).all
  end

  def actualizar_mapa_de_actores_manifestacion_de_interes_params
    params.require(:manifestacion_de_interes).permit(
      :mapa_de_actores_archivo,
      :mapa_de_actores_archivo_cache
    )
  end

  def informe_params
    params.require(:informe_acuerdo).permit(
      :fundamentos,:antecedentes, :normativas_aplicables, :alcance, :campo_de_aplicacion, :definiciones, 
      :objetivo_general, :objetivo_especifico, :mecanismo_de_implementacion, :tipo_acuerdo, :plazo_maximo_adhesion, 
      :plazo_finalizacion_implementacion, :mecanismo_evaluacion_cumplimiento, :plazo_maximo, :plazo_maximo_neto, :adhesiones,
      :vigencia_acuerdo, :plazo_vigencia_acuerdo,
      :vigencia_certificacion, :vigencia_certificacion_final,
      :derechos, :obligaciones, :difusion, :promocion, :incentivos, :sanciones, :personerias, :ejemplares, :firmas,
      :archivos_anexos_cache, archivos_anexos: []
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
