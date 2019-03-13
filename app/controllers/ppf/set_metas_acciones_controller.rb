class Ppf::SetMetasAccionesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_tarea_pendiente
  before_action :set_flujo
  before_action :set_metas_acciones, only: [:index, :create, :update, :revision, :enviar_revision]
  before_action :set_set_metas_accion, only: [:edit,:update,:destroy, :acciones_relacionadas]
  before_action :set_revision, only: [:revision, :get_establecimientos, :enviar_revision]
  before_action :set_accion, only: [:new, :edit, :update, :revision, :get_establecimientos]
  before_action :set_metas_establecimientos, only: [:index, :create, :update, :get_establecimientos, :revision, :pdf_set_metas]
  before_action :set_accion_en
  before_action :set_get_establecimiento, only: [:new, :edit, :update, :revision, :destroy, :get_establecimientos, :index, :pdf_set_metas]

  #after_action :set_metas_acciones, only: [:enviar_revision]

  def actualizacion
  end

  def enviar_a_revision
    if params[:establecimiento].present?
      @set_metas_accion = PpfMetasEstablecimiento.where(flujo_id: @flujo.id, establecimiento_contribuyente_id: params[:establecimiento])
      @set_metas_accion.update(estado: :en_revision)
    end
    continua_flujo_segun_tipo_tarea
    redirect_to ppf_tarea_pendiente_set_metas_acciones_path(@tarea_pendiente), notice: 'Set de metas enviado a revisión correctamente.' #root_path
  end

  def index
    if @metas_establecimientos.blank?
      redirect_to root_path, notice: 'No tiene establecimientos a los cuales cargar el set de metas y acciones, o aún están en revisión.' 
    end
  end

  def revision
    if @metas_establecimientos.blank?
      redirect_to root_path, notice: 'No posee establecimientos que revisar' 
    end
  end

  def enviar_revision #PPF:019
    
    @ppf_metas_establecimiento = PpfMetasEstablecimiento.find(params[:id])
    if @ppf_metas_establecimiento.update(revision_set_metas_accion_params)      
      #metodo para crea los datos productivos
      if @ppf_metas_establecimiento.aceptada? && @flujo.ppf?  
        #Se busca el establecimiento
        establecimiento_para_dpea = @ppf_metas_establecimiento.establecimiento_contribuyente_id
        #Obtengo todas los set de metas
        set_metas_acciones = @ppf_metas_establecimiento.set_metas_acciones
        #Se encuentra los elementos adheridos para este establecimiento.
        adhesion_elementos = @flujo.adhesion.adhesion_elementos.where(establecimiento_contribuyente_id: establecimiento_para_dpea)
        adhesion_elementos.each do |adhesion_elemento|
          #Obtengo todas las actividades economicas asociadas al contribuyente
          contribuyente = adhesion_elemento.persona.contribuyente
          actividades_economicas = ActividadEconomicaContribuyente.where(contribuyente_id: contribuyente.id)
          set_metas_acciones.each do |meta|
            ms = meta.materia_sustancia
            if ms.present?
              #Busco todas las MateriasRubroRelacions existen deacuerdo a la materia y las actividades economicas del contribuyente.-
              actividades_economicas.each do |ae|
                materia_rubro_relacion = MateriaRubroRelacion.where(materia_sustancia_id: ms.id, actividad_economica_id: ae.actividad_economica_id).first
                if materia_rubro_relacion.present?
                  #Obtengo todos los datos relacionadoes segun el rubro y materia.-
                  materia_rubro_dato_relaciones = materia_rubro_relacion.materia_rubro_dato_relacions
                  materia_rubro_dato_relaciones.each do |mrdr|     
                    mrdr.dato_recolectado.dato_productivo_elemento_adheridos.create(adhesion_elemento_id: adhesion_elemento.id, set_metas_accion_id: meta.id)
                  end
                end
              end
            end
          end
        end
      end

      @metas_establecimientos = @flujo.ppf_metas_establecimientos.where(estado: :en_revision) #solo trae los que se encuentran en revision
      @establecimientos = EstablecimientoContribuyente.where(id: @metas_establecimientos.pluck(:establecimiento_contribuyente_id))
      respond_to do |format|
        continua_flujo_segun_tipo_tarea
        format.js {
          flash.now[:success] = 'Revisión enviada.'
        }
      end
    end
  end


  def new
    @meta_establecimiento = PpfMetasEstablecimiento.find(params[:meta_establecimiento])
    @set_metas_accion = SetMetasAccion.new
    @set_metas_accion.ppf_metas_establecimiento_id = @meta_establecimiento.id
    #@set_metas_accion.anexo = params[:anexo]
    @set_metas_accion.anexo = false
    render layout: false if request.xhr?
  end

  def create
    @set_metas_accion = SetMetasAccion.new(set_metas_accion_params)
    @set_metas_accion.flujo_id = @flujo.id
    @set_metas_accion.anexo = false
    @meta_establecimiento = @set_metas_accion.ppf_metas_establecimiento
    @establecimiento = @set_metas_accion.ppf_metas_establecimiento.establecimiento_contribuyente_id
    @metas_establecimiento = @metas_establecimientos.where(establecimiento_contribuyente_id: @establecimiento).first
    @set_metas_acciones = PpfMetasEstablecimiento.where(flujo_id: @flujo.id, establecimiento_contribuyente_id: @establecimiento).first.set_metas_acciones
    respond_to do |format|
      if @set_metas_accion.save
        # continua_flujo_segun_tipo_tarea    <-- utilizar cuando se una al flujo
        format.js { 
          flash.now[:success] = 'Acción correctamente agregada.'
          @set_metas_accion = SetMetasAccion.new
          @set_metas_accion.anexo = params[:anexo]
        }
        format.html {
          r_to = ppf_tarea_pendiente_set_metas_acciones_path(@tarea_pendiente) 
          redirect_to r_to, notice: 'Acción correctamente agregada.'
        }
      else
        @errors = true
        format.html { render :new }
        format.js
      end
    end
  end

  def edit    
    render layout: false 
  end

  def update
    respond_to do |format|
      @set_metas_accion.assign_attributes(set_metas_accion_params)
      @set_metas_accion.estado = 1
      if set_metas_accion_params["materia_sustancia_id"].blank?
        @set_metas_accion.materia_sustancia_id = nil
      end
      if @set_metas_accion.save
        @establecimiento = @set_metas_accion.ppf_metas_establecimiento.establecimiento_contribuyente_id
        @metas_establecimiento = @metas_establecimientos.where(establecimiento_contribuyente_id: @establecimiento).first
        @set_metas_acciones = @set_metas_accion.ppf_metas_establecimiento.set_metas_acciones
        # continua_flujo_segun_tipo_tarea  <-- utilizar cuando se una al flujo
        format.js { flash.now[:success] = 'Acción correctamente actualizada.'
           
        }
        format.html {
          r_to = edit_ppf_tarea_pendiente_set_metas_accion_path(@tarea_pendiente)
          redirect_to r_to, notice: 'Acción correctamente actualizada.' 
        }
      else
        @errors = true
        format.html { render :edit }
        format.js
      end
    end
  end

  def destroy
    @establecimiento = @set_metas_accion.ppf_metas_establecimiento.establecimiento_contribuyente_id
    @set_metas_accion.destroy
    r_to = ppf_tarea_pendiente_set_metas_acciones_path(@tarea_pendiente, establecimiento: @establecimiento) 
    redirect_to r_to, notice: 'Acción correctamente eliminada'
  end

  def acciones_relacionadas
    @accion = @set_metas_accion.accion
    acciones_relacionadas = @accion.accion_relacionadas
    @acciones=acciones_relacionadas.map{|a|a.accion_relacionada}
    render layout: false if request.xhr? #DZC no renderiza el layout si el reques es ajax
  end

  def continua_flujo_segun_tipo_tarea 
    case @tarea.codigo
    when Tarea::COD_PPF_018
      @tarea_pendiente.pasar_a_siguiente_tarea 'A',{},false
    when Tarea::COD_PPF_019
      if @ppf_metas_establecimiento.aceptada?
        @tarea_pendiente.pasar_a_siguiente_tarea 'A',{},false
      else
        @tarea_pendiente.pasar_a_siguiente_tarea 'C',{},false
      end
      # DZC 2018-10-26 12:12:34 se corrige error en condición de paso a 'D', adecuándolo al cambio de tipo de datos (de boolean a integer) en atributo 'estado'
      if PpfMetasEstablecimiento.where(flujo_id: @flujo.id).where.not(estado: 4).count == 0
        @tarea_pendiente.pasar_a_siguiente_tarea 'D'
      end
    end
  end

  def get_establecimientos
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
    @proyecto = @flujo.proyecto_id.blank? ? nil : Proyecto.find(@flujo.proyecto_id)
    @ppp = @flujo.programa_proyecto_propuesta_id.blank? ? nil : ProgramaProyectoPropuesta.find(@flujo.programa_proyecto_propuesta_id)
  end

  def set_accion
    
    if params[:accion].present?
      @accion = params[:accion].to_sym
    end
  end

  def set_accion_en
    case @tarea.codigo
    when Tarea::COD_PPF_018
      @accion_en = :actualizacion
    when Tarea::COD_PPF_019
      @accion_en = :revision
    end
  end

  def set_revision
    if action_name.to_sym == :revision || action_name.to_sym == :enviar_revision
      accion = :revision
    end
    @accion = accion
  end

  def set_metas_accion_params
    params.require(:set_metas_accion).permit(
      :accion_id,
      :materia_sustancia_id,
      :meta_id,
      :tipo_cuantitativa,
      :valor_referencia,
      :criterio_inclusion_exclusion,
      :descripcion_accion,
      :detalle_medio_verificacion,
      :plazo_valor,
      :plazo_unidad_tiempo,
      :comentario,
      :comentario_respuesta,
      :archivo_acta_comite,
      :ppf_metas_establecimiento_id,
      :flujo_id
    )
  end

  def revision_set_metas_accion_params
    params.require(:ppf_metas_establecimiento).permit(
      :estado, ppf_metas_comentarios_attributes: [:id, :comentario, :user_id], set_metas_acciones_attributes: [:id, :estado]
    )
  end

  #devuelve todos los establecimientos que han sido adheridos
  def set_metas_establecimientos
    elementos = @flujo.adhesion.adhesion_elementos
    establecimientos = EstablecimientoContribuyente.where(id: elementos.pluck(:establecimiento_contribuyente_id))
    #Verifica que todos los establecimientos adheridos se encuentren registrados en la tabla.
    establecimientos.each do |establecimiento|
      PpfMetasEstablecimiento.find_or_create_by(flujo_id: @flujo.id, establecimiento_contribuyente_id: establecimiento.id)
    end
    if @tarea.codigo == Tarea::COD_PPF_018
      @metas_establecimientos = @flujo.ppf_metas_establecimientos.where.not(estado: [:en_revision, :aceptada])
      @establecimientos = EstablecimientoContribuyente.where(id: @metas_establecimientos.pluck(:establecimiento_contribuyente_id))
    elsif @tarea.codigo == Tarea::COD_PPF_019
      @metas_establecimientos = @flujo.ppf_metas_establecimientos.where(estado: :en_revision)
      @establecimientos = EstablecimientoContribuyente.where(id: @metas_establecimientos.pluck(:establecimiento_contribuyente_id))
    else
      @metas_establecimientos = @flujo.ppf_metas_establecimientos.where(estado: :pendiente) #solo trae los con estado pendiente
      @establecimientos = EstablecimientoContribuyente.where(id: @metas_establecimientos.pluck(:establecimiento_contribuyente_id))
    end
  end

  #Devuelve el conjunto de set_metas de accion para un establecimiento, este se recorre en  la tabla
  def set_metas_acciones 
    @set_metas_acciones = []
    @comentarios = []
    @metas_establecimiento = PpfMetasEstablecimiento.new
    #@set_metas_acciones_anexas = []
    if @establecimiento.present?
      @set_metas_acciones = PpfMetasEstablecimiento.where(flujo_id: @flujo.id, establecimiento_contribuyente_id: @establecimiento).first.set_metas_acciones
    end
  end

  #Devuelve 1 set_meta en particular que se esta editando
  def set_set_metas_accion
    
    @set_metas_accion = SetMetasAccion.includes([:accion]).find(params[:id])
    @meta_establecimiento = @set_metas_accion.ppf_metas_establecimiento
  end

  def set_get_establecimiento
    
    if params[:establecimiento].present?
      @establecimiento = params[:establecimiento]
      @metas_establecimiento = @metas_establecimientos.where(establecimiento_contribuyente_id: @establecimiento).first
      @set_metas_acciones = @metas_establecimiento.set_metas_acciones
      @comentarios = @metas_establecimiento.ppf_metas_comentarios
      @metas_establecimiento.ppf_metas_comentarios.build
      #@set_metas_acciones_anexas = SetMetasAccion.by_flujo(@flujo.id, params[:establecimiento], true)
    else
      @set_metas_acciones = []
      @metas_establecimiento = PpfMetasEstablecimiento.new
      @comentarios = []
    end
  end  

end
