class AuditoriasController < ApplicationController
  before_action :authenticate_user!
  before_action :set_tarea_pendiente
  before_action :set_flujo
  before_action :set_auditorias, only: [:index]
  before_action :set_auditoria, only: [:actualizar, :actualizar_guardar, :revisar, :revisar_guardar, :validar, :validar_guardar, :descargar, :descargar_compilado]
  before_action :set_datos

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

      #si viene archivo lo guardo
      if params[:auditoria].has_key?(:archivo_revision)
        @auditoria.archivo_revision = params[:auditoria][:archivo_revision]
        @auditoria.save!
      end

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
      @auditoria_validacion.validaciones = params[:validacion]
      @auditoria_validacion.archivo = params[:auditoria_validacion][:archivo]
      if @auditoria_validacion.save
        continua_flujo_segun_tipo_tarea
        set_auditoria
        format.html { redirect_to validar_auditorias_manifestacion_de_interes_path(@tarea_pendiente, @flujo.manifestacion_de_interes), notice: "Auditorías revisadas correctamente" }
        format.js {
          flash.now[:success] = "Elementos revisados correctamente"
          render js: "window.location='#{validar_auditorias_manifestacion_de_interes_path(@tarea_pendiente, @flujo.manifestacion_de_interes)}'"
        } 
      else
        #en teoria no deberia caer aca, salvo que cargue un archivo con extension malo, si fuera el caso
        set_estado_validaciones(params[:validacion])
        format.js {
          flash.now[:danger] = "Error al revisar elementos"
        } 
      end
    end

  end

  def descargar 
    titulos = AuditoriaElemento.columnas_excel
    datos = AuditoriaElemento.includes( :set_metas_accion, adhesion_elemento: [:alcance, persona: [:user, :contribuyente, persona_cargos: :cargo], establecimiento_contribuyente: :comuna]).datos(@manifestacion_de_interes, @auditoria, @adhesiones)    
    dominios = AuditoriaElemento.dominios
    archivo = ExportaExcel.formato(nil, titulos, dominios, datos, "auditorias.xlsx" )
    
    send_data archivo.to_stream.read, type: 'application/xslx', charset: "iso-8859-1", filename: "auditoria.xlsx"  #   #DZC agrega al campo data de la tarea_pendiente 
  end

  #DZC agrega al campo data de la tarea_pendiente 
  def continua_flujo_segun_tipo_tarea(condicion_de_salida=nil)
    case @tarea.codigo
    when Tarea::COD_APL_032
      @tarea_pendiente.pasar_a_siguiente_tarea 'A', {auditoria_id: @auditoria.id}, false #DZC en espera que de la revisión en la APL-033
      enviar_correos_revisar_reportes(@flujo) #DZC 2018-11-15 16:42:43 envia correos suguiriendo la revision de los reportes de auditoría
    when Tarea::COD_APL_032_1
      @tarea_pendiente.pasar_a_siguiente_tarea 'A', {auditoria_id: @auditoria.id}, false #DZC en espera que de la revisión en la APL-033
      enviar_correos_revisar_reportes(@flujo) #DZC 2018-11-15 16:42:43 envia correos suguiriendo la revision de los reportes de auditoría
    when Tarea::COD_APL_033
      auditoria_elementos = AuditoriaElemento.where(auditoria_id: @auditoria.id)
      #esto creo que ya no se usa
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
      #obtengo todas las validaciones de todas las personas
      #si la cantidad de auditoriavalidaciones no coincide con la cantidad de tareaspendientes es porque no tiene el 100 porque a alguien le falta revisar
      auditoria_validaciones = AuditoriaValidacion.where(auditoria_id: @auditoria.id)
      tareas_pendientes_validacion = TareaPendiente.where(flujo_id: @tarea_pendiente.flujo_id, tarea_id: @tarea_pendiente.tarea_id).select{|tp| tp.data == {auditoria_id: @auditoria.id}}
      auditoria_elementos_ids = @auditoria.auditoria_elementos.where(estado: [5]).pluck(:id)
      cumple_elemento_al_100 = false
      se_revisaron_todos = true
      auditoria_elementos_ids.each do |ae_id|
        cumple_este_elemento_al_100 = true
        if !@auditoria_validacion.validaciones.has_key?(ae_id.to_s) || @auditoria_validacion.validaciones[ae_id.to_s][:estado_valor].nil? || @auditoria_validacion.validaciones[ae_id.to_s][:estado_valor] == ""
          se_revisaron_todos = false
        end

        if auditoria_validaciones.length == tareas_pendientes_validacion.length
          auditoria_validaciones.each do |auditoria_validacion|
            if !auditoria_validacion.validaciones.blank?
              if !auditoria_validacion.validaciones.has_key?(ae_id.to_s) || auditoria_validacion.validaciones[ae_id.to_s][:estado_valor] != "true"
                cumple_este_elemento_al_100 = false
              end
            end
          end
          cumple_elemento_al_100 = true if cumple_este_elemento_al_100
        end
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

  def descargar_compilado
    require 'zip'
    require 'open-uri'
    archivo_zip = Zip::OutputStream.write_buffer do |stream|
      @auditoria_elementos.each do |auditoria_elemento|
        adhesion = Adhesion.unscoped.where(id: auditoria_elemento.adhesion_elemento.adhesion_externa_id).first
        archivo_evidencia = auditoria_elemento.archivo_evidencia
        archivo_informe = auditoria_elemento.archivo_informe

        unless archivo_evidencia.url.nil?
          url = archivo_evidencia.url
          nombre = File.basename(URI.parse(url).path)

          URI.open(url) do |file_data|
            stream.put_next_entry(nombre)
            stream.write file_data.read
          end
        end

        unless archivo_informe.url.nil?
          url = archivo_informe.url
          nombre = File.basename(URI.parse(url).path)

          URI.open(url) do |file_data|
            stream.put_next_entry(nombre)
            stream.write file_data.read
          end
        end
      end
    end
    archivo_zip.rewind
    #enviamos el archivo para ser descargado
    send_data archivo_zip.sysread, type: 'application/zip', charset: "iso-8859-1", filename: "documentacion.zip"
  end

  private

    def set_tarea_pendiente
      @tarea_pendiente = TareaPendiente.find(params[:tarea_pendiente_id])
      autorizado? @tarea_pendiente
      @tarea = @tarea_pendiente.tarea #crea una instancia de tarea a través de la forean key de tarea_pendiente (primary de tarea)
    end

    def set_flujo
      @solo_lectura = @tarea_pendiente.solo_lectura(current_user, @tarea_pendiente)
      @flujo = @tarea_pendiente.flujo
      @tipo_instrumento=@flujo.tipo_instrumento
      @manifestacion_de_interes = @flujo.manifestacion_de_interes_id.blank? ? nil : ManifestacionDeInteres.find(@flujo.manifestacion_de_interes_id)
      @manifestacion_de_interes.update(tarea_codigo: @tarea.codigo) unless @manifestacion_de_interes.blank?
      @proyecto = @flujo.proyecto_id.blank? ? nil : Proyecto.find(@flujo.proyecto_id)
      @ppp = @flujo.programa_proyecto_propuesta_id.blank? ? nil : ProgramaProyectoPropuesta.find(@flujo.programa_proyecto_propuesta_id)

      if @tarea_pendiente.tarea_id == Tarea::ID_APL_032_1
        @adhesion = Adhesion.unscoped.where(id: params[:adhesion_externa_id]).first if !params[:adhesion_externa_id].blank?
        @adhesiones_externas = []
        Adhesion.unscoped.where(flujo_id: @flujo.id, externa: true).each do |adh|
          @adhesiones_externas << adh if adh.rut_representante_legal.gsub('k', 'K').gsub(".", "") == current_user.rut.gsub('k', 'K').gsub(".", "")
        end
      else
        # Se añade adhesiones ya que se estaba utilizando solo la primera, y se perdían valores. Se mantiene adhesiones para compatibilidad con otras tareas
        @adhesion = Adhesion.find_by(flujo_id: @flujo.id)
        @adhesiones = Adhesion.unscoped.where(flujo_id: @flujo.id)
      end

      if @tarea_pendiente.tarea_id == Tarea::ID_APL_032_1
        
      end
    end

    def set_auditorias
      
      @auditoria = Auditoria.find_by_id(@tarea_pendiente.data[:auditoria_id])
      @adhesion_elementos = @flujo.adhesion.adhesion_elementos #DZC elementos adheridos a 
      @auditorias = Auditoria.where(id: @auditoria_elementos.pluck(:auditoria_id)) #DZC auditorias

    end

    def set_auditoria
      @auditoria = Auditoria.find_by_id(@tarea_pendiente.data[:auditoria_id])
      aud_elem_archivos = AuditoriaElementoArchivo.where(auditoria_id: @auditoria.id)

      @archivos_auditoria = aud_elem_archivos.count > 0 ? aud_elem_archivos.map{|aea| {aea.id => aea.archivo.url}}.inject(:merge) : {}
      # DZC 2019-06-19 12:56:28 se mueve para correcto funcionamiento del algoritmo
      @auditoria_elementos = nil
      if @tarea.codigo == Tarea::COD_APL_032 #&& @auditoria.archivo_correcto #DZC 2019-06-19 12:57:04 se modifica para correcto funcionamiento del algoritmo
        adh_elems = []
        Adhesion.unscoped.where(flujo_id: @flujo.id).each do |_adh|
          adh_elems += _adh.adhesion_elemento_externos.pluck(:id)
        end
        @auditoria_elementos = AuditoriaElemento
        .includes(:auditoria, :set_metas_accion, adhesion_elemento: :alcance)
        .where(auditoria_id: @auditoria.id)
        .where(adhesion_elemento_id: adh_elems)
        .paginate(page: params[:page], per_page: 10) #.where(estado: [3,4]) #DZC elementos a auditar
        # DZC 2019-06-19 13:02:10 se agrega para ordernar la tabla de resultados
        @auditoria_elementos = @auditoria_elementos.order(:estado) if @auditoria_elementos.present?
      elsif @tarea.codigo == Tarea::COD_APL_032_1
        if params[:adhesion_externa_id].blank?
          @auditoria_elementos = []
        else
          adh_elems = @adhesion.adhesion_elemento_externos.pluck(:id)
          @auditoria_elementos = AuditoriaElemento.where(auditoria_id: @auditoria.id).where(adhesion_elemento_id: adh_elems) #.where(estado: [3,4]) #DZC elementos a auditar
          # DZC 2019-06-19 13:02:10 se agrega para ordernar la tabla de resultados
          @auditoria_elementos = @auditoria_elementos.order(:estado) if @auditoria_elementos.present?
        end
      elsif @tarea.codigo == Tarea::COD_APL_033
        @auditoria_elementos = AuditoriaElemento.where(auditoria_id: @auditoria.id).where(estado: [2]).where.not(adhesion_elemento_id: nil) #DZC elementos a auditar
      else #DZC APL-034
        @auditoria_elementos = AuditoriaElemento.where(auditoria_id: @auditoria.id).where(estado: [5]).where.not(adhesion_elemento_id: nil) #DZC elementos a auditar

        @auditoria_validacion = AuditoriaValidacion.find_or_create_by({auditoria_id: @auditoria.id, user_id: @tarea_pendiente.user_id})
        set_estado_validaciones(@auditoria_validacion.validaciones)
      end
      # DZC 2019-06-19 12:45:07 se comenta para correcto funcionamiento del algoritmo
      # @auditoria_elementos = nil
    end

    def set_estado_validaciones validaciones_data
      @elementos = []
      @auditoria_validacion_sin_guardar = AuditoriaValidacion.find_by({auditoria_id: @auditoria.id, user_id: @tarea_pendiente.user_id})
      @auditoria_elementos.each do |ae|
        validacion_estado_nombre = 'Por validar'
        validacion_estado_valor = nil
        validacion_justificacion = nil
        persiste = false
        if !validaciones_data.blank?
          validacion = validaciones_data[ae.id.to_s]
          if !validacion.nil?
            validacion_estado_nombre = validacion[:estado_nombre]
            validacion_estado_valor = validacion[:estado_valor]
            validacion_justificacion = validacion[:justificacion]
          end
          if !@auditoria_validacion_sin_guardar.nil? && !@auditoria_validacion_sin_guardar.validaciones.blank?
            validacion_bd = @auditoria_validacion_sin_guardar.validaciones[ae.id.to_s]
            persiste = (!validacion_bd.nil? && !validacion_bd[:estado_valor].nil? && validacion_bd[:estado_valor] != "" )
          end
        end
        adh = ae.adhesion_elemento
        aud = ae.auditoria
        @elementos << {
          contribuyente_rut_completo: adh.fila[:rut_institucion],
          auditoria_nombre: aud.nombre,
          auditoria_id: aud.id,
          alcance_nombre: adh.alcance.nombre,
          nombre_instalacion: adh.nombre_del_elemento_v2,
          id: ae.id,
          descripcion_accion: ae.set_metas_accion.descripcion_accion,
          aplica: ae.aplica,
          motivo: ae.motivo,
          cumple: ae.cumple,
          estado_detalle: ae.estado_detalle,
          archivo_evidencia_url: @archivos_auditoria[ae.archivo_evidencia_id],
          archivo_informe_url: @archivos_auditoria[ae.archivo_informe_id],
          validacion_estado_nombre: validacion_estado_nombre,
          validacion_estado_valor: validacion_estado_valor,
          validacion_justificacion: validacion_justificacion,
          persiste: persiste
        }
      end
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

end
