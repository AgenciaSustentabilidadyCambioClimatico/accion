class SetMetasAccionesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_tarea_pendiente
  before_action :set_flujo
  before_action :set_informe
  before_action :set_metas_acciones
  before_action :set_metas_accion, only: [:edit,:update,:destroy,:acciones_relacionadas]
  before_action :set_entra_propuesta, only: [:new, :create, :edit, :update, :actualizacion, :revision, :enviar_revision]

  def actualizacion
  end

  def revision
  end

  def enviar_revision
    parameters = enviar_revision_set_metas_accion_params()
    @manifestacion_de_interes.aprueba_set_metas_accion = parameters[:aprueba_set_metas_accion]
    @propuestas_con_observaciones = parameters[:propuestas]
    success = nil
    # (1) Se asume que la primera vez, no habrá comentarios de este tipo, si los hay guardamos los comentarios anteriores
    # y dejamos la variable con el valor que viene del formulario (sólo string)
    comentarios_anteriores = @manifestacion_de_interes.comentarios_y_observaciones_set_metas_acciones.blank? ? [] : @manifestacion_de_interes.comentarios_y_observaciones_set_metas_acciones
    @manifestacion_de_interes.comentarios_y_observaciones_set_metas_acciones = parameters[:comentarios_y_observaciones_set_metas_acciones]
    if @manifestacion_de_interes.valid?
      # (2) creamos un comentario de tipo array, para agregar más información
      comentarios_anteriores << {
        datetime: DateTime.now,
        # user: current_user.nombre_completo(),
        user: current_user.nombre_completo,
        requiere_correcciones: @propuestas_con_observaciones,
        texto: @manifestacion_de_interes.comentarios_y_observaciones_set_metas_acciones
      }
      # (3) antes de guardar, volvemos a dejar la variable como un array

      @manifestacion_de_interes.comentarios_y_observaciones_set_metas_acciones = comentarios_anteriores

      @manifestacion_de_interes.tarea_codigo = @tarea.codigo
      @manifestacion_de_interes.save

      continua_flujo_segun_tipo_tarea #DZC agregamos nuevamente la tarea pendiente para el revisado 

      # (4) finalmente dejamos la variable en nulo para no mostrarla en el formulario
      @manifestacion_de_interes.comentarios_y_observaciones_set_metas_acciones = nil
      success = "Set de metas y acciones correctamente actualizada"
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
    respond_to do |format|
      format.js {
        flash.now[:success] = success
      }
    end
  end


  def new
    
    # @manifestacion_de_interes.accion_en_set_metas_accion = accion
    @set_metas_accion = SetMetasAccion.new
    @set_metas_accion.anexo = params[:anexo]
    @set_metas_accion.anexo = false
    render layout: false if request.xhr?
  end

  def create
    @manifestacion_de_interes.accion_en_set_metas_accion = params[:accion].to_sym
    @set_metas_accion = SetMetasAccion.new(set_metas_accion_params.merge({flujo_id: @flujo.id}))
    @set_metas_accion.anexo = (@tarea.codigo == Tarea::COD_APL_023) ? true : false 
    respond_to do |format|
      if @set_metas_accion.save
        @informe.update(necesita_evidencia: true) if (@tarea.codigo == Tarea::COD_APL_023)
        continua_flujo_segun_tipo_tarea #DZC agregamos la tarea pendiente para el revisor
        case @tarea.codigo
          when Tarea::COD_APL_013
             r_to = cargar_actualizar_entregable_diagnostico_manifestacion_de_interes_path(@tarea_pendiente,@manifestacion_de_interes, tab_metas: true ) #DZC 2018-11-05 12:40:05 se agrega para posicionar la vista en la pestaña set metas y acciones
          when Tarea::COD_APL_014
            r_to = root_path
          when Tarea::COD_APL_018
            r_to = acuerdo_actores_manifestacion_de_interes_path(@tarea_pendiente, @manifestacion_de_interes, tab_metas: true) #DZC 2018-11-05 12:40:05 se agrega para posicionar la vista en la pestaña set metas y acciones
          when Tarea::COD_APL_020
            r_to = actualizar_acuerdos_actores_manifestacion_de_interes_path(@tarea_pendiente, @manifestacion_de_interes, tab_metas: true) #DZC 2018-11-05 12:40:05 se agrega para posicionar la vista en la pestaña set metas y acciones       
          when Tarea::COD_APL_023
            r_to = actualizar_comite_acuerdos_manifestacion_de_interes_path(@tarea_pendiente,@manifestacion_de_interes, tab_metas: true) #DZC 2018-11-05 12:40:05 se agrega para posicionar la vista en la pestaña set metas y acciones
          else 
            r_to = edit_tarea_pendiente_manifestacion_de_interes_set_metas_accion_url(@tarea_pendiente, @manifestacion_de_interes, @set_metas_accion) #DZC agregamos la tarea pendiente para el revisor
        end
        format.js { 
          flash.now[:success] = 'Metas y acción correctamente creada.'
          @set_metas_accion = SetMetasAccion.new
          @set_metas_accion.anexo = params[:anexo]
          render js: "window.location='#{r_to}'"
        }
        format.html {
          redirect_to r_to, notice: 'Metas y acción correctamente creada.'
        }
      else
        @errors = true
        format.html { render :new }
        format.js
      end
    end
  end

  def edit    
    @manifestacion_de_interes.accion_en_set_metas_accion = params[:accion].to_sym if (@manifestacion_de_interes.present? && params[:accion].present?)
    render layout: false 
  end

  def update 
    set_metas_accion_anterior = @set_metas_accion
    # @manifestacion_de_interes.accion_en_set_metas_accion = params[:accion].to_sym
    respond_to do |format|
      @set_metas_accion.assign_attributes(set_metas_accion_params)
      # DZC 2019-06-21 17:08:57 se modifica para considerar ingreso de comentarios en APL-020
      if set_metas_accion_params["materia_sustancia_id"].blank? && ![Tarea::COD_APL_019, Tarea::COD_APL_020].include?(@tarea.codigo)
        @set_metas_accion.materia_sustancia_id = nil
      end
      if @set_metas_accion.save
        if (@tarea.codigo == Tarea::COD_APL_023) && (set_metas_accion_anterior.detalle_medio_verificacion == @set_metas_accion.detalle_medio_verificacion) && (set_metas_accion_anterior.criterio_inclusion_exclusion == @set_metas_accion.criterio_inclusion_exclusion)
          @informe.update(necesita_evidencia: true)
        end
        # ToDo: hacer sólo esto cuando sea enviado desde un modal, ver contribuyentes/buscador para posible solución
        # @set_metas_acciones = SetMetasAccion.de_la_manifestacion_de_interes_(@manifestacion_de_interes.id)
        set_metas_acciones
        continua_flujo_segun_tipo_tarea
        
        case @tarea.codigo
          when Tarea::COD_APL_013
             r_to = cargar_actualizar_entregable_diagnostico_manifestacion_de_interes_path(@tarea_pendiente,@manifestacion_de_interes, tab_metas: true )
          when Tarea::COD_APL_014
            r_to = root_path
          when Tarea::COD_APL_018
            r_to = acuerdo_actores_manifestacion_de_interes_path(@tarea_pendiente, @manifestacion_de_interes, tab_metas: true) #DZC 2018-11-05 12:40:05 se agrega para posicionar la vista en la pestaña set metas y acciones
          when Tarea::COD_APL_019
            r_to = evaluacion_negociacion_manifestacion_de_interes_path(@tarea_pendiente, @manifestacion_de_interes, @tarea_pendiente.tarea.encuesta, tab_metas: true) #DZC 2018-11-02 18:57:01 se agrega para posicionar la vista en la pestaña set metas y acciones
          when Tarea::COD_APL_020
            r_to = actualizar_acuerdos_actores_manifestacion_de_interes_path(@tarea_pendiente, @manifestacion_de_interes, tab_metas: true) #DZC 2018-11-02 18:57:44 se agrega para posicionar la vista en la pestaña set metas y acciones        
          when Tarea::COD_APL_023
            r_to = actualizar_comite_acuerdos_manifestacion_de_interes_path(@tarea_pendiente,@manifestacion_de_interes, tab_metas: true) #DZC 2018-11-05 12:40:05 se agrega para posicionar la vista en la pestaña set metas y acciones
          else 
            r_to = edit_tarea_pendiente_manifestacion_de_interes_set_metas_accion_url(@tarea_pendiente, @manifestacion_de_interes, @set_metas_accion) #DZC agregamos la tarea pendiente para el revisor
        end
        # if @tarea.codigo ==Tarea::COD_APL_023
        #   r_to = actualizar_comite_acuerdos_manifestacion_de_interes_path(@tarea_pendiente,@manifestacion_de_interes)
        # else 
        #  r_to = edit_tarea_pendiente_manifestacion_de_interes_set_metas_accion_url(
        #     @tarea_pendiente,
        #     @manifestacion_de_interes,
        #     @set_metas_accion #DZC agregamos la tarea pendiente para el revisor
        #   )
        # end 
        format.js { flash.now[:success] = 'Metas y acción correctamente actualizada.'
          render js: "window.location='#{r_to}'"
        }
        format.html {
          redirect_to r_to, notice: 'Metas y acción correctamente actualizada.' 
        }
      else
        @errors = true
        format.html { render :edit }
        format.js
      end
    end
  end

  def destroy
    # DZC 2018-11-02 19:30:23 se agrega condición de borrado para set de metas y acciones
    if @set_metas_accion.es_borrable?(@tarea.codigo)
      @set_metas_accion.destroy
      case @tarea.codigo
        when Tarea::COD_APL_013
           r_to = cargar_actualizar_entregable_diagnostico_manifestacion_de_interes_path(@tarea_pendiente,@manifestacion_de_interes, tab_metas: true )
        when Tarea::COD_APL_018
          r_to = acuerdo_actores_manifestacion_de_interes_path(@tarea_pendiente,@manifestacion_de_interes, tab_metas: true)
        when Tarea::COD_APL_023
          r_to = actualizar_comite_acuerdos_manifestacion_de_interes_path(@tarea_pendiente, @manifestacion_de_interes, tab_metas: true)
        else 
          r_to = tarea_pendiente_manifestacion_de_interes_set_metas_acciones_url(@tarea_pendiente,@manifestacion_de_interes)     
      end 
      redirect_to r_to, notice: 'Set de metas y acción correctamente eliminada.'
    else
      redirect_to root_path, flash: {error:"Usted no tiene permiso para borrar set de metas y acciones."} 
    end   
  end

  def acciones_relacionadas
    
    @accion = @set_metas_accion.accion
    acciones_relacionadas = @accion.accion_relacionadas
    # DZC 2018-10-08 10:50:33 se corrige error que mostraba la misma acción y no las relacionadas a ella
    @acciones=acciones_relacionadas.map{|a|a.accion_relacionada}
    render layout: false if request.xhr? #DZC no renderiza el layout si el reques es ajax
  end

  def continua_flujo_segun_tipo_tarea #DZC generalización de condiciones de continuación de flujo
    case @tarea.codigo
    when Tarea::COD_APL_013
      @tarea_pendiente.pasar_a_siguiente_tarea 'A',{},false
    when Tarea::COD_APL_014
      @tarea_pendiente.pasar_a_siguiente_tarea 'B',{},false
    end
  end

  def establecer_tipo_meta #DZC 2018-10-08 11:15:59 APL-013 Establece el tipo de metas en la pestaña set metas y acciones de APL-013
    tipo = params[:tipo]
    if tipo == '1' #DZC 2018-10-08 17:20:33 se selecciona el propio set de metas y acciones
      @manifestacion_de_interes.estandar_de_certificacion_id = nil
      @manifestacion_de_interes.diagnostico_id = nil
      #@flujo.set_metas_acciones.clear
      # @manifestacion_de_interes.documento_diagnosticos.clear
      
    elsif tipo == '2' #DZC 2018-10-08 17:20:33 se selecciona un standar de homologación
      @manifestacion_de_interes.estandar_de_certificacion_id = nil#params[:estandar_adherido]
      @manifestacion_de_interes.diagnostico_id = nil
      @flujo.set_metas_acciones_by_estandar params[:estandar_adherido]
    elsif tipo == '3' #DZC 2018-10-08 17:20:33 se seleccionan metas y acciones de otro acuerdo
      
      @manifestacion_de_interes.estandar_de_certificacion_id = nil
      @manifestacion_de_interes.diagnostico_id = nil#params[:diagnostico_adherido]
      @flujo.set_metas_acciones.where(modelo_referencia: "SetMetasAccion").destroy_all
      set_metas_by_antiguo_acuerdo params[:diagnostico_adherido], @flujo
    end
    @manifestacion_de_interes.temporal = true
    respond_to do |format|
      
      if @manifestacion_de_interes.save
        format.html { redirect_to cargar_actualizar_entregable_diagnostico_manifestacion_de_interes_path(@tarea_pendiente, @manifestacion_de_interes, tab_metas: true), notice: 'Modificación correcta.' }
      else
        @errors = true
        format.html { redirect_to cargar_actualizar_entregable_diagnostico_manifestacion_de_interes_path(@tarea_pendiente, @manifestacion_de_interes, tab_metas: true), notice: 'Conflicto al generar el cambio.' }
      end
    end
  end

  def pdf_set_metas
    filename = "public/SetMetasAcciones.pdf"
    pdf = Prawn::Document.new
    pdf.text('Metas, acciones y plazos de cumplimiento:')
    set_metas = @set_metas_acciones.includes('meta').group_by{|p| p.meta['nombre'] }
    set_metas.each_with_index do  |(key, value), posicion|
    pdf.text("Meta #{ posicion+1 }: #{key} ", indent_paragraphs: 20)
      value.each_with_index do  |val, pos|
        if val.plazo_unidad_tiempo == 1
          medida_singular = 'mes'
          medida_plural = 'meses'
        else
          medida_singular = 'año'
          medida_plural = 'años'
        end
        plazo = val.plazo_valor.present? ? helpers.pluralize(val.plazo_valor, medida_singular, medida_plural) : 0
        pdf.text("Acción  #{(posicion+1).to_s} . #{(pos+1).to_s}:  #{val.descripcion_accion}", indent_paragraphs: 40)
        pdf.text("Plazo:  #{plazo}", indent_paragraphs: 40)
        pdf.text("Método de verificación:  #{val.detalle_medio_verificacion}", indent_paragraphs: 40)
      end
    end
    pdf.render_file(filename)
    send_data(File.read(filename), :type => "application/pdf", :filename => "SetMetasAcciones.pdf")
  end

  def metas_acciones_tipo_meta
    if params[:tipo] == "2"
      @estandar = EstandarHomologacion.find(params[:id])
    elsif params[:tipo] == "3"
      @metas_acciones = ManifestacionDeInteres.find(params[:id]).flujo.set_metas_acciones.order(id: :asc)
    end
  end

  def eliminar_grupo_combi
    @set_metas_acciones.each do |sma|
      sma.destroy if sma.llave_origen == params[:combi]
    end
    respond_to do |format|
      format.html { redirect_to cargar_actualizar_entregable_diagnostico_manifestacion_de_interes_path(@tarea_pendiente, @manifestacion_de_interes, tab_metas: true), notice: 'Modificación correcta.' }
    end
  end

  private
  def set_tarea_pendiente
    @tarea_pendiente = TareaPendiente.find(params[:tarea_pendiente_id])
    autorizado? @tarea_pendiente
    @tarea = @tarea_pendiente.tarea
  end

  #DZC define el flujo y tipo_instrumento, junto con la manifestación o el proyecto según corresponda, para efecto de completar datos. El id de la manifestación se obtiene del flujo correspondiente a la tarea pendiente.
  def set_flujo
    @flujo = @tarea_pendiente.flujo
    @tipo_instrumento=@flujo.tipo_instrumento
    @manifestacion_de_interes = @flujo.manifestacion_de_interes_id.blank? ? nil : ManifestacionDeInteres.find(@flujo.manifestacion_de_interes_id)
    @manifestacion_de_interes.update(tarea_codigo: @tarea.codigo) unless @manifestacion_de_interes.blank?
    @proyecto = @flujo.proyecto_id.blank? ? nil : Proyecto.find(@flujo.proyecto_id)
    @ppp = @flujo.programa_proyecto_propuesta_id.blank? ? nil : ProgramaProyectoPropuesta.find(@flujo.programa_proyecto_propuesta_id)
  end

  def set_informe
    
    @informe=InformeAcuerdo.find_by(manifestacion_de_interes_id: @manifestacion_de_interes.id)
    if @informe.blank?
      @informe=InformeAcuerdo.create(manifestacion_de_interes_id: @manifestacion_de_interes.id, nuevo: true)
    end
    @auditorias = Auditoria.where(manifestacion_de_interes_id: @manifestacion_de_interes.id).all
  end

  def set_metas_acciones
    # @manifestacion_de_interes = ManifestacionDeInteres.find(params[:manifestacion_de_interes_id])
    @set_metas_acciones = SetMetasAccion.de_la_manifestacion_de_interes_(@manifestacion_de_interes.id)
    @set_metas_acciones_anexas = SetMetasAccion.de_la_manifestacion_de_interes_(@manifestacion_de_interes.id, true)
    
  end

  def set_metas_accion
    @set_metas_accion = SetMetasAccion.includes([:accion]).find(params[:id])
  end

  def set_entra_propuesta
    if action_name.to_sym == :actualizacion ||action_name.to_sym == :actualizar
      # accion = :actualizacion
      accion_en_sma = :actualizacion
    elsif action_name.to_sym == :revision ||action_name.to_sym == :enviar_revision
      # accion = :revision
      accion_en_sma = :revision
    elsif action_name.to_sym == :comite #DZC revisar
      accion_en_sma = :comite
    elsif action_name.to_sym == :update || action_name.to_sym == :edit || action_name.to_sym == :new || action_name.to_sym == :create
      case @tarea.codigo
      when Tarea::COD_APL_013
        accion_en_sma = :actualizacion
      when Tarea::COD_APL_018
        accion_en_sma = :actualizacion
      when Tarea::COD_APL_020
        accion_en_sma = :actualizacion                  
      when Tarea::COD_APL_023
        accion_en_sma = :comite
      end
    end
    @manifestacion_de_interes.accion_en_set_metas_accion = accion_en_sma
    @manifestacion_de_interes.temporal = true
    unless @manifestacion_de_interes.comentarios_y_observaciones_set_metas_acciones.blank?
      comentarios = @manifestacion_de_interes.comentarios_y_observaciones_set_metas_acciones.last
      @propuestas_con_observaciones = comentarios[:requiere_correcciones]
    end

  end

  def set_metas_accion_params
    parameters = params.require(:set_metas_accion).permit(
      :accion_id,
      :materia_sustancia_id,
      :meta_id,
      :tipo_cuantitativa,
      :valor_referencia,
      :alcance_id,
      :criterio_inclusion_exclusion,
      :descripcion_accion,
      :detalle_medio_verificacion,
      :plazo_valor,
      :plazo_unidad_tiempo,
      :comentario,
      :comentario_respuesta,
      :archivo_acta_comite
    )
    parameters[:manifestacion_de_interes_id] = @manifestacion_de_interes.id
    parameters
  end

  def enviar_revision_set_metas_accion_params
    params.require(:manifestacion_de_interes).permit(
      :comentarios_y_observaciones_set_metas_acciones,
      :aprueba_set_metas_accion,
      propuestas: []
    )
  end

end
