class AdhesionesController < ApplicationController
	before_action :authenticate_user!, except: [:descargar]
  before_action :set_tarea_pendiente
  before_action :set_flujo
	before_action :set_datos
  before_action :set_crea_archivo, only: [:descargar]
  before_action :set_contribuyentes
  before_action :set_usuario_actor
  before_action :set_actores, only: [:actualizar]
  before_action :set_listado_adhesiones_temporal

	def actualizar #DZC ACCESO A APL-025 PPF-016
	end

  def actualizar_guardar #DZC TAREA APL-025 PPF-016 TERMINO
    
    # 1. Detectamos el tipo de flujo de forma segura
    es_flujo_excel = params.dig(:adhesion, :archivo_elementos).present?
    tiene_parametros_adhesion = params[:adhesion].present?

    if !es_flujo_excel
      # ─── FLUJO FORMULARIO MANUAL ──────────────────────────────────────
      @adhesion.listado_adhesiones = true
      # Aquí puedes cargar o inicializar las variables que tus partials manuales necesitan, por ejemplo:
      # @listado_adhesion = ListadoAdhesion.new
    else
      # ─── FLUJO EXCEL ──────────────────────────────────────────────────
      # (Tu lógica específica de excel si la hay)
    end 

    # 2. Procesamos el duplicado de archivos SOLO si la clave :adhesion está presente
    if tiene_parametros_adhesion
      @adhesion_new = Adhesion.new
      @adhesion_new.flujo_id = @flujo.id
      @adhesion_new.is_ppf = @ppp.present?
      @adhesion.tarea_id = @tarea.id if @tarea.present?
      @adhesion_new.archivos_adhesion_y_documentacion = @adhesion.archivos_adhesion_y_documentacion
      @adhesion_new.save!
      
      # Solo asignamos si pasó el filtro del require
      @adhesion.assign_attributes(adhesion_params)
    end

    # 3. Seteos transversales antes de guardar
    @adhesion.flujo_id = @flujo.id
    @adhesion.is_ppf = @ppp.present?

    respond_to do |format|
      if @adhesion.save
        
        @rechazadas = []
        continua_flujo_segun_tipo_tarea

        if @tarea.codigo == Tarea::COD_PPF_016 || @tarea.codigo == Tarea::COD_PPF_017
          
          format.js { 
            flash[:success] = "Adhesión solicitada correctamente"
            render js: "window.location='#{root_url}'" 
          }
        elsif @tarea.codigo == Tarea::COD_APL_025
          
          if !es_flujo_excel
            ListadoAdhesionesTemporal.actualiza_estado_listado_adhesiones(@flujo.id)  
          end
          
          format.js { 
            flash[:success] = "Adhesión solicitada correctamente"
            render js: "window.location='#{actualizar_adhesion_path(@tarea_pendiente)}'" 
          }
        else
          format.js { flash[:success] = "Adhesión solicitada correctamente" }
        end
      else
        # 🚨 SI EL GUARDADO FALLA: Para evitar el 'model_name for nil:NilClass',
        # debemos re-inicializar AQUÍ todas las variables que usan tus sub-formularios renderizados
        @listado_adhesion = ListadoAdhesionesTemporal.new 
        
        format.js { flash.now[:error] = @adhesion.errors.messages }
      end
    end
  end

  def revisar #DZC APL-028
    respond_to do |format|
      format.xlsx {
        response.headers[
          'Content-Disposition'
        ] = "attachment; filename=Consolidado_Adhesiones.xlsx"
      }
      format.html { render :revisar }
    end
  end

  # def revisar_guardar #DZC APL-028 PPF-017
  #   # @al_menos_se_acepto_uno = false
  #   seleccionados = params[:adhesion][:elementos_seleccionados]
  #   estado = params[:adhesion][:estado_elementos]
  #   justificacion = params[:adhesion][:justificacion_elementos]
  #   @adhesion.estado_elementos = estado
  #   @adhesion.justificacion_elementos = justificacion
  #   @adhesion.validar_clasificar = true

  #   respond_to do |format|
  #     if @adhesion.valid?
  #       data = @pendientes

  #       seleccionados.each do |seleccionado|
          
  #         datos = data[seleccionado.to_i]
  #         if estado == "true"
  #           # @al_menos_se_acepto_uno = true
  #           #Ademas se pobla la tabla dato_productivo_elemento_adheridos
  #           data[seleccionado.to_i][:revisado] = true
  #           data[seleccionado.to_i][:observaciones] = justificacion
  #           @adhesion.poblar_data(datos, @flujo)
  #         elsif estado == "false"
  #           data[seleccionado.to_i][:revisado] = false
  #           data[seleccionado.to_i][:observaciones] = justificacion
  #         else
  #           data[seleccionado.to_i][:revisado] = false
  #           data[seleccionado.to_i][:observaciones] = nil
  #         end
          
  #       end
  #       @adhesion.adhesiones_data = data
  #       # @adhesion.manifestacion_de_interes_id = @manifestacion_de_interes.id
  #       @adhesion.flujo_id = @flujo.id
  #       @adhesion.tipo = "revision"
  #       @adhesion.save
  #       set_datos
        
  #       continua_flujo_segun_tipo_tarea 
  #       format.js { flash[:success] = "Adhesiones revisadas correctamente" }
  #     else
  #       format.js { }
  #     end
  #   end
  # end

  def revisar_guardar #DZC APL-028 PPF-017
    
    correcto = false
    ActiveRecord::Base.transaction do
      # @al_menos_se_acepto_uno = false
      aceptados = params[:aceptado]
      observaciones = params[:observacion]
      data = @por_revisar_todas
      adh = nil
      procesar_tareas_25 = []

      aceptados.each do |k,v|

        key = k.split("|")
        adhesion_id = key.first
        posicion = key.last
        nueva_adhesion = false
        
        if adh.nil? || adh.id.to_s != adhesion_id.to_s
          adh = Adhesion.unscoped.find(adhesion_id) 
          nueva_adhesion = true
        end
        idx = 0
        datos = nil
        data[adh.id].each_with_index do |fila, _idx|
          if fila[:posicion].to_s == posicion.to_s
            datos = fila
            idx = _idx
          end
        end
        if v == "true"
          # @al_menos_se_acepto_uno = true
          #Ademas se pobla la tabla dato_productivo_elemento_adheridos
          
          data[adh.id][idx][:revisado] = true
          data[adh.id][idx][:observaciones] = observaciones[k]
          @adhesion.poblar_data(datos, @flujo, adh.archivos_adhesion_y_documentacion.first.url, adh)

          procesar_tareas_25 << adh if adh.externa && nueva_adhesion
        elsif v == "false"
          data[adh.id][idx][:revisado] = false
          data[adh.id][idx][:observaciones] = observaciones[k]
          #si observo debo crear igual datos de usuario para tareas 25.1 y 25.2
          procesar_tareas_25 << adh if adh.externa && nueva_adhesion
        else
          data[adh.id][idx][:revisado] = false
          data[adh.id][idx][:observaciones] = nil
        end
        
      end

      procesar_tareas_25.each do |adh|
        adh.crear_data_nuevas_tareas_25
      end
      @adhesiones.each do |adh|
        if !data[adh.id].blank?
          adh.adhesiones_data = data[adh.id]
          # @adhesion.manifestacion_de_interes_id = @manifestacion_de_interes.id
          adh.flujo_id = @flujo.id
          adh.tipo = "revision"
          correcto = true if adh.save
        end
      end
    end
    respond_to do |format|
      if correcto
        set_datos
        
        continua_flujo_segun_tipo_tarea 
        format.js { flash[:success] = "Adhesiones revisadas correctamente" }
      else
        format.js { flash.now[:error] = "Error al revisar adhesiones, reintente"}
      end
    end
  end

  def retirar_elemento

    ae = AdhesionElemento.find(params[:adhesion][:elemento_retirado_id])
    @adhesion = ae.adhesion
    @adhesion.elemento_retirado_id = params[:adhesion][:elemento_retirado_id]

    aer = AdhesionElementoRetirado.new

    fila = ae.fila
    fila[:fecha_retiro] = Date.today

    aer.adhesion_id = ae.adhesion_id
    aer.persona_id = ae.persona_id
    aer.alcance_id = ae.alcance_id
    aer.establecimiento_contribuyente_id = ae.establecimiento_contribuyente_id
    aer.maquinaria_id = ae.maquinaria_id
    aer.otro_id = ae.otro_id
    aer.fila = fila
    aer.adhesion_externa_id = ae.adhesion_externa_id
    #copiar archivos
    #aer.archivo_adhesion = File.open(ae.archivo_adhesion.file.file) if ae.archivo_adhesion.present?
    #aer.archivo_respaldo = File.open(ae.archivo_respaldo.file.file) if ae.archivo_respaldo.present?
    aer.archivo_retiro = params[:adhesion][:documento_justificacion]

    respond_to do |format|

      if aer.valid?
        aer.save
        begin
          AuditoriaElemento.where(adhesion_elemento_id: ae.id).destroy_all
        rescue
          AuditoriaElemento.where(adhesion_elemento_id: ae.id).update_all(adhesion_elemento_id: nil)
        end
        begin
          DatoProductivoElementoAdherido.where(adhesion_elemento_id: ae.id).destroy_all
        rescue
          DatoProductivoElementoAdherido.where(adhesion_elemento_id: ae.id).update_all(adhesion_elemento_id: nil)
        end
        ae.destroy
        set_datos

        format.js { 
          flash[:success] = "Elemento retirado correctamente"
        }
      else
        #pasamos error de archivo a adhesion
        @adhesion.errors.add(:documento_justificacion, aer.errors[:archivo_retiro].first)
        format.js {}
      end
    end
  end

  def descargar
    #enviamos el archivo para ser descargado
    send_data @archivo.to_stream.read, type: 'application/xslx', charset: "iso-8859-1", filename: "formato_adhesion.xlsx"
  end

  def descargar_compilado
    require 'zip'
    require 'open-uri'
    archivo_zip = Zip::OutputStream.write_buffer do |stream|
      if params[:aid].blank?
        @adhesiones_todas = Adhesion.unscoped.where(flujo_id: @flujo.id)
        @adhesiones_todas.each do |adhesion|
          next if adhesion.archivos_adhesion_y_documentacion.blank?
          adhesion.archivos_adhesion_y_documentacion.each do |archivo|

            next if archivo.blank? || archivo.url.blank?
            url = archivo.url

            # 🔥 nombre único (clave)
            nombre = "adhesion_#{adhesion.id}_#{archivo.identifier}"

            begin
              URI.open(url) do |file_data|
                stream.put_next_entry(nombre)
                stream.write file_data.read
              end
            rescue => e
              Rails.logger.error "Error descargando archivo #{url}: #{e.message}"
            end
          end
        end
      else
        @adhesiones_todas = Adhesion.unscoped.where(flujo_id: @flujo.id)
        @adhesiones_todas.each do |adhesion|
          adhesion.archivos_adhesion_y_documentacion.each do |archivo|
            unless archivo.url.nil?
              if params[:nombre_archivo] == archivo.file.path.split('/').last
                if archivo.model.id == params[:aid].to_i
                  url = archivo.url
                  nombre = File.basename(URI.parse(url).path)
                  URI.open(url) do |file_data|
                    stream.put_next_entry(nombre)
                    stream.write file_data.read
                  end
                end
              end
            end
          end
        end
      end
    end
    archivo_zip.rewind
    # archivo_zip.read
    #enviamos el archivo para ser descargado
    send_data archivo_zip.sysread, type: 'application/zip', charset: "iso-8859-1", filename: "documentacion.zip"
  end

  def descargar_compilado_two
    require 'zip'
    archivo_zip_two = Zip::OutputStream.write_buffer do |stream|
      @adhesiones_todas = Adhesion.unscoped.where(flujo_id: @flujo.id)
      @adhesiones_todas.each do |adhesion|
        cuenta = adhesion.archivos_adhesion_y_documentacion.count
        numero_descarga = cuenta / 3
        adhesion.archivos_adhesion_y_documentacion.first(numero_descarga).each do |archivo|
          if File.exists?(archivo.path)
            #nombre = archivo.file.identifier
            if adhesion.externa
              nombre = "#{adhesion.rut_institucion_adherente} - #{adhesion.nombre_institucion_adherente} - #{archivo.file.identifier}"
            else
              c = adhesion.flujo.manifestacion_de_interes.contribuyente
              nombre = "#{c.rut}-#{c.dv} - #{c.razon_social} - #{archivo.file.identifier}"
            end
            # rename the file
            stream.put_next_entry(nombre)
            # add file to zip
            stream.write IO.read((archivo.current_path rescue archivo.path))
          end
        end
      end
    end
    archivo_zip_two.rewind
    #enviamos el archivo para ser descargado
    send_data archivo_zip_two.sysread, type: 'application/zip', charset: "iso-8859-1", filename: "documentacion_parte_1.zip"
  end

  def descargar_compilado_three
    require 'zip'
    archivo_zip_two = Zip::OutputStream.write_buffer do |stream|
      @adhesiones_todas = Adhesion.unscoped.where(flujo_id: @flujo.id)
      @adhesiones_todas.each do |adhesion|
        cuenta = adhesion.archivos_adhesion_y_documentacion.count
        numero_descarga = cuenta / 3
        adhesion.archivos_adhesion_y_documentacion.drop(numero_descarga).first(numero_descarga + 1).each do |archivo|
          if File.exists?(archivo.path)
            #nombre = archivo.file.identifier
            if adhesion.externa
              nombre = "#{adhesion.rut_institucion_adherente} - #{adhesion.nombre_institucion_adherente} - #{archivo.file.identifier}"
            else
              c = adhesion.flujo.manifestacion_de_interes.contribuyente
              nombre = "#{c.rut}-#{c.dv} - #{c.razon_social} - #{archivo.file.identifier}"
            end
            # rename the file
            stream.put_next_entry(nombre)
            # add file to zip
            stream.write IO.read((archivo.current_path rescue archivo.path))
          end
        end
      end
    end
    archivo_zip_two.rewind
    #enviamos el archivo para ser descargado
    send_data archivo_zip_two.sysread, type: 'application/zip', charset: "iso-8859-1", filename: "documentacion_parte_2.zip"
  end

  def descargar_compilado_four
    require 'zip'
    archivo_zip_two = Zip::OutputStream.write_buffer do |stream|
      @adhesiones_todas = Adhesion.unscoped.where(flujo_id: @flujo.id)
      @adhesiones_todas.each do |adhesion|
        cuenta = adhesion.archivos_adhesion_y_documentacion.count
        numero_descarga = cuenta / 3
        adhesion.archivos_adhesion_y_documentacion.drop(numero_descarga * 2).each do |archivo|
          if File.exists?(archivo.path)
            #nombre = archivo.file.identifier
            if adhesion.externa
              nombre = "#{adhesion.rut_institucion_adherente} - #{adhesion.nombre_institucion_adherente} - #{archivo.file.identifier}"
            else
              c = adhesion.flujo.manifestacion_de_interes.contribuyente
              nombre = "#{c.rut}-#{c.dv} - #{c.razon_social} - #{archivo.file.identifier}"
            end
            # rename the file
            stream.put_next_entry(nombre)
            # add file to zip
            stream.write IO.read((archivo.current_path rescue archivo.path))
          end
        end
      end
    end
    archivo_zip_two.rewind
    #enviamos el archivo para ser descargado
    send_data archivo_zip_two.sysread, type: 'application/zip', charset: "iso-8859-1", filename: "documentacion_parte_2.zip"
  end

  #DZC agrega al campo data de la tarea_pendiente 
  def continua_flujo_segun_tipo_tarea(condicion_de_salida=nil)
    case @tarea.codigo
    when Tarea::COD_APL_025
      @tarea_pendiente.pasar_a_siguiente_tarea ['A'], {}, false
    when Tarea::COD_APL_028
      # DZC 2018-11-06 11:04:40 se modifica acorde a los cambios realizados en las condiciones de continuación de flujo
      # DZC 2018-11-08 14:58:14 se corrige erro en acceso a condición 'C'
      if !@aceptadas_todas.blank? && (@tarea_pendiente.data.blank? || @tarea_pendiente.data!={primera_ejecucion: true})
        #@tarea_pendiente.update(data: {primera_ejecucion: false})#no se para que se usa, no encontree el sentido
        @tarea_pendiente.pasar_a_siguiente_tarea 'C', {}, false

        adhesion_base = Adhesion.find_by(flujo_id: @flujo.id)
        if !adhesion_base.nil? && !@aceptadas_todas.empty?
          @tarea_pendiente.pasar_a_siguiente_tarea 'A', {}, false
        end

        auditorias = Auditoria.where(flujo_id: @flujo.id).map{|a| {auditoria_id: a.id}}

        Adhesion.unscoped.where(id: @aceptadas_todas.keys, externa: true).each do |adh|

          representante_legal = User.where(rut: adh.rut_representante_legal.to_s.gsub('k', 'K').gsub(".", "")).first
          _rut_institucion_adherente = adh.rut_institucion_adherente.gsub(".","").gsub("k","K").split('-')
          contribuyente = Contribuyente.find_by(rut: _rut_institucion_adherente.first)
          representante_persona = representante_legal.personas.where(contribuyente_id: contribuyente.id).first if !contribuyente.nil?



          if !representante_legal.nil? && !representante_persona.nil?
            auditorias.each do |extra|
              tp = TareaPendiente.find_or_create_by({
                flujo_id: @flujo.id, 
                tarea_id: Tarea::ID_APL_032_1, 
                estado_tarea_pendiente_id: EstadoTareaPendiente::NO_INICIADA, 
                user_id: representante_legal.id, 
                data: extra,
                persona_id: representante_persona.id
              })
            end
          end
        end
      end

      # auditorias=Auditoria.where(manifestacion_de_interes_id: @manifestacion_de_interes.id).pluck(:final)
      # @tarea_pendiente.pasar_a_siguiente_tarea 'C', {}, false
      # if (!auditorias.include?(nil) && !auditorias.include?(false))
      #   @tarea_pendiente.pasar_a_siguiente_tarea 'A'
      # end
    when Tarea::COD_PPF_016, Tarea::COD_PPF_017
      if @tarea_pendiente.data == {primera_ejecucion: true}
        @tarea_pendiente.update(data: {primera_ejecucion: false})
        @tarea_pendiente.pasar_a_siguiente_tarea 'A', {primera_ejecucion: true}, false
      end
    end    
  end

  def crear_adhesion
    @listado_adhesiones = ListadoAdhesionesTemporal.new
    
    # 1. Convertimos a Hash asegurando "with_indifferent_access" 
    # Esto permite buscar tanto con datos[:rut] como con datos['rut'] sin errores
    datos = sanitize_rut(listado_adhesiones_temporal_params.to_h).with_indifferent_access
    @listado_adhesiones.assign_attributes(datos)
    @listado_adhesiones.flujo_id = @flujo.id
    @listado_adhesiones.fecha_adhesion = Time.now.strftime("%d/%m/%Y")

    # 2. Ahora 'datos[:rut_institucion]' funcionará de forma segura
    contribuyente = Contribuyente.find_by(rut: datos[:rut_institucion])
    
    if contribuyente.present?
      # Usamos &. para navegación segura por si un contribuyente no tiene establecimientos
      casa_matriz = contribuyente.establecimiento_contribuyentes.find_by(casa_matriz: true)
      
      @listado_adhesiones.direccion_casa_matriz = casa_matriz&.direccion || ''
      @listado_adhesiones.comuna_casa_matriz    = casa_matriz&.comuna.nombre || ''
    else
      @listado_adhesiones.direccion_casa_matriz = ''
      @listado_adhesiones.comuna_casa_matriz    = ''
    end
       
    # 3. 🚀 Usamos .save! (con signo de exclamación) en ambiente de desarrollo/debug
    # Si algo falla, romperá la ejecución y te dirá EXACTAMENTE qué validación falló.
    if @listado_adhesiones.save
      # Si guardó con éxito, redirige o procesa
      listado_adhesiones_temporal
    else
      # Si no guardó, puedes poner un binding.pry aquí para revisar: @listado_adhesiones.errors.full_messages
      render :new # o la acción que corresponda si falla
    end
  end

  def eliminar_adhesion
    adhesion = ListadoAdhesionesTemporal.find(params[:adhesion_id])

    if adhesion.destroy
      @listado_adhesiones_temporal = ListadoAdhesionesTemporal.where(flujo_id: adhesion.flujo_id, estado: 0)
      @tarea_pendiente = TareaPendiente.find_by(flujo_id: adhesion.flujo_id)

      respond_to do |format|
        format.js { render 'adhesiones/eliminar_adhesion', locals: { adhesion: adhesion.id } }
      end
    else
      flash[:error] = 'Hubo un problema al eliminar al adhesion.'
    end
  end

  def listado_adhesiones_temporal
    @listado_adhesiones_temporal = ListadoAdhesionesTemporal.where(flujo_id: @tarea_pendiente.flujo_id, estado: 0).order(id: :asc).all
    respond_to do |format|
      format.js { render 'adhesiones/listado_adhesiones_temporal', locals: { manifestacion_de_interes_id: @tarea_pendiente.flujo.manifestacion_de_interes_id } }
    end
  end

	private
	
    #asigna valor de id de tarea pendiente, leyendolo desde la URL (esto es neceario por que no se traspasa desde la jerarquia superior)
    def set_tarea_pendiente
      @tarea_pendiente = TareaPendiente.find(params[:tarea_pendiente_id])
      autorizado? @tarea_pendiente if params[:action] != "descargar"
      @tarea = @tarea_pendiente.tarea #crea una instancia de tarea a través de la forean key de tarea_pendiente (primary de tarea)
      @tarea = Tarea.find(params[:tarea_id]) if !params[:tarea_id].blank?
    end

    #DZC define el flujo y tipo_instrumento, junto con la manifestación o el proyecto según corresponda, para efecto de completar datos. El id de la manifestación se obtiene del flujo correspondiente a la tarea pendiente.
    def set_flujo
      @solo_lectura = @tarea_pendiente.present? ? @tarea_pendiente.solo_lectura(current_user, @tarea_pendiente) : nil
      @flujo = @tarea_pendiente.flujo
      @tipo_instrumento=@flujo.tipo_instrumento
      @manifestacion_de_interes = @flujo.manifestacion_de_interes_id.blank? ? nil : ManifestacionDeInteres.find(@flujo.manifestacion_de_interes_id)
      @manifestacion_de_interes.update(tarea_codigo: @tarea.codigo) unless @manifestacion_de_interes.blank?
      @proyecto = @flujo.proyecto_id.blank? ? nil : Proyecto.find(@flujo.proyecto_id)
      @ppp = @flujo.programa_proyecto_propuesta_id.blank? ? nil : ProgramaProyectoPropuesta.find(@flujo.programa_proyecto_propuesta_id)
    end

		def set_datos
			# @manifestacion_de_interes = ManifestacionDeInteres.find(params[:id])
			@descargables = @tarea_pendiente.get_descargables
      # @adhesion = Adhesion.find_by(manifestacion_de_interes_id: @manifestacion_de_interes.id)
      if @tarea_pendiente.data[:externa]
        @adhesiones_externas = []
        Adhesion.unscoped.where(flujo_id: @flujo.id, externa: true).each do |adh|
          @adhesiones_externas << adh if adh.rut_representante_legal.gsub('k', 'K').gsub(".", "") == current_user.rut.gsub('k', 'K').gsub(".", "")
        end
      end
      if @tarea_pendiente.data[:externa] && !params[:adhesion_externa_id].blank?
        @adhesion = Adhesion.unscoped.where(id: params[:adhesion_externa_id]).first
      else
        @adhesion = Adhesion.where(flujo_id: @flujo.id).first if @adhesion.nil?
  			@adhesion = Adhesion.new(flujo_id: @flujo.id) if @adhesion.nil?
      end

      @rechazadas = @adhesion.adhesiones_rechazadas
      @pendientes = @adhesion.adhesiones_pendientes
      @no_pendientes = @adhesion.adhesiones_aceptadas_y_observadas
      @retiradas = @adhesion.adhesiones_retiradas
      @todas = @adhesion.adhesiones_todas

      @adhesiones = Adhesion.unscoped.where(flujo_id: @flujo.id)
      @adhesion_todas_sin_unscoped = Adhesion.where(flujo_id: @flujo.id)
      @todas_mias = @adhesion.adhesiones_todas_mias
      @rechazadas_todas = {}
      @pendientes_todas = {}
      @no_pendientes_todas = {}
      @retiradas_todas = {}
      @aceptadas_todas = {}
      @todas_todas = {}
      @por_revisar_todas = {}
      @todas_las_mias = {}
      @adhesiones.each do |adh|
        @rechazadas_todas[adh.id] = adh.adhesiones_rechazadas
        @pendientes_todas[adh.id] = adh.adhesiones_pendientes
        @no_pendientes_todas[adh.id] = adh.adhesiones_aceptadas_y_observadas
        @retiradas_todas[adh.id] = adh.adhesiones_retiradas
        _adh_aceptadas = adh.adhesiones_aceptadas_mias
        @aceptadas_todas[adh.id] = _adh_aceptadas if !_adh_aceptadas.blank?
        @todas_todas[adh.id] = adh.adhesiones_todas
        @por_revisar_todas[adh.id] = adh.adhesiones_por_revisar

      end

      @adhesion_todas_sin_unscoped.each do |adhe|
        @todas_las_mias[adhe.id] = adhe.adhesiones_todas_mias
      end

      @adhesion_todas_sin_unscoped.each do |adhe|
        @todas_las_mias[adhe.id] = adhe.adhesiones_todas_mias
      end
		end

		def adhesion_params
      params.require(:adhesion).permit(
        :archivo_elementos,
        :archivo_elementos_cache,
        :archivos_adhesion_y_documentacion_cache,
        archivos_adhesion_y_documentacion: []
      )
		end

    def set_crea_archivo
      titulos = Adhesion.columnas_excel
      datos = []
      if [Tarea::ID_APL_025_1,Tarea::ID_APL_025_2,Tarea::ID_APL_025_3].include?(@tarea.id)
        data_primera_fila = [
          "",
          params[:ri],#rut institucionm
          params[:ni],#nombre institucion
          "",
          params[:ti],#tipo institucion
          "",
          params[:md],#matriz direccion
          params[:mc],#matriz comuna,
          params[:rr],#rut representante
          params[:nr],#nombre representante
          "",
          params[:fr],#fono representante
          params[:er],#email representante
          "",
          "",
          "",
          "",
          "",
          "",
          "",
          "",
          ""
        ]
        datos = [data_primera_fila]
      else
        datos = @adhesion.desparseas_adhesiones_rechazadas unless @adhesion.new_record?
      end
      dominios = Adhesion.dominios(@ppp.present?)
      @archivo = ExportaExcel.formato(nil, titulos, dominios, datos, "Adhesiones" )
    end

    def set_contribuyentes
      @contribuyente = Contribuyente.new
      @contribuyentes = Contribuyente.where(id: @personas.map{|m|m[:contribuyente_id]}).all
      @contribuyente_adhesion = Contribuyente.new
    end

    def set_usuario_actor
      @usuario_adhesion = User.new
    end

    def set_actores
      @listado_adhesiones = ListadoAdhesionesTemporal.new
      @listado_adhesiones = ListadoAdhesionesTemporal.where(flujo_id: params[:id])
      @listado_adhesion = ListadoAdhesionesTemporal.new
    end

    def set_listado_adhesiones_temporal
      @listado_adhesiones_temporal = ListadoAdhesionesTemporal.where(flujo_id:  @tarea_pendiente.flujo_id, estado: 0).order(id: :asc).all
    end

    def listado_adhesiones_temporal_params
    params.require(:listado_adhesiones_temporal).permit(
      :fecha_adhesion,
      :rut_institucion,
      :nombre_institucion,
      :sector_productivo,
      :tipo_institucion,
      :tamano_empresa,
      :direccion_casa_matriz,
      :comuna_casa_matriz,
      :rut_encargado,
      :nombre_encargado,
      :cargo_encargado,
      :fono_encargado,
      :email_encargado,
      :alcance,
      :nombre_instalacion,
      :direccion_instalacion,
      :comuna_instalacion,
      :tipo_elemento,
      :identificador,
      :patente,
      :nombre_elemento,
      :nombre_archivo,
      :flujo_id)
  end

  def sanitize_rut(params)
    params["rut_encargado"]&.gsub!('.', '')
    params["rut_institucion"]&.gsub!('.', '')
    params
  end
end
