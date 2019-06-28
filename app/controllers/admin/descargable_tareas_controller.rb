class Admin::DescargableTareasController < ApplicationController
  protect_from_forgery with: :exception, unless: proc{action_name == 'previsualizacion'}
  before_action :authenticate_user!
  before_action :set_tarea
#DZC Gini
  before_action :set_tarea_pendiente, only: [:descargar], if: -> { params[:tarea_pendiente_id].present? }
#DZC
  before_action :set_descargable, only: [:edit, :update, :destroy, :descargar]
#  before_action :metodos
#DZC Gino 
 before_action :usar_metodos_del_instrumento
#DZC

  def index
    @descargable_tareas = DescargableTarea.where(tarea_id: @tarea.id).order(id: :asc).all
  end

  def new
    @descargable = DescargableTarea.new
  end

  def edit
  end

  def create
    @descargable = DescargableTarea.new(descargable_params)
    
    # if @descargable.subido == false
    #   @descargable.archivo = @descargable.file(@metodos)
    #   File.open(ruta).read
    # end
    @descargable.tarea_id = @tarea.id
    respond_to do |format|
      if @descargable.valid?
        if @descargable.subido
          @descargable.formato = @descargable.archivo.file.extension.downcase
        end
        @descargable.save
        format.js { 
          flash.now[:success] = 'Descargable correctamente creado.'
          @descargable = DescargableTarea.new
        }
        format.html { redirect_to edit_admin_descargable_url(@descargable), notice: 'Descargable correctamente creado.' }
      else
        format.html { render :new }
        format.js
      end
    end
  end

  def descargar
    # DZC 2018-10-04 19:35:51 se corrige error en funcionamiento del método en la vista del mantenedor de descargables
    if params["tarea_pendiente"].present?
      tarea_pendiente = TareaPendiente.find(params["tarea_pendiente"])
      # tarea_pendiente = TareaPendiente.find(params[:"tarea_pendiente"][:tarea_pendiente].to_i) if params[:"tarea_pendiente"][:tarea_pendiente].present?
      tipo_flujo = tarea_pendiente.flujo.tipo_de_flujo if tarea_pendiente.present?

      # DZC 2019-06-18 15:41:31 se modifica para el caso de que no se trate de una tarea pendiente
      case tipo_flujo
      when "APL"
        manifestacion_de_interes = tarea_pendiente.flujo.manifestacion_de_interes
        if manifestacion_de_interes.representante.present?
          representante = manifestacion_de_interes.representante.nombre_completo
        else
          representante = "No definido"
        end 
        if manifestacion_de_interes.institucion_gestora.present?
          entidad_cogestora = manifestacion_de_interes.institucion_gestora.razon_social
        else
          entidad_cogestora = "No definido"
        end       
        @metodos[:"[representante_entidad_cogestora]"] = representante
        @metodos[:"[nombre_entidad_cogestora]"] = entidad_cogestora
      when "PPF"
        ppp = tarea_pendiente.flujo.ppp
        if ppp.representante.present?
          representante = ppp.representante.nombre_completo
        else
          representante = "No definido"
        end
        if ppp.institucion_gestora.present?
          entidad_cogestora = ppp.institucion_gestora.razon_social
        else
          entidad_cogestora = "No definido"
        end        
        @metodos[:"[representante_entidad_cogestora]"] = representante
        @metodos[:"[nombre_entidad_cogestora]"] = entidad_cogestora
      end
    end

    ruta= @descargable.archivo.path
    if ruta.present? && File.exist?(ruta)
      send_data File.open(ruta).read, type: 'application/xslx', charset: "iso-8859-1", filename: ruta.split("/").last.to_s
    elsif @descargable.subido == false && @descargable.contenido.present?
      file = @descargable.file(@metodos)
      send_data file[:content], type: "application/#{file[:format]}", charset: "iso-8859-1", filename: file[:filename] if !file.blank?     
    else
      respond_to do |format|
        format.html { redirect_to admin_tarea_descargable_tareas_path(@tarea, @descargable), flash: {error: "El archivo no existe" }}
        format.js { }
      end
    end
    # @descargable = DescargableTarea.new(descargable_params) if @descargable.blank?
    # file = @descargable.archivo
    # send_data file[:content], type: "application/#{file[:format]}", charset: "iso-8859-1", filename: file[:filename] if !file.blank? #DZC para el caso de que el archivo no exista
  end

  #Se modifica para que permita generar archivos desde donde se generan los descargables.-
  def descargar_formato
    @descargable = DescargableTarea.new(descargable_params) if @descargable.blank?
    file = @descargable.file(@metodos)
    send_data file[:content], type: "application/#{file[:format]}", charset: "iso-8859-1", filename: file[:filename] if !file.blank? #DZC para el caso de que el archivo no exista
  end

  def previsualizacion
    sizes = { small: 10, normal: 13, large: 20, huge: 32 }
    data = DescargableTarea.__contenido(@metodos,params[:data].to_s.as_hash,130,:justify,sizes)
    data.dup.each_with_index do |line,index|
      if line[:value] == "\n"
        data[index][:value] = "<br />"
      end
    end
    respond_to do |format|
      format.json { render json: data }
    end
  end

  def update
    respond_to do |format|
      if @descargable.update(descargable_params)        
        if descargable_params["subido"] == "false"
          @descargable.remove_archivo!
          @descargable.save
        end
        format.js { flash.now[:success] = 'Descargable correctamente actualizado.' }
        format.html { redirect_to edit_admin_descargable_url(@descargable), notice: 'Descargable correctamente actualizado.' }
      else
        format.html { render :edit }
        format.js
      end
    end
  end

  def destroy
    @descargable.destroy
    @descargable_tareas = DescargableTarea.where(tarea_id: @tarea.id).order(id: :desc).all
  end

  private
#    def metodos #modificar agregando nombre de instancias de los distintos flujos. Se debe modifcar la tabla "variable" agregando el campo flujo_id, y poblar en la medida que se crea un flujo
#DZC Gino
    def metodos(campo_acuerdo=nil,nombre_entidad=nil)
#DZC
      director = Variable.where(nombre: :nombre_director_ascc).first
      persona = current_user.personas.first
      contribuyente = persona.blank? ? nil : persona.contribuyente
#DZC Gino
      campo_acuerdo = campo_acuerdo.blank? ? "Acuerdo de Producción Limpia para Certificación de Instalaciones" : campo_acuerdo
      nombre_entidad = nombre_entidad.blank? ? ( contribuyente.blank? ? '--' : contribuyente.razon_social ) : nombre_entidad
#DZC
#DZC lo de antes de Gino
#      @metodos = {
#        "[campo_acuerdo]": "Acuerdo de Producción Limpia para Certificación de Instalaciones",
#        "[nombre_director_ascc]": director.blank? ? '--' : director[:valor],
#        "[fecha_hoy]": (l(Date.today,format: "%A, %d de %B %Y")),
#        "[representante_entidad_cogestora]": current_user.nombre_completo, 
#        "[nombre_entidad_cogestora]": contribuyente.blank? ? '--' : contribuyente.razon_social, 
#      }
#DZC
#DZC Gino
      @metodos = {
        "[campo_acuerdo]": campo_acuerdo,
        "[nombre_director_ascc]": director.blank? ? '--' : director[:valor],
        "[fecha_hoy]": (l(Date.today,format: "%A, %d de %B %Y")),
        "[representante_entidad_cogestora]": current_user.nombre_completo, 
        "[nombre_entidad_cogestora]": nombre_entidad, 
      }
#DZC
    end

    def set_tarea
      @tarea = Tarea.find(params[:tarea_id])
    end
#DZC Gino
    def set_tarea_pendiente
      
      @tarea_pendiente = TareaPendiente.find(params[:tarea_pendiente_id])
      autorizado? @tarea_pendiente
    end
#DZC

    def set_descargable
      @descargable = DescargableTarea.find(params[:id])
    end
#DZC Gino
    # Este método está pensando para reemplazar los tags de cada descargable
    # dependiendo del tipo de instrumento que se esté creando.
    # En un principio sólo se usará para PPF para evitar conflictos con los otros
    # instrumentos.
    # ToDo: 
    # => crear una tabla con los métodos de cada instrumentos (disponibles en descargables)
    # => 
    def usar_metodos_del_instrumento
      metodos
      unless @tarea_pendiente.blank?
        if TipoInstrumento::PPF.include?(@tarea.tipo_instrumento_id)
          entidad = nil
          ppp = @tarea_pendiente.flujo.ppp
          unless ppp.blank?
            contribuyente = ppp.contribuyente
            entidad = contribuyente.razon_social unless contribuyente.blank?
          end
          metodos("Programas y Proyectos de Financiamiento",entidad)
        end
      end
    end
#DZC

    def descargable_params
      params.require(:descargable_tarea).permit(
        :nombre,
        :tarea_id,
        :contenido,
        :formato,
        :codigo,
        :subido,
        :archivo,
        :archivo_cache
      )
    end

end
