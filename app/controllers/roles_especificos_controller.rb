class RolesEspecificosController < ApplicationController
	before_action :authenticate_user!
	before_action :set_tarea_pendiente
	before_action :carga_datos

	def index
		@contribuyente    = Contribuyente.new
		@contribuyentes  = []
	end

	def update
		@manifestacion_de_interes.assign_attributes(roles_params)
		respond_to do |format|
			if @manifestacion_de_interes.valid?
				@manifestacion_de_interes.tarea_codigo = @tarea.codigo
				@manifestacion_de_interes.save
				format.html{ 
					redirect_to roles_especificos_manifestacion_de_interes_path(@tarea_pendiente, @manifestacion_de_interes), 
					flash: { notice: "Usuarios asignados" }
				}
			else
				format.html{ 
					redirect_to roles_especificos_manifestacion_de_interes_path(@tarea_pendiente, @manifestacion_de_interes), 
					flash: { notice: "Error al asignar usuarios" }
				}
			end
		end
	end

	def filtro_entregables
		@personas = Persona.por_institucion(params[:contribuyente_id])
		respond_to do |format|
			format.js{}
		end
	end

	def filtro_carga_datos
		@personas = Persona.por_institucion(params[:contribuyente_id])
		respond_to do |format|
			format.js{}
		end
	end

	private

		def set_tarea_pendiente
			@tarea_pendiente = TareaPendiente.find(params[:tarea_pendiente_id])
			autorizado? @tarea_pendiente
		end	

		def carga_datos
			@manifestacion_de_interes = ManifestacionDeInteres.find(params[:id])
			@manifestacion_de_interes.temporal = true
		end

		def roles_params
			parametros = params.require(:manifestacion_de_interes).permit(
				:roles_especificos_institucion_entregables,
				:roles_especificos_usuario_entregables,
				:roles_especificos_comentarios_entregables,
				:roles_especificos_institucion_carga_datos,
				:roles_especificos_usuario_carga_datos,
				:roles_especificos_comentarios_carga_datos
			)
		end

	

end