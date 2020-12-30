class Admin::DatoRecolectadosController < ApplicationController
	before_action :authenticate_user!
  before_action :set_propiedad, only: [:show, :edit, :update, :destroy]
  before_action :set_unidades, only: [:new, :edit, :create, :update]

	def index	
		@propiedades= []	
	end

	def search
		nombre = params[:nombre]
		cpc = params[:cpc]
		@errors = false
		@propiedades = []
		@resultado_mostrados = 25
  	@filtro_utilizado = []
    
   datos_recolectar = DatoRecolectado
   if nombre.present?
   	@propiedades = datos_recolectar.where("nombre ILIKE ?", "%#{nombre}%")
   	@filtro_utilizado << "Nombre: #{nombre}"
   end
   if cpc.present?
   	@propiedades = datos_recolectar.where("cpc ILIKE ?", "%#{cpc}%")
   	@filtro_utilizado << "Codigo producto: #{cpc}"
   end

   #parsear filtros
   	if !@filtro_utilizado.empty?
      @filtro_utilizado = @filtro_utilizado.join(', ')
    end
	end
  def new
    @propiedad = DatoRecolectado.new    
  end
  def create
    @propiedad = DatoRecolectado.new(propiedad_params)
    respond_to do |format|
      if @propiedad.save        
        format.js { 
          flash[:success] = 'Propiedad correctamente creada.'
          @propiedad = DatoRecolectado.new
        }
        format.html { redirect_to edit_admin_dato_recolectar_propiedade_path(@propiedad), notice: 'Propiedad correctamente creada.' }
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
    respond_to do |format|
      if @propiedad.update(propiedad_params)
        format.js { flash[:success] = 'Propiedad correctamente actualizada'
          render js:  "window.location='#{admin_dato_recolectados_path}'" }
        format.html { redirect_to edit_admin_dato_recolectado_path(@propiedad), notice: 'Propiedad correctamente actualizada' }
      else
        format.html { render :edit }
        format.js { flash[:error] = "Error al actualizar." }
      end
    end
  end

  def destroy
    if current_user.is_admin?
      @propiedad.destroy
      notice = "Propiedad correctamente eliminada"
    else
      error = t(:operación_no_permitida)
    end
    redirect_to admin_dato_recolectados_path, flash: { notice: notice, error: error }
  end

  def get_unidades
	   @unidades = DatoRecolectado.compatibles params[:base]
	end

  private
    def set_propiedad
      @propiedad = DatoRecolectado.find(params[:id])
    end

    def propiedad_params
      params.require(:dato_recolectado).permit(
        :nombre,
        :descripcion,
        :cpc,
        :medios_verificacion,
        :unidad_base,
        unidades_compatibles:[]
      )
    end
    def set_unidades
    	@unidades = Unit.definitions.values
			@unidades.reject! { |k| k.prefix?}
			@unidades = @unidades.map{|k| [k.name.gsub(/[<>]/, '').upcase, k.display_name] } 
      @unidades += DatoRecolectado.unidades_extras.map{|u| [u[:name], u[:prefix]]}
    end
end
