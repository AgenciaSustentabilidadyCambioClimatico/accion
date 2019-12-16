class AuditoriasController < ApplicationController
  before_action :authenticate_user!
  before_action :set_tarea_pendiente
  before_action :set_flujo
  before_action :set_auditorias, only: [:index]
  before_action :set_auditoria, only: [:actualizar, :actualizar_guardar, :revisar, :revisar_guardar, :validar, :validar_guardar, :descargar]
  before_action :set_datos
  before_action :set_crea_archivo, only: [:descargar]

  #DZC TAREA APL-032
  def actualizar
  end

  #DZC TAREA APL-032
  def actualizar_guardar
    # @auditorias = Auditoria.de_la_manif_de_interes(@manifestacion_de_interes).where(aceptado: false).where(en_revision: false)
    
    # @auditoria = Auditoria.new(auditoria_params)
    @auditoria.assign_attributes(auditoria_params)
    @ad_elementos = []
    errors = AuditoriaElemento.data_auditoria @auditoria
    #DZC TODO: revisar e implementar código de Ricardo en same controller
    # @auditoria.formulario = true
    #   # if @auditoria.valid?
    #     @auditoria = Auditoria.new
    #     format.js { flash.now[:success] = "Auditorías cargadas correctamente" }
    #     # continua_flujo_segun_tipo_tarea
    #   else
    #     ap @auditoria.errors.messages
    #     format.js { flash.now[:error] = "Error al cargar auditorias, reintente"}
    #   end
    # end    
    respond_to do |format|
      
      if errors.size == 0
        @auditoria.archivo_correcto = true
        continua_flujo_segun_tipo_tarea
        flash[:notice] = "Carga de auditoría enviada correctamente"
        format.js { render js: "window.location.href='#{root_path}'" }
        format.html { redirect_to root_path, flash: {notice: 'Carga de auditoría enviada correctamente' }}
      else
        # @auditoria.archivo_correcto = false
        format.js { flash.now[:error] = errors.full_messages.to_sentence}
        format.html { render :cargar, flash: {error: errors.full_messages.to_sentence }}
      end
    end
  end

  #DZC TAREA APL-033
  def revisar
    
  end

  #DZC TAREA APL-033
  def revisar_guardar
    
    respond_to do |format|
      auditoria_elementos_form=[]
      auditoria_elementos_params[:auditoria_elementos_attributes].each do |k,v|
        auditoria_elementos_form +=[
          v.each do|k2,v2| 
            [k2.to_sym => v2]
          end
        ]
      end
      auditoria_elementos_form.each do |ae|
        
        fecha_aprobacion = (ae[:estado].to_i == 5)? Time.now : nil
        AuditoriaElemento.find_by_id(ae[:id]).update(estado: ae[:estado].to_i, observacion: ae[:observacion], aprobacion_fecha: fecha_aprobacion)
      end
      continua_flujo_segun_tipo_tarea
      format.html { redirect_to revisar_auditorias_manifestacion_de_interes_path(@tarea_pendiente, @flujo.manifestacion_de_interes), notice: "Auditorías revisadas correctamente" }
      format.js { flash[:success] = "Auditorías revisadas correctamente"; render js: "window.location='#{revisar_auditorias_manifestacion_de_interes_path(@tarea_pendiente, @flujo.manifestacion_de_interes)}'" 
      }
    end

  end

  #DZC TAREA APL-034
  def validar
  end

  #DZC TAREA APL-034
  def validar_guardar
    respond_to do |format|
      auditoria_elementos_form=[]
      auditoria_elementos_validar_params[:auditoria_elementos_attributes].each do |k,v|
        auditoria_elementos_form +=[
          v.each do|k2,v2| 
            [k2.to_sym => v2]
          end
        ]
      end
      auditoria_elementos_form.each do |ae|
        
        ae[:validacion_fecha] = ae[:validacion_aceptada]? Time.now : nil
        AuditoriaElemento.find_by_id(ae[:id]).update(validacion_aceptada: ae[:validacion_aceptada], validacion_observaciones: ae[:validacion_observaciones],validacion_fecha: ae[:validacion_fecha]) 
      end
      continua_flujo_segun_tipo_tarea
      format.html { redirect_to validar_auditorias_manifestacion_de_interes_path(@tarea_pendiente, @flujo.manifestacion_de_interes), notice: "Auditorías revisadas correctamente" }
      format.js {
        
        flash.now[:success] = "Auditorías revisadas correctamente"
        # DZC 2018-11-06 20:45:34 se agrega para filtrar auditorias que ya han sido aceptadas o rechazadas
        @auditoria = Auditoria.find_by_id(@tarea_pendiente.data[:auditoria_id])
          
        # render js: "window.location='#{validar_auditorias_manifestacion_de_interes_path(@tarea_pendiente, @flujo.manifestacion_de_interes)}'"
      }
    end

  end

  def descargar 
    
    send_data File.open(@ruta).read, type: 'application/xslx', charset: "iso-8859-1", filename: "auditoria.xlsx"  #   #DZC agrega al campo data de la tarea_pendiente 
  end

  #DZC agrega al campo data de la tarea_pendiente 
  def continua_flujo_segun_tipo_tarea(condicion_de_salida=nil)
    case @tarea.codigo
    when Tarea::COD_APL_032
      @tarea_pendiente.pasar_a_siguiente_tarea 'A', {auditoria_id: @auditoria.id}, false #DZC en espera que de la revisión en la APL-033
      enviar_correos_revisar_reportes(@flujo) #DZC 2018-11-15 16:42:43 envia correos suguiriendo la revision de los reportes de auditoría
    when Tarea::COD_APL_033
      auditoria_elementos = AuditoriaElemento.where(auditoria_id: @auditoria.id)
      if auditoria_elementos.where.not(estado: [4,5]).size == 0
        @tarea_pendiente.pasar_a_siguiente_tarea 'A', {auditoria_id: @auditoria.id}
      end
      comentarios = []
      auditoria_elementos.where(estado: [1,2,3]).each do |c|
        comentarios += [c.observacion] unless c.observacion.blank?          
      end
      if comentarios.compact.size > 0
        @tarea_pendiente.pasar_a_siguiente_tarea 'B', {auditoria_id: @auditoria.id}, false
      end
      
      adhesion_elementos_id = auditoria_elementos.pluck(:adhesion_elemento_id).uniq
      cumple_elemento_al_100 = false
      adhesion_elementos_id.each do |adel|
        cumple_elemento_al_100 = (AuditoriaElemento.where(adhesion_elemento_id: adel, aplica: true).pluck(:cumple).include?([false, nil]) && !cumple_elemento_al_100)? false : true
      end
      if cumple_elemento_al_100 #DZC tiene al menos 1 elemento con 100% de cumplimiento
        if @auditoria.con_validacion #DZC tiene validación
          @tarea_pendiente.pasar_a_siguiente_tarea 'C', {auditoria_id: @auditoria.id}, false
        elsif @auditoria.con_certificacion #DZC tiene certificación
          if !@auditoria.final #DZC es intermedia
            @tarea_pendiente.pasar_a_siguiente_tarea 'D', {auditoria_id: @auditoria.id}, false
          else #DZC es final
            @tarea_pendiente.pasar_a_siguiente_tarea 'E', {auditoria_id: @auditoria.id}, false
          end
        end
      end
      enviar_correos_revisar_reportes(@flujo) #DZC 2018-11-15 16:42:43 envia correos suguiriendo la revision de los reportes de auditoría
    when Tarea::COD_APL_034
      condicion_de_salida = !@auditoria.final ? 'A' : 'B'
      auditoria_elementos = @auditoria.auditoria_elementos
      adhesion_elementos_id = auditoria_elementos.pluck(:adhesion_elemento_id).uniq
      cumple_elemento_al_100 = false
      se_revisaron_todos = true
      adhesion_elementos_id.each do |adel|
        cumple_elemento_al_100 = (AuditoriaElemento.where(adhesion_elemento_id: adel, aplica: true, cumple: true, estado: 5).pluck(:validacion_aceptada).include?([false, nil]) && !cumple_elemento_al_100)? false : true #DZC se encuentra al menos un elemento que cumple con todas las condiciones
        se_revisaron_todos = (!AuditoriaElemento.where(adhesion_elemento_id: adel, aplica: true, cumple: true, estado: 5).pluck(:validacion_aceptada).include?([nil]) && se_revisaron_todos)? true : false #DZC se encuentra al menos un elemento que no cumple con todas las condiciones
      end
      if cumple_elemento_al_100
        @tarea_pendiente.pasar_a_siguiente_tarea condicion_de_salida, {auditoria_id: @auditoria.id}, false
      end
      if se_revisaron_todos
        @tarea_pendiente.pasar_a_siguiente_tarea 'C', {auditoria_id: @auditoria.id}
      end
      enviar_correos_revisar_reportes(@flujo) #DZC 2018-11-15 16:42:43 envia correos suguiriendo la revision de los reportes de auditoría
    end
  end

  private

    def set_tarea_pendiente
      @tarea_pendiente = TareaPendiente.find(params[:tarea_pendiente_id])
      autorizado? @tarea_pendiente
      @tarea = @tarea_pendiente.tarea #crea una instancia de tarea a través de la forean key de tarea_pendiente (primary de tarea)
    end

    def set_flujo
      @flujo = @tarea_pendiente.flujo
      @tipo_instrumento=@flujo.tipo_instrumento
      @manifestacion_de_interes = @flujo.manifestacion_de_interes_id.blank? ? nil : ManifestacionDeInteres.find(@flujo.manifestacion_de_interes_id)
      @manifestacion_de_interes.update(tarea_codigo: @tarea.codigo) unless @manifestacion_de_interes.blank?
      @proyecto = @flujo.proyecto_id.blank? ? nil : Proyecto.find(@flujo.proyecto_id)
      @ppp = @flujo.programa_proyecto_propuesta_id.blank? ? nil : ProgramaProyectoPropuesta.find(@flujo.programa_proyecto_propuesta_id)
    end

    def set_auditorias
      
      @auditoria = Auditoria.find_by_id(@tarea_pendiente.data[:auditoria_id])
      @adhesion_elementos = @flujo.adhesion.adhesion_elementos #DZC elementos adheridos a 
      @auditorias = Auditoria.where(id: @auditoria_elementos.pluck(:auditoria_id)) #DZC auditorias

    end

    def set_auditoria
      @auditoria = Auditoria.find_by_id(@tarea_pendiente.data[:auditoria_id])
      # DZC 2019-06-19 12:56:28 se mueve para correcto funcionamiento del algoritmo
      @auditoria_elementos = nil
      if @tarea.codigo == Tarea::COD_APL_032 #&& @auditoria.archivo_correcto #DZC 2019-06-19 12:57:04 se modifica para correcto funcionamiento del algoritmo
        @auditoria_elementos = AuditoriaElemento.where(auditoria_id: @auditoria.id) #.where(estado: [3,4]) #DZC elementos a auditar
        # DZC 2019-06-19 13:02:10 se agrega para ordernar la tabla de resultados
        @auditoria_elementos = @auditoria_elementos.order(:estado) if @auditoria_elementos.present?
      elsif @tarea.codigo == Tarea::COD_APL_033
        @auditoria_elementos = AuditoriaElemento.where(auditoria_id: @auditoria.id).where(estado: [2]) #DZC elementos a auditar
      else #DZC APL-034
        @auditoria_elementos = AuditoriaElemento.where(auditoria_id: @auditoria.id).where(estado: [5]) #DZC elementos a auditar
      end
      # DZC 2019-06-19 12:45:07 se comenta para correcto funcionamiento del algoritmo
      # @auditoria_elementos = nil
    end

    def set_datos
      @descargables = @tarea_pendiente.get_descargables
    end

    # def auditoria_params
    #   params.require(:auditoria).permit(
    #     :archivo_auditorias,
    #     :archivo_auditorias_cache,
    #     :archivos_informe_y_evidencias_cache,
    #     archivos_informe_y_evidencias: [],
    #     aceptado: [],
    #     observacion: []
    #   )
    # end

    def auditoria_params
      params.require(:auditoria).permit(
        :archivo_carga_auditoria,
        :archivos_informe => [], 
        :archivos_evidencia => []
      )
    end

    def auditoria_elementos_params
      params.require(:auditoria).permit(auditoria_elementos_attributes: [:id, :observacion, :estado])
    end

    def auditoria_elementos_validar_params
      params.require(:auditoria).permit(auditoria_elementos_attributes: [:id, :validacion_observaciones, :validacion_aceptada])
    end

    def set_crea_archivo
      
      titulos = AuditoriaElemento.columnas_excel
      datos = AuditoriaElemento.datos(@manifestacion_de_interes, @auditoria) #DZC obtiene los datos desde las tablas
      
      dominios = AuditoriaElemento.dominios
      @ruta = "#{Rails.root}/public/uploads/auditoria/"
      FileUtils.mkdir_p(@ruta) unless File.exist?(@ruta) #DZC crea las carpetas pertinentes para la ruta
      @ruta += "auditorias.xlsx"
      ExportaExcel.formato(@ruta, titulos, dominios, datos, "auditorias.xlsx" )
    end

end