class PpfActividadesController < ApplicationController
  before_action :authenticate_user!
	before_action :set_flujo_tarea
	before_action :set_contribuyentes

  def cargar_resultados_auditoria #DZC EJECUTA TAREA PPF-013 CONDICION 'C'
    continua_flujo_segun_tipo_tarea
    tarea_pendiente = TareaPendiente.where(flujo_id: @flujo.id, tarea_id: Tarea::ID_PPF_021, user_id: current_user.id, estado_tarea_pendiente_id: EstadoTareaPendiente::NO_INICIADA).first
    unless tarea_pendiente.blank?
      redirect_to ppf_tarea_pendiente_cargar_path(tarea_pendiente)
    else
      render :edit, notice: 'Error al acceder a los resultados de auditoria'
    end
  end

	def cargar_actividades #DZC EJECUTA TAREA PPF-013 CONDICION 'B'
    continua_flujo_segun_tipo_tarea
    tarea_pendiente = TareaPendiente.where(flujo_id: @flujo.id, tarea_id: Tarea::ID_PPF_018, user_id: current_user.id, estado_tarea_pendiente_id: EstadoTareaPendiente::NO_INICIADA).first
    unless tarea_pendiente.blank?
      redirect_to ppf_tarea_pendiente_set_metas_acciones_path(tarea_pendiente)
    else
      render :edit, notice: 'Error al acceder a las actividades'
    end
  end

  def preparar_convocatoria #DZC EJECUTA TAREA PPF-013 CONDICION 'A'
    continua_flujo_segun_tipo_tarea
    tarea_pendiente = TareaPendiente.where(flujo_id: @flujo.id, tarea_id: Tarea::ID_PPF_014, user_id: current_user.id, estado_tarea_pendiente_id: EstadoTareaPendiente::NO_INICIADA).first
    unless tarea_pendiente.blank?
      redirect_to tarea_pendiente_convocatorias_path(tarea_pendiente)
    else
      render :edit, notice: 'Error al acceder al mantenedor de convocatorias'
    end
  end

  def edit #DZC ACCESO A TAREA PPF-013
    # if @contribuyentes.count == 0
    #   redirect_to root_path, notice: 'No posee elementos adheridos.' 
    # end
  end

  def update #DZC TAREA PPF-013 GUARDA AGENDA
    respond_to do |format|
      
      @ppp.temporal = true
      if @ppp.update(ppp_params)
        format.js { flash[:success] = 'Agenda correctamente actualizada' }
        format.html { redirect_to ppf_agenda_path, notice: 'Agenda correctamente actualizada' }
      else
        format.html { render :edit }
        format.js { flash[:error] = "Error al actualizar." }
      end
    end
  end

  #DZC método para continuar con el flujo según de que tipo de tarea se trate 
  def continua_flujo_segun_tipo_tarea
    case action_name
    when 'preparar_convocatoria'
      @tarea_pendiente.pasar_a_siguiente_tarea 'A', {}, false
    when 'cargar_actividades'
      @tarea_pendiente.pasar_a_siguiente_tarea 'B', {}, false
    when 'cargar_resultados_auditoria'
      @tarea_pendiente.pasar_a_siguiente_tarea 'C', {}, false      
    end
  end

  def descargar
    
    titulos = Adhesion.columnas_excel_descarga
    datos_generados = DatoProductivoElementoAdherido.generar_data(@datos_productivos)
    adhesiones = @ppp.adhesiones  
    adhesion_elementos = AdhesionElemento.where(adhesion_id: adhesiones.pluck(:id))
    datos_temp = adhesion_elementos.map {|v| v.fila.except(:revisado, :observaciones, :posicion) }.compact
    datos = datos_temp.map{|x|x.values}
    # datos = []
    # adhesion_elementos.each do |ae|
    #   datos << ae.fila.except(:revisado, :observaciones)
    # end
    dominios = {descarga: ["0"]}
    @ruta = "#{Rails.root}/public/uploads/ad_elementos/descargas"
    FileUtils.mkdir_p(@ruta) unless File.exist?(@ruta)
    @ruta += "Adhesion_elementos.xlsx"
    
    ExportaExcel.formato(@ruta, titulos, dominios, datos, "Adhesion_elementos")
    send_data File.open(@ruta).read, type: 'application/xslx', charset: "iso-8859-1", filename: "Adhesion_elementos.xlsx"
  end

	private
	def set_flujo_tarea
    @tarea_pendiente = TareaPendiente.find(params[:tarea_pendiente_id])
    autorizado? @tarea_pendiente
    @flujo = @tarea_pendiente.flujo
    @ppp   = @flujo.ppp
  end

  def set_contribuyentes
  	adhesiones = @ppp.adhesiones	
		adhesion_elementos = AdhesionElemento.where(adhesion_id: adhesiones.pluck(:id))
		personas = Persona.where(id: adhesion_elementos.pluck(:persona_id))
		@contribuyentes = Contribuyente.where(id: personas.pluck(:contribuyente_id))  	
  end
  def ppp_params
  	params.require(:programa_proyecto_propuesta).permit(
      ppf_actividad_attributes: 
  			[:fecha,
          :contribuyente_id,
  				:comuna_id,
  				:ppf_tipo_actividad_id,
  				:direccion,
  				:estado_tecnica_id,
  				:observaciones, 
  				:id, 
  				:_destroy,
  			]
      )
  end
end
