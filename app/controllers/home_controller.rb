class HomeController < ApplicationController
  #before_action :authenticate_user!, only: [:consulta_publica_propuestas_acuerdo]
  before_action :set_datos_publicos, only: [:acuerdos_firmados, :empresas_y_elementos_adheridos, :empresas_y_elementos_certificados]
  before_action :datos_header_no_signed, except: [:get_comunas, :solicitar_adhesion_guardar]
  before_action :set_manif_de_interes, only: [:solicitar_adhesion, :solicitar_adhesion_guardar]
  def index
    if user_signed_in?
      include_models    = [:tipo_instrumento,:contribuyente,:estado_manifestacion,:persona]
      persona_ids       = @personas.map{|m|m[:id]}
      @manifestaciones  = []#ManifestacionDeInteres.includes(include_models).where(persona_id: persona_ids).order(id: :desc).all
      TareaPendiente.continua_flujo_tareas_plazo_vencido(current_user.id)
      gg = TareaPendiente.todas_del_(current_user.id).group_by {|f| f.flujo.id }# DZC continua con el flujo de las tareas con plazo vencido, para que se excluyan de la bandeja de entrada
      rr = []
      gg.each do |index, value|
        rr << value.first
      end
      @algo = TareaPendiente.todas_del_(current_user.id) + rr

      @pendientes     = @algo #incluye todas las tareas pendientes del usuario
    else
      @clasificaciones_padre = ReporteriaDato.find_by(ruta: "index")
    end    
  end

  def consulta_publica_propuestas_acuerdo
    @tarea_pendientes = TareaPendiente.where(tarea_id: Tarea::ID_APL_019)
    @acuerdos = []
    @tarea_pendientes.each do |tp|
      flujo = tp.flujo
      manifestacion_de_interes = flujo.manifestacion_de_interes
      tarea_20 = TareaPendiente.where(flujo_id: flujo.id, tarea_id: Tarea::ID_APL_020).first

      disponible = true
      disponible = false if !tarea_20.nil? && tarea_20.estado_tarea_pendiente_id == EstadoTareaPendiente::NO_INICIADA && tp.estado_tarea_pendiente_id == EstadoTareaPendiente::ENVIADA
      disponible = false if !tarea_20.nil? && tarea_20.estado_tarea_pendiente_id == EstadoTareaPendiente::ENVIADA && tp.estado_tarea_pendiente_id == EstadoTareaPendiente::ENVIADA

      @acuerdos << {
        tarea_pendiente_id: tp.id,
        manifestacion_de_interes_id: manifestacion_de_interes.id,
        encuesta_id: tp.tarea.encuesta_id,
        nombre_acuerdo: manifestacion_de_interes.nombre_acuerdo,
        disponible: disponible,
        estado_acuerdo: manifestacion_de_interes.estado_acuerdo
      }
    end
  end

  def adherir_a_un_acuerdo
    @acuerdos = ManifestacionDeInteres.where("firma_fecha IS NOT NULL OR firma_fecha_hora IS NOT NULL")
    @acuerdos = @acuerdos.select{|m| !m.informe_acuerdo.nil? && TareaPendiente.where(flujo_id: m.flujo.id, tarea_id: Tarea::ID_APL_025).count > 0 }.sort_by { |a| a.informe_acuerdo.calcula_fecha_plazo_maximo_adhesion}.reverse!
  end

  def solicitar_adhesion
    
  end

  def registro_proveedores
  end

  def solicitar_adhesion_guardar
    @adhesion.assign_attributes(adhesion_params)
    @adhesion.current_user = current_user
    @adhesion.tarea_id = @tarea.id
    respond_to do |format|
      if @adhesion.save
        #no tiene usuario
        #flujo tarea 169 es de la 25 a la 28 pero en general
        rac = RegistroAperturaCorreo.create(user_id: nil, flujo_tarea_id: 169, fecha_envio_correo: DateTime.now, flujo_id: @flujo.id)
        asunto = "Solicitud de adhesión a #{@manifestacion_de_interes.nombre_acuerdo} recibida"
        cuerpo = "Solicitud de adhesión de empresa #{@adhesion.nombre_institucion_adherente} para #{@manifestacion_de_interes.nombre_acuerdo} recibida con fecha #{DateTime.now.strftime("%F %T")}. <br> ID de solicitud #{@adhesion.id}"
        FlujoMailer.delay.enviar(
                      asunto, 
                      cuerpo, 
                      @adhesion.email_representante_legal, 
                      rac.id)
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
    @acuerdos_firmados = ReporteriaDato.find_by(ruta: 'acuerdos-firmados', clasificacion_id: params[:clasificacion_id])
  end

  def acuerdo_seleccionado
    if params[:acuerdo_id].blank?
      redirect_to root_path
    else
      @vista = params[:vista]
      @vista = "clasificaciones" if @vista.blank?

      if user_signed_in?
        @manifestacion_de_interes = ManifestacionDeInteres.find(params[:acuerdo_id])
        personas_ids = current_user.personas.pluck(:id)
        adhesiones_ids = Adhesion.where(flujo_id: @manifestacion_de_interes.flujo.id).pluck(:id)
        elementos_adheridos = AdhesionElemento.where(persona_id: personas_ids, adhesion_id: adhesiones_ids)
        personas_flujo = elementos_adheridos.map{|ea| ea.persona.contribuyente_id}
        @contribuyentes_de_usuario = Contribuyente.where(id: personas_flujo)
        alcance_ids = elementos_adheridos.pluck(:alcance_id)
        @acuerdo_seleccionado = ReporteriaDato.new

        where_set_metas = {flujo_id: @manifestacion_de_interes.flujo.id}
        if !@adhesion_elemento.nil?
          where_set_metas[:alcance_id] = @adhesion_elemento.alcance_id 
        else
          where_set_metas[:alcance_id] = alcance_ids 
        end
        where_general = {set_metas_acciones: where_set_metas}

         _datos_clasif = {
          id: @manifestacion_de_interes.id,
          nombre_acuerdo: @manifestacion_de_interes.nombre_acuerdo,
          contribuyente_razon_social: (@manifestacion_de_interes.contribuyente.razon_social rescue ""),
          contribuyente_rut: (@manifestacion_de_interes.contribuyente.rut_completo rescue ""),
          firma_fecha: @manifestacion_de_interes.firma_fecha,
          firma_fecha_hora: @manifestacion_de_interes.firma_fecha_hora,
          acciones: @manifestacion_de_interes.acciones.count,
          empresas_adheridas: @manifestacion_de_interes.empresas_adheridas.count,
          empresas_certificadas: @manifestacion_de_interes.empresas_certificadas.count,
          elementos_adheridos: @manifestacion_de_interes.elementos_adheridos,
          #elementos_adheridos.map{|ea| {id: ea.id, nombre: ea.nombre_del_elemento_v2}}, utilizado antes, pero marcaba 0 en vista logeado. Se deja comentado por si se requiere volver atrás.
          clasificaciones: []
        }

        _cards = []

        if @vista == "clasificaciones"
          #clasificaciones
          clasificaciones_ids = []
          clasif_ids = []
          clasif_ids += AccionClasificacion.joins("INNER JOIN set_metas_acciones ON set_metas_acciones.accion_id = accion_clasificaciones.accion_id")
                                                    .where(where_general)
                                                    .pluck("accion_clasificaciones.clasificacion_id")
          clasif_ids += MateriaSustanciaClasificacion.joins("INNER JOIN set_metas_acciones ON set_metas_acciones.materia_sustancia_id = materia_sustancia_clasificaciones.materia_sustancia_id")
                                                    .where(where_general)
                                                    .pluck("materia_sustancia_clasificaciones.clasificacion_id")
          Clasificacion.where(id: clasif_ids).each do |clasif|
            clasificaciones_ids << clasif.mi_padre_mayor.id
          end
          clasificaciones_ids.uniq
          clasificaciones = Clasificacion.where(id: clasificaciones_ids)
          clasificaciones.each do |clasificacion|
            _acciones_comprometidas = []
            _metas_comprometidas = []
            acciones_ids = clasificacion.set_metas_acciones_comprometidas(@manifestacion_de_interes, [], alcance_ids).pluck(:id)
            clasificacion.metas_comprometidas(@manifestacion_de_interes, [], alcance_ids).each do |meta|
              _meta_comprometida = {nombre: meta.nombre, acciones: []}
              meta.set_metas_acciones_comprometidas_de_meta(@manifestacion_de_interes, [], alcance_ids).each do |accion|
                if acciones_ids.include?(accion.id)
                  _meta_comprometida[:acciones] << {
                    descripcion: accion.descripcion_accion,
                    nombre: "#{accion.accion.nombre}#{(accion.materia_sustancia.blank? ? '' : '/'+accion.materia_sustancia.nombre)}",
                    porcentaje_avance: accion.obtiene_porcentaje_avance,
                    porcentaje_cumplimiento: accion.obtiene_procentaje_cumplimiento(nil, elementos_adheridos.pluck(:id)).gsub("%","").to_f
                  }
                end
              end
              _metas_comprometidas << _meta_comprometida
            end
            _cards << {
              id: clasificacion.id,
              imagen: clasificacion.imagen.url,
              color: clasificacion.color,
              icono: clasificacion.icono.url,
              nombre: clasificacion.nombre,
              descripcion: clasificacion.descripcion,
              metas_comprometidas: _metas_comprometidas,
              acciones_comprometidas: _acciones_comprometidas,
              empresas_comprometidas: clasificacion.empresas_comprometidas(@manifestacion_de_interes, @vista).length,
              cumplimiento_promedio: "#{clasificacion.cumplimiento_promedio(@manifestacion_de_interes, @vista, [], elementos_adheridos.to_a)}%",
              elementos_comprometidos: clasificacion.elementos_comprometidos(@manifestacion_de_interes, @vista).count
            }
          end
        else
          #metas
          metas_ids = []
          metas_ids += Accion.joins("INNER JOIN set_metas_acciones ON set_metas_acciones.accion_id = acciones.id")
                                          .where(where_general)
                                          .pluck("acciones.meta_id")
          metas_ids += MateriaSustanciaMeta.joins("INNER JOIN materia_sustancias ON materia_sustancia_metas.materia_sustancia_id = materia_sustancias.id INNER JOIN set_metas_acciones ON set_metas_acciones.materia_sustancia_id = materia_sustancias.id")
                                                  .where(where_general)
                                                  .pluck("materia_sustancia_metas.clasificacion_id")
          metas_ids += SetMetasAccion.where(flujo_id: @manifestacion_de_interes.flujo.id).pluck(:meta_id)
          metas = Clasificacion.where(id: metas_ids)
          metas.each do |clasificacion|
            _acciones_comprometidas = []
            _metas_comprometidas = []
            clasificacion.set_metas_acciones_comprometidas_de_meta(@manifestacion_de_interes, [], alcance_ids).each do |accion|
              _acciones_comprometidas << {
                descripcion: accion.descripcion_accion,
                nombre: "#{accion.accion.nombre}#{(accion.materia_sustancia.blank? ? '' : '/'+accion.materia_sustancia.nombre)}",
                porcentaje_avance: accion.obtiene_porcentaje_avance,
                porcentaje_cumplimiento: accion.obtiene_procentaje_cumplimiento(nil, elementos_adheridos.pluck(:id)).gsub("%","").to_f
              }
            end
            _cards << {
              id: clasificacion.id,
              imagen: clasificacion.imagen.url,
              color: clasificacion.color,
              icono: clasificacion.icono.url,
              nombre: clasificacion.nombre,
              descripcion: clasificacion.descripcion,
              metas_comprometidas: _metas_comprometidas,
              acciones_comprometidas: _acciones_comprometidas,
              empresas_comprometidas: clasificacion.empresas_comprometidas(@manifestacion_de_interes, @vista).length,
              cumplimiento_promedio: "#{clasificacion.cumplimiento_promedio(@manifestacion_de_interes, @vista, [], elementos_adheridos.to_a)}%",
              elementos_comprometidos: clasificacion.elementos_comprometidos(@manifestacion_de_interes, @vista).count
            }
          end
        end
        _datos_clasif[:clasificaciones] = _cards
        @acuerdo_seleccionado.datos = _datos_clasif
      else
        @acuerdo_seleccionado = ReporteriaDato.find_by(ruta: 'acuerdo-seleccionado', acuerdo_id: params[:acuerdo_id], vista: @vista)
      end

    end
  end

  def empresas_y_elementos_adheridos
    #si seleccione acuerdo cargo su institucion,
    #si la institucion es temporal cargo la original
    @acuerdo_seleccionado = ReporteriaDato.find_by(ruta: 'acuerdo-seleccionado', acuerdo_id: params[:acuerdo_id])
    @header = ReporteriaDato.find_by(ruta: nil)
    @elementos_adheridos = ReporteriaDato.find_by(ruta: "empresas-y-elementos-adheridos", acuerdo_id: params[:acuerdo_id])
  end

  def empresas_y_elementos_certificados
    #si seleccione acuerdo cargo su institucion,
    #si la institucion es temporal cargo la original
    @elementos_certificados = ReporteriaDato.find_by(ruta: "empresas-y-elementos-certificados", acuerdo_id: params[:acuerdo_id])
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
      @header = ReporteriaDato.find_by(ruta: nil)
    end
  end

  def set_manif_de_interes
    @manifestacion_de_interes = ManifestacionDeInteres.find(params[:manifestacion_de_interes_id])
    @flujo = @manifestacion_de_interes.flujo
    @todas = []
    #@todas = @adhesion.adhesiones_todas_propietario()
    #tarea pendiente 025
    @tarea_pendiente = TareaPendiente.where(flujo_id: @flujo.id, tarea_id: Tarea::ID_APL_025).first
    if current_user.nil?
      @tarea = Tarea.find(Tarea::ID_APL_025_1)
    elsif current_user.personas.count == 0
      @tarea = Tarea.find(Tarea::ID_APL_025_2)
    else
      @tarea = Tarea.find(Tarea::ID_APL_025_3)
      @contribuyentes = []
      Contribuyente.includes(:personas).where(personas: {user_id: current_user.id}).each do |c|
        casa_matriz = c.establecimiento_contribuyentes.where(casa_matriz: true).first
        dato_anual = c.dato_anual_contribuyentes.first
        @contribuyentes << [
          "#{c.rut}-#{c.dv} | #{c.razon_social}",
          c.id,
          {
            "data-rut": "#{c.rut}-#{c.dv}",
            "data-nombre": c.razon_social,
            "data-matriz-direccion": casa_matriz.nil? ? '' : casa_matriz.direccion,
            "data-matriz-region-id": casa_matriz.nil? ? '' : casa_matriz.region_id,
            "data-matriz-comuna-id": casa_matriz.nil? ? '' : casa_matriz.comuna_id,
            "data-tipo-contribuyente-id": dato_anual.nil? ? '' : dato_anual.tipo_contribuyente_id
          }
        ]
      end
    end
    @descargables = @tarea.get_descargables
    @regiones = Region.all
    @adhesion = Adhesion.new(flujo_id: @flujo.id, externa: true, rol_id: @tarea.rol_id)
  end

  def adhesion_params
    params.require(:adhesion).permit(
      :rut_institucion_adherente, :nombre_institucion_adherente, :matriz_direccion, :matriz_region_id, :matriz_comuna_id,:tipo_contribuyente_id,
      :contribuyente_id,
      :rut_representante_legal, :nombre_representante_legal, :fono_representante_legal, :email_representante_legal,
      :archivo_elementos,
      :archivo_elementos_cache,
      :archivos_adhesion_y_documentacion_cache,
      archivos_adhesion_y_documentacion: []
    )
  end

end
