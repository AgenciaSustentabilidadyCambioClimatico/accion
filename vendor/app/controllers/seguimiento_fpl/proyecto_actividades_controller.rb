class SeguimientoFpl::ProyectoActividadesController < ApplicationController
  before_action :authenticate_user!
  protect_from_forgery with: :exception, unless: proc{action_name == 'enviar_pago'}
  before_action :set_flash_messages_vars
  #before_action :set_proyecto, except: [:crear_actividad,:index,:solicitud_pago,:calendario,:actualizar_calendario, :editar_actividad, :guardar_actividad, :eliminar_actividad, :agregar_actividad] #only: [:mostrar_ocultar, :iniciar_syc, :enviar_pago, :restitucion, :actualizar_restitucion, :resolucion_contrato, :actualizar_resolucion_contrato, :fecha_efectiva_pago, :actualizar_fecha_efectiva_pago]
  before_action :set_proyecto, only: [:index,:modificar_calendario,:actualizar_rendiciones,:nuevo_anticipo, :modificaciones]
  before_action :set_tarea_pendiente
  before_action :set_proyecto_editar_actividad, only: [:edit, :update, :destroy]
  before_action :set_proyecto_agregar_actividad, only: [:new,:create]
  before_action :set_modificacion_calendario, except: [:edit, :update]
  # before_action :permiso_tarea, except: [:reset_rendiciones]

  def set_flash_messages_vars
    @success = []
    @warning = []
    @error = []
  end

  def set_flash_messages
    flash.now[:success] = @success
    flash.now[:warning] = @warning
    flash.now[:error] = @error
  end

  def index
    resultado = verificar_ciertas_cosas
    unless puede_guardar_directamente?
      @modificacion_calendario.atributos_rendiciones = resultado[:rendiciones].map{|m|m.attributes}
      @modificacion_calendario.save
    else
      unless @proyecto.rendiciones.find_index {|r| r.changed?}.blank?
        @proyecto.save
        @success << 'Rendiciones correctamente actualizadas'
      end
    end
    set_flash_messages
  end

  def edit
    resultado = @proyecto_actividad.verificar_estado_items
    @bloqueado = resultado[:bloqueado]
    @estado_actividad = resultado[:estado]
    @se_esta_creando = false
    if @bloqueado
      flash.now[:alert] = "No se puede modificar una actividad que ha sido aprobada o está en revisión"
    end
  end

  def destroy
    eliminada = false
    if puede_guardar_directamente?
      unless @proyecto_actividad.esta_proceso_o_aceptado?
        @proyecto_actividad.destroy
        eliminada = true
      end
    else
      @modificacion_calendario.atributos_proyecto_actividades.each do |apa|
        en_revision = apa["en_revision"].blank? ? false : apa["en_revision"]
        if apa["gb_id"].to_i == params[:id].to_i && en_revision == false
          @modificacion_calendario.atributos_proyecto_actividades.delete(apa)
          @modificacion_calendario.save
          eliminada = true
        end
      end
    end
    
    if eliminada
      @success << 'Actividad correctamente eliminada.'
    else
      @error << 'Actividad no pudo ser eliminada.'
    end
    set_flash_messages
    redirect_to seguimiento_fpl_proyecto_proyecto_actividades_path(@tarea_pendiente,@proyecto)
  end

  def new
    @estado_actividad = "Entrega pendiente"
    @bloqueado = false
    @se_esta_creando = true
  end

  def update
    @proyecto_actividad.assign_attributes(proyecto_params_actividad)
    if @proyecto_actividad.valid? 
      flash.now[:notice] = "Proyecto actualizado"
      if puede_guardar_directamente?
        @proyecto_actividad.update(proyecto_params_actividad)
        @proyecto.calcular_total_cofinanciamiento(true)
      else
        __params = __params_as_hash(:proyecto_actividad, {monto: :i})
        @proyecto_actividad = ProyectoActividad.new(__params)
        @proyecto_actividad.proyecto_id = @proyecto.id
        @proyecto_actividad.id = 0
        @proyecto_actividad.gb_id = params[:id].to_i
        @proyecto_actividad.modificado = true
        @proyecto.calcular_total_cofinanciamiento
        guardar_atributos_modificados(:update,@proyecto_actividad)
      end
    else
      flash.now[:alert] = "Error al actualizar"
    end
    respond_to do |format|
      format.js {}
    end
  end

  def verificar_ciertas_cosas
    asignar_atributos_modificados!
    rendiciones = ((puede_guardar_directamente? ? @proyecto.rendiciones : @rendiciones_attributes.map{|m|Rendicion.new(m)}))
    resultado = verificar_integridad_rendiciones!(@proyecto_actividad,rendiciones)
    fecha_fin_de_contrato_es_menor_que_la_ultima_actividad?
    resultado
  end

  def data_para_verificar_rendiciones(guardar=false)
    @tarea_pendiente=TareaPendiente.find(params[:tarea_pendiente])
    if puede_guardar_directamente?
      @proyecto = Proyecto.find(params[:proyecto_id])
      if guardar
        #@proyecto.assign_attributes(proyecto_rendicion_params)
        @proyecto.update(proyecto_rendicion_params)
        resultado = verificar_integridad_rendiciones!(@proyecto.proyecto_actividad,@proyecto.rendiciones)
        if @error.size == 0 
          @success << "Rendiciones correctamente actualizadas" if @proyecto.save
        end
      end
    else
      
      if guardar
        dp = Proyecto.new(proyecto_rendicion_params)
        resultado = verificar_integridad_rendiciones!(@proyecto.proyecto_actividad,dp.rendiciones)
        @rendiciones_attributes = resultado[:rendiciones].map{|m|m.attributes}
        @modificacion_calendario.atributos_rendiciones = @rendiciones_attributes
        if @error.size == 0 && @modificacion_calendario.save
          @success << "Rendiciones correctamente actualizadas"
        end
      else
        verificar_ciertas_cosas
      end
    end
    set_flash_messages
    fecha_fin_de_contrato_es_menor_que_la_ultima_actividad?
  end

  def reset_rendiciones
    data_para_verificar_rendiciones
    respond_to do |format|
      format.js {}
    end
  end

  def actualizar_rendiciones
    data_para_verificar_rendiciones(true)
    respond_to do |format|
      format.js {}
    end
  end

  def nuevo_anticipo
    @proyecto.assign_attributes(nuevo_anticipo_params)
    if @proyecto.valid?
      flash.now[:notice] = "Proyecto actualizado"
      if puede_guardar_directamente?
        @proyecto.save
      else
        @modificacion_calendario.atributos_proyecto = @proyecto.attributes
        @modificacion_calendario.save if @modificacion_calendario.changed?
      end
    else
      flash.now[:alert] = __list_errors(@proyecto)
    end
    respond_to do |format|
      format.js {}
    end
  end

  def modificaciones
    #@proyecto = Proyecto.find(params[:proyecto_id])
    asignar_atributos_modificados!
    fecha_fin_de_contrato_es_menor_que_la_ultima_actividad?
    @proyecto.assign_attributes(params.require(:proyecto).permit(:comentario))
    @proyecto.debe_agregar_comentario = true
    respond_to do |format|
      if @proyecto.valid?
        if @proyecto.comentario_modificacion.blank?
          @proyecto.comentario_modificacion = []
        end
        @proyecto.comentario_modificacion << {
          comentario: @proyecto.comentario,
          fecha: DateTime.now.strftime('%Y-%m-%d %H:%M:%S'),
          user_id: current_user.id
        }
        flash[:notice] = "Proyecto actualizado"
        if @proyecto.save
          __continuar_flujo_con_opciones
          format.js { render js: "window.location.href='#{root_path}'" }
        end
      else
        @levantar_popup = true
        flash.now[:alert] = __list_errors(@proyecto)
        format.js {}
      end
      
    end
  end

  def aceptar_modificaciones
    # Posibles modificaciones del proyecto
    v = @modificacion_calendario.atributos_proyecto
    ntna = v[:total_nuevo_anticipo].to_i
    if @proyecto.total_nuevo_anticipo != ntna && ntna != 0
      @proyecto.total_nuevo_anticipo = ntna
    end

    # Posibles modificaciones de las actividades
    @modificacion_calendario.atributos_proyecto_actividades.each do |apa|
      if apa[:modificado] == true
        @proyecto.proyecto_actividad.each do |ppa|
          if ppa.id == apa[:gb_id]
            ppa.nombre = apa[:nombre]
            ppa.fecha_finalizacion = apa[:fecha_finalizacion]
            apa[:actividad_item_attributes].each do |aia|
              if aia[:nuevo] == true
                ppa.actividad_item << ActividadItem.new(aia)
              else
                ppa.actividad_item.each do |pai|
                  if pai.id == aia[:gb_id]
                    pai.nombre = aia[:nombre]
                    pai.tipo_aporte_id = aia[:tipo_aporte_id]
                    pai.monto = aia[:monto]
                  end
                end
              end
              aia[:modificado] = false
            end
            if ppa.changed?
              ppa.save
              @modificacion_calendario.save
            end
          end
        end
      elsif apa[:nuevo] == true
        @proyecto.proyecto_actividad << ProyectoActividad.new(apa)
      end
    end

    # Posibles modificaciones de las rendiciones
    rendiciones_del_proyecto_original = @proyecto.rendiciones.map{|pr| pr.fecha_rendicion }.compact.uniq
    rendiciones_del_proyecto_modificado = @modificacion_calendario.atributos_rendiciones.map{|pr| pr[:fecha_rendicion] }.compact.uniq
    combinacion = (rendiciones_del_proyecto_original + rendiciones_del_proyecto_modificado).uniq
    @proyecto.rendiciones = []
    @proyecto.rendiciones = combinacion.map{|c|Rendicion.new({fecha_rendicion: c})}

    if @proyecto.changed?
      @proyecto.save
    end

    @proyecto_actividad = @proyecto.proyecto_actividad

    fecha_fin_de_contrato_es_menor_que_la_ultima_actividad?
    __continuar_flujo_con_opciones
    flash[:notice] = "Cambios aplicados correctamente"
    respond_to do |format|
       format.js { render js: "window.location.href='#{root_path}'" }
    end
  end

  def create
    @proyecto_actividad = @proyecto.proyecto_actividad.new(proyecto_params_actividad)
    @estado_actividad = "No enviada"
    @bloqueado = false
    @se_esta_creando = false
    if @proyecto_actividad.valid?
      if puede_guardar_directamente?
        if @proyecto_actividad.save
          __config_despues_de_crear(true)
        end
      else
        guardar_atributos_modificados(:create,@proyecto_actividad)
        __config_despues_de_crear
      end
    else
      @se_esta_creando = true
      flash.now[:alert] = "Error al crear actividad"
    end
    respond_to do |format|
      format.js {}
    end
  end

  def __config_despues_de_crear(guardar=false)
    @estado_actividad = "Entrega pendiente"
    @bloqueado = false
    @se_esta_creando = true
    @proyecto.calcular_total_cofinanciamiento(guardar)
    flash.now[:notice] = "Actividad creada"
    @proyecto_actividad = ProyectoActividad.new
  end

  # defino la obtencion de param para cada vista
  def proyecto_params_actividad
    # falta recorrer monto para sacar valor
    parametros = params.require(:proyecto_actividad).permit(
      :id,
      :nombre,
      :fecha_finalizacion,
      actividad_item_attributes: [
        :id,
        :nombre,
        :tipo_aporte_id,
        :monto,
        :estado_tecnica_id,
        :estado_respaldo_id,
        :glosa_id,
        :_destroy
      ]
    )
    unless parametros[:actividad_item_attributes].blank?
      parametros[:actividad_item_attributes].each do |k,v|
        v.each do |kk,vv|
          parametros[:actividad_item_attributes][k][kk] = dinero_params(vv) if kk == "monto"
        end
      end
    end
    parametros
  end

  def proyecto_rendicion_params
    parametros = params.require(:proyecto).permit(
      rendiciones_attributes: [
        :id,
        :fecha_rendicion,
        :_destroy
      ]
    )
    parametros
  end

  def nuevo_anticipo_params
    parametros = params.require(:proyecto).permit(:total_nuevo_anticipo)
    parametros[:total_nuevo_anticipo] = dinero_params(parametros[:total_nuevo_anticipo]) unless parametros[:total_nuevo_anticipo].blank?
    parametros[:esta_agregando_nuevo_anticipo] = true
    parametros
  end

  # se define dos veces la obtencion de proyecto, una con los demas modelos para no traer data demas cuando no se necesita
  def set_proyecto
    @proyecto = Proyecto.includes([:proyecto_actividad,:rendiciones]).find(params[:proyecto_id])
    @glosas = Glosa.all
    @tipo_aportes = TipoAporte.all
    @modalidades = Modalidad.as_select

  end

  def set_proyecto_agregar_actividad
    @proyecto = Proyecto.includes([:proyecto_actividad]).find(params[:proyecto_id])
    @proyecto_actividad = @proyecto.proyecto_actividad.new()
    @glosas = Glosa.all
    @tipo_aportes = TipoAporte.all
    @modalidades = Modalidad.as_select
  end

  def set_proyecto_editar_actividad
    @proyecto = Proyecto.includes([:proyecto_actividad]).find(params[:proyecto_id])
    if puede_guardar_directamente?
      @proyecto_actividad = ProyectoActividad.find(params[:id])
    else
      set_modificacion_calendario
      @proyecto_actividad = ProyectoActividad.new(@modificacion_calendario.find_proyecto_actividad(params[:id]))
    end
    @glosas = Glosa.all
    @tipo_aportes = TipoAporte.all
    @modalidades = Modalidad.as_select
  end

  def set_tarea_pendiente
    @tarea_pendiente = TareaPendiente.find(params[:tarea_pendiente])
    autorizado? @tarea_pendiente
    @codigo_tarea = @tarea_pendiente.tarea.codigo
  end

  def guardar_atributos_modificados(modo=:create,proyecto_actividad=nil,rendicion=nil)
    if @proyecto.changed?
      @modificacion_calendario.atributos_proyecto = @proyecto.attributes
    end
    unless proyecto_actividad.blank?
      if modo == :create
        unless @modificacion_calendario.atributos_proyecto_actividades.is_a?(Array)
          @modificacion_calendario.atributos_proyecto_actividades = []
        end
        ultima_actividad_del_lote = @modificacion_calendario.atributos_proyecto_actividades.map{|pa|pa[:gb_id]}.last
        atributos_proyecto_actividades = proyecto_actividad.attributes
        atributos_proyecto_actividades[:gb_id] = (ultima_actividad_del_lote.to_i+1)
        atributos_proyecto_actividades[:en_revision] = false
        atributos_proyecto_actividades[:nuevo] = true
        i = 1;
        actividad_item_attributes = []
        proyecto_actividad.actividad_item.each do |ai|
          aia=ai.attributes
          aia[:gb_id]=i
          aia[:nuevo]=true
          i+=1
          actividad_item_attributes << aia
        end
        atributos_proyecto_actividades[:actividad_item_attributes] = actividad_item_attributes
        @modificacion_calendario.atributos_proyecto_actividades += [atributos_proyecto_actividades]
      elsif modo == :update
        @modificacion_calendario.atributos_proyecto_actividades.each_with_index do |apa,index|
          if proyecto_actividad.gb_id == apa[:gb_id]
            apa[:modificado]            = true
            apa[:nombre]                = proyecto_actividad.nombre
            apa[:fecha_finalizacion]    = proyecto_actividad.fecha_finalizacion
            actividad_item_attributes   = []
            total_items_de_la_actividad = apa[:actividad_item_attributes].sort_by{|pa|pa[:gb_id]}.last[:gb_id].to_i + 1
            
            proyecto_actividad.actividad_item.each do |ai|
              if ai.gb_id.blank?
                aia = ai.attributes
                aia[:nuevo] = true
                aia[:gb_id] = ai.gb_id = total_items_de_la_actividad
                actividad_item_attributes << aia
                total_items_de_la_actividad += 1
              else
                apa[:actividad_item_attributes].each do |aia|
                  if ai.gb_id.to_i == aia[:gb_id]
                    aia[:modificado]      = true
                    aia[:nombre]          = ai.nombre
                    aia[:tipo_aporte_id]  = ai.tipo_aporte_id
                    aia[:monto]           = ai.monto
                    actividad_item_attributes << aia
                  end
                end
              end
            end
            apa[:actividad_item_attributes] = actividad_item_attributes
          end
        end
      end
    end

    unless rendicion.blank?
      unless @modificacion_calendario.atributos_rendiciones.is_a?(Array)
        @modificacion_calendario.atributos_rendiciones = []
      end
      @modificacion_calendario.atributos_rendiciones += [rendicion.attributes]
    end

    if @modificacion_calendario.changed?
      @modificacion_calendario.save
    end
  end

  def asignar_atributos_modificados!
    unless puede_guardar_directamente?
      unless @modificacion_calendario.blank?
        
        if @modificacion_calendario.atributos_proyecto.blank?
          @proyecto.calcular_total_cofinanciamiento
          @modificacion_calendario.atributos_proyecto = @proyecto.attributes
        end

        @rendiciones_attributes = []
        if @modificacion_calendario.atributos_rendiciones.blank?
          atributos_rendiciones = []
          @proyecto.rendiciones.each do |r|
            ra = r.dup.attributes
            ra[:gb_id] = r.id
            atributos_rendiciones << ra
          end
          @modificacion_calendario.atributos_rendiciones = atributos_rendiciones
        end

        @modificacion_calendario.atributos_rendiciones.each do |ra|
          @rendiciones_attributes << ra
        end
        
        if @modificacion_calendario.atributos_proyecto_actividades.blank?
          apa = []
          @proyecto.proyecto_actividad.each do |pa|
            paa = pa.dup.attributes
            paa[:gb_id] = pa.id
            paa[:en_revision] = pa.esta_proceso_o_aceptado?
            paa[:actividad_item_attributes] = pa.actividad_item.map{|ai|aia=ai.dup.attributes;aia[:gb_id]=ai.id;aia}
            apa << paa
          end
          @modificacion_calendario.atributos_proyecto_actividades = apa
        end

        if @modificacion_calendario.changed?
          @modificacion_calendario.save
        end

        #@proyecto.assign_attributes(@modificacion_calendario.atributos_proyecto)
        @proyecto_actividad = @modificacion_calendario.atributos_proyecto_actividades.map{|m|
          pa=ProyectoActividad.new(m);
          pa
        }
      end
    else
      @proyecto_actividad = @proyecto.proyecto_actividad
    end
  end

  def set_modificacion_calendario
    @modificacion_calendario = nil
    @esta_revisando_cambios_tarea_15_desde_tarea_16 = ( @codigo_tarea == Tarea::COD_FPL_016 && @tarea_pendiente.viene_desde_tarea_fpl_015? )
    if @codigo_tarea == Tarea::COD_FPL_015 || @esta_revisando_cambios_tarea_15_desde_tarea_16
      @proyecto = Proyecto.find(params[:proyecto_id]) if @proyecto.blank?
      @modificacion_calendario = ModificacionCalendario.where(proyecto_id: @proyecto.id).first
      if @modificacion_calendario.blank?
        @modificacion_calendario = ModificacionCalendario.new
        @modificacion_calendario.proyecto_id = @proyecto.id
      end
    end
  end

  def puede_guardar_directamente?
    @puede_guardar_directamente = ( @codigo_tarea == Tarea::COD_FPL_016 && @tarea_pendiente.viene_desde_tarea_fpl_015? == false ) 
  end

  def fecha_fin_de_contrato_es_menor_que_la_ultima_actividad?
    menor = false
    unless @proyecto_actividad.blank?
      ultima_actividad = @proyecto_actividad.sort_by{|pa|pa.fecha_finalizacion}.last
      menor = @proyecto.fecha_fin_contrato < ultima_actividad.fecha_finalizacion
    end
    if menor 
      @warning << I18n.t(:diferencias_fecha_fin_contrato)
      @diferencias_contrato = true
    end

    menor
  end

  def verificar_integridad_rendiciones!(proyecto_actividad,rendiciones)
    fechas_actividades    = []
    fechas_rendiciones    = []
    grupos_rendidos       = {}
    actividades_agrupadas = 0

    proyecto_actividad.sort_by{|pa|pa.fecha_finalizacion}.each do |pa|
      fechas_actividades << pa.fecha_finalizacion
    end

    rendiciones.sort_by{|r|r.fecha_rendicion}.each do |r|
      fechas_rendiciones << r.fecha_rendicion
    end

    if fechas_rendiciones.size == 0 && fechas_actividades.size > 0
      @error << "No hay rendiciones declaradas para este calendario"
      @error_en_las_rendiciones = true
    else
      
      fechas_rendiciones.each do |fecha_rendicion|
        grupos_rendidos[fecha_rendicion] = [] unless grupos_rendidos.has_key?(fecha_rendicion)
        fechas_actividades.dup.each do |fecha_finalizacion|
          if fecha_finalizacion <= fecha_rendicion
            grupos_rendidos[fecha_rendicion] << fecha_finalizacion
            fechas_actividades.delete(fecha_finalizacion)
          end
        end
      end
      
      actividades_agrupadas = grupos_rendidos.inject(0){|total,(k,fechas)|total+=fechas.size;total}

      if fechas_actividades.size > 0
        ultima_rendicion = fechas_rendiciones.last
        ultima_actividad = fechas_actividades.last
        if ultima_rendicion < ultima_actividad
          rendiciones.last.fecha_rendicion = ultima_actividad
          @warning << "La rendiciones deben abarcar todas las actividades, es por eso que se movió #{(I18n.l ultima_rendicion)} hasta la última actividad #{(I18n.l ultima_actividad)}"
        end
      end

      grupos_rendidos.each do |fecha_rendicion,actividades|
        if actividades.size == 0
          @error << "La rendición con fecha #{fecha_rendicion} está fuera del rango de actividades"
          @error_en_las_rendiciones = true
        end
      end
    end
    {
      rendiciones: rendiciones,
      fechas_actividades: fechas_actividades,
      fechas_rendiciones: fechas_rendiciones,
      grupos_rendidos: grupos_rendidos,
      actividades_agrupadas: actividades_agrupadas,
      #warnings: warnings,
      #errores: errores
    }
  end

  def __continuar_flujo_con_opciones
    tarea_pendiente = TareaPendiente.find(params[:tarea_pendiente])
    flujo_tareas = FlujoTarea.where(tarea_entrada_id: tarea_pendiente.tarea_id).all
    
    # Si estoy en la tarea 15, sigo con lo que me dice el flujo tarea
    if tarea_pendiente.tarea.codigo == Tarea::COD_FPL_015

      @tarea_pendiente.estado_tarea_pendiente_id = EstadoTareaPendiente::ENVIADA
      @tarea_pendiente.save
      flujo_tareas.each do |ft|
        ft.continuar_flujo(tarea_pendiente.flujo.id, { tarea_pendiente_id: tarea_pendiente.id, codigo_tarea: tarea_pendiente.tarea.codigo })
      end

    # Pero si estoy en la tarea 16 debemos verificar algunas cosas...
    elsif tarea_pendiente.tarea.codigo == Tarea::COD_FPL_016
      if @tarea_pendiente.viene_desde_tarea_fpl_015?
        @tarea_pendiente.estado_tarea_pendiente_id = EstadoTareaPendiente::ENVIADA
        @tarea_pendiente.save
      end
      salidas = []

      # ...diferencias en contrato
      if @diferencias_contrato
        salidas << 'B'
      end

      # ...diferencias en los montos cofinanciados vs 
      # las sumas FPL de las actividades
      dp = Proyecto.find(params[:proyecto_id])
      tc = 0
      @proyecto_actividad.each do |pa|
        tc += pa.suma_total_fpl
      end
      if @proyecto.total_cofinanciamiento > tc
        salidas << 'C'
      end

      # ... o si no se dió ninguno de los casos anteriores
      if salidas.size == 0
        salidas << 'A'
      end
      # Echamos a correr las tareas siguientes si la condición de 
      # salida del flujo se encuentra en la variable salidas
      flujo_tareas.each do |ft|
        if salidas.include?(ft.condicion_de_salida)
          ft.continuar_flujo tarea_pendiente.flujo.id
        end
      end
    end
  end
end