class Admin::ContribuyentesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_contribuyente, only: [:show, :edit, :update, :destroy]
  before_action :es_encargado_institucion
  before_action :sin_permisos, except: [:search, :region_comunas, :edit_modal, :create, :update]

  def index
    if @mis_instituciones
      persona_cargos = current_user.persona_cargos.where(cargo_id: Cargo::ENCARGADO_INS)
      personas = current_user.personas.where(id: persona_cargos.pluck('persona_id'))

      @contribuyentes = Contribuyente.where(id: personas.pluck('contribuyente_id'))
    else
      @contribuyentes = []
      @contribuyente = Contribuyente.new 
    end  
  end

  def search
#DZC
#    @contribuyente = Contribuyente.new(params.require(:contribuyente).permit(
#      :rut,
#      :razon_social,
#      :actividad_economica_id,
#      :es_para_seleccion,
#      :buscar_por_actividad_economica,
#      :resultado_mostrados,
#      :es_maquinaria
#    ))
#DZC
#DZC Gino
    @contribuyente = Contribuyente.new(params.require(:contribuyente).permit(
      :rut,
      :razon_social,
      :actividad_economica_id,
      :es_para_seleccion,
      :seleccion_basica,
      :tipo_instrumento,
      :buscar_por_actividad_economica,
      :resultado_mostrados,
      :es_maquinaria,
      :custom_id,
      :data_table
    ))
    @custom_id = @contribuyente.custom_id
#DZC
    @contribuyente.filter_mode = true
    @es_para_seleccion = ( @contribuyente.es_para_seleccion == "true" )
    @seleccion_basica = @contribuyente.seleccion_basica
    @tipo_instrumento = @contribuyente.tipo_instrumento
    @es_maquinaria = ( @contribuyente.es_maquinaria == "true" )
    
    @buscar_por_actividad_economica = ( @contribuyente.buscar_por_actividad_economica == "true" )
    @resultado_mostrados = @contribuyente.resultado_mostrados
#DZC Gino
    @data_table = (@contribuyente.data_table == "true")
#DZC
    if @contribuyente.valid?
      if @seleccion_basica == "true"
        @contribuyentes = Contribuyente
      else
        @contribuyentes = Contribuyente.includes([:actividad_economica_contribuyentes,:dato_anual_contribuyentes,:establecimiento_contribuyentes])
      end
      if @contribuyente.actividad_economica_id.blank?
        unless @contribuyente.razon_social.blank?
          @contribuyentes = @contribuyentes.where("razon_social ILIKE '%#{@contribuyente.razon_social}%'")
          @filtro_utilizado = "Razón Social: #{@contribuyente.razon_social}"
        end
        unless @contribuyente.rut.blank?
          @contribuyentes = @contribuyentes.where("rut = ?", @contribuyente.rut)
          filtro = "RUT: #{@contribuyente.rut}"
          if @filtro_utilizado.blank?
            @filtro_utilizado = filtro
          else
            @filtro_utilizado = " Y #{filtro}"
          end
        end
        @contribuyentes = @contribuyentes.all
      else
        @contribuyentes = @contribuyentes
          .joins(:actividad_economica_contribuyentes)
          .where("actividad_economica_contribuyentes.actividad_economica_id = (?)",@contribuyente.actividad_economica_id)
        @filtro_utilizado = "Actividad Económica : #{ActividadEconomica.find(@contribuyente.actividad_economica_id).descripcion}"
      end
      @contribuyente = Contribuyente.new
    else
      @errors = true
    end
  end

  #permite realizar busqueda por rut o razon social y devolver unicamente los datos del contribuyente.-
  #Se debe usar de querer utilizar _form_manifestacion_de_interes_cambio_gestor.html
  # def search_contribuyente    
  #   #Datos necesarios para el buscador
  #   @errors = false
  #   @filtro_utilizado = []
  #   @es_para_seleccion = true
  #   #obtiene los parametos de la consulta
  #   rut = params[:rut]
  #   razon_social = params[:razon_social]
  #   #set contribuyentes para que sea un objeto de la clase
  #   @contribuyentes = Contribuyente
  #   if razon_social.present?
  #     @contribuyentes = @contribuyentes.where("razon_social ILIKE '%#{razon_social}%'")
  #     @filtro_utilizado = "Razón Social: #{razon_social}"
  #   end
  #   if rut.present?
  #     @contribuyentes = @contribuyentes.where("rut = ?", rut)
  #     filtro = "RUT: #{rut}"
  #     if @filtro_utilizado.blank?
  #       @filtro_utilizado = filtro
  #     else
  #       @filtro_utilizado = " Y #{filtro}"
  #     end
  #   end
  # end

  def new
    @contribuyente = Contribuyente.new
  end

  def edit
  end

  def create
    parameters = contribuyente_params
   
    # Se busca un contribuyente "maestro" (no temporal, sin flujo_id ni contribuyente_id padre)
    existing_contribuyente = nil
    if parameters[:rut].present?
      existing_contribuyente = Contribuyente.unscoped.find_by(
        rut: parameters[:rut],
        flujo_id: nil,
        contribuyente_id: nil 
      )
    end

    if existing_contribuyente
      # Si el contribuyente ya existe, creamos una nueva instancia TEMPORAL
      @contribuyente = Contribuyente.new(parameters.except(:actividad_economica_contribuyentes_attributes, :establecimiento_contribuyentes_attributes, :dato_anual_contribuyentes_attributes))
      @contribuyente.contribuyente_id = existing_contribuyente.id
      @contribuyente.temporal = true
      @contribuyente.flujo_id = parameters[:flujo_id] # Asegurarse de mantener el flujo_id
      @contribuyente.assign_attributes(parameters.slice(:actividad_economica_contribuyentes_attributes, :establecimiento_contribuyentes_attributes, :dato_anual_contribuyentes_attributes))

    else
      # Si no existe, creamos una nueva institución (podría ser temporal o no)
      @contribuyente = Contribuyente.new(parameters)
    end
    
    if contribuyente_params[:actividad_economica_contribuyentes_attributes].nil? || contribuyente_params[:actividad_economica_contribuyentes_attributes].values.select{|ae| ae[:_destroy] == "false" }.size == 0
      @error_extra = "Debe ingresar al menos una actividad economica" if @error_extra.nil?
    end
    if contribuyente_params[:establecimiento_contribuyentes_attributes].nil? || contribuyente_params[:establecimiento_contribuyentes_attributes].values.select{|ae| ae[:_destroy] == "false" }.size == 0
      @error_extra = "Debe ingresar al menos un establecimiento" if @error_extra.nil?
    end
    if parameters.to_h["establecimiento_contribuyentes_attributes"].nil? ? true : parameters.to_h["establecimiento_contribuyentes_attributes"].select{|k,v| v["casa_matriz"] == "1"}.size == 0
      @error_extra = "Debe seleccionar una casa matriz" if @error_extra.nil?
    elsif contribuyente_params.to_h["establecimiento_contribuyentes_attributes"].select{|k,v| v["casa_matriz"] == "1"}.size > 1
      @error_extra = "Puede haber solo una casa matriz" if @error_extra.nil?
    end

    # Habilita la validación de teléfono durante el create
    @contribuyente.establecimiento_contribuyentes.each do |establecimiento|
      establecimiento.skip_telefono_validation = false # Habilitar validación del teléfono
    end

    if @contribuyente.dato_anual_contribuyentes.present?
      @contribuyente.dato_anual_contribuyentes.each do |dato|
        dato.rango_venta_contribuyente_id = 1
        dato.periodo = Date.today.year-1
        dato.contribuyente = @contribuyente
      end
    end

    errores = false
    errores = true unless @error_extra.nil? 
    errores = true unless @contribuyente.valid?

    @contribuyente.establecimiento_contribuyentes.each{|ec| errores = true unless ec.valid?}
    @contribuyente.actividad_economica_contribuyentes.each{|aec| errores = true unless aec.valid?}

    respond_to do |format|
      if @contribuyente.contribuyente_id.nil?
        unless errores
          @contribuyente.save
          if(parameters[:temporal] == "true") 
            @contribuyente_temporal = @contribuyente
            format.js {}
          else
            format.js { 
              flash.now[:success] = 'Institución correctamente creada.'
              @contribuyente = Contribuyente.new
            }
            format.html { redirect_to edit_admin_contribuyente_url(@contribuyente), notice: 'Institución correctamente creada.' }
          end
        else
          if(parameters[:temporal] != "true")
            flash[:error] = @error_extra unless @error_extra.nil?
            format.html { render :new }
          else
            @contribuyente_temporal = @contribuyente
          end
          format.js
        end
      else
        @contribuyente.save(validate: false)
        @contribuyente_temporal = @contribuyente
        format.js {}
      end
    end
  end

  def update
    #se usa select porque where hace llamada a bd y trae info aun no guardada o actualizada
    
    
    if contribuyente_params[:actividad_economica_contribuyentes_attributes].nil? || contribuyente_params[:actividad_economica_contribuyentes_attributes].values.select{|ae| ae[:_destroy] == "false" }.size == 0
      @error_extra = "Debe ingresar al menos una actividad economica" if @error_extra.nil?
    end
    if contribuyente_params[:establecimiento_contribuyentes_attributes].nil? || contribuyente_params[:establecimiento_contribuyentes_attributes].values.select{|ae| ae[:_destroy] == "false" }.size == 0
      @error_extra = "Debe ingresar al menos un establecimiento" if @error_extra.nil?
    end
    if contribuyente_params.to_h["establecimiento_contribuyentes_attributes"].nil? ? true : contribuyente_params.to_h["establecimiento_contribuyentes_attributes"].select{|k,v| v["casa_matriz"] == "1" && v["_destroy"] == "false"}.size == 0
      @error_extra = "Debe seleccionar una casa matriz" if @error_extra.nil?
    elsif contribuyente_params.to_h["establecimiento_contribuyentes_attributes"].select{|k,v| v["casa_matriz"] == "1" && v["_destroy"] == "false"}.size > 1
      @error_extra = "Puede haber solo una casa matriz" if @error_extra.nil?
    end
   
    # Omitir la validación de teléfono durante el update
    @contribuyente.establecimiento_contribuyentes.each do |establecimiento|
      establecimiento.skip_telefono_validation = true # Deshabilitar validación del teléfono
    end

    @contribuyente.attributes = contribuyente_params
    # Agrupo por id de actividad economica
    grouped_contribuyentes = @contribuyente.actividad_economica_contribuyentes.group_by { |ae| ae.actividad_economica_id }
    filtered_contribuyentes = grouped_contribuyentes.values.map do |group|
    # Si hay duplicados borros los que su id sea nil
      if group.length > 1
        group.reject { |ae| ae.id.nil? }
      else
        group
      end
    end
     @contribuyente.actividad_economica_contribuyentes = filtered_contribuyentes.flatten

    errores = false
    errores = true unless @error_extra.nil? 

    if @contribuyente.errors.full_messages.count >= 1
      errores = true
    end

    respond_to do |format|
      if !errores 
        if @contribuyente.temporal
          @manifestacion_de_interes = @contribuyente.flujo.manifestacion_de_interes
          if !@contribuyente.contribuyente_id.nil? && @contribuyente.contribuyente_id == @contribuyente.id
            @contribuyente_temporal = @contribuyente.clonar_con_relaciones
          else
            @contribuyente.save
            @contribuyente_temporal = @contribuyente
          end
          format.js {}
        else
          @contribuyente.save
          format.js { flash.now[:success] = 'Institución correctamente actualizada' }
          format.html { redirect_to edit_admin_contribuyente_url(@contribuyente), notice: 'Institución correctamente actualizada' }
        end
      else
        if @contribuyente.temporal
          @contribuyente_temporal = @contribuyente
        else
          flash.now[:error] = @error_extra unless @error_extra.nil?
          format.js { flash.now[:error] = @contribuyente.errors.messages }
          format.html { render :new }
        end
        format.js
      end
    end
  end

  def destroy
    @contribuyente.destroy
    redirect_to admin_contribuyentes_url, notice: 'Institución correctamente eliminada.'
  end

  #metodos para la edicion desde mi cuenta
  def mis_instituciones
    
    render 'admin/contribuyentes/mi_cuenta/index'
  end

  def region_comunas
    @codigo = params[:codigo]
    @comunas = Comuna.__select nil, params[:region_id]
  end

  def edit_modal
    if params[:id].blank?
      @contribuyente_temporal = Contribuyente.new
      @contribuyente_temporal.dato_anual_contribuyentes.build
    else
      @contribuyente_temporal = Contribuyente.unscoped.find_by(contribuyente_id: params[:id], flujo_id: params[:flujo_id]) || Contribuyente.unscoped.find(params[:id])
      @contribuyente_temporal.dato_anual_contribuyentes.build if @contribuyente_temporal.dato_anual_contribuyentes.empty?
    end
    @contribuyente_temporal.temporal = true
    @contribuyente_temporal.flujo_id = params[:flujo_id]
    @contribuyente_temporal.contribuyente_id = params[:contribuyente_id] unless params[:contribuyente_id].blank?
    render layout: false
  end

  def edit_actor_modal
    if params[:id].blank?
      @contribuyente_actor = Contribuyente.new
    else
      @contribuyente_actor = Contribuyente.unscoped.find_by(contribuyente_id: params[:id], flujo_id: params[:flujo_id]) || Contribuyente.unscoped.find(params[:id])
    end
    @contribuyente_actor.temporal = true
    @contribuyente_actor.flujo_id = params[:flujo_id]
    @contribuyente_actor.contribuyente_id = params[:contribuyente_id] unless params[:contribuyente_id].blank?
    render layout: false
  end
  
  private
    def set_contribuyente
      @contribuyente = Contribuyente.unscoped.find(params[:id])
    end

    def contribuyente_params
      params.require(:contribuyente).permit(
        :rut,
        :dv,
        :razon_social,
        :temporal,
        :flujo_id,
        :contribuyente_id,
        fields_visibility: {},
        actividad_economica_contribuyentes_attributes: [ :id, :actividad_economica_id, :_destroy ],
        establecimiento_contribuyentes_attributes: [ :id, :casa_matriz, :direccion, :ciudad, :region_id, :comuna_id, :_destroy ],
        dato_anual_contribuyentes_attributes: [ :id, :tipo_contribuyente_id, :rango_venta_contribuyente_id, :periodo, :numero_trabajadores, :f22c_645, :f22c_646, :_destroy ]
      )
    end
    #variable para determinar si posee el cargo encargado de institucion
    def es_encargado_institucion
      if @contribuyente.present? 
        @encargado = current_user.is_encargado_institucion_solicitada? @contribuyente
      elsif action_name == "index"
        @encargado =  current_user.is_encargado_institucion?
      else
        @encargado =  false
      end
      @mis_instituciones = @encargado
      @mis_instituciones = false if (current_user.is_admin? || current_user.posee_rol_ascc?([Rol::JEFE_DE_LINEA,Rol::REVISOR_TECNICO]))
    end

    def sin_permisos
      unless current_user.is_admin? || @encargado || current_user.posee_rol_ascc?([Rol::JEFE_DE_LINEA,Rol::REVISOR_TECNICO])
        return render :file => "layouts/error_pages/401.html.haml", :status => :unauthorized
      end      
    end

end
