class Admin::HitosDePrensaController < ApplicationController
  before_action :authenticate_user!, except: [:index]
  before_action :set_hito_de_prensa, only: [:show, :edit, :update, :destroy]
  before_action :set_new_hito_de_prensa, only: [:index, :new, :create, :search, :search_instrumentos]
  before_action :__set_commons, only: [:new, :create,:update,:edit]
  # before_action :set_tarea_pendiente, if: -> {params[:tarea_pendiente_id].present?}
  before_action :set_tarea_pendiente
  before_action :set_rutas

  def index #DZC APL-007
    @solo_lectura = params[:q]
    @hitos_de_prensa = HitoDePrensa.includes([:tipo_de_medio]).order(id: :desc).all
    #DZC filtra los hitos de prensa por el flujo 
    if !@tarea_pendiente.nil?
      @hitos_de_prensa=@hitos_de_prensa.where(flujo_id: @flujo.id)
    end
  end

  def search
    @hito_de_prensa = HitoDePrensa.new(params.require(:hito_de_prensa).permit(:rut,:dv,:razon_social))
    @hito_de_prensa.filter_mode = true
    if @hito_de_prensa.valid?
     @hitos_de_prensa = HitoDePrensa
     @hitos_de_prensa = @hitos_de_prensa.where("razon_social ILIKE '%#{@hito_de_prensa.razon_social}%'") unless @hito_de_prensa.razon_social.blank?
     @hitos_de_prensa = @hitos_de_prensa.where("rut = ? AND dv = ?", @hito_de_prensa.rut, @hito_de_prensa.dv) unless (@hito_de_prensa.rut.blank? && @hito_de_prensa.dv.blank?)
     @hitos_de_prensa = @hitos_de_prensa.all
    else
      @errors = true
    end
  end

  def search_instrumentos
    tipo_id = params[:tipo_instrumento_id]
    sub_tipo_id = params[:sub_tipo_id]
    region = params[:region]
    @manifestaciones = []
    @proyectos = []
    @programas = []
    @errors = false
    @instrumentos = []     
    #@flujos = Flujo.where.not(proyecto_id: nil).or(Flujo.where.not(manifestacion_de_interes_id: nil)).or(Flujo.where.not(programa_proyecto_propuesta_id: nil))
    if sub_tipo_id.present? 
      @manifestaciones = ManifestacionDeInteres.where(tipo_instrumento_id: sub_tipo_id)
      @proyectos = Proyecto.where(tipo_instrumento_id: sub_tipo_id)
      @programas = ProgramaProyectoPropuesta.where(tipo_instrumento_id: sub_tipo_id)     
      #@flujos = @flujos.where(tipo_instrumento: sub_tipo_id)
    end
  end

  def new
    if current_user.is_coordinador? || current_user.is_cogestor?
      @hito_de_prensa.hito_de_prensa_responsables << HitoDePrensaResponsable.new({persona_id: current_user.id})
    end
    if !@flujo.nil? && @hito_de_prensa.hito_de_prensa_instrumentos.where(flujo_id: @flujo.id).first.nil?
      @hito_de_prensa.hito_de_prensa_instrumentos.new({
        flujo_id: @flujo.id
      })
    end
  end

  def edit

    if !@flujo.nil? && @hito_de_prensa.hito_de_prensa_instrumentos.where(flujo_id: @flujo.id).first.nil?
      @hito_de_prensa.hito_de_prensa_instrumentos.new({
        flujo_id: @flujo.id
      })
    end
  end

  def create
    parameters = hito_de_prensa_params
    @hito_de_prensa = HitoDePrensa.new(parameters)
    respond_to do |format|
      if @hito_de_prensa.save
        #Para que en el caso de crear un hito desde tarea, se agregue su flujo como instrumento relacionado.-
        #Lo haremos en vista para mejorar funcionalidad
        #if @flujo.present?
        #  HitoDePrensaInstrumento.find_or_create_by(flujo_id: @flujo.id, hitos_de_prensa_id: @hito_de_prensa.id)
        #end
        format.js { 
          flash.now[:success] = 'Hito de prensa correctamente creado.'
          @hito_de_prensa = HitoDePrensa.new
        }
        format.html { redirect_to @ruta_nuevo, notice: 'Hito de prensa correctamente creado.' }
      else
        format.html { render :new }
        format.js
      end
    end
  end

  def update
    respond_to do |format|
      if @hito_de_prensa.update(hito_de_prensa_params)
        format.js { flash.now[:success] = 'Hito de prensa correctamente actualizado.' }
        format.html { redirect_to @ruta_editar, notice: 'Hito de prensa correctamente actualizado.' }
      else
        format.html { render :edit }
        format.js
      end
    end
  end

  def destroy
    @hito_de_prensa.destroy
    redirect_to @ruta_index, notice: 'Hito de prensa correctamente eliminado.'
  end

  private
    def __set_commons
      @instrumento = Instrumento.new
      @instrumentos = {}
    end

    def set_hito_de_prensa
      begin
        @hito_de_prensa = HitoDePrensa.includes([:hito_de_prensa_responsables,:hito_de_prensa_instrumentos,:hito_de_prensa_archivos]).find(params[:id])
      rescue ActiveRecord::RecordNotFound => record_not_found
        respond_to do |format|
          format.html { redirect_to admin_hitos_de_prensa_index_url, flash: { error: "Hito de prensa no encontrado" } }
        end
      end
    end

    def set_new_hito_de_prensa
      @hito_de_prensa = HitoDePrensa.new
    end

    def set_tarea_pendiente #DZC setea objetos relativos a la tarea pendiente y al flujo
      
      @tarea_pendiente=nil
      @flujo=nil
      if params[:tarea_pendiente_id].present?
        @tarea_pendiente = TareaPendiente.find(params[:tarea_pendiente_id])
        autorizado? @tarea_pendiente
        @tarea = @tarea_pendiente.blank? ? nil : @tarea_pendiente.tarea
        @flujo = @tarea_pendiente.flujo
      elsif !@hito_de_prensa.nil? && !@hito_de_prensa.flujo_id.nil?
        @flujo = Flujo.find(@hito_de_prensa.flujo_id)
      end
      if !@flujo.nil?
        @tipo_instrumento=@flujo.tipo_instrumento
        @manifestacion_de_interes = @flujo.manifestacion_de_interes_id.blank? ? nil : ManifestacionDeInteres.find(@flujo.manifestacion_de_interes_id)
        @manifestacion_de_interes.update(tarea_codigo: @tarea.codigo) if !@manifestacion_de_interes.blank? && !@tarea.blank?
        @proyecto = @flujo.proyecto_id.blank? ? nil : Proyecto.find(@flujo.proyecto_id)
        @ppp = @flujo.programa_proyecto_propuesta_id.blank? ? nil : ProgramaProyectoPropuesta.find(@flujo.programa_proyecto_propuesta_id)
      end
    end

    def set_rutas #DZC setea las rutas dependiendo de si se accede como administrador o como tarea pendiente
      if @tarea_pendiente.nil?
        @ruta_index = admin_hitos_de_prensa_path
        @ruta_nuevo = new_admin_hito_de_prensa_path
        @ruta_guardar = admin_hitos_de_prensa_path
        if(!@hito_de_prensa.new_record?)
          @ruta_editar = edit_admin_hito_de_prensa_path(@hito_de_prensa)
          @ruta_guardar = admin_hito_de_prensa_path(@hito_de_prensa)
        end
      else
        @ruta_index = tarea_pendiente_hitos_de_prensa_path(@tarea_pendiente)
        @ruta_nuevo = new_tarea_pendiente_hito_de_prensa_path(@tarea_pendiente)
        @ruta_guardar = create_tarea_pendiente_hito_de_prensa_path(@tarea_pendiente)
        if(!@hito_de_prensa.new_record?)
          @ruta_editar = edit_tarea_pendiente_hito_de_prensa_path(@tarea_pendiente, @hito_de_prensa)
          @ruta_guardar = tarea_pendiente_hito_de_prensa_path(@tarea_pendiente, @hito_de_prensa)
        end
      end
    end


    def hito_de_prensa_params
      params.require(:hito_de_prensa).permit(
        :flujo_id,
        :tarea_pendiente_id,
      	:nombre,
      	:medio,
      	:tipo_de_medio_id,
      	:fecha_publicacion,
      	:enlace,
      	:observaciones,
        hito_de_prensa_instrumentos_attributes: [ 
        	:id, 
        	:flujo_id, 
        	:_destroy
        ],
        hito_de_prensa_responsables_attributes: [ 
          :id, 
          :user_id,
          :_destroy
        ],
        hito_de_prensa_archivos_attributes: [ 
        	:id, 
        	:archivo,
          :archivo_cache,
        	:_destroy
        ]
      )
    end

end
