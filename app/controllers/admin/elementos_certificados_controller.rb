class Admin::ElementosCertificadosController < ApplicationController
  before_action :authenticate_user!, except: [:certificado]
  before_action :set_variables_del_usuario, except: [:certificado]
  before_action :set_cargar_institucion, only: [:filtro_institucion]
  before_action :tiene_permiso?, except: [:index, :certificado]

  def index
  end

  def filtro_institucion
  end

  def certificado
    auditoria = Auditoria.find(params[:auditoria_id])
    adhesion_elemento = AdhesionElemento.find(params[:adhesion_elemento_id])
    auditoria_nivel = AuditoriaNivel.find(params[:auditoria_nivel_id]) if params.has_key?(:auditoria_nivel_id)
    auditoria_elementos = auditoria.auditoria_elementos.where(adhesion_elemento_id: adhesion_elemento.id)
    #minuta_ceremonia = Minuta.find_by(convocatoria_id: auditoria.convocatoria_id)
    
    fecha_certificacion = auditoria_elementos.order(aprobacion_fecha: :asc).last.aprobacion_fecha
    if auditoria.con_validacion
      #si tiene validacion lo tomo desde dato de validacion
      fecha_certificacion = (AuditoriaValidacion.find_by(auditoria_id: auditoria.id).updated_at rescue nil)
    end
    vigencia_certificacion = "Pendiente"

    if auditoria_nivel.nil?
      if auditoria.final
        #si es audit final tomo valor general de informe
        tiempo = auditoria.flujo.manifestacion_de_interes.informe_acuerdo.vigencia_certificacion_final
      else
        #si no el plazo cargado en lista de plazos
        tiempo = auditoria.plazo
        #si no esta en la lista de plazos utilizo el de auditoria final
        tiempo = auditoria.flujo.manifestacion_de_interes.informe_acuerdo.vigencia_certificacion_final if tiempo.blank?
      end
      tiempo_calculado = 0
      if tiempo.blank?
        #para version antigua (utilizaba meses)
        tiempo = auditoria.plazo if tiempo.blank?
        #si no existe dato se fuerza a el plazo minimo (1 año/12 meses)
        tiempo = 12 if tiempo.blank?
        tiempo_calculado = tiempo
      else
        #años a meses
        tiempo_calculado = tiempo * 12
      end
    else
      #de nivel
      #cargo el plazo del nivel
      tiempo = auditoria_nivel.plazo
      #si nivel no tiene cargo el de auditoria
      tiempo = aud.plazo if tiempo.blank?
      #si auditoria no tiene cargo el de aud final
      tiempo = aud.flujo.manifestacion_de_interes.informe_acuerdo.vigencia_certificacion_final if tiempo.blank?
      #si no existe plazo final se fuera al minimo 1 año/12 meses
      tiempo = 1 if tiempo.blank?

      tiempo_calculado = tiempo * 12
    end

    vigencia_certificacion = (fecha_certificacion + tiempo_calculado.months)

    if vigencia_certificacion != "Pendiente" && vigencia_certificacion >= Date.today
      archivo = CreaCertificadoCertificacion.new(auditoria, adhesion_elemento, fecha_certificacion, vigencia_certificacion, auditoria_nivel).generar_archivo
      send_data archivo, disposition: "inline", filename: "Certificado.pdf"
    else
      #NOSE
    end
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