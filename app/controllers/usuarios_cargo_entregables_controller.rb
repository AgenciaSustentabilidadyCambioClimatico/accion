class UsuariosCargoEntregablesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_tarea_pendiente
  before_action :set_flujo

  def index
    @mapa_actor = MapaDeActor.new
    @contribuyente = Contribuyente.new

    tipo_instrumento = @manifestacion_de_interes.tipo_instrumento_id.nil? ? TipoInstrumento::ACUERDO_DE_PRODUCCION_LIMPIA : @manifestacion_de_interes.tipo_instrumento_id
    
    rol_tarea_entregables = Tarea::find_by(codigo: Tarea::COD_APL_025).rol_id
    responsables_entregables = Responsable.__personas_responsables(rol_tarea_entregables, tipo_instrumento)
    contribuyentes_entregables_ids = responsables_entregables.map{|p| p.contribuyente_id }.uniq
    @contribuyentes_entregables = Contribuyente.where(id: contribuyentes_entregables_ids)

    rol_tarea_cargadores = Tarea::find_by(codigo: Tarea::COD_APL_029).rol_id
    responsables_cargadores = Responsable.__personas_responsables(rol_tarea_cargadores, tipo_instrumento)
    contribuyentes_cargadores_ids = responsables_cargadores.map{|p| p.contribuyente_id }.uniq
    @contribuyentes_cargadores = Contribuyente.where(id: contribuyentes_cargadores_ids)
    
  end

  def update
    @mapa_actor = MapaDeActor.new(mapa_actor_params)
    @contribuyente = Contribuyente.new
    @mapa_actor.validar_apl_024 = true
    tipo_instrumento = @manifestacion_de_interes.tipo_instrumento_id.nil? ? TipoInstrumento::ACUERDO_DE_PRODUCCION_LIMPIA : @manifestacion_de_interes.tipo_instrumento_id
    rol_tarea_entregables = Tarea::find_by(codigo: Tarea::COD_APL_025).rol_id
    rol_tarea_cargadores = Tarea::find_by(codigo: Tarea::COD_APL_029).rol_id
    
    ## aca va el codigo que hace cuando los datos son validos
    if @mapa_actor.valid?
      @mapa_actor.validar_apl_024 = false

      #obtengo persona de usuario
      persona_entregables_by_user = Responsable::__personas_responsables_v2(rol_tarea_entregables, tipo_instrumento, @mapa_actor.institucion_entregables.to_i).select{|p| p.user_id == @mapa_actor.usuario_entregables.to_i }.first

      mapa_entregables = MapaDeActor.find_or_create_by({
        flujo_id: @tarea_pendiente.flujo_id,
        rol_id: rol_tarea_entregables,
        # rol_id: Rol.find_by(nombre: 'Responsable Entregables').id,
        persona_id: persona_entregables_by_user.id
      })

      #obtengo persona de usuario
      persona_carga_datos_by_user = Responsable::__personas_responsables_v2(rol_tarea_cargadores, tipo_instrumento, @mapa_actor.institucion_carga_datos.to_i).select{|p| p.user_id == @mapa_actor.usuario_carga_datos.to_i }.first

      mapa_entregables = MapaDeActor.find_or_create_by({
        flujo_id: @tarea_pendiente.flujo_id,
        rol_id: rol_tarea_cargadores,
        # rol_id: Rol.find_by(nombre: 'Responsable Entregables').id,
        persona_id: persona_carga_datos_by_user.id
      })

      @flujo.duplica_pendientes_para_responsable_especifico(@mapa_actor.usuario_entregables) 
        
      # TODO: el campo observación se debe guardar en alguna parte, porque debe ser usado en otras tareas que no es siempre la siguiente
      observacion = {}
      observacion[Rol::RESPONSABLE_ENTREGABLES] = @mapa_actor.observacion_entregables
      observacion[Rol::CARGADOR_DATOS_ACUERDO] = @mapa_actor.observacion_carga_datos
      @tarea_pendiente.pasar_a_siguiente_tarea(nil,{observacion_tarea_anterior: observacion})

      respond_to do |format|
        format.js {
          flash[:success] = 'Usuarios actualizados'
          render js: "window.location='#{root_path}'"
        }
      end

        
    else #DZC 2018-11-06 14:22:50 se modifica para el caso de que no se seleccionen contribuyentes
      # hacer esto si es incorrecto, para el form
    
      responsables_entregables = Responsable.__personas_responsables(rol_tarea_entregables, tipo_instrumento)
      contribuyentes_entregables_ids = responsables_entregables.map{|p| p.contribuyente_id }.uniq
      @contribuyentes_entregables = Contribuyente.where(id: contribuyentes_entregables_ids)

      responsables_cargadores = Responsable.__personas_responsables(rol_tarea_cargadores, tipo_instrumento)
      contribuyentes_cargadores_ids = responsables_cargadores.map{|p| p.contribuyente_id }.uniq
      @contribuyentes_cargadores = Contribuyente.where(id: contribuyentes_cargadores_ids)

      if !@mapa_actor.institucion_entregables.blank?
        personas_responsables_entregables = Responsable::__personas_responsables_v2(rol_tarea_entregables, tipo_instrumento, @mapa_actor.institucion_entregables)
        @usuarios_entregables = personas_responsables_entregables.map { |e| e.user  }
      end

      if !@mapa_actor.institucion_carga_datos.blank?
        personas_responsables_cargadores = Responsable::__personas_responsables_v2(rol_tarea_cargadores, tipo_instrumento, @mapa_actor.institucion_carga_datos)
        @usuarios_cargadores = personas_responsables_cargadores.map { |e| e.user  }
      end
      flash.now[:alert] = 'Ingrese todos los campos obligatorios'

      respond_to do |format|
        format.js
      end
    end
  end

  def filtro_entregables
    tipo_instrumento = @manifestacion_de_interes.tipo_instrumento_id.nil? ? TipoInstrumento::ACUERDO_DE_PRODUCCION_LIMPIA : @manifestacion_de_interes.tipo_instrumento_id
    rol_tarea = Tarea::find_by(codigo: Tarea::COD_APL_025).rol_id
    personas_responsables = Responsable::__personas_responsables_v2(rol_tarea, tipo_instrumento, params[:contribuyente_id])
    @usuarios = personas_responsables.map { |e| e.user  }
  end

  def filtro_carga_datos
    tipo_instrumento = @manifestacion_de_interes.tipo_instrumento_id.nil? ? TipoInstrumento::ACUERDO_DE_PRODUCCION_LIMPIA : @manifestacion_de_interes.tipo_instrumento_id
    rol_tarea = Tarea::find_by(codigo: Tarea::COD_APL_029).rol_id
    personas_responsables = Responsable::__personas_responsables_v2(rol_tarea, tipo_instrumento, params[:contribuyente_id])
    @usuarios = personas_responsables.map { |e| e.user  }
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
        :institucion_entregables_name,
        :usuario_entregables,
        :usuario_entregables_name,
        :observacion_entregables,
        :institucion_carga_datos,
        :institucion_carga_datos_name,
        :usuario_carga_datos,
        :usuario_carga_datos_name,
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