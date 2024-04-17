class Admin::HistorialInstrumentosController < ApplicationController
  before_action :authenticate_user!
  before_action :set_variables_del_usuario
  before_action :set_cargar_instrumento, only: [:cargar_instrumento]
  before_action :set_crear_excel_respuesta_encuesta_diagnostico, only: [:descargar_respuesta_encuesta_diagnostico]

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

  def descargar_informe_acuerdo_pdf

    manifestacion_de_interes = ManifestacionDeInteres.find(params[:manifestacion_de_interes_id])
    informe_acuerdo = manifestacion_de_interes.informe_acuerdo
    auditorias = Auditoria.where(flujo_id: manifestacion_de_interes.flujo.id).all
    actores_mapa = MapaDeActor.where(flujo_id: manifestacion_de_interes.flujo.id, rol_id: Rol::FIRMANTE).includes([:rol, persona: [:user,:contribuyente, persona_cargos: [:cargo]]]).all

    pdf = WickedPdf.new.pdf_from_string(
      render_to_string(
        template: 'acuerdo_actores/_informe', 
        layout: 'layouts/wicked_pdf',
        locals: {
          datos: informe_acuerdo._a_datos(auditorias),
          actores_mapa: actores_mapa,
          es_descargable: true
        }
      )
    )
    send_data pdf, type: "application/pdf", disposition: "inline", filename: "Informe Acuerdo.pdf"
  end

  def descargar_respuesta_encuesta_diagnostico
    #enviamos el archivo para ser descargado
    send_data File.open(@ruta_encuesta_diagnostico).read, type: 'application/xslx', charset: "iso-8859-1", filename: "respuesta_encuesta_diagnostico_general.xlsx"
  end

  def descargar_respuesta_encuesta
    @encuesta = Tarea.find(params[:tarea_id]).encuesta
    #identificamos manifestacion para obtener flujo_id
    @manifestacion_de_interes = ManifestacionDeInteres.includes(:flujo).find(params[:manifestacion_de_interes_id])
    #obtenemos las partes para el excel
    titulos = @encuesta.cabecera_respuestas_excel
    datos = @encuesta.respuestas_por_usuario_con_datos_excel(@manifestacion_de_interes.flujo.id)
    #obtenemos el modelo axlsx
    excel = CrearExcel.new({titulos: titulos,datos: datos, nombre_hoja: 'Respuestas'}).crear_libro

    #enviamos el archivo para ser descargado
    send_data excel.to_stream.read, type: 'application/xslx', charset: "iso-8859-1", filename: "respuestas_encuesta.xlsx"
  end

  def descargar_respuesta_encuesta_auditoria
    tarea = Tarea.find(params[:tarea_id])
    @encuesta = tarea.encuesta
    #identificamos manifestacion para obtener flujo_id
    @manifestacion_de_interes = ManifestacionDeInteres.includes(:flujo).find(params[:manifestacion_de_interes_id])
    tareas_pendientes_ids = []
    TareaPendiente.where(flujo_id: @manifestacion_de_interes.flujo.id).where(tarea_id: tarea.id).each do |tarea_pendiente|
      tareas_pendientes_ids << tarea_pendiente.id if tarea_pendiente.data.present? && tarea_pendiente.data[:auditoria_id].to_i == params[:auditoria_id].to_i
    end
    #obtenemos las partes para el excel
    titulos = @encuesta.cabecera_respuestas_excel
    datos = @encuesta.respuestas_por_usuario_con_datos_excel(@manifestacion_de_interes.flujo.id, tareas_pendientes_ids)
    #obtenemos el modelo axlsx
    excel = CrearExcel.new({titulos: titulos,datos: datos, nombre_hoja: 'Respuestas'}).crear_libro

    #enviamos el archivo para ser descargado
    send_data excel.to_stream.read, type: 'application/xslx', charset: "iso-8859-1", filename: "respuestas_encuesta.xlsx"
  end

  def descargar_observaciones_informe_metas_acciones

    #identificamos manifestacion para obtener flujo_id
    @manifestacion_de_interes = ManifestacionDeInteres.find(params[:manifestacion_de_interes_id])
    # nos traemos el set de metas
    @set_metas_acciones = SetMetasAccion.de_la_manifestacion_de_interes_(@manifestacion_de_interes.id)
    #obtenemos las partes para el excel
    titulos = ["Meta","Acción","Materia","Alcance","Nombre","Rut","Email","Fecha/Hora","Observación"]
    titulos_informe = ["Nombre","Rut","Email","Fecha/Hora","Observación"]
    # se arma los datos para el excel
    datos = SetMetasAccion.observaciones_agrupadas_para_excel_v2(@set_metas_acciones)
    datos_informe = @manifestacion_de_interes.informe_acuerdo.comentarios_informe_acuerdos.map{|comentario| 
      [
        comentario.nombre,
        comentario.rut,
        comentario.email,
        comentario.created_at.strftime("%F %T"),
        comentario.comentario
      ]
    }

    #llamamos el servicio para crear excel entregandole los parametros necesarios
    parametros_excel = {
      titulos: titulos,
      datos: datos,
      nombre_hoja: 'Observaciones metas acciones',
      titulos_informe: titulos_informe,
      datos_informe: datos_informe,
      nombre_hoja_informe: 'Observaciones informe'
    }
    excel = CrearExcel.new(parametros_excel).crear_libro_observaciones


    #enviamos el archivo para ser descargado
    send_data excel.to_stream.read, type: 'application/xslx', charset: "iso-8859-1", filename: "observaciones_informe_metas_acciones.xlsx"
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
      if current_user.is_admin? || current_user.is_ascc? #DZC se trata del admin de la ASCC
        @instrumentos = Flujo.order(id: :desc)
      else
        # @instrumentos = Flujo.where(contribuyente_id: contribuyentes.pluck(:id), terminado: [false, nil]).order(id: :asc).all
        @instrumentos = Flujo.where(id: user_actores.pluck(:flujo_id).uniq).order(id: :desc)
      end
      # @tareas_pendientes = TareaPendiente.where(flujo_id: @instrumentos.pluck(:id))
      @apls = @instrumentos.where.not(manifestacion_de_interes_id: nil)
      @ppfs = @instrumentos.where.not(programa_proyecto_propuesta_id: nil)
      #@fpls = @instrumentos.where.not(proyecto_id: nil)
      @fpls = FondoProduccionLimpia.fpls()

      @instancias = []
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
      if @instrumentos.pluck(:id).include?(instrumento_id) #DZC 2018-10-17 16:49:01 evita que se muestren instrumentos a los que no se debería tener acceso
        @instancias = @instrumento.instancias_del_flujo(current_user)#.sort_by { |hsh| [hsh[:tipo_instrumento], hsh[:id_instrumento], hsh[:nombre_tarea]]}
      else
        @instancias = []
        flash.now[:warning] = "Usted no tiene permiso para acceder al historial del instrumento '#{instrumento_id}'."
      end
      # 
    end

    def set_crear_excel_respuesta_encuesta_diagnostico
      #nos traemos la encuesta que queremos obtener
      @encuesta = Encuesta.find(Encuesta::ENCUESTA_DIAGNOSTICO_GENERAL)
      #identificamos manifestacion para obtener flujo_id
      @manifestacion_de_interes = ManifestacionDeInteres.includes(:flujo).find(params[:manifestacion_de_interes_id])
      #obtenemos las partes para el excel
      titulos = @encuesta.preguntas_cabecera_excel
      datos = @encuesta.respuestas_por_usuario_excel(@manifestacion_de_interes.flujo.id)
      #creamos una ruta para guardar el excel
      @ruta_encuesta_diagnostico = "#{Rails.root}/public/uploads/manifestacion_de_interes/respuesta_encuesta_diagnostico_general/#{@manifestacion_de_interes.id}/"
      FileUtils.mkdir_p(@ruta_encuesta_diagnostico) unless File.exist?(@ruta_encuesta_diagnostico) 
      @ruta_encuesta_diagnostico += "respuesta_encuesta_diagnostico_general.xlsx"
      #llamamos el servicio para crear excel entregandole los parametros necesarios
      salida = CrearExcel.new({titulos: titulos,datos: datos, nombre_hoja: 'Respuestas',ruta: @ruta_encuesta_diagnostico}).crear_libro
    end

    def set_crear_excel_observaciones_informe_metas_acciones
      #identificamos manifestacion para obtener flujo_id
      @manifestacion_de_interes = ManifestacionDeInteres.find(params[:manifestacion_de_interes_id])
      # nos traemos el set de metas
      @set_metas_acciones = SetMetasAccion.de_la_manifestacion_de_interes_(@manifestacion_de_interes.id)
      #obtenemos las partes para el excel
      titulos = ["Meta","Acción","Nombre","Rut","Email","Observación"]
      # se arma los datos para el excel
      datos = SetMetasAccion.observaciones_agrupadas_para_excel(@set_metas_acciones)
      #creamos una ruta para guardar el excel
      @ruta_observaciones_informe_metas_acciones = "#{Rails.root}/public/uploads/manifestacion_de_interes/observaciones_metas_acciones_informe/#{@manifestacion_de_interes.id}/"
      FileUtils.mkdir_p(@ruta_observaciones_informe_metas_acciones) unless File.exist?(@ruta_observaciones_informe_metas_acciones) 
      @ruta_observaciones_informe_metas_acciones += "observaciones_metas_acciones_informe.xlsx"
      #llamamos el servicio para crear excel entregandole los parametros necesarios
      parametros_excel = {
        titulos: titulos,
        datos: datos,
        nombre_hoja: 'Observaciones metas acciones',
        ruta: @ruta_observaciones_informe_metas_acciones
      }
      salida = CrearExcel.new(parametros_excel).crear_libro_observaciones
    end
end
