class Admin::TiposInstrumentosController < ApplicationController
  before_action :authenticate_user!
  before_action :set_tipo_instrumento, only: [:show, :edit, :update, :destroy]
  before_action :__set_commons, only: [:index]

  def index
  end

  def show
  end

  def new
    @tipo_instrumento = TipoInstrumento.new
  end

  def edit
    @tipo_instrumentos = {}#TipoInstrumento.__por_responsable(current_user.session) 
  end

  def create
    @tipo_instrumento = TipoInstrumento.new(tipo_instrumento_params)
    respond_to do |format|
      if @tipo_instrumento.save
        format.js { 
          flash.now[:success] = 'Tipo instrumento correctamente creado.'
          @tipo_instrumento = TipoInstrumento.new
        }
        format.html { redirect_to edit_admin_tipos_instrumento_url(@tipo_instrumento), notice: 'Tipo instrumento correctamente creado.' }
      else
        format.html { render :new }
        format.js
      end
    end
  end

  def update
    respond_to do |format|
      if @tipo_instrumento.update(tipo_instrumento_params)
        format.js { flash.now[:success] = 'Tipo instrumento correctamente actualizado.' }
        format.html { redirect_to edit_admin_tipos_instrumento_url(@tipo_instrumento), notice: 'Tipo instrumento correctamente actualizado.' }
      else
        format.html { render :edit }
        format.js
      end
    end
  end

  def destroy
    error = nil
    notice = nil
    # ToDo: Responsables, Tareas
    if TipoInstrumento.where(tipo_instrumento_id: @tipo_instrumento.id).size > 0
      error = "Esta acción viola la restricción de llave foránea"
    else
      @tipo_instrumento.destroy
      notice = 'Tipo instrumento correctamente eliminado.'
    end
    redirect_to admin_tipos_instrumentos_url, flash: { error: error, notice: notice }
  end

  private
    def set_tipo_instrumento
      @tipo_instrumento = TipoInstrumento.find(params[:id])
    end

    def tipo_instrumento_params
      params.require(:tipo_instrumento).permit(:tipo_instrumento_id,:nombre,:descripcion)
    end

    def __set_commons
      @tipos_instrumentos = TipoInstrumento.includes([:tipo]).order(nombre: :asc, tipo_instrumento_id: :desc).all
      @tipo_instrumento = TipoInstrumento.new
    end
end
