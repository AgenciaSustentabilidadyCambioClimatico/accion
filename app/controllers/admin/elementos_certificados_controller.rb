class Admin::ElementosCertificadosController < ApplicationController
  before_action :authenticate_user!
  before_action :set_variables_del_usuario
  before_action :set_cargar_institucion, only: [:filtro_institucion]
  before_action :tiene_permiso?, except: [:index]

  def index
  end

  def filtro_institucion
  end

  private
    def set_variables_del_usuario
      @instituciones = Contribuyente.joins(personas: :persona_cargos)
                                  .where(personas: {user_id: current_user.id})
                                  .where(persona_cargos: {cargo_id: Cargo::ENCARGADO_INS})
      @elementos_certificados = []  
    end

    def set_cargar_institucion
      @institucion = nil
      if params[:institucion_id].present?
        institucion_id = params[:institucion_id].to_i
        @institucion = Contribuyente.find(institucion_id) 
        if @institucion.present? #DZC 2018-11-14 15:25:17 verificamos que la instución ingresada exista

          @elementos_certificados = @institucion.elementos_certificados
        else
          flash.now[:warning] = "La institución ID #{params[:institucion_id]} no fue encontrada."
          @elementos_certificados = []
          #redirect_to admin_elementos_certificados_path
        end

      else
        @institucion=nil
        @elementos_certificados = []
      end
    end

    # DZC 2018-11-14 15:25:50 valida que el usuario este autorizado para este contribuyente específico
    def tiene_permiso?
      tiene = true
      if !@instituciones.include?(@institucion) && !@institucion.blank?
        tiene = false
        flash[:warning] = "Usted no tiene permiso para acceder a los elementos certificados de la institución #{@institucion.present? ? @institucion.razon_social.to_s : nil}"
        redirect_to admin_reporte_automatizado_avances_path
      end
      tiene
    end  
end