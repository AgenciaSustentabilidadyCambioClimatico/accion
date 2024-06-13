class FondoProduccionLimpia < ApplicationRecord
  belongs_to :flujo
  belongs_to :linea
  belongs_to :sublinea, optional: true

  MINUTOS_MENSAJE_GUARDAR = 20

  mount_uploader :instrumento_constitucion_estatutos_postulante, ArchivoInstrumentoConstitucionEstatutosPostulanteFondoProduccionLimpiaUploader
  mount_uploader :certificado_vigencia_constitucion_postulante, ArchivoCertificadoVigenciaConstitucionPostulanteFondoProduccionLimpiaUploader
  mount_uploader :copia_instrumento_nombre_representante_postulante, ArchivoCopiaInstrumentoNombreRepresentantePostulanteFondoProduccionLimpiaUploader
  mount_uploader :certificado_vigencia_copia_instrumento_postulante, ArchivoCertificadoVigenciaCopiaInstrumentoPostulanteFondoProduccionLimpiaUploader
  mount_uploader :copia_cedula_representantes_legales_postulantes, ArchivoCopiaCedulaRepresentantesLegalesPostulantesFondoProduccionLimpiaUploader
  mount_uploader :documento_coste_rol_unico_tributario_postulante, ArchivoDocumentoCosteRolUnicoTributarioPostulanteFondoProduccionLimpiaUploader
  mount_uploader :antecedentes_contrato_anexo_c_postulante, ArchivoAntecedentesContratoAnexoCPostulanteFondoProduccionLimpiaUploader

  mount_uploader :instrumento_constitucion_estatutos_receptor , ArchivoInstrumentoConstitucionEstatutosReceptorFondoProduccionLimpiaUploader
  mount_uploader :certificado_vigencia_constitucion_receptor, ArchivoCertificadoVigenciaConstitucionReceptorFondoProduccionLimpiaUploader
  mount_uploader :copia_instrumento_nombre_representante_receptor, ArchivoCopiaInstrumentoNombreRepresentanteReceptorFondoProduccionLimpiaUploader
  mount_uploader :certificado_vigencia_copia_instrumento_receptor, ArchivoCertificadoVigenciaCopiaInstrumentoReceptorFondoProduccionLimpiaUploader
  mount_uploader :copia_cedula_representantes_legales_receptor, ArchivoCopiaCedulaRepresentantesLegalesReceptorFondoProduccionLimpiaUploader
  mount_uploader :documento_coste_rol_unico_tributario_receptor, ArchivoDocumentoCosteRolUnicoTributarioReceptorFondoProduccionLimpiaUploader
  mount_uploader :declaracion_jurada_representante_legal_anexo_a_receptor, ArchivoDeclaracionJuradaRepresentanteLegalAnexoAReceptorFondoProduccionLimpiaUploader
  mount_uploader :declaracion_jurada_representante_legal_anexo_b_receptor, ArchivoDeclaracionJuradaRepresentanteLegalAnexoBReceptorFondoProduccionLimpiaUploader
  
  mount_uploader :instrumento_constitucion_estatutos_ejecutor , ArchivoInstrumentoConstitucionEstatutosEjecutorFondoProduccionLimpiaUploader
  mount_uploader :certificado_vigencia_constitucion_ejecutor, ArchivoCertificadoVigenciaConstitucionEjecutorFondoProduccionLimpiaUploader
  mount_uploader :copia_instrumento_nombre_representante_ejecutor, ArchivoCopiaInstrumentoNombreRepresentanteEjecutorFondoProduccionLimpiaUploader
  mount_uploader :certificado_vigencia_copia_instrumento_ejecutor, ArchivoCertificadoVigenciaCopiaInstrumentoEjecutorFondoProduccionLimpiaUploader
  mount_uploader :declaracion_jurada_representante_legal_anexo_a_ejecutor, ArchivoDeclaracionJuradaRepresentanteLegalAnexoAEjecutorFondoProduccionLimpiaUploader
  mount_uploader :declaracion_jurada_representante_legal_anexo_b_ejecutor, ArchivoDeclaracionJuradaRepresentanteLegalAnexoBEjecutorFondoProduccionLimpiaUploader
  mount_uploader :certificado_inicio_actividades_sii_ejecutor, ArchivoCertificadoInicioActividadesSiiEjecutorFondoProduccionLimpiaUploader
  mount_uploader :cedula_identidad_persona_ejecutor, ArchivoCedulaIdentidadPersonaEjecutorFondoProduccionLimpiaUploader
  mount_uploader :declaracion_jurada_simple_anexo_a_ejecutor, ArchivoDeclaracionJuradaSimpleAnexoAEjecutorFondoProduccionLimpiaUploader
  mount_uploader :declaracion_jurada_simple_anexo_b_ejecutor, ArchivoDeclaracionJuradaSimpleAnexoBEjecutorFondoProduccionLimpiaUploader

  ##CONTENIDO
  #validaciones = get_campos_validaciones

  def comunas
    self.flujo.comunas
  end
  
  def comunas_beauty_tree_selector
    Pais.find(Pais::CHILE).beauty_tree_selector(self.comunas.pluck(:id))
  end

  def get_campos_validaciones
    #filtro_tarea = self.tarea_id.present? ? {tarea_id: self.tarea_id} : {}
    filtro_tarea =  nil
    validaciones = {}
    campos = Campo.where(clase: self.class.name) #, validaciones_activas: true, tipo: "text")
    campos = filtro_tarea.present? ? campos.select{|v| v.tareas.where(filtro_tarea)} : campos
    campos.each do |c|
      clase_nombre = c.clase.to_s.constantize.table_name.singularize
      validaciones[clase_nombre.to_sym] = {} if validaciones[clase_nombre.to_sym].blank?
      validaciones[clase_nombre.to_sym][c.atributo.to_sym] = {
        id_campo: c.id,
        nombre: (c.nombre.present? ? c.nombre : c.atributo),
        tooltip_activo: c.tooltip_activo,
        tooltip: (c.tooltip.present? ? c.tooltip : c.atributo),
        ayuda_activo: c.ayuda_activo,
        ayuda: c.ayuda.present? ? c.ayuda : "",
        validaciones_activas: c.validaciones_activas,
        obligatorio_campo: c.validacion_contenido_obligatorio,
        tipo: c.tipo,
        atributo: c.atributo
      }
      if c.validaciones_activas
        validacion_min = c.validacion_min.present? ? c.validacion_min : 0
        validacion_max = c.validacion_max.present? ? c.validacion_max : 0
        validaciones[clase_nombre.to_sym][c.atributo.to_sym].merge!(
          validacion_min_activa: (c.validacion_min_activa.present? & validacion_min != 0) ? c.validacion_min_activa : false,
          validacion_max_activa: (c.validacion_max_activa.present? & validacion_max != 0) ? c.validacion_max_activa : false,
          validacion_min: validacion_min,
          validacion_max: validacion_max
        )
      end
    end
    validaciones
  end

  def revisores_select
    #tipo_instrumento_id = self.tipo_instrumento_id.blank? ? self.flujo.tipo_instrumento_id : self.tipo_instrumento_id
    nombre_acuerdo = self.nombre_acuerdo.blank? ? self.flujo.tipo_instrumento_id : self.nombre_acuerdo
    Responsable.__personas_responsables(Rol::REVISOR_TECNICO, nombre_acuerdo).map{|p| [p.user.nombre_completo, p.id]}     
  end
 
  def self.fpls
    select("fondo_produccion_limpia.flujo_id AS id, fondo_produccion_limpia.codigo_proyecto AS nombre_para_raa")
      .joins("INNER JOIN flujos ON fondo_produccion_limpia.flujo_id = flujos.id")
      .where("flujos.tipo_instrumento_id = ?", 11)
      .order("id DESC")
  end 

  def generar_pdf(revision = nil)
    require 'stringio'
  
    pdf = Prawn::Document.new
    pdf.font Rails.root.join("app/assets/fonts/Open_Sans/OpenSans-Regular.ttf")
  
    # HEADER
    pdf.repeat :all do
      pdf.bounding_box [pdf.bounds.left, pdf.bounds.top], width: pdf.bounds.width do
        pdf.image Rails.root.join("app/assets/images/logo-ascc.png"), width: 119
        pdf.bounding_box [pdf.bounds.left, pdf.bounds.bottom], width: pdf.bounds.width do
          pdf.font Rails.root.join("app/assets/fonts/Open_Sans/OpenSans-Bold.ttf") do 
            pdf.text "FORMULARIO DE DIAGNÓSTICO FONDO PRODUCCIÓN LIMPIA", size: 10, color: "003DA6", align: :right
          end
        end
        pdf.move_down 8
        pdf.stroke do
          pdf.stroke_color '003DA6'
          pdf.line_width 3
          pdf.stroke_horizontal_rule
        end
      end
    end
  
    # CONTENIDO
    validaciones = self.get_campos_validaciones
  
    pdf.bounding_box [pdf.bounds.left, pdf.bounds.top - 100], width: pdf.bounds.width do
      # Aquí se agregan los elementos del PDF, según el contenido necesario.
      self.pdf_titulo_formato(pdf, I18n.t(:propuesta_tecnica), "Objetivos del proyecto")
      self.pdf_separador(pdf, 20)
  
      # Añade más contenido según sea necesario
      self.pdf_titulo_formato(pdf, I18n.t(:equipo_tabajo), "Equipo de Institución Receptora del Cofinanciamiento")
      self.pdf_separador(pdf, 20)
  
      self.pdf_titulo_formato(pdf, I18n.t(:plan_actividades), "Plan de Actividades")
      self.pdf_separador(pdf, 20)
  
      self.pdf_titulo_formato(pdf, I18n.t(:documentacion_legal), "Antecedentes que se deben adjuntar")
      self.pdf_separador(pdf, 20)
  
      self.pdf_titulo_formato(pdf, I18n.t(:costos), "Resumen")
      self.pdf_separador(pdf, 20)
    end
    
    # Ruta donde se guardará el archivo PDF
    pdf_file_path = Rails.root.join('public', 'uploads', 'fondo_produccion_limpia', 'pdf', "fondo_produccion_limpia_#{self.id}_#{revision}.pdf")

    # Asegúrate de que el directorio existe
    FileUtils.mkdir_p(File.dirname(pdf_file_path))
  
    # Guardar el PDF en la ruta especificada
    pdf.render_file(pdf_file_path)
  
    # Retorna la ruta del archivo guardado o el objeto PDF si prefieres manipularlo luego
    pdf_file_path.to_s
  rescue StandardError => e
    Rails.logger.error "Error generando PDF: #{e.message}"
    nil
  end
  

  def pdf_titulo_formato pdf, titulo, subtitulo
    pdf.font Rails.root.join("app/assets/fonts/Open_Sans/OpenSans-Bold.ttf") do 
      pdf.text titulo, size: 11
    end
    pdf.text subtitulo, size: 9
    pdf.text "··········<color rgb='003DA6'>··········</color>", size: 20, color: 'EB0029', inline_format: true, leading: 0
    pdf.move_down 15
  end

  def pdf_contenido_formato pdf, variable, validaciones
    var = validaciones[:manifestacion_de_interes][variable]
    if !var.nil?
      pdf.font Rails.root.join("app/assets/fonts/Open_Sans/OpenSans-SemiBold.ttf") do 
        pdf.text var[:nombre], size: 9
      end
      pdf.move_down 4
      valor = self.send(variable.to_s)
      if valor.blank?
        pdf.font Rails.root.join("app/assets/fonts/Open_Sans/OpenSans-Italic.ttf") do 
          pdf.text 'No se ingresa respuesta', size: 9, color: 'A4A5A7'
        end
      elsif valor.class.superclass == CarrierWave::Uploader::Base
        #pdf.text "<link href='"+valor.url+"'>"+valor.file.filename+"</link>", size: 9, color: '007BFF', inline_format: true
        self.pdf_boton_descarga(pdf, valor.url, valor.file.filename)
      elsif([String,Integer].include?(valor.class))
        pdf.text valor.to_s, size: 9, color: '555555', align: :justify
      elsif(valor.class == Symbol)
        pdf.text I18n.t(valor.to_s.gsub!('-', '_')), size: 9, color: '555555', align: :justify
      end
      pdf.move_down 11
    end
  end

  def pdf_contenido_formato_custom pdf, variable, valor, validaciones, forzar_mostrar=false
    var = validaciones[:manifestacion_de_interes][variable]
    if !var.nil?
      pdf.font Rails.root.join("app/assets/fonts/Open_Sans/OpenSans-SemiBold.ttf") do 
        pdf.text var[:nombre], size: 9
      end
      pdf.move_down 4
      valor_por_variable = self.send(variable.to_s)
      if((valor_por_variable.blank? || valor.blank?) && !forzar_mostrar)
        pdf.font Rails.root.join("app/assets/fonts/Open_Sans/OpenSans-Italic.ttf") do 
          pdf.text 'No se ingresa respuesta', size: 9, color: 'A4A5A7'
        end
      else
        pdf.text valor, size: 9, color: '555555', align: :justify
      end
      pdf.move_down 11
    end
  end

  def pdf_contenido_formato_select pdf, variable, valor_real, link, validaciones
    var = validaciones[:manifestacion_de_interes][variable]
    if !var.nil?
      pdf.font Rails.root.join("app/assets/fonts/Open_Sans/OpenSans-SemiBold.ttf") do 
        pdf.text var[:nombre], size: 9
      end
      pdf.move_down 4
      valor = self.send(variable.to_s)
      if valor.blank?
        pdf.font Rails.root.join("app/assets/fonts/Open_Sans/OpenSans-Italic.ttf") do 
          pdf.text 'No se ingresa respuesta', size: 9, color: 'A4A5A7'
        end
      else
        if link.blank?
          pdf.text valor_real, size: 9, color: '555555', align: :justify
        else
          #pdf.text "<link href='"+link+"'>"+valor_real+"</link>", size: 9, color: '007BFF', inline_format: true
          self.pdf_boton_descarga(pdf, link, valor_real)
        end
      end
      pdf.move_down 11
    end
  end

  def pdf_contenido_formato_checks pdf, variable, valores, validaciones
    var = validaciones[:manifestacion_de_interes][variable]
    if !var.nil?
      pdf.font Rails.root.join("app/assets/fonts/Open_Sans/OpenSans-SemiBold.ttf") do 
        pdf.text var[:nombre], size: 9
      end
      pdf.move_down 4
      if valores.blank? || valores.select{|v| v[:status] == "indeterminate" || v[:status] == "checked" }.size == 0
        pdf.font Rails.root.join("app/assets/fonts/Open_Sans/OpenSans-Italic.ttf") do 
          pdf.text 'No se ingresa respuesta', size: 9, color: 'A4A5A7'
        end
      else
        self._pdf_contenido_format_checks(pdf, valores)
      end
      pdf.move_down 11
    end
  end

  def _pdf_contenido_format_checks pdf, valores
    valores.each do |valor|
      if valor[:status] == 'indeterminate'
        self._pdf_contenido_format_checks(pdf, valor[:children])
      elsif valor[:status] == 'checked'
        pdf.text valor[:name], size: 9, color: '555555'
        pdf.move_down 5
        pdf.stroke do
          pdf.stroke_color '555555'
          pdf.line_width 1
          pdf.stroke_horizontal_rule
        end
        pdf.move_down 5
      end
    end
  end

  def pdf_boton_descarga pdf, link, texto
    pdf.table([
      [
        {
          image: Rails.root.join("app/assets/images/download-solid-blue.jpg").to_s,
          image_height: 9,
          image_width: 9
        },
        "<font size='9'><color rgb='007BFF'><link href='"+link+"'>"+texto+"</link></color></font>"
      ]
    ],
    cell_style: {
      border_color: "007BFF",
      inline_format: true
    }) do
      cells.borders = []
      column(0).borders =[:bottom, :left, :top]
      column(0).padding =[5, 2, 5, 5]
      column(1).borders =[:bottom, :right, :top]
      column(1).padding =[5, 5, 5, 2]
    end
  end

  def pdf_separador(pdf, tamano_pos)
    pdf.stroke do
      pdf.stroke_color 'E5E5E5'
      pdf.line_width 1
      pdf.stroke_horizontal_rule
    end
    pdf.move_down tamano_pos

  end

  def splitBase64(uri)
    if uri.match(%r{^data:(.*?);(.*?),(.*)$})
      return {
        type:      $1, # "image/png"
        encoder:   $2, # "base64"
        data:      $3, # data string
        extension: $1.split('/')[1] # "png"
        }
    end
  end

end
