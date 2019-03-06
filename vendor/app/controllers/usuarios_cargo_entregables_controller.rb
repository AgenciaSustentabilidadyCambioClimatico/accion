class UsuariosCargoEntregablesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_tarea_pendiente
  before_action :set_flujo

  def index
    @mapa_actor = MapaDeActor.new
    @contribuyente    = Contribuyente.new
    @contribuyentes  = []
    @instituciones_e = []
    @instituciones_c = []
    # DZC 2018-11-02 17:08:51 se instancian inicialmente las variables para los listados
    usuarios_e = @manifestacion_de_interes.usuarios_para_lista(Rol::RESPONSABLE_ENTREGABLES)
    @usuarios_e = usuarios_e.map{|p| ["#{p.user[:rut]} - #{p.user[:nombre_completo]}",p[:id]]}.sort
    usuarios_c = @manifestacion_de_interes.usuarios_para_lista(Rol::CARGADOR_DATOS_ACUERDO)
    @usuarios_c = usuarios_c.map{|p| ["#{p.user[:rut]} - #{p.user[:nombre_completo]}",p[:id]]}.sort
    
  end

  def update
    @mapa_actor = MapaDeActor.new(mapa_actor_params)
    @correcto = false
    ocurrio_un_error = false
    
    ## aca va el codigo que hace cuando los datos son validos
    unless @mapa_actor.campos_invalidos_asignar_cargo.blank?
      @mapa_actor.valid?
      flash.now[:alert] = 'Ingrese todos los campos obligatorios'
      ocurrio_un_error = true
    else
      # obtengo los actores actuales del mapa de actores, para reemplazarlos por los nuevos

      # DZC 2018-11-02 17:19:23 se modifica el algoritmo para que busque o agregue al actor, sin reemplazar la persona de algúna actor prexistente  
      actor_entregable = MapaDeActor.find_or_initialize_by(flujo_id: @tarea_pendiente.flujo_id,rol_id: Rol::RESPONSABLE_ENTREGABLES, persona_id: entregable_params[:usuario_entregables])
      actor_carga_datos = MapaDeActor.find_or_initialize_by(flujo_id: @tarea_pendiente.flujo_id,rol_id: Rol::CARGADOR_DATOS_ACUERDO, persona_id: carga_datos_params[:usuario_carga_datos])
      # actor_entregable.persona_id = entregable_params[:usuario_entregables]
      # actor_carga_datos.persona_id = carga_datos_params[:usuario_carga_datos]
      
      if (actor_entregable.save && actor_carga_datos.save)


        # DZC 2018-11-06 14:05:45 duplica tareas pendientes de los RESPONSABLE_ENTREGABLES anteriores
        
        @flujo.duplica_pendientes_para_responsable_especifico(actor_entregable.persona.user_id) 
        
        # TODO: el campo observación se debe guardar en alguna parte, porque debe ser usado en otras tareas que no es siempre la siguiente
        observacion = {}
        observacion[Rol::RESPONSABLE_ENTREGABLES] = @mapa_actor.observacion_entregables
        observacion[Rol::CARGADOR_DATOS_ACUERDO] = @mapa_actor.observacion_carga_datos
        @tarea_pendiente.pasar_a_siguiente_tarea(nil,{observacion_tarea_anterior: observacion})
        @correcto = true
        flash[:success] = 'Usuarios actualizados'
      else
        flash.now[:alert] = 'No se pudieron actualizar los usuarios'        
      end
        
    end
    unless @correcto #DZC 2018-11-06 14:22:50 se modifica para el caso de que no se seleccionen contribuyentes
      # hacer esto si es incorrecto, para el form
      @contribuyente    = Contribuyente.new
      @contribuyentes  = []
      unless @mapa_actor.institucion_entregables.blank?
        c_e = Contribuyente.where(id: @mapa_actor.institucion_entregables)
        @instituciones_e = Contribuyente.to_select(:razon_social,:id,c_e)
        @usuarios_e = []
        c_e.each do |c_ee|
          @usuarios_e += c_ee.personas.map { |f| [f.user.nombre_completo,f.id]  }
        end
        @contribuyentes  += c_e
      else
        usuarios_e = @manifestacion_de_interes.usuarios_para_lista(Rol::RESPONSABLE_ENTREGABLES)
        @usuarios_e = usuarios_e.map{|p| ["#{p.user[:rut]} - #{p.user[:nombre_completo]}",p[:id]]}.sort
      end

      unless @mapa_actor.institucion_entregables.blank?
        c_c = Contribuyente.where(id: @mapa_actor.institucion_carga_datos)
        @instituciones_c = Contribuyente.to_select(:razon_social,:id,c_c)
        @usuarios_c = []
        c_c.each do |c_cc|
          @usuarios_c += c_cc.personas.map { |f| [f.user.nombre_completo,f.id]  }
        end
        @contribuyentes  += c_c
      else
        usuarios_c = @manifestacion_de_interes.usuarios_para_lista(Rol::CARGADOR_DATOS_ACUERDO)
        @usuarios_c = usuarios_c.map{|p| ["#{p.user[:rut]} - #{p.user[:nombre_completo]}",p[:id]]}.sort
      end

      # se llenan los usuarios de los contribuyentes seleccionados


    end
    respond_to do |format|
      format.js
    end
  end

  def filtro_entregables
    # DZC 2018-10-03 18:10:49 se modifica el filtro para encontrar responsables que existan en la tabla pertinente, pertenecientes a la institucion seleccionada. DZC 2018-11-02 15:51:52 se modifica para que lea todos los responsables en caso de que no haya insitución seleccionada
    
    contribuyente = params[:contribuyente_id].present? ? params[:contribuyente_id].to_i : nil
    @personas = @manifestacion_de_interes.usuarios_para_lista(Rol::RESPONSABLE_ENTREGABLES, contribuyente)
    
    # personas = Responsable.__personas_responsables(Rol::RESPONSABLE_ENTREGABLES, @flujo.tipo_instrumento_id)
    # @personas = Persona.where(id: personas.pluck(:id), contribuyente_id: params[:contribuyente_id])
    respond_to do |format|
      format.js{}
    end
  end

  def filtro_carga_datos
    # DZC 2018-10-03 18:10:49 se modifica el filtro para encontrar responsables que existan en la tabla pertinente, pertenecientes a la institucion seleccionada. DZC 2018-11-02 15:51:52 se modifica para que lea todos los responsables en caso de que no haya insitución seleccionada

    contribuyente = params[:contribuyente_id].present? ? params[:contribuyente_id].to_i : nil
    @personas = @manifestacion_de_interes.usuarios_para_lista(Rol::CARGADOR_DATOS_ACUERDO, contribuyente)

    # personas = Responsable.__personas_responsables(Rol::CARGADOR_DATOS_ACUERDO, @flujo.tipo_instrumento_id)
    # @personas = Persona.where(id: personas.pluck(:id), contribuyente_id: params[:contribuyente_id])
    respond_to do |format|
      format.js{}
    end
  end
  private
    def set_tarea_pendiente
      @tarea_pendiente = TareaPendiente.find(params[:tarea_pendiente_id])
      autorizado? @tarea_pendiente
      @tarea = @tarea_pendiente.tarea #crea una instancia de tarea a través de la forean key de tarea_pendiente (primary de tarea)
    end

    #DZC define el flujo y tipo_instrumento, junto con la manifestación o el proyecto según corresponda, para efecto de completar datos. El id de la manifestación se obtiene del flujo correspondiente a la tarea pendiente.
    def set_flujo
      @flujo = @tarea_pendiente.flujo
      @tipo_instrumento=@flujo.tipo_instrumento
      @manifestacion_de_interes = @flujo.manifestacion_de_interes_id.blank? ? nil : ManifestacionDeInteres.find(@flujo.manifestacion_de_interes_id)
      @manifestacion_de_interes.update(tarea_codigo: @tarea.codigo) unless @manifestacion_de_interes.blank?
      @proyecto = @flujo.proyecto_id.blank? ? nil : Proyecto.find(@flujo.proyecto_id)
      @ppp = @flujo.programa_proyecto_propuesta_id.blank? ? nil : ProgramaProyectoPropuesta.find(@flujo.programa_proyecto_propuesta_id)
      @manifestacion_de_interes.temporal = true unless @manifestacion_de_interes.nil?
    end

    def mapa_actor_params
      parametros = params.require(:mapa_de_actor).permit(
        :institucion_entregables,
        :usuario_entregables,
        :observacion_entregables,
        :institucion_carga_datos,
        :usuario_carga_datos,
        :observacion_carga_datos
      )
      parametros[:tipo] = :entregables_carga_datos
      parametros
    end

    def entregable_params
      parametros = params.require(:mapa_de_actor).permit(
        :institucion_entregables,
        :usuario_entregables,
        :observacion_entregables,
      )
      parametros[:tipo] = :entregables
      parametros
    end
    def carga_datos_params
      parametros = params.require(:mapa_de_actor).permit(
        :institucion_carga_datos,
        :usuario_carga_datos,
        :observacion_carga_datos
      )
      parametros[:tipo] = :carga_datos
      parametros
    end

end