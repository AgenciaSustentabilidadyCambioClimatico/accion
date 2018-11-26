class Ppf::AuditoriasController < ApplicationController
	before_action :authenticate_user!
	before_action :set_tarea_pendiente
	before_action :set_flujo
	before_action :set_auditoria
	before_action :set_establecimientos
  before_action :set_data, only: [:cargar_establecimiento]
  before_action :set_datos_aprobacion, only: [:aprobar_establecimiento]

	def cargar #DZC Acceso a Tarea PPF-021		 
	end
  def cargar_establecimiento   
  end

	def update_cargar #DZC Término de Tarea PPF-021
    @auditoria.assign_attributes(auditoria_params)
    @ad_elementos = []
    if @auditoria.valid?
      errors = AuditoriaElemento.data_auditoria @auditoria
      mensaje = errors.messages[:archivo_auditorias].to_sentence
    else
      errors = @auditoria.errors.full_messages
      mensaje = "Verifique los datos"
    end
    respond_to do |format|
      if errors.size == 0
        flash[:notice] = "Carga de auditoría enviada correctamente"
        format.js { render js: "window.location.href='#{ppf_tarea_pendiente_cargar_path(@tarea_pendiente)}'" }
        format.html { redirect_to ppf_tarea_pendiente_cargar_path(@tarea_pendiente), flash: {notice: 'Carga de auditoría enviada correctamente' }}
        continua_flujo_segun_tipo_tarea
      else
        format.js { flash[:error] = mensaje}
        format.html { render :cargar, flash: {error: mensaje }}
      end
    end
	end

  def aprobar #DZC Acceso a Tarea PPF-022   
  end
  def aprobar_establecimiento   
  end

  def update_aprobar #DZC Término de Tarea PPF-022
    @ad_elementos = []
    respond_to do |format|
      if @auditoria.update(auditoria_aprobar_params)
        flash[:notice] = "Aprobación de auditoria correctamente actualizada"
        format.js { render js: "window.location.href='#{ppf_tarea_pendiente_aprobar_path(@tarea_pendiente)}'" }
        format.html { redirect_to ppf_agenda_path, notice: 'Aprobación de auditoria correctamente actualizada' }
        continua_flujo_segun_tipo_tarea
      else
        format.html { render :edit }
        format.js { flash[:error] = "Error al actualizar." }
      end
    end
  end

  def descargar_formato 
    if params[:establecimiento].present?
      
      @establecimiento = EstablecimientoContribuyente.find(params[:establecimiento])
      titulos = AuditoriaElemento.columnas_excel
      datos = AuditoriaElemento.datos_ppf @flujo, @establecimiento
      dominios = AuditoriaElemento.dominios
      @ruta = "#{Rails.root}/public/uploads/auditorias/formato/#{@flujo.id}/descargado/"
      FileUtils.mkdir_p(@ruta) unless File.exist?(@ruta)
      @ruta += "auditorias.xlsx"
      
      ExportaExcel.formato(@ruta, titulos, dominios, datos, "auditorias")
      send_data File.open(@ruta).read, type: 'application/xslx', charset: "iso-8859-1", filename: "auditorias.xlsx"
    end
  end

  #DZC método para continuar con el flujo según de que tipo de tarea se trate 
  def continua_flujo_segun_tipo_tarea
    case @tarea.codigo
      when Tarea::COD_PPF_021
        if @tarea_pendiente.primera_ejecucion
          @tarea_pendiente.pasar_a_siguiente_tarea 'A', {}, false
          @tarea_pendiente.primera_ejecucion = false
        end
        enviar_correos_revisar_reportes(@flujo) #DZC 2018-11-15 16:42:43 envia correos suguiriendo la revision de los reportes de auditoría
      when Tarea::COD_PPF_022
        auditoria_elementos_estados = @auditoria.auditoria_elementos.pluck(:estado)
        if (auditoria_elementos_estados & [1,2,3]).size == 0 #DZC todos los elementos de auditorías estan aceptados o rechazados
          MapaDeActor.where(flujo_id: @tarea_pendiente.flujo_id, rol_id: Rol::RESPONSABLE_CUMPLIMIENTO_COMPROMISOS).each do |a|
            MapaDeActor.find_or_create_by({
              flujo_id: a.flujo_id,
              rol_id: Rol::PARTE_INTERESADA_RELEVANTE,
              persona_id: a.persona_id
            })
          end
          @tarea_pendiente.pasar_a_siguiente_tarea ['A','D']
          enviar_correos_revisar_reportes(@flujo) #DZC 2018-11-15 16:42:43 envia correos suguiriendo la revision de los reportes de auditoría
        end
        if auditoria_elementos_estados.include?(3) #DZC existe una auditoria observada  
          @tarea_pendiente.pasar_a_siguiente_tarea 'B', {}, false
        end
    end
  end

	private
  def set_tarea_pendiente
    @tarea_pendiente = TareaPendiente.find(params[:tarea_pendiente_id])
    autorizado? @tarea_pendiente
    @tarea = @tarea_pendiente.tarea
  end

  def set_flujo
    @flujo = @tarea_pendiente.flujo
    @tipo_instrumento=@flujo.tipo_instrumento
    if @flujo.ppf?
    	@ppp = @flujo.programa_proyecto_propuesta_id.blank? ? nil : ProgramaProyectoPropuesta.find(@flujo.programa_proyecto_propuesta_id)
    end
  end

  def set_auditoria
  	@auditoria = Auditoria.find_or_create_by(flujo_id: @flujo.id)
  end

  def set_establecimientos
    if @tarea.codigo == Tarea::COD_PPF_022
      ppf_metas_establecimientos = @flujo.ppf_metas_establecimientos.where(estado: :aceptada)
      @establecimientos_all = EstablecimientoContribuyente.where(id: ppf_metas_establecimientos.pluck(:establecimiento_contribuyente_id))
      @establecimientos = []
      @establecimientos_all.each do |establecimiento|
        con_pendientes = false
        meta = establecimiento.ppf_metas_establecimiento.find_by_flujo_id(@flujo)
        elemento_adherido = @flujo.adhesion.adhesion_elementos.where(establecimiento_contribuyente_id: establecimiento.id).first
        @set_metas_acciones = meta.set_metas_acciones.where(estado: 3)
        @set_metas_acciones.each do |sma|
          ad_elemento = AuditoriaElemento.where(auditoria_id: @auditoria.id, set_metas_accion_id: sma.id, adhesion_elemento_id: elemento_adherido.id).first_or_create
          #Verifica que la auditoria elemento se encuenta en el estado en revision
          if ad_elemento.estado == 2
            con_pendientes = true
          end
        end
        if con_pendientes
          @establecimientos << establecimiento
        end
      end
    elsif @tarea.codigo == Tarea::COD_PPF_021
      ppf_metas_establecimientos = @flujo.ppf_metas_establecimientos.where(estado: :aceptada)
      @establecimientos_all = EstablecimientoContribuyente.where(id: ppf_metas_establecimientos.pluck(:establecimiento_contribuyente_id))
      @establecimientos = []

      @establecimientos_all.each do |establecimiento|
        sin_pendientes = false
        meta = establecimiento.ppf_metas_establecimiento.find_by_flujo_id(@flujo)
        elemento_adherido = @flujo.adhesion.adhesion_elementos.where(establecimiento_contribuyente_id: establecimiento.id).first
        @set_metas_acciones = meta.set_metas_acciones.where(estado: 3)
        @set_metas_acciones.each do |sma|
          #Verifica que la auditoria elemento se encuenta en el estado pendiente o en observacion
          ad_elemento = AuditoriaElemento.where(auditoria_id: @auditoria.id, set_metas_accion_id: sma.id, adhesion_elemento_id: elemento_adherido.id).first_or_create
          if ad_elemento.estado == 1 || ad_elemento.estado == 3
            sin_pendientes = true
          end
        end
        if sin_pendientes
          @establecimientos << establecimiento
        end
      end
    else
      ppf_metas_establecimientos = @flujo.ppf_metas_establecimientos.where(estado: :aceptada)
      @establecimientos = EstablecimientoContribuyente.where(id: ppf_metas_establecimientos.pluck(:establecimiento_contribuyente_id))
    end
  end

  def set_data
    if params[:establecimiento].present?
      @establecimiento = EstablecimientoContribuyente.find(params[:establecimiento]) 
      meta = @establecimiento.ppf_metas_establecimiento.find_by_flujo_id(@flujo)
      @ad_elementos = []
      if meta.present? && meta.estado        
        elemento_adherido = @flujo.adhesion.adhesion_elementos.where(establecimiento_contribuyente_id: @establecimiento.id).first
        @set_metas_acciones = meta.set_metas_acciones.where(estado: 3)
        @set_metas_acciones.each do |sma|
          @ad_elementos << AuditoriaElemento.where(auditoria_id: @auditoria.id, set_metas_accion_id: sma.id, adhesion_elemento_id: elemento_adherido.id).first_or_create
        end
      else
        @establecimiento = nil
      end
    end
  end

  def set_datos_aprobacion
    if params[:establecimiento].present?
      @establecimiento = EstablecimientoContribuyente.find(params[:establecimiento])    
      meta = @establecimiento.ppf_metas_establecimiento.find_by_flujo_id(@flujo)
      @ad_elementos = []  
      if meta.present? && meta.estado
        @elemento_adherido = @flujo.adhesion.adhesion_elementos.where(establecimiento_contribuyente_id: @establecimiento.id).first
        set_metas_acciones = meta.set_metas_acciones.where(estado: 3, estado: 2)
        set_metas_acciones.each do |sma|
          @ad_elementos << AuditoriaElemento.where(auditoria_id: @auditoria.id, set_metas_accion_id: sma.id, adhesion_elemento_id: elemento_adherido.id).first_or_create
        end
      else
        @establecimiento = nil
      end
    end
  end

  #DZC REVISAR
  def set_ppf_metas_establecimiento
  	ppf_metas_establecimientos = @flujo.ppf_metas_establecimientos
  	ppf_metas_establecimiento = ppf_metas_establecimientos.where(estado: :aceptada).where(establecimiento_contribuyente_id @establecimiento).first
  	set_metas = ppf_metas_establecimiento.set_metas_acciones	
  end

  def auditoria_params
    params.require(:auditoria).permit(
      :archivo_carga_auditoria,
      :archivos_informe => [], 
      :archivos_evidencia => []
    )
  end

  def auditoria_aprobar_params
    params.require(:auditoria).permit(auditoria_elementos_attributes: [:id, :observacion, :estado])
  end

end
