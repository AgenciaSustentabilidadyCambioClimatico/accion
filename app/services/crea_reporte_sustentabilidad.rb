class CreaReporteSustentabilidad
  attr_accessor :request, :datos_publicos, :manifestacion_de_interes, 
                :clasificaciones_del_acuerdo, :ods_clasif, :metas, 
                :niveles, :auditorias, :clasificaciones_padre_del_acuerdo, :set_metas_acciones
  ## metodo inicializador
  # titulos => ['campo1','campo2',...'campoN']
  # datos => [['dato1','dato2',...'datoN'],['dato1','dato2',...'datoN']]
  # nombre_hoja => "titulo hoja"
  # ruta => "fake_path/mis_documentos/archivo.xlsx"
  def initialize(request, datos_publicos, manifestacion_de_interes, clasificaciones_del_acuerdo, ods_clasif, metas, niveles, auditorias, clasificaciones_padre_del_acuerdo, set_metas_acciones)
    @request = request
    @manifestacion_de_interes = manifestacion_de_interes
    @clasificaciones_del_acuerdo = clasificaciones_del_acuerdo
    @ods_clasif = ods_clasif
    @metas = metas
    @niveles = niveles
    @auditorias = auditorias
    @clasificaciones_padre_del_acuerdo = clasificaciones_padre_del_acuerdo
    @set_metas_acciones = set_metas_acciones
    @datos_publicos = datos_publicos
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
            clasificaciones_del_acuerdo: @clasificaciones_del_acuerdo,
            ods_clasif: @ods_clasif,
            metas: @metas,
            niveles: @niveles,
            auditorias: @auditorias,
            clasificaciones_padre_del_acuerdo: @clasificaciones_padre_del_acuerdo,
            set_metas_acciones: @set_metas_acciones,
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
      #datos
      manifestacion_de_interes = @manifestacion_de_interes
      clasificaciones_del_acuerdo = @clasificaciones_del_acuerdo
      ods_clasif = @ods_clasif
      metas = @metas
      niveles = @niveles
      auditorias = @auditorias
      clasificaciones_padre_del_acuerdo = @clasificaciones_padre_del_acuerdo
      set_metas_acciones = @set_metas_acciones
      request = @request

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

        # clasificaciones del acuerdo
        acuerdo = Caracal::Core::Models::TableCellModel.new do
          clase_base.titulo_pdf self, manifestacion_de_interes.nombre_acuerdo, font_title_1
        end
        estado_acuerdo = Caracal::Core::Models::TableCellModel.new do
          p "Estado del Acuerdo:", font_subtitle_3
          p "Evaluación final de cumplimiento", font_title_3
        end
        fecha_firma = Caracal::Core::Models::TableCellModel.new do
          p "Fecha Firma:", font_subtitle_3
          p (manifestacion_de_interes.firma_fecha.nil? ? 'Aún no firmado' : manifestacion_de_interes.firma_fecha.strftime("%d-%m-%Y")), font_title_3
        end
        institucion = Caracal::Core::Models::TableCellModel.new do
          p "Institución:", font_subtitle_3
          p manifestacion_de_interes.contribuyente.razon_social, font_title_3
        end
        fecha_creacion_doc = Caracal::Core::Models::TableCellModel.new do
          p "Fecha creación documento:", font_subtitle_3
          p Date.today.strftime("%d-%m-%Y"), font_title_3
        end

        sub_c1 = Caracal::Core::Models::TableCellModel.new margins: { top: 1000} do
          img logo, width: 110, height: 40
        end
        c1 = Caracal::Core::Models::TableCellModel.new margins: { top: 200, bottom: 200, left: 200, right: 200 } do
          table [[sub_c1]] do
            cell_style rows[0], background: 'F8F8F8', align: :center
          end
        end
        sub_c2 = Caracal::Core::Models::TableCellModel.new margins: { top: 200, bottom: 200, left: 400, right: 200 } do
          table [[acuerdo],[estado_acuerdo,fecha_firma],[institucion,fecha_creacion_doc]] do
            cell_style rows[0], background: 'F8F8F8'
            cell_style rows[1], background: 'F8F8F8'
            cell_style rows[2], background: 'F8F8F8'
            cell_style rows[0][0], colspan: 2
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

        docx.table [[c1,c2]], margins: { top: 200, bottom: 200, left: 200, right: 200 } do
          border_bottom do
            color   'E5E5E5'
            size    2
          end
          cell_style rows[0], background: 'F8F8F8', align: :center
          cell_style cols[1], width: 8000
        end

        #armo todo lo que va al content para despues pasarlo nomas
        cards_clasificaciones = []
        clasificaciones_del_acuerdo.each_slice(3) do |sub_grupo|
          _cards_clasificaciones = []
          sub_grupo.each do |clasificacion|
            _cards_clasificaciones << clase_base.card_clasificacion(request, clase_base, manifestacion_de_interes, clasificacion, font_title_3, font_subtitle_3)
          end
          (sub_grupo.length..2).each do |e|
            _cards_clasificaciones << ""
          end
          cards_clasificaciones << _cards_clasificaciones
        end

        #metas vs ods

        data_metas_ods = []
        _ods = [""]
        ods_clasif.each do |ods|
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
          ods_clasif.each do |ods|
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

        #resumen certificaciones obtenidas & cert y detalle elementos

        cert_obtenidas = []
        cert_detalle_elementos = []
        niveles.each do |nivel|
          _cert_obtenidas = []
          _cert_obtenidas << Caracal::Core::Models::TableCellModel.new do
            if !nivel[:icono].blank?
              img ActionController::Base.helpers.image_url(nivel[:icono], host: request.base_url), {width: 90, height: 90}
            else
              p " "
            end
          end
          _cert_obtenidas << Caracal::Core::Models::TableCellModel.new do
            p "CERTIFICACIÓN NIVEL #{nivel[:nombre]}", font_title_2
            p nivel[:descripcion], font_subtitle_2
          end
          _cert_obtenidas << Caracal::Core::Models::TableCellModel.new do
            p nivel[:elementos].length, font_title_2.merge({size: 60})
            p "Elementos", font_title_2
          end
          _cert_obtenidas << Caracal::Core::Models::TableCellModel.new do
            if !nivel[:grafica].blank?
              img ActionController::Base.helpers.image_url(nivel[:grafica], host: request.base_url), {width: 90, height: 90}
            else
              p " "
            end
          end
          cert_obtenidas << [Caracal::Core::Models::TableCellModel.new do
            table [_cert_obtenidas] do
              cell_style rows[0], background: 'F8F8F8', align: :center
              cell_style cols[0], width: 2000
              cell_style cols[1], align: :left
              cell_style cols[2], width: 1200
              cell_style cols[3], width: 2000
            end
          end]

          #detalle elem
          
          cert_header = Caracal::Core::Models::TableCellModel.new do
            table [_cert_obtenidas] do
              cell_style rows[0], background: 'F8F8F8', align: :center
              cell_style cols[0], width: 2000
              cell_style cols[1], align: :left
              cell_style cols[2], width: 1200
              cell_style cols[3], width: 2000
            end
          end
          _cert_tabla_elementos = [["Detalle de elementos y vigencia"],["Nombre","Tipo (Alcance)","Otro dato","Fecha certificación","Vigencia certificación"]]
          nivel[:elementos].each do |elemento|
            fecha_cert = elemento.fecha_certificacion
            _cert_tabla_elementos << [
              elemento.nombre_segun_alcance,
              elemento.alcance.nombre,
              elemento.otro_dato,
              fecha_cert.strftime("%d-%m-%Y"),
              elemento.vigencia_certificacion(nivel[:plazo], fecha_cert).strftime("%d-%m-%Y")
            ]
          end
          cert_tabla_elementos = Caracal::Core::Models::TableCellModel.new do
            table _cert_tabla_elementos do
              cell_style rows, font_subtitle_2.merge({color: '4D4D4D'})
              cell_style rows[0][0], font_title_2.merge({background: '003DA5', color: 'FFFFFF', colspan: 5})
              cell_style rows[1], font_title_2.merge({background: 'D2DFFF', color: '003DA5'})
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
          cert_detalle_elementos << [Caracal::Core::Models::TableCellModel.new do
            table [[cert_header], [cert_tabla_elementos]] do
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

        #auditorias realizadas

        audit_realizadas = [["Nombre", "Fecha inicio", "Fecha fin", "Certificación auditoría", "Validación auditoría", "Tipo de auditoría", "Mantención auditoría"]]
        auditorias.each do |auditoria|
          plazo_apertura = auditoria.plazo_apertura.nil? ? 0 : auditoria.plazo_apertura.months
          plazo_cierre = auditoria.plazo_cierre.nil? ? 0 : auditoria.plazo_cierre.months
          audit_realizadas << [
            auditoria.nombre,
            (manifestacion_de_interes.firma_fecha.blank? ? '' : (manifestacion_de_interes.firma_fecha+plazo_apertura).strftime("%d-%m-%Y")),
            (manifestacion_de_interes.firma_fecha.blank? ? '' : (manifestacion_de_interes.firma_fecha+plazo_cierre).strftime("%d-%m-%Y")),
            auditoria.con_certificacion ? "Con certificación" : "Sin certificación",
            auditoria.con_validacion ? "Con validación" : "Sin validación",
            auditoria.final ? "Final" : "intermedia",
            auditoria.con_mantencion ? "Con mantención" : "Sin mantención"
          ]
        end

        #metas y avances de acciones
        metas_avances_acciones = []
        clasificaciones_padre_del_acuerdo.each do |clasificacion|
          _avance_imagen = Caracal::Core::Models::TableCellModel.new do
            if clasificacion.imagen.nil? || clasificacion.imagen.url.blank?
              p " "
            else
              img ActionController::Base.helpers.image_url(clasificacion.imagen.url, host: request.base_url), {width: 100, height: 100}
            end
          end
          _avance_nombre_desc = Caracal::Core::Models::TableCellModel.new do
            p clasificacion.nombre, font_title_2
            p clasificacion.descripcion, font_subtitle_2
          end
          _avance_header = [_avance_imagen, _avance_nombre_desc]
          avance_header = Caracal::Core::Models::TableCellModel.new do
            table [_avance_header] do
              cell_style rows[0], background: 'F8F8F8'
              cell_style cols[0], width: 2500
            end
          end
          _avance_tabla = [["Tabla de acciones"]]
          _avance_tabla_filas_azules = []
          _avance_tabla_filas_datos = []
          _avance_tabla_filas_index = 1
          clasificacion.set_metas_acciones_comprometidas(manifestacion_de_interes).uniq.each do |set_meta_accion|
            _avance_tabla << [
              set_meta_accion.accion.nombre,
              (set_meta_accion.materia_sustancia.nil? ? ' ' : set_meta_accion.materia_sustancia.nombre),
              set_meta_accion.alcance.nombre
            ]
            _avance_tabla_filas_azules << _avance_tabla_filas_index
            _avance_tabla_filas_index += 1

            auditorias.each do |auditoria|
              porcentaje_avance = auditoria.obtiene_porcentaje_avance(set_meta_accion)
              #porcentaje_avance = rand(100)
              if !porcentaje_avance.nil?
                _avance_tabla << [
                  auditoria.nombre,
                  Caracal::Core::Models::TableCellModel.new do
                    p "Porcentaje de avance: #{porcentaje_avance}%", font_subtitle_2.merge({color: '4D4D4D'})
                    table [["","","","","","","","","",""]] do
                      cell_style cols, background: 'E5E5E5'
                      (0..((porcentaje_avance/10).to_i-1)).to_a.each do |n|
                        cell_style cols[n], background: '18762D'
                      end
                      cell_style rows[0], size: 10
                    end
                  end
                ]
                _avance_tabla_filas_datos << _avance_tabla_filas_index
                _avance_tabla_filas_index += 1
              end
            end
          end
          avance_tabla = Caracal::Core::Models::TableCellModel.new do
            table _avance_tabla do
              cell_style rows[0][0], font_title_2.merge({background: (clasificacion.color.blank? ? '003DA5' : clasificacion.color.sub("#","")), colspan: 3, color: 'FFFFFF'})
              _avance_tabla_filas_azules.each do |n|
                cell_style rows[n], font_title_2.merge({background: 'D2DFFF', color: '003DA5'})
              end
              _avance_tabla_filas_datos.each do |n|
                cell_style rows[n][0], colspan: 2
                cell_style rows[n], font_subtitle_2.merge({color: '4D4D4D'})
              end
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

        reporte_avances = [["Meta por elemento","Acción","Detalle del medio de verificación","Porcentaje de cumplimiento"]]
        set_metas_acciones.each do |set_meta_accion|
          reporte_avances << [
            set_meta_accion.meta.nombre,
            set_meta_accion.accion.nombre,
            set_meta_accion.detalle_medio_verificacion,
            set_meta_accion.obtiene_procentaje_cumplimiento
          ]
        end

        #diseño content
        content = Caracal::Core::Models::TableCellModel.new margins: {left: 400, right: 400} do
          p
          clase_base.titulo_pdf self, "Clasificaciones del acuerdo", font_title_1
          table cards_clasificaciones if !cards_clasificaciones.blank?
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
          clase_base.titulo_pdf self, "Resumen certificaciones obtenidas", font_title_1
          if !cert_obtenidas.blank?
            table cert_obtenidas
          end
          p
          clase_base.titulo_pdf self, "Auditorías realizadas", font_title_1
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
          clase_base.titulo_pdf self, "Metas y avances de acciones", font_title_1
          if !metas_avances_acciones.blank?
            table metas_avances_acciones
          end
          p
          clase_base.titulo_pdf self, "Certificaciones y detalle de Elementos y vigencia", font_title_1
          if !cert_detalle_elementos.blank?
            table cert_detalle_elementos
          end
          p
          clase_base.titulo_pdf self, "Reporte de Avance", font_title_1
          if !reporte_avances.blank?
            table reporte_avances do
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

  def card_clasificacion request, clase_base, manif_de_interes, clasificacion, font_title_3, font_subtitle_3
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
      table [[
        clase_base.card_clasificacion_numero("metas", clasificacion.metas_comprometidas(manif_de_interes).count, font_title_3, font_subtitle_3),
        clase_base.card_clasificacion_numero("acciones", clasificacion.set_metas_acciones_comprometidas(manif_de_interes).uniq.count, font_title_3, font_subtitle_3),
        clase_base.card_clasificacion_numero("empresas", clasificacion.empresas_comprometidas(manif_de_interes, 'clasificaciones').length, font_title_3, font_subtitle_3),
        clase_base.card_clasificacion_numero("elementos totales", clasificacion.elementos_comprometidos(manif_de_interes, 'clasificaciones').count, font_title_3, font_subtitle_3)
      ]] do
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