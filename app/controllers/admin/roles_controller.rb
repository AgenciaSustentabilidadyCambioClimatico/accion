class Admin::RolesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_rol, only: [:show, :edit, :update, :destroy]

  def index
    @roles = Rol.order(id: :asc).all
    @rol = Rol.new
  end

  def new
    @rol = Rol.new
  end

  def edit
  end

  def create
    # 
    @rol = Rol.new(rol_params)
    @rol.nombre = @rol.nombre.titleize #DZC 2018-10-23 17:41:39 transforma en mayúsculas las primeras letras de cada palabra del nombre
    # @rol.nombre = @rol.nombre.gsub(/\w+/, &:capitalize) # DZC 2018-10-23 17:45:03 no funciona con acentos, snif snif
    respond_to do |format|
      if @rol.save
        format.js { 
          flash[:success] = 'Rol correctamente creado.'
          render js: "window.location='#{admin_roles_path}'" 
        }
        format.html { redirect_to admin_roles_path, notice: 'Rol correctamente creado.' }
      else
        format.html { render :new }
        format.js
      end
    end
  end

  def update
    respond_to do |format|
      # 
      @rol.assign_attributes(rol_update_params)
      @rol.nombre = @rol.nombre.titleize
      # @rol.nombre = @rol.nombre.split.map(&:capitalize).join(" ") #DZC 2018-10-23 17:41:39 transforma en mayúsculas las primeras letras de cada palabra del nombre
      if @rol.save
        format.js { 
          flash[:success] = 'Rol correctamente actualizado.' 
          render js: "window.location='#{admin_roles_path}'"
        }
        format.html { redirect_to admin_roles_path, notice: 'Rol correctamente actualizado.' }
      else
        format.html { render :index }
        format.js
      end
    end
  end

  def destroy
    begin #DZC 2018-10-17 14:59:44 se agrega para solucionar el intento de eliminar roles actualmente usados en tareas
      @rol.destroy
      redirect_to admin_roles_url, notice: 'Rol correctamente eliminado.'
    rescue ActiveRecord::InvalidForeignKey => rol_usado
      respond_to do |format|
        format.html { redirect_to admin_roles_path, flash: { error: "No se pudo eliminar el rol #{@rol.nombre}, por que se está utilizando en la o las tareas #{Tarea.where(rol_id: @rol.id).pluck(:nombre).to_sentence}." } }
      end
    end
  end

  private
    def set_rol
      @rol = Rol.find(params[:id])
    end

    def rol_params
      params.require(:rol).permit(
      	:nombre,
        :descripcion
      )
    end

    def rol_update_params
      params.require(:rol).permit(
        :nombre,
        :descripcion
      )
    end
end