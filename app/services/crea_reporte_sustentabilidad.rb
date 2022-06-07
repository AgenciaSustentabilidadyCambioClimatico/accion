class CreaReporteSustentabilidad

  def initialize(request, manifestacion_de_interes, adhesion_elemento, current_user, contribuyente)
    @request = request
    @manifestacion_de_interes = manifestacion_de_interes
    @adhesion_elemento = adhesion_elemento
    @current_user = current_user
    @datos_publicos = DatosPublico.load
    @reporte_sustentabilidad = ReporteSustentabilidad.all.first
    @contribuyente = contribuyente
    if !@adhesion_elemento.nil?
      @contribuyente = @adhesion_elemento.persona.contribuyente
    end
    @elementos_adheridos = nil

    if @manifestacion_de_interes.nil?
      sin_manifestacion
    else
      con_manifestacion
    end
  end

  def con_manifestacion

    where_set_metas = {flujo_id: @manifestacion_de_interes.flujo.id}
    if !@adhesion_elemento.nil?
      where_set_metas[:alcance_id] = @adhesion_elemento.alcance_id
    else
      if @contribuyente.nil?
        personas_ids = @current_user.personas.pluck(:id)
      else
        personas_ids = @current_user.personas.where(contribuyente_id: @contribuyente.id).pluck(:id)
      end
      adhesiones_ids = Adhesion.where(flujo_id: @manifestacion_de_interes.flujo.id).pluck(:id)
      @elementos_adheridos = AdhesionElemento.where(persona_id: personas_ids, adhesion_id: adhesiones_ids)
      where_set_metas[:alcance_id] = @elementos_adheridos.pluck(:alcance_id)
    end
    where_general = {set_metas_acciones: where_set_metas}

    #contribucion a los ods
    _contribucion_ods = []
    clasif_ids = []
    clasif_ids += AccionClasificacion.joins("INNER JOIN set_metas_acciones ON set_metas_acciones.accion_id = accion_clasificaciones.accion_id")
                                              .where(where_general)
                                              .pluck("accion_clasificaciones.clasificacion_id")
    clasif_ids += MateriaSustanciaClasificacion.joins("INNER JOIN set_metas_acciones ON set_metas_acciones.materia_sustancia_id = materia_sustancia_clasificaciones.materia_sustancia_id")
                                              .where(where_general)
                                              .pluck("materia_sustancia_clasificaciones.clasificacion_id")
    Clasificacion.where(id: clasif_ids).each do |clasif|
      _contribucion_ods << clasif.mi_padre_mayor.id
    end
    _contribucion_ods.uniq
    @contribucion_ods = Clasificacion.where(id: _contribucion_ods)

    #metas y cumplimientos
    _metas_cumplimientos = []
    _metas_cumplimientos += Accion.joins("INNER JOIN set_metas_acciones ON set_metas_acciones.accion_id = acciones.id")
                                  .where(where_general)
                                  .pluck("acciones.meta_id")
    _metas_cumplimientos += MateriaSustanciaMeta.joins("INNER JOIN materia_sustancias ON materia_sustancia_metas.materia_sustancia_id = materia_sustancias.id INNER JOIN set_metas_acciones ON set_metas_acciones.materia_sustancia_id = materia_sustancias.id")
                                            .where(where_general)
                                            .pluck("materia_sustancia_metas.clasificacion_id")
    set_metas_acciones = SetMetasAccion.where(where_set_metas)

    _metas_cumplimientos += set_metas_acciones.pluck(:meta_id)
    @metas_cumplimientos = Clasificacion.where(id: _metas_cumplimientos)

    #metas vs ods
    @odss = Clasificacion.where(clasificacion_id: nil)
    @metas = {}
    set_metas_acciones.each do |set_metas_accion|
      if(set_metas_accion.meta_id.present?)
        @metas[set_metas_accion.meta_id] = {nombre: set_metas_accion.meta.nombre, icono: set_metas_accion.meta.icono.url, color: set_metas_accion.meta.color, clasificaciones: []} if !@metas.has_key?(set_metas_accion.meta_id)
        @metas[set_metas_accion.meta_id][:clasificaciones] = @metas[set_metas_accion.meta_id][:clasificaciones]+set_metas_accion.accion.accion_clasificaciones.pluck(:clasificacion_id) if !set_metas_accion.accion.nil?
        @metas[set_metas_accion.meta_id][:clasificaciones] = @metas[set_metas_accion.meta_id][:clasificaciones]+set_metas_accion.materia_sustancia.materia_sustancia_clasificaciones.pluck(:clasificacion_id) if !set_metas_accion.materia_sustancia.nil?
      end
    end
    @metas = @metas.values

    #plan de auditoria
    @auditorias = @manifestacion_de_interes.flujo.auditorias
  end

  def sin_manifestacion
    manif_de_intereses_firmadas = ManifestacionDeInteres.where("firma_fecha IS NOT NULL OR firma_fecha_hora IS NOT NULL")
    @acuerdos_firmados = manif_de_intereses_firmadas.count
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
    flujos = Flujo.where(manifestacion_de_interes_id: manif_de_intereses_firmadas.pluck(:id))
    @acciones = SetMetasAccion.where(flujo_id: flujos.pluck(:id)).count

    @flujos_ids = manif_de_intereses_firmadas.map{|mdi| mdi.flujo.id}
    where_set_metas = {flujo_id: @flujos_ids}
    where_general = {set_metas_acciones: where_set_metas}

    #contribucion a los ods
    _contribucion_ods = []
    clasif_ids = []
    clasif_ids += AccionClasificacion.joins("INNER JOIN set_metas_acciones ON set_metas_acciones.accion_id = accion_clasificaciones.accion_id")
                                              .where(where_general)
                                              .pluck("accion_clasificaciones.clasificacion_id")
    clasif_ids += MateriaSustanciaClasificacion.joins("INNER JOIN set_metas_acciones ON set_metas_acciones.materia_sustancia_id = materia_sustancia_clasificaciones.materia_sustancia_id")
                                              .where(where_general)
                                              .pluck("materia_sustancia_clasificaciones.clasificacion_id")
    Clasificacion.where(id: clasif_ids).each do |clasif|
      _contribucion_ods << clasif.mi_padre_mayor.id
    end
    _contribucion_ods.uniq
    @contribucion_ods = Clasificacion.where(id: _contribucion_ods)

    #metas y cumplimientos
    _metas_cumplimientos = []
    _metas_cumplimientos += Accion.joins("INNER JOIN set_metas_acciones ON set_metas_acciones.accion_id = acciones.id")
                                  .where(where_general)
                                  .pluck("acciones.meta_id")
    _metas_cumplimientos += MateriaSustanciaMeta.joins("INNER JOIN materia_sustancias ON materia_sustancia_metas.materia_sustancia_id = materia_sustancias.id INNER JOIN set_metas_acciones ON set_metas_acciones.materia_sustancia_id = materia_sustancias.id")
                                            .where(where_general)
                                            .pluck("materia_sustancia_metas.clasificacion_id")
    set_metas_acciones = SetMetasAccion.where(where_set_metas)

    _metas_cumplimientos += set_metas_acciones.pluck(:meta_id)
    @metas_cumplimientos = Clasificacion.where(id: _metas_cumplimientos)

    #metas vs ods
    @odss = Clasificacion.where(clasificacion_id: nil)
    @metas = {}
    set_metas_acciones.each do |set_metas_accion|
      if(set_metas_accion.meta_id.present?)
        @metas[set_metas_accion.meta_id] = {nombre: set_metas_accion.meta.nombre, icono: set_metas_accion.meta.icono.url, color: set_metas_accion.meta.color, clasificaciones: []} if !@metas.has_key?(set_metas_accion.meta_id)
        @metas[set_metas_accion.meta_id][:clasificaciones] = @metas[set_metas_accion.meta_id][:clasificaciones]+set_metas_accion.accion.accion_clasificaciones.pluck(:clasificacion_id) if !set_metas_accion.accion.nil?
        @metas[set_metas_accion.meta_id][:clasificaciones] = @metas[set_metas_accion.meta_id][:clasificaciones]+set_metas_accion.materia_sustancia.materia_sustancia_clasificaciones.pluck(:clasificacion_id) if !set_metas_accion.materia_sustancia.nil?
      end
    end
    @metas = @metas.values


  end

  def crear_reporte
    archivo = nil
    if @datos_publicos.pdf?

      archivo = WickedPdf.new.pdf_from_string(
        ActionController::Base.new.render_to_string(
          #cover: render_to_string('_portada_reporte_sustentabilidad'),
          'admin/gestionar_mis_instrumentos/_reporte_sustentabilidad', 
          layout: 'layouts/wicked_pdf',
          locals: {
            manifestacion_de_interes: @manifestacion_de_interes,
            contribuyente: @contribuyente,
            adhesion_elemento: @adhesion_elemento,
            elementos_adheridos: @elementos_adheridos,
            alcances_ids: @adhesion_elemento.nil? ? @elementos_adheridos.pluck(:alcance_id) : @adhesion_elemento,
            elementos_adheridos_ids: @adhesion_elemento.nil? ? @elementos_adheridos.pluck(:id) : [@adhesion_elemento.id],
            contribucion_ods: @contribucion_ods,
            metas_cumplimientos: @metas_cumplimientos,
            odss: @odss,
            metas: @metas,
            auditorias: @auditorias,
            acuerdos_firmados: @acuerdos_firmados,
            empresas_adheridas: @empresas_adheridas,
            empresas_certificadas: @empresas_certificadas,
            acciones: @acciones,
            flujos_ids: @flujos_ids,
            reporte_sustentabilidad: @reporte_sustentabilidad,
            app_helpers: ApplicationController.helpers,
            request: @request
          }
        ),
        header: {
          content: ActionController::Base.new.render_to_string(
            'admin/gestionar_mis_instrumentos/_reporte_header',
            layout: 'layouts/wicked_pdf',
            locals: {
              app_helpers: ApplicationController.helpers,
              request: @request
            }
          ),
          spacing: 0
        },
        footer: {
          content: ActionController::Base.new.render_to_string(
            'admin/gestionar_mis_instrumentos/_reporte_footer',
            layout: 'layouts/wicked_pdf'
          )
        },
        margin: {top: 16, bottom: 12, left: 0, right: 0},
        show_as_html: true
      )
    else
      #variables iniciales
      request = @request
      manifestacion_de_interes = @manifestacion_de_interes
      adhesion_elemento = @adhesion_elemento
      elementos_adheridos = @elementos_adheridos
      alcances_ids = adhesion_elemento.nil? ? elementos_adheridos.pluck(:alcance_id) : adhesion_elemento
      elementos_adheridos_ids = adhesion_elemento.nil? ? elementos_adheridos.pluck(:id) : [adhesion_elemento.id]
      current_user = @current_user
      datos_publicos = @datos_publicos
      reporte_sustentabilidad = @reporte_sustentabilidad
      contribuyente = @contribuyente

      contribucion_ods = @contribucion_ods
      metas_cumplimientos = @metas_cumplimientos
      odss = @odss
      metas = @metas
      auditorias = @auditorias

      acuerdos_firmados = @acuerdos_firmados
      empresas_adheridas = @empresas_adheridas
      empresas_certificadas = @empresas_certificadas
      acciones = @acciones
      flujos_ids = @flujos_ids

      #config inicial
      clase_base = self
      logo = ActionController::Base.helpers.image_url('logo-ascc.png', host: request.base_url)
      font_title_1 = {size: 18, color: '000000', bold: true}
      font_title_2 = {size: 16, color: '000000', bold: true}
      font_subtitle_2 = {size: 16, color: '000000'}
      font_title_3 = {size: 14, color: '000000', bold: true}
      font_subtitle_3 = {size: 14, color: '000000'}
      default_margins = {indent_left: 720, indent_rigth: 720}

      archivo = Caracal::Document.render do |docx|
        #config
        docx.page_margins do
          left    1     # sets the left margin. units in twips.
          right   1     # sets the right margin. units in twips.
          top     1    # sets the top margin. units in twips.
          bottom  1    # sets the bottom margin. units in twips.
        end
        #cover
        docx.img ActionController::Base.helpers.image_url('cover-reporte-sustentabilidad.jpg', host: request.base_url), width: 615, height: 795

        #intro
        content_intro = Caracal::Core::Models::TableCellModel.new margins: {left: 400, right: 400} do
          clase_base.titulo_pdf self, reporte_sustentabilidad.nil? ? "Introducción" : reporte_sustentabilidad.titulo_intro, font_title_1
          p reporte_sustentabilidad.nil? ? '' : ActionView::Base.full_sanitizer.sanitize(reporte_sustentabilidad.cuerpo_intro)
        end
        docx.table [[content_intro]]
        docx.page

        # clasificaciones del acuerdo
        if !manifestacion_de_interes.nil?
          acuerdo = Caracal::Core::Models::TableCellModel.new do
            clase_base.titulo_pdf self, manifestacion_de_interes.nombre_acuerdo, font_title_1
          end
          estado_acuerdo = Caracal::Core::Models::TableCellModel.new do
            p "Estado del Acuerdo:", font_subtitle_3
            p "Evaluación final de cumplimiento", font_title_3
          end
          fecha_firma = Caracal::Core::Models::TableCellModel.new do
            p "Fecha Firma:", font_subtitle_3
            _firma_fecha = manifestacion_de_interes.firma_fecha_hora.blank? ? manifestacion_de_interes.firma_fecha : manifestacion_de_interes.firma_fecha_hora
            p (_firma_fecha.blank? ? 'Aún no firmado' : _firma_fecha.strftime("%d-%m-%Y")), font_title_3
          end
          if contribuyente.nil?
            institucion = Caracal::Core::Models::TableCellModel.new do
              p "Institución:", font_subtitle_3
              p manifestacion_de_interes.contribuyente.razon_social, font_title_3
            end
          else
            institucion = Caracal::Core::Models::TableCellModel.new do
              p "Institución:", font_subtitle_3
              p contribuyente.razon_social, font_title_3
            end
          end
          fecha_creacion_doc = Caracal::Core::Models::TableCellModel.new do
            p "Fecha creación documento:", font_subtitle_3
            p Date.today.strftime("%d-%m-%Y"), font_title_3
          end
          _data_b = [[acuerdo],[estado_acuerdo,fecha_firma],[institucion,fecha_creacion_doc]]
          if !adhesion_elemento.nil?
            unidad_funcional = Caracal::Core::Models::TableCellModel.new do
              p "Unidad Funcional:", font_subtitle_3
              p adhesion_elemento.nombre_segun_alcance, font_title_3
            end
            _data_b << [unidad_funcional]
          end
          sub_c2 = Caracal::Core::Models::TableCellModel.new margins: { top: 200, bottom: 200, left: 400, right: 200 } do
            table _data_b do
              cell_style rows[0], background: 'F8F8F8'
              cell_style rows[1], background: 'F8F8F8'
              cell_style rows[2], background: 'F8F8F8'
              cell_style rows[3], background: 'F8F8F8' if !adhesion_elemento.nil?
              cell_style rows[0][0], colspan: 2
              cell_style rows[3][0], colspan: 2 if !adhesion_elemento.nil?
            end
          end
        else
          acuerdos_firmados = Caracal::Core::Models::TableCellModel.new do
            p "Acuerdos Firmados:", font_subtitle_3
            p acuerdos_firmados, font_title_3
          end
          empresas_adheridas = Caracal::Core::Models::TableCellModel.new do
            p "Empresas adheridas:", font_subtitle_3
            p empresas_adheridas, font_title_3
          end
          empresas_certificadas = Caracal::Core::Models::TableCellModel.new do
            p "Empresas certificadas:", font_subtitle_3
            p empresas_certificadas, font_title_3
          end
          acciones = Caracal::Core::Models::TableCellModel.new do
            p "Acciones:", font_subtitle_3
            p acciones, font_title_3
          end
          sub_c2 = Caracal::Core::Models::TableCellModel.new margins: { top: 200, bottom: 200, left: 400, right: 200 } do
            table [[acuerdos_firmados,empresas_adheridas],[empresas_certificadas,acciones]] do
              cell_style rows[0], background: 'F8F8F8'
              cell_style rows[1], background: 'F8F8F8'
            end
          end
        end

        sub_c1 = Caracal::Core::Models::TableCellModel.new margins: { top: 1000} do
          img logo, width: 110, height: 40
        end
        c1 = Caracal::Core::Models::TableCellModel.new margins: { top: 200, bottom: 200, left: 200, right: 200 } do
          table [[sub_c1]] do
            cell_style rows[0], background: 'F8F8F8', align: :center
          end
        end

        c2 = Caracal::Core::Models::TableCellModel.new do
          table [[sub_c2]] do
            border_left do
              color   'E5E5E5'
              size    2
            end
            cell_style rows[0], background: 'F8F8F8'
          end
        end

        docx.page
        docx.table [[c1,c2]], margins: { top: 200, bottom: 200, left: 200, right: 200 } do
          border_bottom do
            color   'E5E5E5'
            size    2
          end
          cell_style rows[0], background: 'F8F8F8', align: :center
          cell_style cols[1], width: 8000
        end

        #armo todo lo que va al content para despues pasarlo nomas
        cards_contribucion_ods = []
        contribucion_ods.each_slice(3) do |sub_grupo|
          _cards_contribucion_ods = []
          sub_grupo.each do |clasificacion|
            _cards_contribucion_ods << clase_base.card_clasificacion(request, clase_base, manifestacion_de_interes, clasificacion, font_title_3, font_subtitle_3, flujos_ids, alcances_ids, adhesion_elemento, elementos_adheridos_ids)
          end
          (sub_grupo.length..2).each do |e|
            _cards_contribucion_ods << ""
          end
          cards_contribucion_ods << _cards_contribucion_ods
        end


        cards_metas_cumplimientos = []
        metas_cumplimientos.each_slice(3) do |sub_grupo|
          _cards_metas_cumplimientos = []
          sub_grupo.each do |clasificacion|
            _cards_metas_cumplimientos << clase_base.card_meta(request, clase_base, manifestacion_de_interes, clasificacion, font_title_3, font_subtitle_3, flujos_ids, alcances_ids, elementos_adheridos, adhesion_elemento, elementos_adheridos_ids)
          end
          (sub_grupo.length..2).each do |e|
            _cards_metas_cumplimientos << ""
          end
          cards_metas_cumplimientos << _cards_metas_cumplimientos
        end

        #metas vs ods

        data_metas_ods = []
        _ods = [""]
        odss.each do |ods|
          _ods << Caracal::Core::Models::TableCellModel.new do
            if ods.icono.nil? || ods.icono.url.blank?
              p " "
            else
              img ActionController::Base.helpers.image_url(ods.icono.url, host: request.base_url), {width: 20, height: 20}
            end
          end
        end
        data_metas_ods << _ods
        metas.each do |meta|
          _meta = []
          _meta << Caracal::Core::Models::TableCellModel.new do
            if meta[:icono].blank?
              p " "
            else
              img ActionController::Base.helpers.image_url(meta[:icono], host: request.base_url), {width: 20, height: 20}
            end
          end
          odss.each do |ods|
            _meta << Caracal::Core::Models::TableCellModel.new do
              if meta[:clasificaciones].include?(ods.id)
                #ToDo: se puede usar color?
                #ToDo: evaluar crear controlar que convierta a png con color incluido, y que lo devuelva una url
                color = meta[:color]
                color = '#C4C4C4' if color.nil?
                img ActionController::Base.helpers.image_url('tint-solid.svg', host: request.base_url), {width: 20, height: 20}
              else
                p " "
              end
            end
            
          end
          data_metas_ods << _meta
        end

        data_metas_guia = []
        metas.each do |meta|
          img = Caracal::Core::Models::TableCellModel.new do
            if meta[:icono].blank?
              p " "
            else
              img ActionController::Base.helpers.image_url(meta[:icono], host: request.base_url), {width: 20, height: 20}
            end
          end
          data_metas_guia << [img, meta[:nombre]]
        end

        #resumen certificaciones obtenidas & cert y detalle elementos

        # cert_obtenidas = []
        # cert_detalle_elementos = []
        # niveles.each do |nivel|
        #   _cert_obtenidas = []
        #   _cert_obtenidas << Caracal::Core::Models::TableCellModel.new do
        #     if !nivel[:icono].blank?
        #       img ActionController::Base.helpers.image_url(nivel[:icono], host: request.base_url), {width: 90, height: 90}
        #     else
        #       p " "
        #     end
        #   end
        #   _cert_obtenidas << Caracal::Core::Models::TableCellModel.new do
        #     p "CERTIFICACIÓN NIVEL #{nivel[:nombre]}", font_title_2
        #     p nivel[:descripcion], font_subtitle_2
        #   end
        #   _cert_obtenidas << Caracal::Core::Models::TableCellModel.new do
        #     p nivel[:elementos].length, font_title_2.merge({size: 60})
        #     p "Elementos", font_title_2
        #   end
        #   _cert_obtenidas << Caracal::Core::Models::TableCellModel.new do
        #     if !nivel[:grafica].blank?
        #       img ActionController::Base.helpers.image_url(nivel[:grafica], host: request.base_url), {width: 90, height: 90}
        #     else
        #       p " "
        #     end
        #   end
        #   cert_obtenidas << [Caracal::Core::Models::TableCellModel.new do
        #     table [_cert_obtenidas] do
        #       cell_style rows[0], background: 'F8F8F8', align: :center
        #       cell_style cols[0], width: 2000
        #       cell_style cols[1], align: :left
        #       cell_style cols[2], width: 1200
        #       cell_style cols[3], width: 2000
        #     end
        #   end]

        #   #detalle elem
          
        #   cert_header = Caracal::Core::Models::TableCellModel.new do
        #     table [_cert_obtenidas] do
        #       cell_style rows[0], background: 'F8F8F8', align: :center
        #       cell_style cols[0], width: 2000
        #       cell_style cols[1], align: :left
        #       cell_style cols[2], width: 1200
        #       cell_style cols[3], width: 2000
        #     end
        #   end
        #   _cert_tabla_elementos = [["Detalle de elementos y vigencia"],["Nombre","Tipo (Alcance)","Otro dato","Fecha certificación","Vigencia certificación"]]
        #   nivel[:elementos].each do |elemento|
        #     fecha_cert = elemento.fecha_certificacion
        #     _cert_tabla_elementos << [
        #       elemento.nombre_segun_alcance,
        #       elemento.alcance.nombre,
        #       elemento.otro_dato,
        #       fecha_cert.strftime("%d-%m-%Y"),
        #       elemento.vigencia_certificacion(nivel[:plazo], fecha_cert).strftime("%d-%m-%Y")
        #     ]
        #   end
        #   cert_tabla_elementos = Caracal::Core::Models::TableCellModel.new do
        #     table _cert_tabla_elementos do
        #       cell_style rows, font_subtitle_2.merge({color: '4D4D4D'})
        #       cell_style rows[0][0], font_title_2.merge({background: '003DA5', color: 'FFFFFF', colspan: 5})
        #       cell_style rows[1], font_title_2.merge({background: 'D2DFFF', color: '003DA5'})
        #       border_top do
        #         color   'E0E0E0'
        #         size    1
        #       end
        #       border_bottom do
        #         color   'E0E0E0'
        #         size    1
        #       end
        #       border_left do
        #         color   'E0E0E0'
        #         size    1
        #       end
        #       border_right do
        #         color   'E0E0E0'
        #         size    1
        #       end
        #       border_horizontal do
        #         color   'E0E0E0'
        #         size    1
        #       end
        #     end
        #   end
        #   cert_detalle_elementos << [Caracal::Core::Models::TableCellModel.new do
        #     table [[cert_header], [cert_tabla_elementos]] do
        #       cell_style rows, background: 'F8F8F8'
        #       border_top do
        #         color   'E0E0E0'
        #         size    1
        #       end
        #       border_bottom do
        #         color   'E0E0E0'
        #         size    1
        #       end
        #       border_left do
        #         color   'E0E0E0'
        #         size    1
        #       end
        #       border_right do
        #         color   'E0E0E0'
        #         size    1
        #       end
        #     end
        #   end]
                    
        # end

        if !manifestacion_de_interes.nil?
          #auditorias realizadas

          audit_realizadas = [["Nombre", "Fecha inicio", "Fecha fin", "Certificación auditoría", "Validación auditoría", "Tipo de auditoría", "Mantención auditoría"]]
          auditorias.each do |auditoria|
            plazo_apertura = auditoria.plazo_apertura.nil? ? 0 : auditoria.plazo_apertura.months
            plazo_cierre = auditoria.plazo_cierre.nil? ? 0 : auditoria.plazo_cierre.months
            _firma_fecha = manifestacion_de_interes.firma_fecha_hora.blank? ? manifestacion_de_interes.firma_fecha : manifestacion_de_interes.firma_fecha_hora
            audit_realizadas << [
              auditoria.nombre,
              (_firma_fecha.blank? ? '' : (_firma_fecha+plazo_apertura).strftime("%d-%m-%Y")),
              (_firma_fecha.blank? ? '' : (_firma_fecha+plazo_cierre).strftime("%d-%m-%Y")),
              auditoria.con_certificacion ? "Con certificación" : "Sin certificación",
              auditoria.con_validacion ? "Con validación" : "Sin validación",
              auditoria.final ? "Final" : "intermedia",
              auditoria.con_mantencion ? "Con mantención" : "Sin mantención"
            ]
          end

          #metas y avances de acciones
          metas_avances_acciones = []
          metas_cumplimientos.each_with_index do |clasificacion, _idx|
            _avance_imagen = Caracal::Core::Models::TableCellModel.new do
              if clasificacion.imagen.nil? || clasificacion.imagen.url.blank?
                p " "
              else
                img ActionController::Base.helpers.image_url(clasificacion.imagen.url, host: request.base_url), {width: 100, height: 100}
              end
            end
            _avance_nombre_desc = Caracal::Core::Models::TableCellModel.new do
              p "Meta #{_idx+1}", font_title_1
              p clasificacion.nombre, font_title_1
              p clasificacion.descripcion, font_subtitle_2
            end
            _avance_header = [_avance_imagen, _avance_nombre_desc]
            avance_header = Caracal::Core::Models::TableCellModel.new do
              table [_avance_header] do
                cell_style rows[0], background: 'F8F8F8'
                cell_style cols[0], width: 2500
              end
            end

            _avance_tabla = [["ACCIONES (UNIDAD FUNCIONAL A LA QUE APLICA)", "PORCENTAJE CUMPLIMIENTO"]]
            _avance_tabla_filas_azules = []
            _avance_tabla_filas_datos = []
            _avance_tabla_filas_index = 1
            clasificacion.set_metas_acciones_comprometidas_de_meta(manifestacion_de_interes, flujos_ids, alcances_ids).each do |accion|
              porcentaje_cumple = accion.obtiene_procentaje_cumplimiento(nil, elementos_adheridos_ids).gsub("%","").to_f
              _avance_tabla << [
                "#{accion.accion.nombre}#{(accion.materia_sustancia.blank? ? '' : '/'+accion.materia_sustancia.nombre)} (#{accion.alcance.nombre})",
                Caracal::Core::Models::TableCellModel.new do
                  p "#{porcentaje_cumple}%", font_subtitle_2.merge({color: '4D4D4D'})
                  table [["","","","","","","","","",""]] do
                    cell_style cols, background: 'E5E5E5'
                    (0..((porcentaje_cumple/10).to_i-1)).to_a.each do |n|
                      cell_style cols[n], background: '18762D'
                    end
                    cell_style rows[0], size: 10
                  end
                end
              ]
            end
            avance_tabla = Caracal::Core::Models::TableCellModel.new do
              table _avance_tabla do
                cell_style rows[0], font_title_2.merge({background: (clasificacion.color.blank? ? '003DA5' : clasificacion.color.sub("#","")), colspan: 3, color: 'FFFFFF'})

                border_top do
                  color   'E0E0E0'
                  size    1
                end
                border_bottom do
                  color   'E0E0E0'
                  size    1
                end
                border_left do
                  color   'E0E0E0'
                  size    1
                end
                border_right do
                  color   'E0E0E0'
                  size    1
                end
                border_horizontal do
                  color   'E0E0E0'
                  size    1
                end
                
              end
            end
            _metas_avances_acciones = [[avance_header],[avance_tabla]]

            metas_avances_acciones << [Caracal::Core::Models::TableCellModel.new do
              table _metas_avances_acciones do
                cell_style rows, background: 'F8F8F8'
                border_top do
                  color   'E0E0E0'
                  size    1
                end
                border_bottom do
                  color   'E0E0E0'
                  size    1
                end
                border_left do
                  color   'E0E0E0'
                  size    1
                end
                border_right do
                  color   'E0E0E0'
                  size    1
                end
              end
            end]
          end

          #reporte de avance

          # reporte_avances = [["Meta por elemento","Acción","Detalle del medio de verificación","Porcentaje de cumplimiento"]]
          # set_metas_acciones.each do |set_meta_accion|
          #   reporte_avances << [
          #     set_meta_accion.meta.nombre,
          #     set_meta_accion.accion.nombre,
          #     set_meta_accion.detalle_medio_verificacion,
          #     set_meta_accion.obtiene_procentaje_cumplimiento
          #   ]
          # end
        end

        #diseño content
        content = Caracal::Core::Models::TableCellModel.new margins: {left: 400, right: 400} do
          p
          clase_base.titulo_pdf self, "Contribución a los ODS", font_title_1
          table cards_contribucion_ods if !cards_contribucion_ods.blank?
          p
          clase_base.titulo_pdf self, "Metas y cumplimientos", font_title_1
          table cards_metas_cumplimientos if !cards_metas_cumplimientos.blank?
          p
          table data_metas_ods do
            border_vertical do
              color   '003DA6'
              size    1
            end
            border_horizontal do
              color   '003DA6'
              size    1
            end
          end
          p
          table data_metas_guia
          #p
          #clase_base.titulo_pdf self, "Resumen certificaciones obtenidas", font_title_1
          #if !cert_obtenidas.blank?
          #  table cert_obtenidas
          #end
          if !manifestacion_de_interes.nil?
            p
            clase_base.titulo_pdf self, "Plan de auditorías", font_title_1
            if !audit_realizadas.blank?
              table audit_realizadas do
                border_top do
                  color   'E0E0E0'
                  size    1
                end
                border_bottom do
                  color   'E0E0E0'
                  size    1
                end
                border_left do
                  color   'E0E0E0'
                  size    1
                end
                border_right do
                  color   'E0E0E0'
                  size    1
                end
                cell_style rows, font_subtitle_3.merge({background: 'F8F8F8', color: '4D4D4D'})
                cell_style rows[0], font_title_3.merge({background: '003DA5', color: 'FFFFFF'})
              end
            end
            p
            clase_base.titulo_pdf self, "Estado consolidado cumplimiento de acciones / compromisos", font_title_1
            table metas_avances_acciones if !metas_avances_acciones.blank?
            #p
            #clase_base.titulo_pdf self, "Certificaciones y detalle de Elementos y vigencia", font_title_1
            #if !cert_detalle_elementos.blank?
            #  table cert_detalle_elementos
            #end
            #p
            #clase_base.titulo_pdf self, "Reporte de Avance", font_title_1
            #if !reporte_avances.blank?
            #  table reporte_avances do
            #    border_top do
            #      color   'E0E0E0'
            #      size    1
            #    end
            #    border_bottom do
            #      color   'E0E0E0'
            #      size    1
            #    end
            #    border_left do
            #      color   'E0E0E0'
            #      size    1
            #    end
            #    border_right do
            #      color   'E0E0E0'
            #      size    1
            #    end
            #    cell_style rows, font_subtitle_3.merge({background: 'F8F8F8', color: '4D4D4D'})
            #    cell_style rows[0], font_title_3.merge({background: '003DA5', color: 'FFFFFF'})
            #  end
            #end
          end

        end

        docx.table [[content]]

        docx.page
      end
    end
    archivo
  end

  def titulo_pdf docx, titulo, font
    docx.p titulo, font
    docx.img ActionController::Base.helpers.image_url('report-dots.png', host: @request.base_url), {width: 100, height: 4}
  end

  def card_clasificacion request, clase_base, manif_de_interes, clasificacion, font_title_3, font_subtitle_3, flujos_ids=[], alcances_ids=nil, adhesion_elemento=nil, elementos_adheridos_ids=nil
    _celda_icono = Caracal::Core::Models::TableCellModel.new do
      if clasificacion.icono.nil? || clasificacion.icono.url.blank?
        p " "
      else
        img ActionController::Base.helpers.image_url(clasificacion.icono.url, host: request.base_url), {width: 12, height: 12}
      end
    end
    celda_icono = Caracal::Core::Models::TableCellModel.new do
      table [[_celda_icono]] do
        cell_style rows[0], background: (clasificacion.color.blank? ? 'BB302D' : clasificacion.color.sub("#","")), align: :center
      end
    end
    celda_nombre_desc = Caracal::Core::Models::TableCellModel.new do
      p clasificacion.nombre, font_title_3.merge({color: 'FFFFFF'})
      p clasificacion.descripcion, font_subtitle_3.merge({color: 'FFFFFF'})
    end
    celda_numeros = Caracal::Core::Models::TableCellModel.new do
      _datos_a = [
        clase_base.card_clasificacion_numero("Metas", clasificacion.metas_comprometidas(manif_de_interes, flujos_ids, alcances_ids).count, font_title_3, font_subtitle_3),
        clase_base.card_clasificacion_numero("Acciones", clasificacion.set_metas_acciones_comprometidas(manif_de_interes, flujos_ids, alcances_ids).uniq.count, font_title_3, font_subtitle_3)
      ]
      _datos_a << clase_base.card_clasificacion_numero("Unidades funcionales ", clasificacion.elementos_comprometidos(manif_de_interes, 'clasificaciones', flujos_ids, elementos_adheridos_ids).count, font_title_3, font_subtitle_3) if adhesion_elemento.nil?

      table [_datos_a] do
        border_vertical do
          color   'FFFFFF'
          size    1
        end
        cell_style rows[0], background: '003693'
      end
    end
    Caracal::Core::Models::TableCellModel.new do
      table [[celda_icono],[celda_nombre_desc],[celda_numeros]] do
        cell_style rows[0], background: '003693', width: 650, align: :right
        cell_style rows[1], background: '003693'
        cell_style rows[2], background: '003693'
      end
    end
  end

  def card_meta request, clase_base, manif_de_interes, clasificacion, font_title_3, font_subtitle_3, flujos_ids=[], alcances_ids=nil, elementos_adheridos=nil, adhesion_elemento=nil, elementos_adheridos_ids=nil
    _celda_icono = Caracal::Core::Models::TableCellModel.new do
      if clasificacion.icono.nil? || clasificacion.icono.url.blank?
        p " "
      else
        img ActionController::Base.helpers.image_url(clasificacion.icono.url, host: request.base_url), {width: 12, height: 12}
      end
    end
    celda_icono = Caracal::Core::Models::TableCellModel.new do
      table [[_celda_icono]] do
        cell_style rows[0], background: (clasificacion.color.blank? ? 'BB302D' : clasificacion.color.sub("#","")), align: :center
      end
    end
    celda_nombre_desc = Caracal::Core::Models::TableCellModel.new do
      p clasificacion.nombre, font_title_3.merge({color: 'FFFFFF'})
      p clasificacion.descripcion, font_subtitle_3.merge({color: 'FFFFFF'})
    end
    celda_numeros = Caracal::Core::Models::TableCellModel.new do
      _datos_a = [
        clase_base.card_clasificacion_numero("Acciones", clasificacion.set_metas_acciones_comprometidas_de_meta(manif_de_interes, flujos_ids, alcances_ids).count, font_title_3, font_subtitle_3),
        clase_base.card_clasificacion_numero("Cumplimiento promedio", "#{clasificacion.cumplimiento_promedio(manif_de_interes, 'metas', flujos_ids, elementos_adheridos.to_a)}%", font_title_3, font_subtitle_3)
      ]
      _datos_a << clase_base.card_clasificacion_numero("Unidades funcionales ", clasificacion.elementos_comprometidos(manif_de_interes, 'metas', flujos_ids, elementos_adheridos_ids).count, font_title_3, font_subtitle_3) if adhesion_elemento.nil?

      table [_datos_a] do
        border_vertical do
          color   'FFFFFF'
          size    1
        end
        cell_style rows[0], background: '003693'
      end
    end
    Caracal::Core::Models::TableCellModel.new do
      table [[celda_icono],[celda_nombre_desc],[celda_numeros]] do
        cell_style rows[0], background: '003693', width: 650, align: :right
        cell_style rows[1], background: '003693'
        cell_style rows[2], background: '003693'
      end
    end
  end

  def card_clasificacion_numero titulo, numero, font_title_3, font_subtitle_3
    Caracal::Core::Models::TableCellModel.new do
      p numero, font_title_3.merge({color: 'FFFFFF'})
      p titulo, font_subtitle_3.merge({color: 'FFFFFF'})
    end
  end
end
