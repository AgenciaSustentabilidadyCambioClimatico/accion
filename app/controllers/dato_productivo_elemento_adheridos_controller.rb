class DatoProductivoElementoAdheridosController < ApplicationController
  before_action :authenticate_user!
  before_action :set_tarea_pendiente
  before_action :set_flujo
  before_action :set_datos_productivos

  # GET /dato_productivo_elemento_adheridos 
  #DZC Accesso a Tarea PPF-020
  def edit
    if @datos_productivos.blank?
      flash[:warning] = 'No posee datos productivos que revisar' 
      redirect_to root_path
    end
  end

  def descargar_formato
    
    titulos = DatoProductivoElementoAdherido.columnas_excel
    datos_generados = DatoProductivoElementoAdherido.generar_data(@datos_productivos)
    datos = datos_generados[0]
    dominios = datos_generados[1]
    @ruta = "#{Rails.root}/public/uploads/dato_productivo_elemento_adherido/formato/#{@flujo.id}/descargado/"
    FileUtils.mkdir_p(@ruta) unless File.exist?(@ruta)
    @ruta += "DatoProductivoElementoAdherido.xlsx"
    
    ExportaExcel.formato(@ruta, titulos, dominios, datos, "DatoProductivoElementoAdherido")
    send_data File.open(@ruta).read, type: 'application/xslx', charset: "iso-8859-1", filename: "DatoProductivoElementoAdherido.xlsx"
  end

  def cargar_dato_productivo
    
    ruta = "uploads/dato_productivo_elemento_adherido/formato/#{@flujo.id}/subido/" #DZC path genérico
    uploaded_excel = params[:excell]

    #DZC Se modifica para subir los archivos y poder pasar archivos en reemplazo de los parametros al método 
    uploaded_pdf = params[:archivos] #DZC se agrega para que suba archivos y se pueda ejecutar data_dato_productivo_elementoAdherido

    #Se almacenan los archivos de evidencia
    if uploaded_pdf.present? #DZC se agrega subir los archivos PDFs
      ruta_pdf = ruta + "archivos_evidencia/"
      FileUtils.mkdir_p("#{Rails.root}/public/#{ruta_pdf}") unless File.exist?("#{Rails.root}/public/#{ruta_pdf}")
      uploaded_pdf.each do |up|
        File.open(Rails.root.join('public', ruta_pdf, up.original_filename), 'wb') do |file|
          file.write(up.read)
        end
      end  
    end

    #Se almacena el excell subido
    if uploaded_excel.present?
      ruta_excel = ruta + "datos_productivos/"
      FileUtils.mkdir_p("#{Rails.root}/public/#{ruta_excel}") unless File.exist?("#{Rails.root}/public/#{ruta_excel}")
      File.open(Rails.root.join('public', ruta_excel, uploaded_excel.original_filename), 'wb') do |file|
        file.write(uploaded_excel.read)
      end
      archivo_excel=[Pathname.new("#{Rails.root}/public/#{ruta_excel}"+uploaded_excel.original_filename).open] #DZC lee el archivo excel para enviarlo al método data_dato_productivo_elementoAdherido
      archivos_pdf=nil 
      if uploaded_pdf.present? #DZC construye un array de archivos pdf para envialos al método data_dato_productivo_elementoAdherido
        archivos_pdf=[]
        uploaded_pdf.each do |up|
          archivos_pdf << Pathname.new("#{Rails.root}/public/#{ruta_pdf}"+up.original_filename).open
        end
      end

      # Se pobla la tabla con los datos del excell
      @resultados = DatoProductivoElementoAdherido.data_dato_productivo_elementoAdherido(archivo_excel.first, archivos_pdf) #DZC ejecuta el método de poblamiento TODO: revisar funcionamiento
    end
    
    respond_to do |format|
      if @resultados.blank?     
        format.js { 
          flash[:success] = 'Datos productivos correctamente actualizados' 
          render js: "window.location.href='#{root_path}'"
        }
        format.html { redirect_to dato_productivo_elemento_adheridos_path(), notice: 'Datos productivos correctamente actualizada' }
        continua_flujo_segun_tipo_tarea
      else
        format.html { render :edit }
        format.js { flash[:error] = @resultados.to_sentence }
      end
    end
  end

  def continua_flujo_segun_tipo_tarea #DZC generalización de condiciones de continuación de flujo
    case @tarea.codigo
    when Tarea::COD_APL_029
      @tarea_pendiente.pasar_a_siguiente_tarea 'B'
    end
  end
  private
    def set_tarea_pendiente
      @tarea_pendiente = TareaPendiente.includes([:flujo]).find(params[:tarea_pendiente_id])
      autorizado? @tarea_pendiente
      @tarea = @tarea_pendiente.tarea
    end

    def set_flujo
      @flujo = @tarea_pendiente.flujo
      @tipo_instrumento = @flujo.tipo_instrumento
      @manifestacion_de_interes = @flujo.manifestacion_de_interes
    end

    def set_datos_productivos
      set_metas_acciones = @flujo.set_metas_acciones.where.not('materia_sustancia_id' => nil)
      @datos_productivos = DatoProductivoElementoAdherido.where(set_metas_accion_id: set_metas_acciones.pluck(:id))

      @archivos_evidencia = []
      @archivo_excel = nil

      ruta = "uploads/dato_productivo_elemento_adherido/formato/#{@flujo.id}/subido/"

      ruta_pdf = "#{Rails.root}/public/"+ruta+"archivos_evidencia/"
      if File.exist?(ruta_pdf)
        Dir.entries(ruta_pdf).each do |filename|
          @archivos_evidencia << Pathname.new(ruta_pdf+filename).open if !['.','..'].include?(filename)
        end
      end

      ruta_excel = "#{Rails.root}/public/"+ruta+"datos_productivos/"
      if File.exist?(ruta_excel)
        Dir.entries(ruta_excel).each do |filename|
          @archivo_excel = Pathname.new(ruta_excel+filename).open if !['.','..'].include?(filename)
        end
      end

      @dato_productivo = @datos_productivos.first

      @descargables = @tarea_pendiente.get_descargables
      @comentario_coordinador = nil
      data_tarea_025 = TareaPendiente.where(tarea_id: Tarea::ID_APL_025, flujo_id: @flujo.id).order(id: :asc).first.data
      @comentario_coordinador = data_tarea_025[:observacion_tarea_anterior][Rol::CARGADOR_DATOS_ACUERDO] if data_tarea_025.has_key?(:observacion_tarea_anterior)
    end
end
