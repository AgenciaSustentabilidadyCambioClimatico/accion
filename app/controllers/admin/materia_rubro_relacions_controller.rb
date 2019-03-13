class Admin::MateriaRubroRelacionsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_levantar, only: [:show, :edit, :update, :destroy]
  before_action :set_unidades, only: [:new, :edit, :create, :update]

  def index 
    @levantados= [] 
  end

  def search
    materia = params[:materia]
    ciiu = params[:ciiu]
    propiedad = params[:propiedad]
    @errors = false
    @levantados = []
    @resultado_mostrados = 25
    @filtro_utilizado = []
    
   @levantados = MateriaRubroRelacion
   if materia.present?
    materias = MateriaSustancia.where("nombre ILIKE ?", "%#{materia}%")
    @filtro_utilizado << "Materia: #{materia}"
    @levantados = @levantados.where(materia_sustancia_id: materias.pluck(:id))
   end
   if ciiu.present?
    actividades = ActividadEconomica.where("codigo_ciiuv2 ILIKE ?", "%#{ciiu}%")
    @filtro_utilizado << "Codigo producto: #{ciiu}"
    @levantados = @levantados.where(actividad_economica_id: actividades.pluck(:id))
   end
   if propiedad.present?
    propiedades = DatoRecolectado.where("nombre ILIKE ?", "%#{propiedad}%")
    intermedios = MateriaRubroDatoRelacion.where(dato_recolectado_id: propiedades.pluck(:id))
    @levantados = @levantados.where(id: intermedios.pluck(:materia_rubro_relacion_id))
    @filtro_utilizado << "Nombre de la propiedad: #{propiedad}"
   end

   #parsear filtros
    if !@filtro_utilizado.empty?
      @filtro_utilizado = @filtro_utilizado.join(', ')
    end
  end
  def new
    @levantar = MateriaRubroRelacion.new    
  end

  def tupla_existe
    levantar = MateriaRubroRelacion.find_by(materia_sustancia_id: params[:materia], actividad_economica_id: params[:actividad])
    respond_to do |format|
      unless levantar.nil?       
        format.js { 
          flash[:warning] = 'Asociación ya existente, se procede a cargar.'
          render js: "window.location.href='#{edit_admin_materia_rubro_relacion_path(levantar)}'"
        }
      else       
        format.js { 
          render js: "$('.loading-data').hide();"
        }
      end
    end
  end

  def create
    @levantar = MateriaRubroRelacion.new(levantado_params)
    respond_to do |format|
      if @levantar.save        
        format.js { 
          flash[:success] = 'Asociación correctamente creada.'
          @levantar = MateriaRubroRelacion.new
        }
        format.html { redirect_to edit_admin_dato_levantado_path(@levantar), notice: 'Asociación correctamente creado.' }
      else
        format.html { render :new }
        format.js {
          flash[:error] = "Error al crear."
        }
      end
    end
  end

  def edit
  end

  def update
    @levantar.materia_rubro_dato_relacions.destroy_all
    respond_to do |format|
      if @levantar.update(levantado_params)
        format.js { flash[:success] = 'Asociación correctamente actualizada'
          render js:  "window.location='#{admin_materia_rubro_relacions_path}'" }
        format.html { redirect_to edit_admin_materia_rubro_relacion_path(@levantar), notice: 'Asociación correctamente actualizada' }
      else
        format.html { render :edit }
        format.js { flash[:error] = "Error al actualizar." }
      end
    end
  end

  def destroy
    if current_user.is_admin?
      @levantar.destroy
      notice = t(:m_successfully_destroyed, m: t(:dato_levantar))
    else
      error = t(:operación_no_permitida)
    end
    redirect_to admin_materia_rubro_relacions_path, flash: { notice: notice, error: error }
  end

  def get_unidades
     @unidades = MateriaRubroRelacion.compatibles params[:base]
  end

  private
    def set_levantar
      @levantar = MateriaRubroRelacion.find(params[:id])
    end

    def levantado_params
      params.require(:materia_rubro_relacion).permit(
        :materia_sustancia_id,
        :actividad_economica_id,
        materia_rubro_dato_relacions_attributes: [:dato_recolectado_id, :_delete]
      )
    end
    def set_unidades
      @unidades = Unit.definitions.values
      @unidades.reject! { |k| k.prefix?}
      @unidades = @unidades.map{|k| [k.name.gsub(/[<>]/, '').upcase, k.display_name] }      
    end
end
