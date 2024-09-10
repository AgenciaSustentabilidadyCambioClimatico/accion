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

    @manifestacion_de_interes = ManifestacionDeInteres.find(params[:id]) if !params[:id].blank?

    if !@manifestacion_de_interes.nil? || current_user.is_admin?

      @datos_publicos = DatosPublico.load

      @adhesion_elemento = AdhesionElemento.find(params[:ae_id]) if !params[:ae_id].blank?

      @contribuyente = Contribuyente.find(params[:c_id]) if !params[:c_id].blank?

      archivo = CreaReporteSustentabilidad.new(request, @manifestacion_de_interes, @adhesion_elemento, current_user, @contribuyente).crear_reporte

      send_data archivo, disposition: "attachment", filename: "Reporte Sustentabilidad.#{@datos_publicos.extension_reporte}"
    else
      redirect_to root_path, alert: "No tiene permiso para acceder a esta página"
    end
  end

  private

    #DZC define las variables a instanciar para el usuario específico. Determina el flujo dependiendo de los flujos de los contribuyentes a los que esta asociado el usuario. Si el usuario tiene el rol Rol::ADMIN de la ASCC, entonces accede a todos los instrumentos
    def set_variables_del_usuario  
      personas = current_user.personas
      personas_id = personas.pluck(:id)
      user_actores = MapaDeActor.where(persona_id: personas.pluck(:id))
      @instrumentos = Flujo.where(id: user_actores.pluck(:flujo_id).uniq).order(id: :desc)
      #persona = personas.first
      #user_id = persona.user_id 

      unless @instrumentos.blank?
        @apls = @instrumentos.where.not(manifestacion_de_interes_id: nil)
        @ppfs = @instrumentos.where.not(programa_proyecto_propuesta_id: nil)
        @ppls = @instrumentos.where.not(proyecto_id: nil)
        @fpls = @instrumentos.where.not(fondo_produccion_limpia_id: nil)
        #@fpls = FondoProduccionLimpia.fpls()
        #@fpls = FondoProduccionLimpia.fpls_mis_instrumentos(user_id);
      
        @instancias = []
        @instrumentos.each do |i|
          @instancias += i.datos_para_gestionar(personas_id)       
        end
        #@instancias = @instancias.sort_by { |hsh| hsh[:id_instrumento]}
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
      elsif params[:ppl].present?
        instrumento_id = params[:ppl].to_i  
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
