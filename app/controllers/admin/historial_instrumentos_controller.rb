class Admin::HistorialInstrumentosController < ApplicationController
  before_action :authenticate_user!
  before_action :set_variables_del_usuario
  before_action :set_cargar_instrumento, only: [:cargar_instrumento]

  def index
  end

  def cargar_instrumento    
  end

  def descargar_manifestacion_pdf
    @manifestacion_de_interes = ManifestacionDeInteres.find(params[:manifestacion_de_interes_id])
  end

  def descargar_manifestacion_pdf_archivo
    @manifestacion_de_interes = ManifestacionDeInteres.find(params[:manifestacion_de_interes_id])
    pdf = @manifestacion_de_interes.generar_pdf(params[:url_territorio],params[:url_area_influencia],params[:url_alternativas])
    send_data pdf.render, type: "application/pdf", disposition: "inline", filename: "Manifestacion de interes.pdf"
  end


  #def ejecutada
  #  require 'open-uri'
  #  url = URI.parse("http://localhost:3999"+params[:uri])
  #  open(url, "Cookie" => request.headers["Cookie"]) do |http|
  #    view_string = http.read
  #  end
  #  start_marker = Regexp.escape('<div id="contenido_principal">')
  #  end_marker = Regexp.escape('</div><div id="fin_contenido_principal">')
  #
  #  @view_content = view_string[/#{start_marker}(.*?)#{end_marker}/m, 1]
  #
  #end

  private

    #DZC define las variables a instanciar para el usuario específico. Determina el flujo dependiendo de los flujos de los contribuyentes a los que esta asociado el usuario. Si el usuario tiene el rol Rol::ADMIN de la ASCC, entonces accede a todos los instrumentos
    def set_variables_del_usuario  
      personas = current_user.personas

      # DZC 2018-11-12 17:54:15 se modifica para que solo una persona que sea actor tenga acceso a verificar el historial de ese instrumento
      personas_id = personas.pluck(:id)
      user_actores = MapaDeActor.where(persona_id: personas.pluck(:id))

      # contribuyentes = Contribuyente.where(id: personas.pluck(:contribuyente_id))
      if current_user.is_admin? #DZC se trata del admin de la ASCC
        @instrumentos = Flujo.where(terminado: [false, nil]).where("manifestacion_de_interes_id IS NOT NULL OR programa_proyecto_propuesta_id IS NOT NULL OR proyecto_id IS NOT NULL").order(id: :asc).all
      else
        # @instrumentos = Flujo.where(contribuyente_id: contribuyentes.pluck(:id), terminado: [false, nil]).order(id: :asc).all
        @instrumentos = Flujo.where(id: user_actores.pluck(:flujo_id).uniq, terminado: [false, nil]).order(id: :asc).all
      end
      # @tareas_pendientes = TareaPendiente.where(flujo_id: @instrumentos.pluck(:id))
      @apls = @instrumentos.where.not(manifestacion_de_interes_id: nil)
      @ppfs = @instrumentos.where.not(programa_proyecto_propuesta_id: nil)
      @fpls = @instrumentos.where.not(proyecto_id: nil)

      #@instancias = []
      #@instrumentos.each do |i|
      #  @instancias += i.instancias_del_flujo(current_user)
      #end
      #@instancias = @instancias.sort_by { |hsh| [hsh[:tipo_instrumento], hsh[:id_instrumento], hsh[:nombre_tarea]]}      
    end

    def set_cargar_instrumento
       
      if params[:apl].present?
        instrumento_id = params[:apl].to_i
      elsif params[:ppf].present?
        instrumento_id = params[:ppf].to_i
      elsif params[:fpl].present?
        instrumento_id = params[:fpl].to_i
      elsif params[:instrumento].present?
        instrumento_id = params[:instrumento].to_i #DZC 2018-10-17 16:27:08 se agrega para llegar desde vista 
      else
        instrumento_id = nil
      end
      @instrumento = Flujo.find_by(id: instrumento_id)
      if @instrumentos.include?(@instrumento) #DZC 2018-10-17 16:49:01 evita que se muestren instrumentos a los que no se debería tener acceso
        @instancias = @instrumento.instancias_del_flujo(current_user).sort_by { |hsh| [hsh[:tipo_instrumento], hsh[:id_instrumento], hsh[:nombre_tarea]]}
      else
        @instancias = {}
        flash.now[:warning] = "Usted no tiene permiso para acceder al historial del instrumento '#{instrumento_id}'."
      end
      # 
    end
end
