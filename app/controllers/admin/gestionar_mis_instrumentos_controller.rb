class Admin::GestionarMisInstrumentosController < ApplicationController
  before_action :authenticate_user!
  before_action :set_variables_del_usuario
  before_action :set_cargar_instrumento, only: [:cargar_instrumento]
  before_action :set_flujo, only: [:apl_set_metas_acciones, :ppf_set_metas_acciones, :fpl_set_metas_acciones, :set_fpl_rendiciones]
  before_action :tiene_permiso?, only: [:apl_set_metas_acciones, :ppf_set_metas_acciones, :fpl_set_metas_acciones, :set_fpl_rendiciones]
  before_action :set_apl_set_metas_acciones, only: [:apl_set_metas_acciones]
  before_action :set_apl_set_auditorias, only: [:apl_set_auditorias]
  before_action :set_ppf_set_metas_acciones, only: [:ppf_set_metas_acciones]
  before_action :set_fpl_set_metas_acciones, only: [:fpl_set_metas_acciones]
  before_action :set_fpl_rendiciones, only: [:fpl_rendiciones]

  def index
  end

  def cargar_instrumento    
  end

  def apl_set_metas_acciones
  end

  def apl_set_auditorias
  end

  def ppf_set_metas_acciones
    if @establecimientos.blank?
      flash[:warning] = "No hay establecimientos."
      # redirect_to admin_gestionar_mis_instrumentos_path
    end    
  end

  def fpl_set_metas_acciones    
  end

  def fpl_rendiciones
  end

  def descargar_reporte_sustentabilidad

    @datos_publicos = DatosPublico.load

    @manifestacion_de_interes = ManifestacionDeInteres.find(params[:id])

    #clasificaciones del acuerdo
    clasificaciones_ids = []
    clasificaciones_ids += AccionClasificacion.joins("INNER JOIN set_metas_acciones ON set_metas_acciones.accion_id = accion_clasificaciones.accion_id")
                                              .where("set_metas_acciones.flujo_id = #{@manifestacion_de_interes.flujo.id}")
                                              .pluck("accion_clasificaciones.clasificacion_id")
    clasificaciones_ids += MateriaSustanciaClasificacion.joins("INNER JOIN set_metas_acciones ON set_metas_acciones.materia_sustancia_id = materia_sustancia_clasificaciones.materia_sustancia_id")
                                              .where("set_metas_acciones.flujo_id = #{@manifestacion_de_interes.flujo.id}")
                                              .pluck("materia_sustancia_clasificaciones.clasificacion_id")
    @clasificaciones_del_acuerdo = Clasificacion.where(id: clasificaciones_ids)

    @ods_clasif = Clasificacion.where(clasificacion_id: nil)
    @metas = {}
    @set_metas_acciones = @manifestacion_de_interes.flujo.set_metas_acciones
    @set_metas_acciones.each do |set_metas_accion|
      @metas[set_metas_accion.meta_id] = {icono: set_metas_accion.meta.icono.url, color: set_metas_accion.meta.color, clasificaciones: []} if !@metas.has_key?(set_metas_accion.meta_id)
      @metas[set_metas_accion.meta_id][:clasificaciones] = @metas[set_metas_accion.meta_id][:clasificaciones]+set_metas_accion.accion.accion_clasificaciones.pluck(:clasificacion_id) if !set_metas_accion.accion.nil?
      @metas[set_metas_accion.meta_id][:clasificaciones] = @metas[set_metas_accion.meta_id][:clasificaciones]+set_metas_accion.materia_sustancia.materia_sustancia_clasificaciones.pluck(:clasificacion_id) if !set_metas_accion.materia_sustancia.nil?
    end
    @metas = @metas.values
    #fin clasificaciones del acuerdo

    #certificaciones obtenidas
    @niveles = {}
    AdhesionElemento.joins(:adhesion).where(adhesiones: {flujo_id: @manifestacion_de_interes.flujo.id}).each do |adhesion_elemento|
      #obtengo las auditorias elementos
      #asi lo asocio con set_meta_accion
      #y del set_meta_accion traigo el estandar y sus niveles
      #segun el porcentaje de cumplimiento del elemento es a que nivel pertenece
      auditoria_elementos = AuditoriaElemento.where(auditoria_id: Auditoria.where(flujo_id: @manifestacion_de_interes.flujo.id).pluck(:id), adhesion_elemento_id: adhesion_elemento.id)

      total_auditorias_elementos_aplica = auditoria_elementos.where(aplica: true).size.to_f

      auditorias_cumple_aplica = auditoria_elementos.where(cumple: true, aplica: true)
      
      auditorias_cumple_aplica = auditorias_cumple_aplica.select do |aud_elem|
        if aud_elem.auditoria.con_validacion == true
          (aud_elem[:validacion_aceptada] == true && aud_elem[:aprobacion_fecha].present?)
        else
          aud_elem[:aprobacion_fecha].present?
        end
      end

      total_auditorias_cumple_aplica = auditorias_cumple_aplica.size.to_f 
      porcentaje = (total_auditorias_elementos_aplica > 0) ? ((total_auditorias_cumple_aplica/total_auditorias_elementos_aplica)*100.0).to_f : 0.to_f

      estandares_ids = []
      auditorias_cumple_aplica.each do |aud_elem|
        #obtengo los niveles del estandar relacionado al set meta accion
        estandares_ids += EstandarSetMetasAccion.where(id: aud_elem.set_metas_accion.id_referencia).pluck(:estandar_homologacion_id)
      end


      auditorias_ids = @manifestacion_de_interes.flujo.auditorias.pluck(:id)
      #voy desde el mayor porcentaje al menor, una vez que calze con uno se agrega y ya no se agrega a los menores
      EstandarNivel.where(estandar_homologacion_id: estandares_ids).order(porcentaje: :desc).each do |nivel|
        plazo = AuditoriaNivel.where(auditoria_id: auditorias_ids, estandar_nivel_id: nivel.id).last
        plazo = plazo.nil? ? 0 : plazo.plazo
        icono = nivel.estandar_homologacion.referencias.select{|f| ["jpg", "jpeg", "png"].include?(f.file.extension.downcase) }.first
        icono = icono.url if !icono.nil?
        if porcentaje >= nivel.porcentaje.to_f
          @niveles[nivel.id] = {nombre: nivel.nombre, icono: icono, grafica: nivel.archivo.url, descripcion: nivel.estandar_homologacion.descripcion, plazo: plazo, elementos: []} if !@niveles.has_key?(nivel.id)
          @niveles[nivel.id][:elementos] = @niveles[nivel.id][:elementos]+[adhesion_elemento]
          break
        end
      end
    end

    #una vez cargados los niveles, quito los que no tienen elementos
    @niveles = @niveles.values
    #fin certificaciones obtenidas

    #auditoria
    @auditorias = @manifestacion_de_interes.flujo.auditorias
    #fin auditorias

    #metas y avances
    clasificaciones_padre_ids = []
    clasificaciones_padre_ids += AccionClasificacion.joins("INNER JOIN set_metas_acciones ON set_metas_acciones.accion_id = accion_clasificaciones.accion_id")
                                              .where("set_metas_acciones.flujo_id = #{@manifestacion_de_interes.flujo.id}")
                                              .pluck("accion_clasificaciones.clasificacion_id")
    clasificaciones_padre_ids += MateriaSustanciaClasificacion.joins("INNER JOIN set_metas_acciones ON set_metas_acciones.materia_sustancia_id = materia_sustancia_clasificaciones.materia_sustancia_id")
                                                .where("set_metas_acciones.flujo_id = #{@manifestacion_de_interes.flujo.id}")
                                                .pluck("materia_sustancia_clasificaciones.clasificacion_id")

    @clasificaciones_padre_del_acuerdo = Clasificacion.where(id: clasificaciones_padre_ids)
    #fin metas y avances

    #reporte de avances
    #son las set metas acciones del flujo definidas en clasificaciones del acuerdo
    #fin reporte de avances
    archivo = CreaReporteSustentabilidad.new(request, @datos_publicos, @manifestacion_de_interes, @clasificaciones_del_acuerdo, @ods_clasif, @metas, @niveles, @auditorias, @clasificaciones_padre_del_acuerdo, @set_metas_acciones)
                                        .crear_reporte
    send_data archivo, disposition: "attachment", filename: "Reporte Sustentabilidad.#{@datos_publicos.extension_reporte}"
    #render '_reporte_sustentabilidad'
  end

  private

    #DZC define las variables a instanciar para el usuario específico. Determina el flujo dependiendo de los flujos de los contribuyentes a los que esta asociado el usuario. Si el usuario tiene el rol Rol::ADMIN de la ASCC, entonces accede a todos los instrumentos
    def set_variables_del_usuario  
      personas = current_user.personas
      personas_id = personas.pluck(:id)
      user_actores = MapaDeActor.where(persona_id: personas.pluck(:id))
      @instrumentos = Flujo.where(id: user_actores.pluck(:flujo_id).uniq)
      unless @instrumentos.blank?
        @apls = @instrumentos.where.not(manifestacion_de_interes_id: nil)
        @ppfs = @instrumentos.where.not(programa_proyecto_propuesta_id: nil)
        @fpls = @instrumentos.where.not(proyecto_id: nil)
        @instancias = []
        @instrumentos.each do |i|
          @instancias += i.datos_para_gestionar(personas_id)       
        end
        @instancias = @instancias.sort_by { |hsh| [hsh[:tipo_instrumento], hsh[:id_instrumento], hsh[:nombre_instrumento]]}
      else
        flash[:warning] = "Usted no tiene instrumentos asociados."
        redirect_to root_path
      end
    end

    def set_cargar_instrumento
    
      if params[:apl].present?
        instrumento_id = params[:apl].to_i
      elsif params[:ppf].present?
        instrumento_id = params[:ppf].to_i
      elsif params[:fpl].present?
        instrumento_id = params[:fpl].to_i
      else
        instrumento_id = nil
      end
      personas = current_user.personas
      personas_id = personas.pluck(:id)
      instrumento = Flujo.find_by(id: instrumento_id)
      @instancias = instrumento.datos_para_gestionar(personas_id).sort_by { |hsh| [hsh[:tipo_instrumento], hsh[:id_instrumento], hsh[:nombre_tarea]]}
    end

    def set_flujo
      if params[:id].present?
        @flujo = Flujo.find(params[:id])
        if @flujo.present?
          @manifestacion_de_interes = @flujo.manifestacion_de_interes if @flujo.manifestacion_de_interes.present?
          @ppp = @flujo.ppp if @flujo.ppp.present?
          @proyecto = @flujo.proyecto if @flujo.proyecto.present?
          @tipo_instrumento = @flujo.tipo_instrumento
        else 
          flash[:warning] = "El instrumento ID #{params[:id]} no fue encontrado."
          redirect_to admin_gestionar_mis_instrumentos_path
        end
      else
        @actividades =  {}
        flash[:warning] = "No se ha seleccionado un instrumento."
        redirect_to admin_gestionar_mis_instrumentos_path
      end
    end  

    # DZC 2018-10-20 13:20:20 valida que el usuario este autorizado para este flujo específico
    def tiene_permiso?
      tiene = true
      unless @instrumentos.include?(@flujo)
        tiene = false
        flash[:warning] = "Usted no tiene permiso para acceder a las actividades y acciones del del instrumento ID #{@flujo.id}."
        redirect_to admin_gestionar_mis_instrumentos_path
      end
      tiene
    end  

    def set_apl_set_metas_acciones
      # 
      if @manifestacion_de_interes.present?
        # DZC 2018-11-21 19:21:32 se modifica para que incluya las acciones anexas
        @set_metas_acciones = SetMetasAccion.where(manifestacion_de_interes_id: @manifestacion_de_interes.id)
      else
        @set_metas_acciones = {}
      end
    end

    def set_apl_set_auditorias
      # 
      if @manifestacion_de_interes.present?
        @set_metas_acciones = SetMetasAccion.de_la_manifestacion_de_interes_(@manifestacion_de_interes.id)
      else
        @set_metas_acciones = {}
      end
    end

    def set_ppf_set_metas_acciones
      if @ppp.present?
        
        instancia = @instancias.find do |i|
          i[:id_instrumento] == @flujo.id
        end
        @establecimientos = EstablecimientoContribuyente.where(id: instancia[:establecimientos_id])
        ppf_metas_establecimientos = PpfMetasEstablecimiento.where(flujo_id: @flujo.id, establecimiento_contribuyente_id: instancia[:establecimientos_id])
        @set_metas_acciones = SetMetasAccion.where(ppf_metas_establecimiento_id: ppf_metas_establecimientos.pluck(:id))
      else
        @set_metas_acciones = {}
      end
    end

    def set_fpl_set_metas_acciones
      # 
      if @proyecto.present?
        @actividades = ProyectoActividad::get_actividades_calendario(@proyecto.id)
        @actividades = @actividades.present? ? @actividades : {}
      else
        @actividades = {}
      end
    end

    def set_fpl_rendiciones
      @tipo_rendicion = :envio
      @en_modificacion = []
      if @proyecto.present?
        @glosas = Glosa.all
        mod_calendario = ModificacionCalendario.find_by(proyecto_id: @proyecto.id)
        unless mod_calendario.nil?
          mod_calendario.atributos_proyecto_actividades.each do |pa|
            pa[:actividad_item_attributes].each do |ai|
              @en_modificacion <<ai[:proyecto_actividad_id] if ai[:modificado] == true
            end
          end
          @en_modificacion.uniq
        end 
      else
        @proyecto = nil
        @glosas = nil
      end
    end
end
