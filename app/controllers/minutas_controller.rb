class MinutasController < ApplicationController #crea la depencia con convocatoria en la carpeta del controlado
  before_action :authenticate_user!, except: [:archivo_acuerdo_anexos_zip]
  before_action :set_tarea_pendiente, except: [:archivo_acuerdo_anexos_zip]
  before_action :set_flujo
  before_action :set_convocatoria, except: [:archivo, :archivo_acuerdo_anexos_zip]
  before_action :set_tipo, except: [:archivo, :archivo_acuerdo_anexos_zip]
  before_action :set_descargable_tareas, except: [:archivo, :archivo_acuerdo_anexos_zip]
  before_action :set_minuta, only: [:edit, :update, :destroy], except: [:archivo, :archivo_acuerdo_anexos_zip]
  before_action :permiso_tarea, except: [:archivo, :archivo_acuerdo_anexos_zip]
  respond_to :docx
  # GET /minuta/new
  def new
    # if @tarea_pendiente.estado_tarea_pendiente_id != EstadoTareaPendiente::NO_INICIADA
    #   redirect_to root_path #modificar si es necesario para volver al mantenedor de convocatorias
    # else
      # @minuta = Minuta.new
    # end
  end

  # # GET /minuta/id
  # def show
  # end

  def edit
  end

  # PATCH/PUT
  def update
    respond_to do |format|
      if @minuta.update(minuta_params)
        params[:convocados].each do |dest|
          #modifica la calidad de invitado
          @convocatoria.convocatoria_destinatarios.where(destinatario_id: dest).update_all({asistio: true})
        end
        @minuta.establece_mensaje_encabezado
        @minuta.establece_mensaje_cuerpo

        if @tarea.codigo==Tarea::COD_APL_022

          if(!@tarea_pendiente.data.has_key?(:ejecutada))

            # 
            @convocatoria.convocatoria_destinatarios.each do |rd| #probar funcionamiento, manda correos con attachments!
              rgc = RegistroAperturaCorreo.create(convocatoria_destinatario_id: rd.id, fecha_envio_correo: DateTime.now)
               ConvocatoriaMailer.delay.enviar(rd, @minuta.mensaje_encabezado, @minuta.mensaje_cuerpo, [@minuta.acta, @minuta.lista_asistencia], rgc.id)
            end

            data = @tarea_pendiente.data
            data[:ejecutada] = true
            @tarea_pendiente.update(data: data)

            continua_flujo_segun_tipo_tarea
          end
          @tarea_pendiente.update(estado_tarea_pendiente_id: EstadoTareaPendiente::ENVIADA) if !@minuta.acta.blank? && !@minuta.archivo_resolucion.blank?
        else
          # 
          @convocatoria.convocatoria_destinatarios.each do |rd| #probar funcionamiento, manda correos con attachments!
            rgc = RegistroAperturaCorreo.create(convocatoria_destinatario_id: rd.id, fecha_envio_correo: DateTime.now)
             ConvocatoriaMailer.delay.enviar(rd, @minuta.mensaje_encabezado, @minuta.mensaje_cuerpo, [@minuta.acta, @minuta.lista_asistencia], rgc.id)
          end
          continua_flujo_segun_tipo_tarea
        end
        format.html { redirect_to root_path, notice: "Minuta enviada" }#redirecciona a donde debe volver. 
        format.js { 
          flash[:success] = "Minuta enviada"; render js: "window.location='#{root_path}'"   
        }
      else
        # ap @minuta.errors.messages
        errores = ["Minuta NO enviada."]
        errores += @minuta.errors.full_messages
        
        format.html { render :edit, notice: errores }
        format.js {
           
          flash[:error] = errores
        }
      end
    end
  end

#DZC NOTA: las condiciones de salita dependendientes de cumplimiento de plazos se verifican mediante el método tarea_pendiente.continua_flujo_tareas_plazo_vencido (user_id).
#DZC agrega al campo data de la tarea_pendiente 
  def continua_flujo_segun_tipo_tarea(condicion_de_salida=nil)
    case @tarea.codigo
    when Tarea::COD_APL_012, Tarea::COD_APL_017, Tarea::COD_PPF_015,Tarea::COD_APL_011,Tarea::COD_APL_016 #agrego tareas de padre, porque podrian venir de ahi y no funcionaria
      @convocatoria.update({terminada: true})
    when Tarea::COD_APL_022, Tarea::COD_APL_038 #DZC minuta de firma de acuerdo APL-022, y de ceremonia de certificación APL-038
      tipo_campo = (@tarea.codigo==Tarea::COD_APL_022) ? 'firma' : 'ceremonia_certificacion'
      if !@minuta.fecha_hora.blank? && !@minuta.direccion.blank? #DZC verifica cumplimiento de condición 'B' y termina tareas pendientes correspondientes a las convocatorias de todos los actores. 
        #DZC guarda datos significativos de firma de acuerdo en @manifestación
        
        @manifestacion_de_interes.assign_attributes({
          (tipo_campo + '_fecha').to_sym => @minuta.fecha,
          (tipo_campo + '_fecha_hora').to_sym => minuta_params[:fecha_hora],
          (tipo_campo + '_tipo_reunion').to_sym => minuta_params[:tipo_reunion],
          (tipo_campo + '_direccion').to_sym => minuta_params[:direccion],
          (tipo_campo + '_lat').to_sym => minuta_params[:lat],
          (tipo_campo + '_lng').to_sym => minuta_params[:lng],
          (tipo_campo + '_firmantes').to_sym => minuta_params[:lista_asistencia]
        })

        # if @tarea.codigo==Tarea::COD_APL_022
        #   @manifestacion_de_interes.assign_attributes({
        #     fecha_firma: minuta_params[:fecha],
        #     direccion_firma: minuta_params[:direccion],
        #     lat_firma: minuta_params[:lat],
        #     lng_firma: minuta_params[:lng],
        #     firmantes: minuta_params[:lista_asistencia]
        #   })
        # else 
        #   @manifestacion_de_interes.assign_attributes({
        #     ceremonia_certificacion_fecha: minuta_params[:fecha],
        #     ceremonia_certificacion_direccion: minuta_params[:direccion],
        #     ceremonia_certificacion_lat: minuta_params[:lat],
        #     ceremonia_certificacion_lng: minuta_params[:lng],
        #     ceremonia_certificacion_participantes: minuta_params[:lista_asistencia]
        #   })
        # end
        @manifestacion_de_interes.tarea_codigo = @tarea.codigo
        @manifestacion_de_interes.save
        @convocatoria.update({terminada: true})
        #DZC finaliza las tareas APL-021 y APL-037 existentes para este flujo
        TareaPendiente.where(flujo_id: @flujo.id).includes([:tarea]).where({"tareas.codigo" => [Tarea::COD_APL_021.to_s, Tarea::COD_APL_037.to_s]}).update(estado_tarea_pendiente_id: 2)
        # TareaPendiente.where(flujo_id: @flujo.id).each do |tp| 
        #   if !tp.data.blank?
        #     begin
        #       if tp.data.has_key?(:convocatoria_id) && (tp.data[:convocatoria_id]==@convocatoria.id)
        #         tp.update(estado_tarea_pendiente_id: EstadoTareaPendiente::ENVIADA)
        #       end
        #     rescue NoMethodError
        #     end
        #   end
        # end
        if @tarea.codigo==Tarea::COD_APL_022
          @tarea_pendiente.pasar_a_siguiente_tarea 'B', {primera_ejecucion: true}, false
        end
      end
      if !@minuta.acta.blank?
        #DZC Esto lee el archivo desde su ubicación en el servidor y lo "sube" via carrierwave al campo de la manifestación 
        archivos=[Pathname.new(@minuta.acta.path).open] #DZC el campo archivo_firma de la manifestación es serializado como JSON, asi que se necesita un array de archivos
        

        # DZC 2018-11-07 06:29:18 se elimina el paso de las actas a la manifestación 
        # @manifestacion_de_interes.update((tipo_campo + '_archivo').to_sym => archivos)
        # if @tarea.codigo==Tarea::COD_APL_022
        #   @manifestacion_de_interes.update(archivo_firma: archivos)
        # else
        #   @manifestacion_de_interes.update(ceremonia_certificacion_archivo_firma: archivos)
        # end
        @tarea_pendiente.pasar_a_siguiente_tarea 'A'
      end
    when Tarea::COD_APL_031 #DZC Termina reuníon para establecer Comité Coordinador APL-031
      @convocatoria.update({terminada: true})
    end
  end

  def archivo   
    # firmantes = MapaDeActor.includes(persona: [:user, persona_cargos: [:cargo]]).where(flujo_id: @flujo, rol_id: Rol::FIRMANTE).all
    # #firmantes = MapaDeActor.where(flujo_id: @flujo, rol_id: Rol::FIRMANTE).all
    # nombre_acuerdo = @flujo.manifestacion_de_interes.nombre_acuerdo
    # fecha_firma = @flujo.manifestacion_de_interes.fecha_firma_formateada
    # texto = "En [INGRESAR COMUNA], a #{fecha_firma}, comparecen, por una parte, "
    # firmantes.each do |firmante|
    #   cargos = firmantes.last.persona.persona_cargos.map{|pc| pc.cargo.nombre}
    #   texto += "#{firmante.persona.user.nombres}, #{cargos.to_sentence}, en representación de #{firmante.persona.contribuyente.razon_social},"
    # end
    # texto += " y las empresas del territorio, quiénes adherirán al presente Acuerdo en los plazos estipulados. Los anteriormente citados, concurren a la firma del Acuerdo de Producción Limpia: #{nombre_acuerdo}, cuyo texto se desarrolla a continuación."
    firmantes = MapaDeActor.where(flujo_id: @flujo, rol_id: Rol::FIRMANTE).all
    nombre_acuerdo = @flujo.manifestacion_de_interes.nombre_acuerdo
    fecha_firma = (@flujo.manifestacion_de_interes.fecha_firma_formateada.nil? ? "INGRESAR FECHA FIRMA" : @flujo.manifestacion_de_interes.fecha_firma_formateada)
    @partes = "En [INGRESAR COMUNA], a #{fecha_firma}, comparecen, por una parte, "
    firmantes.each do |firmante|
      cargos = Cargo.where(id: firmante.persona.persona_cargos.select(:cargo_id)).pluck(:nombre).to_sentence
      @partes += "#{firmante.persona.user.nombre_completo}, #{cargos}, en representación de #{firmante.persona.contribuyente.razon_social}, "
    end
    @personeria = ""
    firmantes.each do |firmante|
      cargos = Cargo.where(id: firmante.persona.persona_cargos.select(:cargo_id)).pluck(:nombre).to_sentence
      @personeria += "#{firmante.persona.user.nombre_completo}, #{cargos}, de #{firmante.persona.contribuyente.razon_social}; "
    end
    @firmas = []
    firmantes.each do |firmante|
      cargos = Cargo.where(id: firmante.persona.persona_cargos.select(:cargo_id)).pluck(:nombre).to_sentence
      @firmas << [firmante.persona.user.nombre_completo, cargos, firmante.persona.contribuyente.razon_social]
    end
    @partes += " y las empresas del territorio, quiénes adherirán al presente Acuerdo en los plazos estipulados. Los anteriormente citados, concurren a la firma del Acuerdo de Producción Limpia: #{nombre_acuerdo}, cuyo texto se desarrolla a continuación."
    @informe_de_acuerdo =  @flujo.manifestacion_de_interes.informe_acuerdo
    @fundamentos = @flujo.manifestacion_de_interes.informe_acuerdo.fundamentos if @flujo.manifestacion_de_interes.informe_acuerdo.present?
    @antecedentes = @flujo.manifestacion_de_interes.informe_acuerdo.antecedentes if @flujo.manifestacion_de_interes.informe_acuerdo.present?
    @normativas_aplicables = @flujo.manifestacion_de_interes.informe_acuerdo.normativas_aplicables if @flujo.manifestacion_de_interes.informe_acuerdo.present?
    @alcance = @flujo.manifestacion_de_interes.informe_acuerdo.alcance if @flujo.manifestacion_de_interes.informe_acuerdo.present?
    @campo_de_aplicacion = @flujo.manifestacion_de_interes.informe_acuerdo.campo_de_aplicacion if @flujo.manifestacion_de_interes.informe_acuerdo.present?
    @definiciones = @flujo.manifestacion_de_interes.informe_acuerdo.definiciones if @flujo.manifestacion_de_interes.informe_acuerdo.present?
    @objetivo_general = @flujo.manifestacion_de_interes.informe_acuerdo.objetivo_general if @flujo.manifestacion_de_interes.informe_acuerdo.present?
    @objetivo_especifico = @flujo.manifestacion_de_interes.informe_acuerdo.objetivo_especifico if @flujo.manifestacion_de_interes.informe_acuerdo.present?
    if @flujo.manifestacion_de_interes.informe_acuerdo.present?
      @mecanismo_de_implementacion = @flujo.manifestacion_de_interes.informe_acuerdo.mecanismo_de_implementacion
      InformeAcuerdo.palabras_claves("mecanismo_de_implementacion").each do |key, val|
        valor = @informe_de_acuerdo.attributes[val.to_s].to_s
        if valor == "true"
          valor = "Si"
        elsif valor == "false"
          valor = "No"
        elsif valor.include?("_")
          valor = t(valor)
        end
        @mecanismo_de_implementacion = @mecanismo_de_implementacion.gsub("[#{key.to_s}]", valor)
      end
    end
    @tipo_de_acuerdo = @flujo.manifestacion_de_interes.informe_acuerdo.tipo_acuerdo if @flujo.manifestacion_de_interes.informe_acuerdo.present?
    @auditorias = @flujo.auditorias
    #@set_metas = @flujo.set_metas_acciones
    #@set_metas = @flujo.set_metas_acciones.includes('meta').group_by(&:meta_id)
    @set_metas = @flujo.set_metas_acciones.includes('meta').group_by{|p| p.meta['nombre'] }
    #
    # path_file = "#{Rails.root}/public/uploads/test.docx"
    # File.delete(path_file) if File.exist?(path_file)
    # #FileUtils.rm_f("#{Rails.root}/public/uploads/test.docx")
    # a = PureDocx.create(path_file, paginate_pages: 'right') do |doc|
    #   # doc.header([
    #   #   doc.text('header', style: [:italic], size: 28, align: 'left')
    #   # ])
    #   doc.content([
    #     doc.text(texto, size: 14, align: 'left'),
    #     doc.brake,
    #     doc.text("Fundamentos:", size: 16, align: 'left'),
    #     doc.text(fundamentos.to_s, size: 16, align: 'left'),
    #     doc.text("Antecedentes:", size: 16, align: 'left'),
    #     doc.text(antecedentes.to_s, size: 16, align: 'left'),
    #     doc.text("Normativas aplicables:", size: 16, align: 'left'),
    #     doc.text(normativas_aplicables.to_s, size: 16, align: 'left'),
    #     doc.text("Alcance:", size: 16, align: 'left'),
    #     doc.text(alcance.to_s, size: 16, align: 'left'),
    #     doc.text("Campo de aplicación:", size: 16, align: 'left'),
    #     doc.text(campo_de_aplicacion.to_s, size: 16, align: 'left'),
    #     doc.text("Definiciones:", size: 16, align: 'left'),
    #     doc.text(definiciones.to_s, size: 16, align: 'left'),
    #     doc.text("Objetivo general:", size: 16, align: 'left'),
    #     doc.text(objetivo_general.to_s, size: 16, align: 'left'),
    #     doc.text("Objetivo específico:", size: 16, align: 'left'),
    #     doc.text(objetivo_especifico.to_s, size: 16, align: 'left'),
    #   ])
    # end   
    # a.save!
    # send_file(a.file_path, filename: "test.docx", type: "application/docx")
    respond_to do |format|
      format.docx do
        render docx: 'archivo', filename: 'acuerdo.docx'
      end
    end
  end

  def archivo_acuerdo_anexos_zip

    firmantes = MapaDeActor.where(flujo_id: @flujo, rol_id: Rol::FIRMANTE).all
    nombre_acuerdo = @flujo.manifestacion_de_interes.nombre_acuerdo
    fecha_firma = (@flujo.manifestacion_de_interes.fecha_firma_formateada.nil? ? "INGRESAR FECHA FIRMA" : @flujo.manifestacion_de_interes.fecha_firma_formateada)
    @partes = "En [INGRESAR COMUNA], a #{fecha_firma}, comparecen, por una parte, "
    firmantes.each do |firmante|
      cargos = Cargo.where(id: firmante.persona.persona_cargos.select(:cargo_id)).pluck(:nombre).to_sentence
      @partes += "#{firmante.persona.user.nombre_completo}, #{cargos}, en representación de #{firmante.persona.contribuyente.razon_social}, "
    end
    @personeria = ""
    firmantes.each do |firmante|
      cargos = Cargo.where(id: firmante.persona.persona_cargos.select(:cargo_id)).pluck(:nombre).to_sentence
      @personeria += "#{firmante.persona.user.nombre_completo}, #{cargos}, de #{firmante.persona.contribuyente.razon_social}; "
    end
    @firmas = []
    firmantes.each do |firmante|
      cargos = Cargo.where(id: firmante.persona.persona_cargos.select(:cargo_id)).pluck(:nombre).to_sentence
      @firmas << [firmante.persona.user.nombre_completo, cargos, firmante.persona.contribuyente.razon_social]
    end
    @partes += " y las empresas del territorio, quiénes adherirán al presente Acuerdo en los plazos estipulados. Los anteriormente citados, concurren a la firma del Acuerdo de Producción Limpia: #{nombre_acuerdo}, cuyo texto se desarrolla a continuación."
    @informe_de_acuerdo =  @flujo.manifestacion_de_interes.informe_acuerdo
    @fundamentos = @flujo.manifestacion_de_interes.informe_acuerdo.fundamentos if @flujo.manifestacion_de_interes.informe_acuerdo.present?
    @antecedentes = @flujo.manifestacion_de_interes.informe_acuerdo.antecedentes if @flujo.manifestacion_de_interes.informe_acuerdo.present?
    @normativas_aplicables = @flujo.manifestacion_de_interes.informe_acuerdo.normativas_aplicables if @flujo.manifestacion_de_interes.informe_acuerdo.present?
    @alcance = @flujo.manifestacion_de_interes.informe_acuerdo.alcance if @flujo.manifestacion_de_interes.informe_acuerdo.present?
    @campo_de_aplicacion = @flujo.manifestacion_de_interes.informe_acuerdo.campo_de_aplicacion if @flujo.manifestacion_de_interes.informe_acuerdo.present?
    @definiciones = @flujo.manifestacion_de_interes.informe_acuerdo.definiciones if @flujo.manifestacion_de_interes.informe_acuerdo.present?
    @objetivo_general = @flujo.manifestacion_de_interes.informe_acuerdo.objetivo_general if @flujo.manifestacion_de_interes.informe_acuerdo.present?
    @objetivo_especifico = @flujo.manifestacion_de_interes.informe_acuerdo.objetivo_especifico if @flujo.manifestacion_de_interes.informe_acuerdo.present?
    @mecanismo_de_implementacion = @flujo.manifestacion_de_interes.informe_acuerdo.mecanismo_de_implementacion if @flujo.manifestacion_de_interes.informe_acuerdo.present?
    @tipo_de_acuerdo = @flujo.manifestacion_de_interes.informe_acuerdo.tipo_acuerdo if @flujo.manifestacion_de_interes.informe_acuerdo.present?
    @auditorias = @flujo.auditorias
    @set_metas = @flujo.set_metas_acciones.includes('meta').group_by{|p| (p.meta['nombre'] rescue "") }

    html_acuerdo = render_to_string(
        template: 'minutas/archivo.docx.erb', 
        layout: 'layouts/wicked_pdf',
        locals: {
          partes: @partes,
          fundamentos: @fundamentos,
          antecedentes: @antecedentes,
          normativas_aplicables: @normativas_aplicables,
          alcance: @alcance,
          campo_de_aplicacion: @campo_de_aplicacion,
          definiciones: @definiciones,
          objetivo_general: @objetivo_general,
          objetivo_especifico: @objetivo_especifico,
          set_metas: @set_metas,
          mecanismo_de_implementacion: @mecanismo_de_implementacion,
          tipo_de_acuerdo: @tipo_de_acuerdo,
          auditorias: @auditorias,
          informe_de_acuerdo: @informe_de_acuerdo,
          personeria: @personeria,
          firmas: @firmas
        }
      )

    archivo_acuerdo = Htmltoword::Document.create html_acuerdo, 'acuerdo.docx'
    archivos = []
    archivos << {
      nombre: "acuerdo.docx",
      data: archivo_acuerdo
    }
    archivos += @informe_de_acuerdo.archivos_anexos if !@informe_de_acuerdo.blank?
    zip = helpers.generar_zip archivos
    send_data(zip, type: 'application/zip',filename: "acuerdo_y_anexos.zip")
  end

  private
    def minuta_params #hay que tener presente 
      parametros=params.require(:minuta).permit(
        :convocatoria_id,
        :fecha_hora,
        :tipo_reunion,
        :direccion,
        :lat,
        :lng,
        :mensaje_encabezado,
        :mensaje_cuerpo,
        :acta,
        :acta_cache,
        :lista_asistencia,
        :lista_asistencia_cache,
        :archivo_resolucion,
        :archivo_resolucion_cache
      )
      parametros[:fecha_acta]=Time.now.utc #agrega nuevo campo al hash, lo que permite instanciar ese campo en la tabla al momento de ejecutar el patch (update)
      #Continuando con cómo se creo fecha_acta, se agrega archivo_resolucion, desde aquí es necesario ambos archivos para cerrar tarea.
      if parametros[:archivo_resolucion] !=  nil
        parametros[:fecha_resolucion] = Time.now.utc 
      end
        # if !@tarea_pendiente.blank?
   #      parametros[:tarea_pendiente_id]=@tarea_pendiente.id
   #    end
      parametros
    end

    def convocatoria_destinatario_params # revisar
      params.require(:convocatoria_destinatario).permit(
        :convocatoria_id,
        :destinatario_id,
        :asistio
      )
    end

    #DZC asigna valor de id de tarea pendiente, leyendolo desde la URL (esto es neceario por que no se traspasa desde la jerarquia superior)
    def set_tarea_pendiente
      @tarea_pendiente = TareaPendiente.find(params[:tarea_pendiente_id])
      autorizado? @tarea_pendiente
      @tarea = @tarea_pendiente.tarea
    end

    #DZC define el flujo y tipo_instrumento, junto con la manifestación o el proyecto según corresponda, para efecto de completar datos. El id de la manifestación se obtiene del flujo correspondiente a la tarea pendiente.
    def set_flujo
      @solo_lectura = params[:q]
      @flujo = @tarea_pendiente.blank? ? Flujo.find(params[:flujo]) : @tarea_pendiente.flujo
      @tipo_instrumento=@flujo.tipo_instrumento
      @manifestacion_de_interes = @flujo.manifestacion_de_interes_id.blank? ? nil : ManifestacionDeInteres.find(@flujo.manifestacion_de_interes_id)
      if !@manifestacion_de_interes.blank? && !@tarea_pendiente.blank?
        @manifestacion_de_interes.temporal = true
        @manifestacion_de_interes.update(tarea_codigo: @tarea.codigo)
        @informe_de_acuerdo =  @manifestacion_de_interes.informe_acuerdo.present? ? @manifestacion_de_interes.informe_acuerdo : nil
      end
      @proyecto = @flujo.proyecto_id.blank? ? nil : Proyecto.find(@flujo.proyecto_id)
      @ppp = @flujo.programa_proyecto_propuesta_id.blank? ? nil : ProgramaProyectoPropuesta.find(@flujo.programa_proyecto_propuesta_id)
    end

    def set_convocatoria #DZC asigna al objeto los valores correspondientes a los campos del registro que calza con el id obtenido como parámetro de la URL
      @convocatoria = Convocatoria.find(params[:convocatoria_id])
      #DZC se instancia la última tarea pendiente asociada al tipo de convoncatoria 
      @tarea_pendiente_convocatoria = TareaPendiente.where(flujo_id: @flujo).includes([:tarea]).where({"tareas.codigo" => @convocatoria.tarea_codigo.to_s}).includes([:user]).where({"users.id" => current_user.id}).last
      @convocatorias = Convocatoria.where(flujo_id: @flujo.id).where(tarea_codigo: @tarea.codigo).all
    end

    def set_tipo
      @tipo=ConvocatoriaTipo.where(tarea_codigo: @convocatoria.tarea_codigo).first
      @tipo_conv=ConvocatoriaTipo.where(tarea_codigo: @tarea.codigo).first
    end

    def set_minuta #asigna al objeto los valores correspondientes a los campos del registro que calza con el id obtenido como parámetro de la URL
      @minuta=@convocatoria.minuta
      @minuta.establece_mensaje_encabezado
      @minuta.establece_mensaje_cuerpo
      @convocados=@minuta.convocados
    end

    def set_descargable_tareas 
      @descargable_tareas = DescargableTarea.where(tarea_id: @tarea.id).order(id: :asc).all
    end

    def permiso_tarea
      unless @tarea_pendiente.tengo_permiso? current_user
        flash[:warning] = 'No tiene permiso para acceder a esta tarea'
        redirect_to root_path
      end
    end
end
