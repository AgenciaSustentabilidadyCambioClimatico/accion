class AdhesionesController < ApplicationController
	before_action :authenticate_user!
  before_action :set_tarea_pendiente
  before_action :set_flujo
	before_action :set_datos
  before_action :set_crea_archivo, only: [:descargar]

	def actualizar #DZC ACCESO A APL-025 PPF-016
	end

	def actualizar_guardar #DZC TAREA APL-025 PPF-016 TERMINO
    @adhesion.assign_attributes(adhesion_params)
		# @adhesion.manifestacion_de_interes_id = @manifestacion_de_interes.id
    @adhesion.flujo_id = @flujo.id
    @adhesion.is_ppf = @ppp.present?
    respond_to do |format|
      
      if @adhesion.save
        @rechazadas = []
        continua_flujo_segun_tipo_tarea
        if @tarea.codigo == Tarea::COD_PPF_016 || @tarea.codigo == Tarea::COD_PPF_017
          format.js { flash[:success] = "Adhesión solicitada correctamente"
            render js: "window.location='#{root_url}'" 
          }
        else
          format.js { flash[:success] = "Adhesión solicitada correctamente" }
        end
      else
      	# ap @adhesion.errors.messages
        format.js { flash.now[:error] = @adhesion.errors.messages}
      end
    end
	end

  def revisar #DZC APL-028

  end

  def revisar_guardar #DZC APL-028 PPF-017
    
    # @al_menos_se_acepto_uno = false
    aceptados = params[:aceptado]
    observaciones = params[:observacion]
    data = @pendientes

    aceptados.each do |k,v|
      
      datos = data[k.to_i]
      if v == "true"
        # @al_menos_se_acepto_uno = true
        #Ademas se pobla la tabla dato_productivo_elemento_adheridos
        @adhesion.poblar_data(datos, @flujo)
        data[k.to_i][:revisado] = true
        data[k.to_i][:observaciones] = observaciones[k]
      elsif v == "false"
        data[k.to_i][:revisado] = false
        data[k.to_i][:observaciones] = observaciones[k]
      else
        data[k.to_i][:revisado] = false
        data[k.to_i][:observaciones] = nil
      end
      
    end
    @adhesion.adhesiones_data = data
    # @adhesion.manifestacion_de_interes_id = @manifestacion_de_interes.id
    @adhesion.flujo_id = @flujo.id
    @adhesion.tipo = "revision"
    respond_to do |format|
      if @adhesion.save
        set_datos
        
        continua_flujo_segun_tipo_tarea 
        format.js { flash[:success] = "Adhesiones revisadas correctamente" }
      else
        format.js { flash.now[:error] = "Error al revisar adhesiones, reintente"}
      end
    end
  end

  def descargar 
    send_data File.open(@ruta).read, type: 'application/xslx', charset: "iso-8859-1", filename: "formato_adhesion.xlsx"
  end

  #DZC agrega al campo data de la tarea_pendiente 
  def continua_flujo_segun_tipo_tarea(condicion_de_salida=nil)
    case @tarea.codigo
    when Tarea::COD_APL_025
      @tarea_pendiente.pasar_a_siguiente_tarea ['A','C']
    when Tarea::COD_APL_028
      # DZC 2018-11-06 11:04:40 se modifica acorde a los cambios realizados en las condiciones de continuación de flujo
      # DZC 2018-11-08 14:58:14 se corrige erro en acceso a condición 'C'
       
      if @todas.present? && @todas[:aceptada].present? && (@tarea_pendiente.data.blank? || @tarea_pendiente.data!={primera_ejecucion: true})
        @tarea_pendiente.update(data: {primera_ejecucion: false})
        @tarea_pendiente.pasar_a_siguiente_tarea 'C', {}, false
      end
      @tarea_pendiente.pasar_a_siguiente_tarea 'A', {}, false

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

	private
	
    #asigna valor de id de tarea pendiente, leyendolo desde la URL (esto es neceario por que no se traspasa desde la jerarquia superior)
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
    end

		def set_datos
			# @manifestacion_de_interes = ManifestacionDeInteres.find(params[:id])
			@descargables = @tarea_pendiente.get_descargables
      # @adhesion = Adhesion.find_by(manifestacion_de_interes_id: @manifestacion_de_interes.id)
      
      @adhesion = Adhesion.find_by(flujo_id: @flujo.id)
			@adhesion = Adhesion.new(flujo_id: @flujo.id) if @adhesion.nil?
      @rechazadas = @adhesion.adhesiones_rechazadas
      @pendientes = @adhesion.adhesiones_pendientes
      @no_pendientes = @adhesion.adhesiones_aceptadas_y_observadas
      @todas = @adhesion.adhesiones_todas
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
      datos = @adhesion.desparseas_adhesiones_rechazadas unless @adhesion.new_record?
      dominios = Adhesion.dominios(@ppp.present?)
      @ruta = "#{Rails.root}/public/uploads/adhesion/"
      FileUtils.mkdir_p(@ruta) unless File.exist?(@ruta) #DZC crea las carpetas pertinentes para la ruta
      @ruta += "formato_adhesion.xlsx"
      ExportaExcel.formato(@ruta, titulos, dominios, datos, "Adhesiones" )
    end

end