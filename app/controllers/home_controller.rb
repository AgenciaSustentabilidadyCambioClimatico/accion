class HomeController < ApplicationController
  #before_action :authenticate_user!, only: [:consulta_publica_propuestas_acuerdo]
  before_action :set_datos_publicos, only: [:acuerdos_firmados, :empresas_y_elementos_adheridos, :empresas_y_elementos_certificados]
  before_action :datos_header_no_signed, except: [:consulta_publica_propuestas_acuerdo, :get_comunas, :solicitar_adhesion_guardar]
  before_action :set_manif_de_interes, only: [:solicitar_adhesion, :solicitar_adhesion_guardar]
  def index
    if user_signed_in?
      include_models    = [:tipo_instrumento,:contribuyente,:estado_manifestacion,:persona]
      persona_ids       = @personas.map{|m|m[:id]}
      @manifestaciones  = []#ManifestacionDeInteres.includes(include_models).where(persona_id: persona_ids).order(id: :desc).all
      TareaPendiente.continua_flujo_tareas_plazo_vencido(current_user.id) # DZC continua con el flujo de las tareas con plazo vencido, para que se excluyan de la bandeja de entrada
      @pendientes       = TareaPendiente.todas_del_(current_user.id) #incluye todas las tareas pendientes del usuario
    else
      @clasificaciones_padre = Clasificacion.where(clasificacion_id: nil)
    end    
  end

  def consulta_publica_propuestas_acuerdo
    @tarea_pendientes = TareaPendiente.where(tarea_id: Tarea::ID_APL_019)
    @acuerdos = []
    @tarea_pendientes.each do |tp|
      flujo = tp.flujo
      manifestacion_de_interes = flujo.manifestacion_de_interes
      tarea_20 = TareaPendiente.where(flujo_id: flujo.id, tarea_id: Tarea::ID_APL_020).first

      nombre_acuerdo = manifestacion_de_interes.nombre_acuerdo
      estado_consulta = "Abierta"
      estado_consulta = "Cerrada" if !tarea_20.nil? && tarea_20.estado_tarea_pendiente_id == EstadoTareaPendiente::NO_INICIADA && tp.estado_tarea_pendiente_id == EstadoTareaPendiente::ENVIADA
      estado_consulta = "Finalizada" if !tarea_20.nil? && tarea_20.estado_tarea_pendiente_id == EstadoTareaPendiente::ENVIADA && tp.estado_tarea_pendiente_id == EstadoTareaPendiente::ENVIADA

      @acuerdos << {
        tarea_pendiente_id: tp.id,
        manifestacion_de_interes_id: manifestacion_de_interes.id,
        encuesta_id: tp.tarea.encuesta_id,
        nombre_acuerdo: nombre_acuerdo,
        estado_consulta: estado_consulta
      }
    end
  end

  def adherir_a_un_acuerdo
    @acuerdos = ManifestacionDeInteres.where.not(firma_fecha: nil)
    @acuerdos = @acuerdos.select{|m| !m.informe_acuerdo.nil? && TareaPendiente.where(flujo_id: m.flujo.id, tarea_id: Tarea::ID_APL_025).count > 0 }.sort_by { |a| a.informe_acuerdo.calcula_fecha_plazo_maximo_adhesion}.reverse!
  end

  def solicitar_adhesion
    
  end

  def solicitar_adhesion_guardar
    @adhesion.assign_attributes(adhesion_params)
    @adhesion.current_user = current_user
    respond_to do |format|
      if @adhesion.save
        #abro tarea 28 si esque no esta abierta
        @tarea_pendiente.pasar_a_siguiente_tarea ['A'], {}, false
        @adhesion = Adhesion.new(flujo_id: @flujo.id, externa: true, rol_id: @tarea.rol_id)
        format.js{
          flash.now[:success] = "Adhesion enviada correctamente"
        }
      else
        format.js
      end
    end
  end

  def acuerdos_firmados
    #get requerido por cliente
    if params[:clasificacion_id].blank?
      flujos_ids = Flujo.all.pluck(:id)
    else
      clasificacion = Clasificacion.find(params[:clasificacion_id])
      flujos_ids = clasificacion.acuerdos
    end
    manifestacion_de_intereses_ids = Flujo.where(id: flujos_ids).pluck(:manifestacion_de_interes_id)
    @manifestaciones_de_interes = ManifestacionDeInteres.where(id: manifestacion_de_intereses_ids).where.not(firma_fecha: nil)
  end

  def acuerdo_seleccionado
    #cargar valores generales y de clasificacion
    #si es por clasificacion, debo cargar las clasificaciones padre asociadas, si una no es padre debo cargar su padre
    #porque podria un padre agrupas muchos metas hijo
    #si es por meta muetro todos los metas, sea padre o hijo, da lo mismo
    if params[:acuerdo_id].blank?
      redirect_to root_path
    else
      @vista = params[:vista]
      @vista = "clasificaciones" if @vista.blank?
      @manifestacion_de_interes = ManifestacionDeInteres.find(params[:acuerdo_id])
      clasificaciones_ids = []
      if @vista == "clasificaciones"
        clasificaciones_ids += AccionClasificacion.joins("INNER JOIN set_metas_acciones ON set_metas_acciones.accion_id = accion_clasificaciones.accion_id")
                                                  .where("set_metas_acciones.flujo_id = #{@manifestacion_de_interes.flujo.id}")
                                                  .pluck("accion_clasificaciones.clasificacion_id")
        clasificaciones_ids += MateriaSustanciaClasificacion.joins("INNER JOIN set_metas_acciones ON set_metas_acciones.materia_sustancia_id = materia_sustancia_clasificaciones.materia_sustancia_id")
                                                  .where("set_metas_acciones.flujo_id = #{@manifestacion_de_interes.flujo.id}")
                                                  .pluck("materia_sustancia_clasificaciones.clasificacion_id")
      else
        clasificaciones_ids += Accion.joins("INNER JOIN set_metas_acciones ON set_metas_acciones.accion_id = acciones.id")
                                      .where("set_metas_acciones.flujo_id = #{@manifestacion_de_interes.flujo.id}")
                                      .pluck("acciones.meta_id")
        clasificaciones_ids += MateriaSustancia.joins("INNER JOIN set_metas_acciones ON set_metas_acciones.materia_sustancia_id = materia_sustancias.id")
                                                .where("set_metas_acciones.flujo_id = #{@manifestacion_de_interes.flujo.id}")
                                                .pluck("materia_sustancias.meta_id")
        clasificaciones_ids += SetMetasAccion.where(flujo_id: @manifestacion_de_interes.flujo.id).pluck(:meta_id)
      end
      @clasificaciones_del_acuerdo = Clasificacion.where(id: clasificaciones_ids)
    end
  end

  def empresas_y_elementos_adheridos
    #si seleccione acuerdo cargo su institucion,
    #si la institucion es temporal cargo la original
    @elementos_adheridos = []
    if params[:acuerdo_id].blank?
      ManifestacionDeInteres.all.each do |manif_de_interes|
        @elementos_adheridos += manif_de_interes.elementos_adheridos
      end
    else
      @manifestacion_de_interes = ManifestacionDeInteres.find(params[:acuerdo_id])
      @elementos_adheridos = @manifestacion_de_interes.elementos_adheridos
    end
  end

  def empresas_y_elementos_certificados
    #si seleccione acuerdo cargo su institucion,
    #si la institucion es temporal cargo la original
    @elementos_certificados = []
    if params[:acuerdo_id].blank?
      ManifestacionDeInteres.all.each do |manif_de_interes|
        @elementos_certificados += manif_de_interes.elementos_certificados
      end
    else
      @manifestacion_de_interes = ManifestacionDeInteres.find(params[:acuerdo_id])
      @elementos_certificados = @manifestacion_de_interes.elementos_certificados
    end
  end

  def get_comunas
    @region = Region.find(params[:id])
    @comunas = @region.comunas
  end

  private
  def set_datos_publicos
    #id 1 porque solo sera un registro que contenga la data
    @datos_publicos = DatosPublico.load
  end



  def datos_header_no_signed
    if !user_signed_in?
      @acuerdos_firmados = ManifestacionDeInteres.where.not(firma_fecha: nil).count
      @empresas_adheridas = []
      @empresas_certificadas = []
      ManifestacionDeInteres.all.each do |manif_de_interes|
        manif_de_interes.elementos_adheridos.each do |elem_adherido|
          @empresas_adheridas << elem_adherido[:rut_institucion]
        end
        manif_de_interes.elementos_certificados.each do |elem_cert|
          @empresas_certificadas << elem_cert[:rut_institucion]
        end
      end
      @empresas_adheridas = @empresas_adheridas.uniq.length
      @empresas_certificadas = @empresas_certificadas.uniq.length
      flujos = Flujo.where.not(manifestacion_de_interes_id: nil)
      @acciones = SetMetasAccion.where(flujo_id: flujos.pluck(:id)).count
    end
  end

  def set_manif_de_interes
    @manifestacion_de_interes = ManifestacionDeInteres.find(params[:manifestacion_de_interes_id])
    @flujo = @manifestacion_de_interes.flujo
    @todas = []
    #@todas = @adhesion.adhesiones_todas_propietario()
    #tarea pendiente 025
    @tarea_pendiente = TareaPendiente.where(flujo_id: @flujo.id, tarea_id: Tarea::ID_APL_025).first
    @tarea = Tarea.find(Tarea::ID_APL_025_1)
    @descargables = @tarea.get_descargables
    @regiones = Region.all
    @adhesion = Adhesion.new(flujo_id: @flujo.id, externa: true, rol_id: @tarea.rol_id)
  end

  def adhesion_params
    params.require(:adhesion).permit(
      :rut_institucion_adherente, :nombre_institucion_adherente, :matriz_direccion, :matriz_region_id, :matriz_comuna_id,:tipo_contribuyente_id,
      :rut_representante_legal, :nombre_representante_legal, :fono_representante_legal, :email_representante_legal,
      :archivo_elementos,
      :archivo_elementos_cache,
      :archivos_adhesion_y_documentacion_cache,
      archivos_adhesion_y_documentacion: []
    )
  end
end