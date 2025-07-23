class Admin::UsersController < ApplicationController
	include ApplicationHelper
	before_action :authenticate_user!
	before_action :set_user, only: [:edit, :update, :destroy]
  before_action :set_new_contribuyente, only: [:new, :edit, :create, :update]
  before_action :set_flujo, only: [:buscador]
  before_action :posee_permisos_administracion_admin, except: [:edit_modal]

	def index
		# binding
		# @users = User.where('id NOT IN (?)', User::ROOT).order(nombres: :asc, apellido_paterno: :asc, apellido_materno: :asc).all		
		if @acceso == :admin || current_user.posee_rol_ascc?(Rol::REVISOR_TECNICO) || current_user.posee_rol_ascc?(Rol::JEFE_DE_LINEA) #DZC 2018-10-20 15:24:38
	      @users = User.where('id NOT IN (?)', User::ROOT).order(nombre_completo: :asc).all
	    else
	      #obtengo todas las personas asociadas a los contribuyentes, en donde posee el cargo.-
	      personas_empresas = Persona.where(contribuyente_id: current_user.instituciones_donde_es_admin)
	      @users = User.where('id NOT IN (?)', User::ROOT).where(id: personas_empresas.distinct.pluck('user_id')).order(nombre_completo: :asc).all
	    end
	end

	def new
		acceso_permitido
	    @user 		= User.new
	    @persona 	= @user.personas.build
	    @cargo 		= @persona.persona_cargos.build
	end

	def edit
		if @acceso != :admin
			coincidencias = @user.personas.pluck('contribuyente_id') & current_user.instituciones_donde_es_admin #Obtiene las concidencias entre los arrays.-
			if coincidencias.size == 0
				return render :file => "layouts/error_pages/401.html.haml", :status => :unauthorized
			end
		end

	end

	def create
		@user = User.new(create_user_params)
		respond_to do |format|
      if @user.user_id.nil?
  			if @user.save
          if(create_user_params[:temporal] == "true")
            @usuario_temporal = @user
            format.js {}
          else
    				message = t(:m_successfully_created, m: t(:user))
    				format.js { flash.now[:success] = message }
    				format.html { redirect_to admin_users_url, notice: message }
          end
  			else
          if(create_user_params[:temporal] == "true")
            @usuario_temporal = @user
            format.js {}
          else
    				@personas = @user.personas
    				format.js
    				format.html { render :new }
          end
  			end
      else
        @user.save(validate: false)
        @usuario_temporal = @user
        format.js {}
      end
		end
	end

	def update
    @user.assign_attributes(update_user_params)
		respond_to do |format|
			# DZC 2018-11-16 13:00:30 se agrega manejo de errores por datos instanciados en tablas
			begin
        if @user.valid?
          if !@user.user_id.nil? && @user.user_id == @user.id
            @usuario_temporal = @user.clonar_con_relaciones
          else
            @user.save
            @usuario_temporal = @user
          end
          if !@user.temporal
    				format.js { flash.now[:success] = t(:m_successfully_updated, m: t(:user))  }
    			else
          	format.js {}
          end
        else
          if @user.temporal
            @usuario_temporal = @user
          else
            format.html { render :edit }
          end
          format.js {}
        end

			rescue ActiveRecord::InvalidForeignKey => e
				format.js{
					flash[:error] = "No se pudo actualizar las asociaciones con instituciones del usuario por que ya existen datos ingresados al sistema que requieren la existencia de dichas relaciones"
				}
			end
		end
	end

	def destroy
		unless @user.is_root?
			# DZC 2018-11-16 13:00:30 se agrega manejo de errores por datos instanciados en tablas
			begin
				@user.destroy
				notice = t(:m_successfully_destroyed, m: t(:user))
			rescue ActiveRecord::InvalidForeignKey => e
				error = "No se pudo eliminar al usuario '#{@user.nombre_completo}', RUT:#{@user.rut}, por que ya existen datos ingresados al sistema que requieren la existencia de las asociaciones del usuario con sus instituciones"
			end
		else
			error = t(:operación_no_permitida)
		end
		redirect_to admin_users_path, flash: { notice: notice, error: error }
	end

	def buscador
		rut = buscador_params[:rut].gsub('.', '')
		nombre = buscador_params[:nombre_completo]
		@usuarios = User
		if rut.present?
			rut = rut.upcase
      @usuarios = @usuarios.where("rut = ?", rut)
      @filtro_utilizado = "Rut: #{rut}"
    end
    if nombre.present?
      @usuarios = @usuarios.where("nombre_completo ILIKE '%#{nombre}%'")
      filtro = "Nombre: #{nombre}"
      if @filtro_utilizado.blank?
        @filtro_utilizado = filtro
      else
        @filtro_utilizado += " Y #{filtro}"
      end
    end
    @modal_id = buscador_params[:modal_id]
	end

  def edit_modal
    if params[:id].blank?
      @usuario_temporal = User.new
    else
      @usuario_temporal = User.unscoped.find_by(user_id: params[:id], flujo_id: params[:flujo_id]) || User.unscoped.find(params[:id])
    end
    @usuario_temporal.temporal = true
    @usuario_temporal.flujo_id = params[:flujo_id]
    @usuario_temporal.user_id = params[:user_id] unless params[:user_id].blank?
    render layout: false
  end

  def edit_actor_modal
    if params[:id].blank?
      @usuario_actor = User.new
    else
      @usuario_actor = User.unscoped.find_by(user_id: params[:id], flujo_id: params[:flujo_id]) || User.unscoped.find(params[:id])
    end
    @usuario_actor.temporal = true
    @usuario_actor.flujo_id = params[:flujo_id]
    @usuario_actor.user_id = params[:user_id] unless params[:user_id].blank?
    render layout: false
  end

  def recarga_contribuyente
	@personas = ::Persona.where(user_id: params[:user_id])
	@contribuyente = Contribuyente.new
	@contribuyente_actor = Contribuyente.new
    @contribuyentes = Contribuyente.where(id: @personas.map{|m|m[:contribuyente_id]}).all
	@es_para_seleccion = "true"

	render partial: 'admin/contribuyentes/buscador', locals: { es_para_seleccion: @es_para_seleccion }
  end

	######################################################################################################################################################################################
	private
		def set_user
			@user = User.unscoped.find(params[:id])
			@persona =  @user.personas.size > 0 ? @user.personas.first : Persona.new
		end

	    def set_new_contribuyente
	      @contribuyente    = Contribuyente.new
	      @contribuyentes  = []
	    end

		def common_params
			[
				:nombre_completo,
				:telefono,
				:email,
				:web_o_red_social_1,
				:web_o_red_social_2,
				:password,
				:password_confirmation,
        :temporal,
        :flujo_id,
        :user_id,
				personas_attributes: [
          :id,
          :user_id,
          :contribuyente_id,
          :establecimiento_contribuyente_id,
          :email_institucional,
          :telefono_institucional,
          :_destroy,
          persona_cargos_attributes: [
          	:id,
          	:persona_id,
          	:establecimiento_contribuyente_id,
          	:cargo_id,
          	:_destroy,
          ]
				]
			]
		end

		def create_user_params
			params.require(:user).permit((common_params << :rut))
		end

		def update_user_params
			parameters = params.require(:user).permit(common_params)
			if parameters[:password].blank?
				parameters.delete(:password)
				parameters.delete(:password_confirmation)
			end
			parameters
		end

		def buscador_params
			params.require(:buscador).permit(
				:rut,
				:nombre_completo,
				:flujo_id,
				:modal_id)
		end

		def acceso_permitido
			if @acceso != :admin
				return render :file => "layouts/error_pages/401.html.haml", :status => :unauthorized
			end
		end

		def set_flujo
			if params[:buscador][:flujo_id].present?
				@flujo_id = params[:buscador][:flujo_id].to_i
			end
		end

end