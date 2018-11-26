class InstrumentosController < ApplicationController
  before_action :authenticate_user!
  before_action :set_instrumento, only: [:show, :edit, :update, :destroy]

  # GET /instrumentos
  def index
    @instrumentos = Instrumento.all
  end

  def search
    @instrumento = Instrumento.new(params.require(:instrumento).permit(:nombre))
    @instrumento.filter_mode = true
    if @instrumento.valid?
     @instrumentos = Instrumento.where("nombre ILIKE '%#{@instrumento.nombre}%'").all
    else
      @errors = true
    end
  end

  # GET /instrumentos/1
  def show
  end

  # GET /instrumentos/new
  def new
    @instrumento = Instrumento.new
  end

  # GET /instrumentos/1/edit
  def edit
  end

  # POST /instrumentos
  def create
    @instrumento = Instrumento.new(instrumento_params)

    if @instrumento.save
      redirect_to @instrumento, notice: 'Instrumento was successfully created.'
    else
      render :new
    end
  end

  # PATCH/PUT /instrumentos/1
  def update
    if @instrumento.update(instrumento_params)
      redirect_to @instrumento, notice: 'Instrumento was successfully updated.'
    else
      render :edit
    end
  end

  # DELETE /instrumentos/1
  def destroy
    @instrumento.destroy
    redirect_to instrumentos_url, notice: 'Instrumento was successfully destroyed.'
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_instrumento
      @instrumento = Instrumento.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def instrumento_params
      params.require(:instrumento).permit(:tipo_instrumento_id, :nivel, :nombre, :poligono_ubicacion, :glosario, :certificaciones_homologables)
    end
end
