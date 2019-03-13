class Admin::PrivacidadPermisosController < ApplicationController
  before_action :set_admin_privacidad_permiso, only: [:update]
  # before_action

  # GET /admin/privacidad_permisos
  def index
    # @admin_privacidad_permisos = Admin::PrivacidadPermiso.all
  end

  # GET /admin/privacidad_permisos/1
  def show
  end

  # GET /admin/privacidad_permisos/new
  def new
    # @admin_privacidad_permiso = Admin::PrivacidadPermiso.new
  end

  # GET /admin/privacidad_permisos/1/edit
  def edit
  end

  # POST /admin/privacidad_permisos
  def create
    # @admin_privacidad_permiso = Admin::PrivacidadPermiso.new(admin_privacidad_permiso_params)

    # if @admin_privacidad_permiso.save
    #   redirect_to @admin_privacidad_permiso, notice: 'Privacidad permiso was successfully created.'
    # else
    #   render :new
    # end
  end

  # PATCH/PUT /admin/privacidad_permisos/1
  def update
    respond_to do |format|
      if @privacidad.update(admin_privacidad_permiso_params)
        format.js { flash.now[:success] = 'Privacidad correctamente actualizada.' }
      else
        format.js { flash.now[:warning] = 'Conflicto al actualizar.' }
      end
    end
  end

  # DELETE /admin/privacidad_permisos/1
  def destroy
    # @admin_privacidad_permiso.destroy
    # redirect_to admin_privacidad_permisos_url, notice: 'Privacidad permiso was successfully destroyed.'
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_admin_privacidad_permiso
      @privacidad = PrivacidadPermiso.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def admin_privacidad_permiso_params
      params.require(:privacidad_permiso).permit(
        :entidad, 
        fields_visibility: {}
      )
    end
end
