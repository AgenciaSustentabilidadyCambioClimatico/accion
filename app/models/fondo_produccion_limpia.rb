class FondoProduccionLimpia < ApplicationRecord
  belongs_to :flujo
  belongs_to :linea, optional: true
  belongs_to :sublinea, optional: true
  #has_many :flujo

  attr_accessor :coordernadas_territorios

  MINUTOS_MENSAJE_GUARDAR = 20
  DURACION_FPL_LINEA_1_1 = 4
  DURACION_FPL_LINEA_1_2 = 12
  DURACION_FPL_LINEA_1_3   = 12
  DURACION_FPL_EXTRAPRESUPUESTARIO = 24
  APORTE_MICRO_EMPRESA = 900000
  APORTE_PEQUEÑA_EMPRESA = 700000
  APORTE_MEDIANA_EMPRESA = 300000
  APORTE_MICRO_EMPRESA_L13 = 135000
  APORTE_PEQUEÑA_EMPRESA_L13 = 105000
  APORTE_MEDIANA_EMPRESA_L13 = 45000
  PORCENTAJE_APORTE_BENEFICIARIO_MICRO_EMPRESA = 0.1
  PORCENTAJE_APORTE_BENEFICIARIO_PEQUEÑA_EMPRESA = 0.3
  PORCENTAJE_APORTE_BENEFICIARIO_MEDIANA_EMPRESA = 0.7
  TIPO_CONSULTOR_FPL = 3

  mount_uploader :instrumento_constitucion_estatutos_postulante, ArchivoInstrumentoConstitucionEstatutosPostulanteFondoProduccionLimpiaUploader
  mount_uploader :certificado_vigencia_constitucion_postulante, ArchivoCertificadoVigenciaConstitucionPostulanteFondoProduccionLimpiaUploader
  mount_uploader :copia_instrumento_nombre_representante_postulante, ArchivoCopiaInstrumentoNombreRepresentantePostulanteFondoProduccionLimpiaUploader
  mount_uploader :certificado_vigencia_copia_instrumento_postulante, ArchivoCertificadoVigenciaCopiaInstrumentoPostulanteFondoProduccionLimpiaUploader
  mount_uploader :copia_cedula_representantes_legales_postulantes, ArchivoCopiaCedulaRepresentantesLegalesPostulantesFondoProduccionLimpiaUploader
  mount_uploader :documento_coste_rol_unico_tributario_postulante, ArchivoDocumentoCosteRolUnicoTributarioPostulanteFondoProduccionLimpiaUploader
  mount_uploader :antecedentes_contrato_anexo_c_postulante, ArchivoAntecedentesContratoAnexoCPostulanteFondoProduccionLimpiaUploader
  mount_uploader :solicitud_cofinanciamiento, SolicitudCofinanciamientoPostulanteFondoProduccionLimpiaUploader

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
  mount_uploader :copia_cedula_representantes_legales_ejecutor, ArchivoCopiaCedulaRepresentantesLegalesEjecutorFondoProduccionLimpiaUploader
  mount_uploader :declaracion_jurada_representante_legal_anexo_a_ejecutor, ArchivoDeclaracionJuradaRepresentanteLegalAnexoAEjecutorFondoProduccionLimpiaUploader
  mount_uploader :declaracion_jurada_representante_legal_anexo_b_ejecutor, ArchivoDeclaracionJuradaRepresentanteLegalAnexoBEjecutorFondoProduccionLimpiaUploader
  mount_uploader :certificado_inicio_actividades_sii_ejecutor, ArchivoCertificadoInicioActividadesSiiEjecutorFondoProduccionLimpiaUploader
  mount_uploader :cedula_identidad_persona_ejecutor, ArchivoCedulaIdentidadPersonaEjecutorFondoProduccionLimpiaUploader
  mount_uploader :declaracion_jurada_simple_anexo_a_ejecutor, ArchivoDeclaracionJuradaSimpleAnexoAEjecutorFondoProduccionLimpiaUploader
  mount_uploader :declaracion_jurada_simple_anexo_b_ejecutor, ArchivoDeclaracionJuradaSimpleAnexoBEjecutorFondoProduccionLimpiaUploader

  mount_uploader :archivo_resolucion, ArchivoResolucionFondoProduccionLimpiaUploader
  mount_uploader :archivo_contrato, ArchivoContratoFondoProduccionLimpiaUploader

  def comunas
    self.flujo.comunas
  end

  def comunas_beauty_tree_selector
    Pais.find(Pais::CHILE).beauty_tree_selector(self.comunas.pluck(:id))
  end

  def get_campos_validaciones
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
    nombre_acuerdo = self.nombre_acuerdo.blank? ? self.flujo.tipo_instrumento_id : self.nombre_acuerdo
    Responsable.__personas_responsables(Rol::REVISOR_TECNICO, nombre_acuerdo).map{|p| [p.user.nombre_completo, p.id]}
  end

   def generar_pdf(revision = nil, objetivo_especificos = nil, postulantes = nil, consultores = nil, empresa = nil, planes = nil, costos = nil, tipo_instrumento = nil, 
                  costos_seguimiento = nil, confinanciamiento_empresa = nil, fondo_produccion_limpia = nil, manifestacion_de_interes = nil, nombre_tipo_instrumento = nil,
                  comentarios = nil)
    
    pdf = Prawn::Document.new
    pdf.font Rails.root.join("app/assets/fonts/Open_Sans/OpenSans-Regular.ttf")

    # HEADER
    pdf.repeat :all do
      pdf.bounding_box [pdf.bounds.left, pdf.bounds.top], width: pdf.bounds.width do
        pdf.image Rails.root.join("app/assets/images/logo-ascc-nuevo.png"), width: 119
        pdf.bounding_box [pdf.bounds.left, pdf.bounds.bottom], width: pdf.bounds.width do
          pdf.font Rails.root.join("app/assets/fonts/Open_Sans/OpenSans-Bold.ttf") do
            pdf.text "FORMULARIO FONDO PRODUCCIÓN LIMPIA", size: 10, color: "003DA6", align: :right
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

    # OPTIMIZACIÓN BD: Consultamos al contribuyente UNA sola vez
    contribuyente = obtiene_contribuyente(fondo_produccion_limpia.institucion_entregables_id)

    # CONTENIDO
    pdf.bounding_box [pdf.bounds.left, pdf.bounds.top - 100], width: pdf.bounds.width do
      proyecto_fpl = "Proyecto: #{fondo_produccion_limpia.codigo_proyecto}"
      proyecto_apl = "APL: #{manifestacion_de_interes.flujo.nombre_instrumento}"
      beneficiario = "Beneficiario: #{contribuyente.razon_social}"
      rut_beneficiario = "Rut: #{contribuyente.rut}-#{contribuyente.dv}"
      
      self.pdf_titulo_formato(pdf, TipoInstrumento::STR_FONDO_DE_PRODUCCION_LIMPIA)

      self.pdf_sub_titulo_formato(pdf, nombre_tipo_instrumento)
      self.pdf_sub_titulo_formato(pdf, proyecto_fpl)
      self.pdf_sub_titulo_formato(pdf, proyecto_apl)
      self.pdf_sub_titulo_formato(pdf, beneficiario)
      self.pdf_sub_titulo_formato(pdf, rut_beneficiario)
      self.pdf_separador(pdf, 20)

      self.pdf_titulo_formato(pdf, I18n.t(:observaciones))
      self.pdf_sub_titulo_formato(pdf, "Observaciones y comentarios anteriores")
      self.pdf_tabla_observaciones(pdf, comentarios)
      self.pdf_separador(pdf, 20)

      self.pdf_titulo_formato(pdf, I18n.t(:admiisibilidad_financiera))
      self.pdf_sub_titulo_formato(pdf, "Formulario Admisibilidad Financiera")
      self.pdf_tabla_cuestionario_financiero(pdf, self.flujo_id)
      self.pdf_separador(pdf, 20)

      self.pdf_titulo_formato(pdf, I18n.t(:admiisibilidad_tecnica))
      self.pdf_sub_titulo_formato(pdf, "Formulario Admisibilidad Técnica")
      self.pdf_tabla_cuestionario_tecnico(pdf, self.flujo_id)
      self.pdf_separador(pdf, 20)

      self.pdf_titulo_formato(pdf, I18n.t(:propuesta_tecnica))
      self.pdf_sub_titulo_formato(pdf, "Objetivos del proyecto")
      self.pdf_tabla_objetivos(pdf, objetivo_especificos)
      self.pdf_separador(pdf, 20)
      self.pdf_sub_titulo_formato(pdf, "Empresas que serán consideradas para la realizacion del diagnóstico sectorial")
      
      if tipo_instrumento == TipoInstrumento::FPL_LINEA_1_1 || tipo_instrumento == TipoInstrumento::FPL_LINEA_5_1 || tipo_instrumento == TipoInstrumento::FPL_EXTRAPRESUPUESTARIO_DIAGNOSTICO  
        self.pdf_tabla_cantidad_empresas(pdf, self.cantidad_micro_empresa, self.cantidad_pequeña_empresa, self.cantidad_mediana_empresa, self.cantidad_grande_empresa)
        self.pdf_separador(pdf, 20)  
        self.pdf_sub_titulo_formato(pdf, "Territorios involucrados en el acuerdo")
        self.pdf_tabla_empresas_A_G(pdf, self.empresas_asociadas_ag, self.empresas_no_asociadas_ag)
        self.pdf_separador(pdf, 20)
      else
        self.pdf_tabla_cantidad_empresas_elementos(pdf, self.cantidad_micro_empresa, self.cantidad_pequeña_empresa, self.cantidad_mediana_empresa, self.cantidad_grande_empresa, self.elementos_micro_empresa, self.elementos_pequena_empresa, self.elementos_mediana_empresa, self.elementos_grande_empresa)
        self.pdf_separador(pdf, 20)
      end
      self.pdf_sub_titulo_formato(pdf, "Duración del proyecto")

      duracion_formateado = if self.duracion.blank?
        'No se ingresa respuesta'
      elsif self.duracion.is_a?(Numeric)
        "#{self.duracion} meses"
      else
        self.duracion.to_s
      end

      self.pdf_contenido_formato(pdf, duracion_formateado)
      self.pdf_separador(pdf, 20)
      
      self.pdf_titulo_formato(pdf, I18n.t(:equipo_tabajo))
      self.pdf_sub_titulo_formato(pdf, "Equipo de Institución Receptora del Cofinanciamiento")
      self.pdf_tabla_equipo_trabajo(pdf, postulantes)
      self.pdf_separador(pdf, 20)
      self.pdf_sub_titulo_formato(pdf, "Equipo de Institución Ejecutora")
      self.pdf_tabla_empresa(pdf, empresa)
      self.pdf_separador(pdf, 20)
      self.pdf_tabla_equipo_trabajo(pdf, consultores)
      self.pdf_separador(pdf, 20)
      self.pdf_sub_titulo_formato(pdf, "Indicar fortalezas del o los consultores")
      self.pdf_contenido_formato(pdf, self.fortalezas_consultores)
      self.pdf_separador(pdf, 20)

      self.pdf_titulo_formato(pdf, I18n.t(:plan_actividades))
      self.pdf_tabla_plan_actividades(pdf, planes)    
      self.pdf_separador(pdf, 20)

      self.pdf_titulo_formato(pdf, I18n.t(:costos))
      self.pdf_sub_titulo_formato(pdf, "Resumen")
      if costos != nil
        self.pdf_tabla_costos(pdf, costos)
      end
      self.pdf_separador(pdf, 20)
      self.pdf_sub_titulo_formato(pdf, "Validación")
      if tipo_instrumento == TipoInstrumento::FPL_LINEA_1_1 || tipo_instrumento == TipoInstrumento::FPL_LINEA_5_1 || tipo_instrumento == TipoInstrumento::FPL_EXTRAPRESUPUESTARIO_DIAGNOSTICO
        if costos != nil
          self.pdf_tabla_validacion(pdf, costos)
        end
      else
        if costos != nil
          self.pdf_tabla_validacion_tipos(pdf, costos, costos_seguimiento, confinanciamiento_empresa)
        end
      end
      self.pdf_separador(pdf, 20)
    end

    # --- INICIO MAGIA DE SUBIDA RAPIDA ---
    pdf_string = pdf.render
    pdf_file_name = "fondo_produccion_limpia_#{self.id}_#{revision}.pdf"
    
    # 1. Guardamos el PDF de memoria al disco temporal del servidor
    ruta_temporal = Rails.root.join("tmp", pdf_file_name)
    File.binwrite(ruta_temporal, pdf_string)

    # 2. Usamos CarrierWave para subirlo directo y sin cuellos de botella
    File.open(ruta_temporal) do |archivo_fisico|
      uploader_class = Class.new(CarrierWave::Uploader::Base) do
        def store_dir
          "accion/public/uploads/fondo_produccion_limpia/pdf"
        end
      end
      
      uploader = uploader_class.new
      uploader.store!(archivo_fisico)
    end

    # 3. Borramos el archivo temporal
    File.delete(ruta_temporal) if File.exist?(ruta_temporal)
    # --- FIN MAGIA DE SUBIDA RAPIDA ---

  rescue StandardError => e
    Rails.logger.error "Error generando PDF: #{e.message}"
    nil
  end

  def generar_admisibilidad_juridica_pdf(revision = nil, flujo_id = nil, tipo_contribuyentes_id = nil, fondo_produccion_limpia = nil, manifestacion_de_interes = nil, tipo_instrumento = nil)
    t_inicio = Time.now
    Rails.logger.info "=== [RADAR PDF 1] INICIANDO GENERACIÓN (t=0s) ==="
    
    pdf = Prawn::Document.new
    pdf.font Rails.root.join("app/assets/fonts/Open_Sans/OpenSans-Regular.ttf")

    # HEADER
    pdf.repeat :all do
      pdf.bounding_box [pdf.bounds.left, pdf.bounds.top], width: pdf.bounds.width do
        pdf.image Rails.root.join("app/assets/images/logo-ascc-nuevo.png"), width: 119
        pdf.bounding_box [pdf.bounds.left, pdf.bounds.bottom], width: pdf.bounds.width do
          pdf.font Rails.root.join("app/assets/fonts/Open_Sans/OpenSans-Bold.ttf") do
            pdf.text "ADMISIBILIDAD DE LA PROPUESTA", size: 10, color: "003DA6", align: :right
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

    Rails.logger.info "=== [RADAR PDF 2] OBTENIENDO CONTRIBUYENTE a los (#{Time.now - t_inicio}s) ==="
    contribuyente = obtiene_contribuyente(fondo_produccion_limpia.institucion_entregables_id)

    pdf.bounding_box [pdf.bounds.left, pdf.bounds.top - 100], width: pdf.bounds.width do
      proyecto_fpl = "Proyecto: #{fondo_produccion_limpia.codigo_proyecto}"
      proyecto_apl = "APL: #{manifestacion_de_interes.flujo.nombre_instrumento}"
      beneficiario = "Beneficiario: #{contribuyente.razon_social}"
      rut_beneficiario = "Rut: #{contribuyente.rut}-#{contribuyente.dv}"
      
      self.pdf_titulo_formato(pdf, TipoInstrumento::STR_FONDO_DE_PRODUCCION_LIMPIA)
      self.pdf_sub_titulo_formato(pdf, tipo_instrumento)
      self.pdf_sub_titulo_formato(pdf, proyecto_fpl)
      self.pdf_sub_titulo_formato(pdf, proyecto_apl)
      self.pdf_sub_titulo_formato(pdf, beneficiario)
      self.pdf_sub_titulo_formato(pdf, rut_beneficiario)
      self.pdf_separador(pdf, 20)

      self.pdf_titulo_formato(pdf, I18n.t(:documentacion_legal))

      Rails.logger.info "=== [RADAR PDF 3] GENERANDO TABLA 1 a los (#{Time.now - t_inicio}s) ==="
      self.pdf_sub_titulo_formato(pdf, "A) Postulante")
      self.pdf_tabla_cuestionario(pdf, flujo_id, tipo_contribuyentes_id, 1)
      self.pdf_separador(pdf, 20)

      Rails.logger.info "=== [RADAR PDF 4] GENERANDO TABLA 2 a los (#{Time.now - t_inicio}s) ==="
      self.pdf_sub_titulo_formato(pdf, "B) Receptor cofinanciamiento")
      self.pdf_tabla_cuestionario(pdf, flujo_id, tipo_contribuyentes_id, 2)
      self.pdf_separador(pdf, 20)

      Rails.logger.info "=== [RADAR PDF 5] GENERANDO TABLA EJECUTOR a los (#{Time.now - t_inicio}s) ==="
      self.pdf_sub_titulo_formato(pdf, "C) Ejecutor")
      self.pdf_tabla_cuestionario_ejecutor(pdf, flujo_id)
      self.pdf_separador(pdf, 20)
    end
    
     Rails.logger.info "=== [RADAR PDF 6] RENDERIZANDO PDF a los (#{Time.now - t_inicio}s) ==="
    pdf_string = pdf.render

    pdf_file_name = "admisibilidad_juridica_#{self.id}_#{revision}.pdf"

    Rails.logger.info "=== [RADAR PDF 7] SUBIENDO A AZURE VIA CARRIERWAVE a los (#{Time.now - t_inicio}s) ==="
    
    # 1. Guardamos el PDF de memoria al disco temporal del servidor
    ruta_temporal = Rails.root.join("tmp", pdf_file_name)
    File.binwrite(ruta_temporal, pdf_string)

    # 2. Usamos nuestro "Caballo de Troya" para subirlo en milisegundos
    File.open(ruta_temporal) do |archivo_fisico|
      uploader_class = Class.new(CarrierWave::Uploader::Base) do
        def store_dir
          "accion/public/uploads/fondo_produccion_limpia/admisibilidad"
        end
      end
      
      uploader = uploader_class.new
      uploader.store!(archivo_fisico)
    end

    # 3. Borramos el archivo temporal para mantener el servidor limpio
    File.delete(ruta_temporal) if File.exist?(ruta_temporal)

    Rails.logger.info "=== [RADAR PDF 8] SUBIDA EXITOSA a los (#{Time.now - t_inicio}s) ==="

  rescue StandardError => e
    tiempo_total = Time.now - t_inicio
    Rails.logger.error "=== [RADAR PDF ERROR] FALLA a los #{tiempo_total}s: #{e.class} - #{e.message} ==="
    nil
  end

  def generar_formulario_fpl(objetivo_especificos = nil, postulantes = nil, consultores = nil, empresa = nil, planes = nil, costos = nil, tipo_instrumento = nil, 
                  costos_seguimiento = nil, confinanciamiento_empresa = nil, fondo_produccion_limpia = nil, manifestacion_de_interes = nil, nombre_tipo_instrumento = nil,
                  comentarios = nil, adheridas = nil, auditor = nil)
    require 'stringio'

    pdf = Prawn::Document.new
    pdf.font Rails.root.join("app/assets/fonts/Open_Sans/OpenSans-Regular.ttf")

    # HEADER
    pdf.repeat :all do
      pdf.bounding_box [pdf.bounds.left, pdf.bounds.top], width: pdf.bounds.width do
        pdf.image Rails.root.join("app/assets/images/logo-ascc-nuevo.png"), width: 119
        pdf.bounding_box [pdf.bounds.left, pdf.bounds.bottom], width: pdf.bounds.width do
          pdf.font Rails.root.join("app/assets/fonts/Open_Sans/OpenSans-Bold.ttf") do
            pdf.text "FORMULARIO FONDO PRODUCCIÓN LIMPIA", size: 10, color: "003DA6", align: :right
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
      proyecto_fpl = "Proyecto: #{fondo_produccion_limpia.codigo_proyecto}"
      proyecto_apl = "APL: #{manifestacion_de_interes.flujo.nombre_instrumento}"
      beneficiario = "Beneficiario: #{obtiene_contribuyente(fondo_produccion_limpia.institucion_entregables_id).razon_social}"
      rut_beneficiario = "Rut: #{obtiene_contribuyente(fondo_produccion_limpia.institucion_entregables_id).rut}-#{obtiene_contribuyente(fondo_produccion_limpia.institucion_entregables_id).dv}"
      
      self.pdf_titulo_formato(pdf, TipoInstrumento::STR_FONDO_DE_PRODUCCION_LIMPIA)

      self.pdf_sub_titulo_formato(pdf, nombre_tipo_instrumento)
      self.pdf_sub_titulo_formato(pdf, proyecto_fpl)
      self.pdf_sub_titulo_formato(pdf, proyecto_apl)
      self.pdf_sub_titulo_formato(pdf, beneficiario)
      self.pdf_sub_titulo_formato(pdf, rut_beneficiario)
      self.pdf_separador(pdf, 20)

      self.pdf_titulo_formato(pdf, I18n.t(:propuesta_tecnica))
      self.pdf_sub_titulo_formato(pdf, "Objetivos del proyecto")
      self.pdf_separador(pdf, 20)
      self.pdf_sub_titulo_formato(pdf, "Objetivo general")

      if [
        TipoInstrumento::FPL_LINEA_1_1,
        TipoInstrumento::FPL_LINEA_5_1,
        TipoInstrumento::FPL_EXTRAPRESUPUESTARIO_DIAGNOSTICO
      ].include?(tipo_instrumento)

        pdf_texto_con_link(
          pdf,
          "Realizar el Diagnóstico General de un grupo de empresas o un sector empresarial, que permitirá definir acciones y metas específicas que contribuyan a su desarrollo sustentable.\n\n" \
          "Dicho diagnóstico contendrá:\n " \
          "- Motivación, oportunidad y fundamento del APL propuesto.\n " \
          "- Objetivos del APL propuesto.\n " \
          "- Caracterización económica, ambiental y social del sector económico y/o territorio en que operan las empresas.\n " \
          "- Identificación de los problemas y/o oportunidades a ser abordados.\n " \
          "- Identificación de potenciales suscriptores y grupos de interés.\n " \
          "- Metodologías utilizadas en la elaboración del Diagnóstico General.\n " \
          "- Propuesta de contenidos para el APL.\n\n " \
          "Para la elaboración se utilizará la Guía para la Elaboración de un Diagnóstico ",
          link: "https://drive.google.com/file/d/1D1-2IcCBBT_4EuCIE-38jmkYrrroIhPC/view",
          link_text: "Descargar Guía Nº1"
        )


      elsif [
        TipoInstrumento::FPL_LINEA_1_2_1,
        TipoInstrumento::FPL_LINEA_1_2_2,
        TipoInstrumento::FPL_EXTRAPRESUPUESTARIO_SEGUIMIENTO,
        TipoInstrumento::FPL_EXTRAPRESUPUESTARIO_SEGUIMIENTO_2
      ].include?(tipo_instrumento)

        pdf_contenido_formato(
          pdf,
          "Apoyar a sectores productivos del país a la formación de Cultura de Producción Limpia a través del desarrollo de estrategias, programas o proyectos de comunicación hacia empresas, trabajadores y comunidad."
        )

      elsif [
        TipoInstrumento::FPL_LINEA_1_3,
        TipoInstrumento::FPL_EXTRAPRESUPUESTARIO_EVALUACION
      ].include?(tipo_instrumento)

        pdf_texto_con_link(
          pdf,
          "Etapa de evaluación final de cumplimiento es aquella en la cual se verifica el estado de cumplimiento de la totalidad de las acciones establecidas en el APL. " \
          "La etapa se debe realizar conforme con la",
          link: "https://ascc.cl/pagina/guias_apl",
          link_text: "Guía técnica"
        )
      end

      self.pdf_separador(pdf, 20)
      self.pdf_sub_titulo_formato(pdf, "Objetivos especificos")
      self.pdf_tabla_objetivos(pdf, objetivo_especificos)
      self.pdf_separador(pdf, 20)
      
      if tipo_instrumento == TipoInstrumento::FPL_LINEA_1_1 || tipo_instrumento == TipoInstrumento::FPL_LINEA_5_1 || tipo_instrumento == TipoInstrumento::FPL_EXTRAPRESUPUESTARIO_DIAGNOSTICO  
        self.pdf_sub_titulo_formato(pdf, "Empresas que serán consideradas para la realizacion del diagnóstico sectorial")
        self.pdf_tabla_cantidad_empresas(pdf, self.cantidad_micro_empresa, self.cantidad_pequeña_empresa, self.cantidad_mediana_empresa, self.cantidad_grande_empresa)
        self.pdf_separador(pdf, 20)  
        self.pdf_sub_titulo_formato(pdf, "Territorios involucrados en el acuerdo")
        self.pdf_tabla_empresas_A_G(pdf, self.empresas_asociadas_ag, self.empresas_no_asociadas_ag)
        self.pdf_separador(pdf, 20)
      elsif tipo_instrumento == TipoInstrumento::FPL_LINEA_1_2_1 || tipo_instrumento == TipoInstrumento::FPL_EXTRAPRESUPUESTARIO_SEGUIMIENTO  
        #implementar tabla elementos 
        self.pdf_sub_titulo_formato(pdf, "Empresas que serán consideradas para la realizacion del diagnóstico sectorial") 
        self.pdf_tabla_cantidad_empresas_elementos(pdf, self.cantidad_micro_empresa, self.cantidad_pequeña_empresa, self.cantidad_mediana_empresa, self.cantidad_grande_empresa, self.elementos_micro_empresa, self.elementos_pequena_empresa, self.elementos_mediana_empresa, self.elementos_grande_empresa)
        self.pdf_separador(pdf, 20)
      elsif tipo_instrumento == TipoInstrumento::FPL_LINEA_1_2_2 || tipo_instrumento == TipoInstrumento::FPL_EXTRAPRESUPUESTARIO_SEGUIMIENTO_2 || tipo_instrumento == TipoInstrumento::FPL_LINEA_1_3 || tipo_instrumento == TipoInstrumento::FPL_EXTRAPRESUPUESTARIO_EVALUACION 
        self.pdf_sub_titulo_formato(pdf, "Empresas Adheridas")
        self.pdf_tabla_empresas_adheridas(pdf, adheridas)
        self.pdf_sub_titulo_formato(pdf, "Resumen de Empresas Adheridas")
        self.pdf_tabla_cantidad_empresas_elementos(pdf, self.cantidad_micro_empresa, self.cantidad_pequeña_empresa, self.cantidad_mediana_empresa, self.cantidad_grande_empresa, self.elementos_micro_empresa, self.elementos_pequena_empresa, self.elementos_mediana_empresa, self.elementos_grande_empresa)
        self.pdf_separador(pdf, 20)
      end
      self.pdf_sub_titulo_formato(pdf, "Duración del proyecto")

      duracion_formateado = if self.duracion.blank?
        'No se ingresa respuesta'
      elsif self.duracion.is_a?(Numeric)
        "#{self.duracion} meses"
      else
        self.duracion.to_s
      end

      self.pdf_contenido_formato(pdf, duracion_formateado)
      self.pdf_separador(pdf, 20)
      # Añade más contenido según sea necesario
      self.pdf_titulo_formato(pdf, I18n.t(:equipo_tabajo))
      self.pdf_sub_titulo_formato(pdf, "Equipo de Institución Receptora del Cofinanciamiento")
      self.pdf_tabla_equipo_trabajo(pdf, postulantes)
      self.pdf_separador(pdf, 20)
      self.pdf_sub_titulo_formato(pdf, "Equipo de Institución Ejecutora")
      if empresa.count != 0
        self.pdf_tabla_empresa(pdf, empresa)
      end
      self.pdf_separador(pdf, 20)
      self.pdf_tabla_equipo_trabajo(pdf, consultores)
      self.pdf_separador(pdf, 20)

      if tipo_instrumento == TipoInstrumento::FPL_LINEA_1_3 || tipo_instrumento == TipoInstrumento::FPL_EXTRAPRESUPUESTARIO_EVALUACION 
        self.pdf_sub_titulo_formato(pdf, "Auditor")
        self.pdf_tabla_auditor(pdf, auditor)
        self.pdf_separador(pdf, 20)
      end

      self.pdf_sub_titulo_formato(pdf, "Indicar fortalezas del o los consultores")
      self.pdf_contenido_formato(pdf, self.fortalezas_consultores)
      self.pdf_separador(pdf, 20)

      self.pdf_titulo_formato(pdf, I18n.t(:plan_actividades))
      self.pdf_tabla_plan_actividades(pdf, planes)  
      self.pdf_separador(pdf, 20)

      self.pdf_titulo_formato(pdf, I18n.t(:costos))
      self.pdf_sub_titulo_formato(pdf, "Resumen")
      if costos != nil
        self.pdf_tabla_costos(pdf, costos)
      end
      self.pdf_separador(pdf, 20)
      self.pdf_sub_titulo_formato(pdf, "Validación")
      if tipo_instrumento == TipoInstrumento::FPL_LINEA_1_1 || tipo_instrumento == TipoInstrumento::FPL_LINEA_5_1 || tipo_instrumento == TipoInstrumento::FPL_EXTRAPRESUPUESTARIO_DIAGNOSTICO
        if costos != nil
          self.pdf_tabla_validacion(pdf, costos)
        end
      else
        if costos != nil
          self.pdf_tabla_validacion_tipos(pdf, costos, costos_seguimiento, confinanciamiento_empresa)
        end
      end
      self.pdf_separador(pdf, 20)
      self.pdf_sub_titulo_formato(pdf, "Detalle Costos Por Actividad")
      self.pdf_tabla_detalle_costos_x_actividad(pdf, fondo_produccion_limpia.flujo_id)
      self.pdf_separador(pdf, 20)
    end

    # 1. Generamos el binario del PDF en memoria (Toma 1 segundo)
    pdf_binario = pdf.render
    
    pdf_file_name = "formulario_fpl_#{self.id}.pdf"
    blob_key = "accion/public/uploads/fondo_produccion_limpia/formulario_fpl/#{pdf_file_name}"

    # 2. MAGIA: Enviar a Azure en un Hilo en Segundo Plano (Background Thread)
    # Así el usuario NO espera a que Azure responda.
    Thread.new do
      begin
        # Le damos unos segundos al servidor para que respire antes de subirlo
        sleep(2) 
        AzureBlobStorage.upload(blob_key, pdf_binario, content_type: "application/pdf")
        Rails.logger.info "✅ PDF subido exitosamente a Azure en segundo plano: #{blob_key}"
      rescue StandardError => e
        Rails.logger.error "❌ Error subiendo PDF a Azure: #{e.message}"
      end
    end
    
    # 3. Guardado local (solo para desarrollo)
    if Rails.env.development?
      require 'fileutils'
      ruta_dir = Rails.root.join('public', 'uploads', 'fondo_produccion_limpia', 'formulario_fpl')
      FileUtils.mkdir_p(ruta_dir) unless File.directory?(ruta_dir)
      File.binwrite(ruta_dir.join(pdf_file_name), pdf_binario)
    end

    # 4. Devolvemos el PDF inmediatamente al controlador
    return pdf_binario
  end

  # Método para crear una tabla con cuatro campos en el PDF
  def pdf_tabla_objetivos(pdf, objetivo_especificos)

    begin
      # Encabezados de la tabla
      headers = ["N°", "Descripción", "Metodología", "Resultado", "Indicadores"]

      # Datos de la tabla
      data = [headers] # Comienza con los encabezados

      # Agregar cada objetivo específico a la tabla
      objetivo_especificos.each do |objetivo|
        fila = [
          objetivo[:correlativo].to_s,
          objetivo[:descripcion].to_s,
          objetivo[:metodologia].to_s,
          objetivo[:resultado].to_s,
          objetivo[:indicadores].to_s
        ]
        data << fila
      end

      pdf.table(data, header: true, column_widths: [40, 120, 120, 120, 120], cell_style: { size: 9, padding: [4, 8] }) do |table|
        # Sin estilos adicionales por ahora
      end

      pdf.move_down 10 # Espacio después de la tabla

    rescue => e
      Rails.logger.error "Error creando la tabla en el PDF: #{e.message}"
      puts "Error creando la tabla en el PDF: #{e.message}"
    end
  end

  def pdf_tabla_cantidad_empresas(pdf, campo1, campo2, campo3, campo4)
    begin
      # Crear la tabla en el PDF
      data = [
        ["Micro", "Pequeña", "Mediana", "Grande"], # Encabezados de la tabla
        [campo1.to_s, campo2.to_s, campo3.to_s, campo4.to_s] # Datos de los campos
      ]

      pdf.table(data, header: true, column_widths: [130, 130, 130, 130], cell_style: { size: 9, padding: [4, 8] }) do |table|
        # Sin estilos adicionales por ahora
      end

      pdf.move_down 10 # Espacio después de la tabla

    rescue => e
      Rails.logger.error "Error creando la tabla en el PDF: #{e.message}"
      puts "Error creando la tabla en el PDF: #{e.message}"
    end
  end

  def pdf_tabla_cantidad_empresas_elementos(pdf, campo_empresas1, campo_empresas2, campo_empresas3, campo_empresas4, campo_elementos1, campo_elementos2, campo_elementos3, campo_elementos4)
    begin
      # Crear la tabla en el PDF
      data = [
        ["", "Micro", "Pequeña", "Mediana", "Grande"], # Encabezados de la tabla
        ["Empresas Totales a Adherir", campo_empresas1.to_s, campo_empresas2.to_s, campo_empresas3.to_s, campo_empresas4.to_s], # Datos de los campos
        ["Elementos Totales a Adherir", campo_elementos1.to_s, campo_elementos2.to_s, campo_elementos3.to_s, campo_elementos4.to_s] # Datos de los campos
      ]
    
      pdf.table(data, header: true, column_widths: [120, 100, 100, 100, 100], cell_style: { size: 9, padding: [4, 8] }) do |table|
        # Sin estilos adicionales por ahora
      end

      pdf.move_down 10 # Espacio después de la tabla
    rescue => e
      Rails.logger.error "Error creando la tabla en el PDF: #{e.message}"
      puts "Error creando la tabla en el PDF: #{e.message}"
    end
  end

  def pdf_tabla_empresas_adheridas(pdf, empresas_adheridas)
    begin
      # Encabezados de la tabla
      headers = ["Nombre", "RUT", "Establecimiento", "Comuna", "Tamaño Empresa"]

      # Datos de la tabla
      data = [headers] # Comienza con los encabezados

      # Agregar cada objetivo específico a la tabla
      empresas_adheridas.each do |adheridas|
        if adheridas[:seleccionada] == true
          fila = [ 
            adheridas[:nombre_institucion],
            adheridas[:rut_institucion],
            adheridas[:nombre_elemento],
            adheridas[:comuna_instalacion],
            adheridas[:tamano_contribuyente_nombre]
          ]
          data << fila
        end
      end
      pdf.table(data, header: true, column_widths: [120, 100, 100, 100, 100], cell_style: { size: 9, padding: [4, 8] }) do |table|
        # Sin estilos adicionales por ahora
      end

      pdf.move_down 10 # Espacio después de la tabla
    rescue => e
      Rails.logger.error "Error creando la tabla en el PDF: #{e.message}"
      puts "Error creando la tabla en el PDF: #{e.message}"
    end
  end

  def pdf_tabla_empresas_A_G(pdf, campo1, campo2)
    begin
      # Crear la tabla en el PDF
      data = [
        ["Empresas socias de la A.G. potenciales suscriptoras del APL", "Empresas potenciales no socias de la A.G."], # Encabezados de la tabla
        [campo1.to_s, campo2.to_s] # Datos de los campos
      ]

      pdf.table(data, header: true, column_widths: [260, 260], cell_style: { size: 9, padding: [4, 8] }) do |table|
        # Sin estilos adicionales por ahora
      end

      pdf.move_down 10 # Espacio después de la tabla

    rescue => e
      Rails.logger.error "Error creando la tabla en el PDF: #{e.message}"
      puts "Error creando la tabla en el PDF: #{e.message}"
    end
  end

  def pdf_titulo_formato pdf, titulo
    pdf.font Rails.root.join("app/assets/fonts/Open_Sans/OpenSans-Bold.ttf") do
      pdf.text titulo, size: 11
    end
    pdf.text "··········<color rgb='003DA6'>··········</color>", size: 20, color: 'EB0029', inline_format: true, leading: 0
    pdf.move_down 5
  end

  def pdf_sub_titulo_formato pdf, subtitulo
    pdf.font Rails.root.join("app/assets/fonts/Open_Sans/OpenSans-Bold.ttf") do
      #pdf.text titulo, size: 11
      pdf.text subtitulo, size: 10
    end

    #pdf.text "··········<color rgb='003DA6'>··········</color>", size: 20, color: 'EB0029', inline_format: true, leading: 0
    pdf.move_down 5
  end

  def pdf_contenido_formato pdf, contenido
    pdf.font Rails.root.join("app/assets/fonts/Open_Sans/OpenSans-Bold.ttf") do
    #  pdf.text titulo, size: 11
    end
    pdf.text contenido.to_s, size: 9
    pdf.move_down 5
  end

  

  def pdf_texto_con_link(pdf, texto, link: nil, link_text: "ver")
    if link.present?
      pdf.formatted_text [
        { text: "#{texto} ", size: 9 },
        { text: link_text, link: link, styles: [:underline], color: '0000FF', size: 9  }
      ]
    else
      pdf.text texto, size: 9 
    end

    pdf.move_down 8
  end


  def pdf_tabla_equipo_trabajo(pdf, equipos)

    begin
      # Encabezados de la tabla
      headers = ["Nombre Completo", "RUT", "Teléfono", "E-mail", "Profesión", "Funciones", "Valor HH"]

      # Datos de la tabla
      data = [headers] # Comienza con los encabezados

      # Agregar cada objetivo específico a la tabla
      equipos.each do |equipo|
        fila = [
          equipo.user.nombre_completo.to_s,
          equipo.user.rut.to_s,
          equipo.user.telefono.to_s,
          equipo.user.email.to_s,
          equipo.profesion.to_s,
          equipo.funciones_proyecto.to_s,
          sprintf("$%<valor_hh>.0f", valor_hh: equipo.valor_hh).gsub(/(\d)(?=(\d\d\d)+(?!\d))/, "\\1.")
        ]
        data << fila
      end

      pdf.table(data, header: true, column_widths: [75, 75, 75, 75, 75, 75, 75], cell_style: { size: 9, padding: [4, 8] }) do |table|
        # Sin estilos adicionales por ahora
      end

      pdf.move_down 10 # Espacio después de la tabla

    rescue => e
      #c
      Rails.logger.error "Error creando la tabla en el PDF: #{e.message}"
      puts "Error creando la tabla en el PDF: #{e.message}"
    end
  end

  def pdf_tabla_auditor(pdf, auditores)
    begin
      # Encabezados de la tabla
      headers = ["Nombre Completo", "RUT", "Teléfono", "E-mail", "Profesión", "Valor HH"]

      # Datos de la tabla
      data = [headers] # Comienza con los encabezados

      # Agregar cada objetivo específico a la tabla
      auditores.each do |item|
        auditor = item[:auditor]
        valor_hh  = item[:valor_hh]&.first.to_f

        fila = [
          "#{auditor.nombre} #{auditor.apellido}".to_s,
          auditor.rut.to_s,
          auditor.telefono.to_s,
          auditor.email.to_s,
          auditor.profesion.to_s,
          sprintf("$%<valor_hh>.0f", valor_hh: valor_hh).gsub(/(\d)(?=(\d{3})+(?!\d))/, "\\1.")
        ]
        data << fila
      end

      pdf.table(data, header: true, column_widths: [88, 87, 87, 88, 88, 87], cell_style: { size: 9, padding: [4, 8] }) do |table|
        # Sin estilos adicionales por ahora
      end

      pdf.move_down 10 # Espacio después de la tabla

    rescue => e
      #c
      Rails.logger.error "Error creando la tabla en el PDF: #{e.message}"
      puts "Error creando la tabla en el PDF: #{e.message}"
    end
  end

  def pdf_tabla_empresa(pdf, empresas)

    begin
      # Encabezados de la tabla
      headers = ["Razón Social", "RUT"]

      # Datos de la tabla
      data = [headers] # Comienza con los encabezados

      # Agregar cada objetivo específico a la tabla
      empresas.each do |empresa|

        fila = [
          empresa.contribuyente.razon_social.to_s,
          empresa.contribuyente.rut.to_s
        ]
        data << fila
      end

      pdf.table(data, header: true, column_widths: [260, 260], cell_style: { size: 9, padding: [4, 8] }) do |table|
        # Sin estilos adicionales por ahora
      end

      pdf.move_down 10 # Espacio después de la tabla

    rescue => e
      Rails.logger.error "Error creando la tabla en el PDF: #{e.message}"
      puts "Error creando la tabla en el PDF: #{e.message}"
    end
  end

  def pdf_tabla_plan_actividades(pdf, planes)
    begin
      # Encabezados de la tabla
      headers = ["Objetivo Descripción", "Actividades", "Periodos", "Recursos Humanos Propios", "Recursos Humanos Externos", "Gastos de Operación", "Gastos de Administración"]
  
      # Datos de la tabla
      data = [headers] # Comienza con los encabezados
  
      # Agregar cada objetivo específico a la tabla
      duracion_total = self.duracion.to_i
      planes.each do |plan|
        # Verifica si duracion_total y plan.duracion son válidos
        #meses = plan.duracion.to_s.split(',').map(&:to_i) # Asegúrate de convertir a entero
   
        meses = plan.duracion.to_s.split(',').map(&:strip).join(' - ')
        fila = [
          "#{plan.objetivo_correlativo} - #{plan.objetivo_descripcion}",
          "#{plan.correlativo} - #{plan.nombre}",
          meses,
          sprintf("$%<valor_hh_tipo_3>.0f", valor_hh_tipo_3: plan.valor_hh_tipo_3).gsub(/(\d)(?=(\d\d\d)+(?!\d))/, "\\1."),
          sprintf("$%<valor_hh_tipos_1_2>.0f", valor_hh_tipos_1_2: plan.valor_hh_tipos_1_2).gsub(/(\d)(?=(\d\d\d)+(?!\d))/, "\\1."),
          sprintf("$%<total_gastos_tipo_1>.0f", total_gastos_tipo_1: plan.total_gastos_tipo_1).gsub(/(\d)(?=(\d\d\d)+(?!\d))/, "\\1."),
          sprintf("$%<total_gastos_tipo_2>.0f", total_gastos_tipo_2: plan.total_gastos_tipo_2).gsub(/(\d)(?=(\d\d\d)+(?!\d))/, "\\1.")
        ]
        data << fila
      end
  
      # Generar la tabla en el PDF
      pdf.table(data, header: true, column_widths: [120,120,60,60,60,60,60], cell_style: { size: 9, padding: [4, 8] }) do |table|
        # Opcional: Configura estilos adicionales si es necesario
      end

      pdf.move_down 10 # Espacio después de la tabla
  
    rescue => e
      Rails.logger.error "Error creando la tabla en el PDF: #{e.message}"
      puts "Error creando la tabla en el PDF: #{e.message}"
    end
  end
  

  def pdf_tabla_costos(pdf, costos)
    begin
      # Encabezados de la tabla principal

      # Datos de la tabla principal

      porcentaje = (costos.costo_total_de_la_propuesta.to_f / costos.costo_total_de_la_propuesta) * 100
      porcentaje_costo_total_de_la_propuesta = "%.2f %%" % porcentaje

      porcentaje2 = (costos.aporte_propio_valorado.to_f / costos.costo_total_de_la_propuesta) * 100
      porcentaje_aporte_propio_valorado = "%.2f %%" % porcentaje2

      porcentaje3 = (costos.aporte_propio_liquido.to_f / costos.costo_total_de_la_propuesta) * 100
      porcentaje_aporte_propio_liquido = "%.2f %%" % porcentaje3

      porcentaje4 = ((costos.aporte_propio_liquido.to_f + costos.aporte_propio_valorado.to_f) / costos.costo_total_de_la_propuesta) * 100
      porcentaje_aporte_propio_total = "%.2f %%" % porcentaje4

      porcentaje5= (costos.aporte_solicitado_al_fondo.to_f / costos.costo_total_de_la_propuesta) * 100
      porcentaje_aporte_solicitado_al_fondo = "%.2f %%" % porcentaje5

      data_principal = [
        ["Estructura de costos", "$", "% (del costo total de la propuesta)"],
        ["Costo total de la propuesta", sprintf("$%<costo>.0f", costo: costos.costo_total_de_la_propuesta).gsub(/(\d)(?=(\d\d\d)+(?!\d))/, "\\1."), porcentaje_costo_total_de_la_propuesta],
        ["Aporte Propio Valorado", sprintf("$%<costo>.0f", costo: costos.aporte_propio_valorado).gsub(/(\d)(?=(\d\d\d)+(?!\d))/, "\\1."), porcentaje_aporte_propio_valorado],
        ["Aporte Propio Líquido", sprintf("$%<costo>.0f", costo: costos.aporte_propio_liquido).gsub(/(\d)(?=(\d\d\d)+(?!\d))/, "\\1."), porcentaje_aporte_propio_liquido],
        ["Aporte Propio Total", sprintf("$%<costo>.0f", costo: (costos.aporte_propio_liquido.to_f + costos.aporte_propio_valorado.to_f)).gsub(/(\d)(?=(\d\d\d)+(?!\d))/, "\\1."), porcentaje_aporte_propio_total],
        ["Aporte solicitado Fondo PL", sprintf("$%<costo>.0f", costo: costos.aporte_solicitado_al_fondo).gsub(/(\d)(?=(\d\d\d)+(?!\d))/, "\\1."), porcentaje_aporte_solicitado_al_fondo]
      ]

      # Encabezados de la segunda tabla (Estructura de costos por partida)

      #data_partida = [headers_partida] # Comienza con los encabezados

      porcentaje6 = (costos.recursos_humanos_propios.to_f / costos.costo_total_de_la_propuesta) * 100
      porcentaje_recursos_humanos_propios = "%.2f %%" % porcentaje6

      porcentaje7 = (costos.recursos_humanos_externos.to_f / costos.costo_total_de_la_propuesta) * 100
      porcentaje_recursos_humanos_externos = "%.2f %%" % porcentaje7

      porcentaje8 = (costos.gastos_operacion.to_f / costos.costo_total_de_la_propuesta) * 100
      porcentaje_gastos_operacion = "%.2f %%" % porcentaje8

      porcentaje9 = (costos.gastos_administrativos.to_f / costos.costo_total_de_la_propuesta) * 100
      porcentaje_gastos_administrativos = "%.2f %%" % porcentaje9


      # Datos de la segunda tabla (Estructura de costos por partida)
      data_partida = [
        ["Estructura de costos por partida", "$", "% (del costo total de la propuesta)"],
        ["Recursos Humanos Propios", sprintf("$%<costo>.0f", costo: costos.recursos_humanos_propios).gsub(/(\d)(?=(\d\d\d)+(?!\d))/, "\\1."), porcentaje_recursos_humanos_propios],
        ["Recursos Humanos Externos", sprintf("$%<costo>.0f", costo: costos.recursos_humanos_externos).gsub(/(\d)(?=(\d\d\d)+(?!\d))/, "\\1."), porcentaje_recursos_humanos_externos],
        ["Gastos de Operación", sprintf("$%<costo>.0f", costo: costos.gastos_operacion).gsub(/(\d)(?=(\d\d\d)+(?!\d))/, "\\1."), porcentaje_gastos_operacion],
        ["Gastos de Administración", sprintf("$%<costo>.0f", costo: costos.gastos_administrativos).gsub(/(\d)(?=(\d\d\d)+(?!\d))/, "\\1."), porcentaje_gastos_administrativos]
      ]
      # Encabezados de la tercera tabla (Aporte beneficiario por partida)
      #headers_aporte = ["Aporte beneficiario por partida", "$ Aporte Valorado", "% Aporte Valorado", "$ Aporte Líquido", "% Aporte Líquido"]

      #data_aporte = [headers_aporte] # Comienza con los encabezados



      porcentaje10 = (costos.aporte_propio_valorado_rrhh_propio.to_f / costos.aporte_propio_valorado) * 100
      porcentaje_aporte_propio_valorado_rrhh_propio = "%.2f %%" % porcentaje10

      porcentaje11 = (costos.aporte_propio_liquido_rrhh_propio.to_f / costos.aporte_propio_liquido) * 100
      porcentaje_aporte_propio_liquido_rrhh_propio = "%.2f %%" % porcentaje11

      porcentaje12 = (costos.aporte_propio_valorado_rrhh_externo.to_f / costos.aporte_propio_valorado) * 100
      porcentaje_aporte_propio_valorado_rrhh_externo = "%.2f %%" % porcentaje12

      porcentaje13 = (costos.aporte_propio_liquido_rrhh_externo.to_f / costos.aporte_propio_liquido) * 100
      porcentaje_aporte_propio_liquido_rrhh_externo = "%.2f %%" % porcentaje13

      porcentaje14 = (costos.aporte_propio_valorado_gasto_operacion.to_f / costos.aporte_propio_valorado) * 100
      porcentaje_aporte_propio_valorado_gasto_operacion = "%.2f %%" % porcentaje14

      porcentaje15 = (costos.aporte_propio_liquido_gasto_operacion.to_f / costos.aporte_propio_liquido) * 100
      porcentaje_aporte_propio_liquido_gasto_operacion = "%.2f %%" % porcentaje15

      porcentaje16 = (costos.aporte_propio_valorado_gasto_administracion.to_f / costos.aporte_propio_valorado) * 100
      porcentaje_aporte_propio_valorado_gasto_administracion = "%.2f %%" % porcentaje16

      porcentaje17 = (costos.aporte_propio_liquido_gasto_administracion.to_f / costos.aporte_propio_liquido) * 100
      porcentaje_aporte_propio_liquido_gasto_administracion = "%.2f %%" % porcentaje17

      # Datos de la tercera tabla (Aporte beneficiario por partida)
      data_aporte = [
        ["Aporte beneficiario por partida", "$ Aporte Valorado", "% Aporte Valorado", "$ Aporte Líquido", "% Aporte Líquido"],
        ["Recursos Humanos Propios", sprintf("$%<costo>.0f", costo: costos.aporte_propio_valorado_rrhh_propio).gsub(/(\d)(?=(\d\d\d)+(?!\d))/, "\\1."), porcentaje_aporte_propio_valorado_rrhh_propio, sprintf("$%<costo>.0f", costo: costos.aporte_propio_liquido_rrhh_propio).gsub(/(\d)(?=(\d\d\d)+(?!\d))/, "\\1."), porcentaje_aporte_propio_liquido_rrhh_propio],
        ["Recursos Humanos Externos", sprintf("$%<costo>.0f", costo: costos.aporte_propio_valorado_rrhh_externo).gsub(/(\d)(?=(\d\d\d)+(?!\d))/, "\\1."), porcentaje_aporte_propio_valorado_rrhh_externo, sprintf("$%<costo>.0f", costo: costos.aporte_propio_liquido_rrhh_externo).gsub(/(\d)(?=(\d\d\d)+(?!\d))/, "\\1."), porcentaje_aporte_propio_liquido_rrhh_externo],
        ["Gastos de Operación", sprintf("$%<costo>.0f", costo: costos.aporte_propio_valorado_gasto_operacion).gsub(/(\d)(?=(\d\d\d)+(?!\d))/, "\\1."), porcentaje_aporte_propio_valorado_gasto_operacion, sprintf("$%<costo>.0f", costo: costos.aporte_propio_liquido_gasto_operacion).gsub(/(\d)(?=(\d\d\d)+(?!\d))/, "\\1."), porcentaje_aporte_propio_liquido_gasto_operacion],
        ["Gastos de Administración", sprintf("$%<costo>.0f", costo: costos.aporte_propio_valorado_gasto_administracion).gsub(/(\d)(?=(\d\d\d)+(?!\d))/, "\\1."), porcentaje_aporte_propio_valorado_gasto_administracion, sprintf("$%<costo>.0f", costo: costos.aporte_propio_liquido_gasto_administracion).gsub(/(\d)(?=(\d\d\d)+(?!\d))/, "\\1."), porcentaje_aporte_propio_liquido_gasto_administracion],
      ]

      if costos.aporte_solicitado_al_fondo != 0
        porcentaje18 = (costos.aporte_solicitado_fondo_rrhh_externo.to_f / costos.aporte_solicitado_al_fondo) * 100
        porcentaje_aporte_solicitado_fondo_rrhh_externo = "%.2f %%" % porcentaje18

        porcentaje19 = (costos.aporte_solicitado_fondo_gasto_operacion.to_f / costos.aporte_solicitado_al_fondo) * 100
        porcentaje_aporte_solicitado_fondo_gasto_operacion = "%.2f %%" % porcentaje19

        porcentaje20 = (costos.aporte_solicitado_fondo_gasto_administracion.to_f / costos.aporte_solicitado_al_fondo) * 100
        porcentaje_aporte_solicitado_fondo_gasto_administracion = "%.2f %%" % porcentaje20

      else
        porcentaje_aporte_solicitado_fondo_rrhh_externo ="0,00%"
        porcentaje_aporte_solicitado_fondo_gasto_operacion = "0,00%"
        porcentaje_aporte_solicitado_fondo_gasto_administracion = "0,00%"
      end

      # Datos de la tercera tabla (Aporte del fondo por partida)
      data_aporte_fondo = [
        ["Aporte del fondo por partida", "$", "% (del costo total de la propuesta)"],
        ["Recursos Humanos Externos", sprintf("$%<costo>.0f", costo: costos.aporte_solicitado_fondo_rrhh_externo).gsub(/(\d)(?=(\d\d\d)+(?!\d))/, "\\1."), porcentaje_aporte_solicitado_fondo_rrhh_externo],
        ["Gastos de Operación", sprintf("$%<costo>.0f", costo: costos.aporte_solicitado_fondo_gasto_operacion).gsub(/(\d)(?=(\d\d\d)+(?!\d))/, "\\1."), porcentaje_aporte_solicitado_fondo_gasto_operacion],
        ["Gastos de Administración", sprintf("$%<costo>.0f", costo: costos.aporte_solicitado_fondo_gasto_administracion).gsub(/(\d)(?=(\d\d\d)+(?!\d))/, "\\1."), porcentaje_aporte_solicitado_fondo_gasto_administracion],
      ]


      # Generar las tablas en el PDF
      pdf.table(data_principal, header: true, column_widths: [200, 150, 150], cell_style: { size: 9, padding: [4, 8] }) do |table|
      end

      pdf.move_down 10

      pdf.table(data_partida, header: true, column_widths: [200, 150, 150], cell_style: { size: 9, padding: [4, 8] }) do |table|
      end

      pdf.move_down 10

      pdf.table(data_aporte, header: true, column_widths: [200, 75, 75, 75, 75], cell_style: { size: 9, padding: [4, 8] }) do |table|
      end

      pdf.move_down 10

      pdf.table(data_aporte_fondo, header: true, column_widths: [200, 150, 150], cell_style: { size: 9, padding: [4, 8] }) do |table|
      end

      pdf.move_down 10

    rescue => e
      Rails.logger.error "Error creando la tabla en el PDF: #{e.message}"
      puts "Error creando la tabla en el PDF: #{e.message}"
    end
  end

  def pdf_tabla_validacion(pdf, costos)
    begin
      monto = 0
      flujo = Flujo.find_by(id: self.flujo_id)
      if flujo
        case flujo.tipo_instrumento_id
        when 11
          monto = Gasto::TOPE_MAXIMO_SOLICITAR_DIAGNOSTICO
        when 22
          monto = Gasto::TOPE_MAXIMO_SOLICITAR_DIAGNOSTICO_L5
        else
          nil
        end
      else
        nil
      end

      valida_pregunta_aporte_propio_liquido = (costos.costo_total_de_la_propuesta * Gasto::PORCENTAJE_APORTE_LIQUIDO_MINIMO_DIAGNOSTICO) / 100
      if costos.aporte_propio_liquido >= valida_pregunta_aporte_propio_liquido && costos.costo_total_de_la_propuesta != ''
        cumple1 = 'SI'
      else
        cumple1 = 'NO'
      end

      valida_pregunta_costo_total_de_la_propuesta = (costos.costo_total_de_la_propuesta * Gasto::PORCENTAJE_APORTE_PROPIO_MINIMO_DIAGNOSTICO) / 100
      if costos.aporte_propio_liquido + costos.aporte_propio_valorado >= valida_pregunta_costo_total_de_la_propuesta && costos.costo_total_de_la_propuesta != ''
        cumple2 = 'SI'
      else
        cumple2 = 'NO'
      end

      valida_pregunta_gastos_administrativos = (costos.costo_total_de_la_propuesta * Gasto::PORCENTAJE_GASTO_ADMINISTRACION_DIAGNOSTICO) / 100
      if costos.gastos_administrativos <= valida_pregunta_gastos_administrativos && costos.costo_total_de_la_propuesta != ''
        cumple3 = 'SI'
      else
        cumple3 = 'NO'
      end

      #valida_pregunta_aporte_solicitado_al_fondo = (costos.costo_total_de_la_propuesta * monto) / 100
      if costos.aporte_solicitado_al_fondo <= monto && costos.costo_total_de_la_propuesta != ''
        cumple4 = 'SI'
      else
        cumple4 = 'NO'
      end

      # Datos de la tabla validación
      data_validacion = [
        ["Glosa", "Monto", "Criterio", "Límite", "Cumple?"],
        ["Aporte líquido del postulante", sprintf("$%<costo>.0f", costo: costos.aporte_propio_liquido).gsub(/(\d)(?=(\d\d\d)+(?!\d))/, "\\1."), "Mayor o igual al #{Gasto::PORCENTAJE_APORTE_LIQUIDO_MINIMO_DIAGNOSTICO}% del total del proyecto", sprintf("$%<valida>.0f", valida: valida_pregunta_aporte_propio_liquido).gsub(/(\d)(?=(\d\d\d)+(?!\d))/, "\\1."), cumple1],
        ["Aporte del postulante", sprintf("$%<costo>.0f", costo: costos.aporte_propio_liquido + costos.aporte_propio_valorado).gsub(/(\d)(?=(\d\d\d)+(?!\d))/, "\\1."), "Mayor o igual al #{Gasto::PORCENTAJE_APORTE_PROPIO_MINIMO_DIAGNOSTICO}% del total del proyecto", sprintf("$%<valida>.0f", valida: valida_pregunta_costo_total_de_la_propuesta).gsub(/(\d)(?=(\d\d\d)+(?!\d))/, "\\1."), cumple2],
        ["Gastos de Administración", sprintf("$%<costo>.0f", costo: costos.gastos_administrativos).gsub(/(\d)(?=(\d\d\d)+(?!\d))/, "\\1."), "Menor o igual al #{Gasto::PORCENTAJE_GASTO_ADMINISTRACION_DIAGNOSTICO}% del total del proyecto", sprintf("$%<valida>.0f", valida: valida_pregunta_gastos_administrativos).gsub(/(\d)(?=(\d\d\d)+(?!\d))/, "\\1."), cumple3],
        ["Cofinanciamiento ASCC", sprintf("$%<costo>.0f", costo: costos.aporte_solicitado_al_fondo).gsub(/(\d)(?=(\d\d\d)+(?!\d))/, "\\1."), "Menor o igual a " + sprintf("$%<costo>.0f", costo: monto).gsub(/(\d)(?=(\d\d\d)+(?!\d))/, "\\1."), sprintf("$%<costo>.0f", costo: monto).gsub(/(\d)(?=(\d\d\d)+(?!\d))/, "\\1."), cumple4],
      ]

      pdf.table(data_validacion, header: true, column_widths: [200, 75, 75, 75, 75], cell_style: { size: 9, padding: [4, 8] }) do |table|
      end
      pdf.move_down 10
    rescue => e
      Rails.logger.error "Error creando la tabla en el PDF: #{e.message}"
      puts "Error creando la tabla en el PDF: #{e.message}"
    end
  end

  def pdf_tabla_validacion_tipos(pdf, costos, costos_seguimiento, confinanciamiento_empresa)
    begin
      monto = 0
      flujo = Flujo.find_by(id: self.flujo_id)
      if flujo
        case flujo.tipo_instrumento_id
        when 12
          monto = Gasto::TOPE_MAXIMO_SOLICITAR_SEGUIMIENTO_L1_1
        when 29
          monto = Gasto::TOPE_MAXIMO_SOLICITAR_SEGUIMIENTO_L1_2
        when 13
          monto = Gasto::TOPE_MAXIMO_SOLICITAR_EVALUACION_L1_3
        else
          nil
        end
      else
        nil
      end
    
      if costos_seguimiento[0] != nil
        valida_pregunta__aporte_del_postulante = ((costos_seguimiento[0]["aporte_solicitado_al_fondo"] + costos_seguimiento[0]["aporte_propio_valorado"] + costos_seguimiento[0]["aporte_propio_liquido"]) * Gasto::PORCENTAJE_APORTE_PROPIO_MINIMO_DIAGNOSTICO) / 100
        if costos_seguimiento[0]["aporte_propio_valorado"].to_f + costos_seguimiento[0]["aporte_propio_liquido"].to_f >= valida_pregunta__aporte_del_postulante && costos_seguimiento[0]["aporte_propio_valorado"].present?
          cumple1 = 'SI'
        else
          cumple1 = 'NO'
        end


        if costos_seguimiento[0]["aporte_solicitado_al_fondo"] <= monto && costos_seguimiento[0]["aporte_solicitado_al_fondo"].present?
          cumple2 = 'SI'
        else
          cumple2 = 'NO'
        end

        costos_seguimiento_0_aporte_propio_liquido = costos_seguimiento[0]["aporte_propio_liquido"]
        costos_seguimiento_0_aporte_propio_valorado = costos_seguimiento[0]["aporte_propio_valorado"]
        costos_seguimiento_0_aporte_solicitado_al_fondo = costos_seguimiento[0]["aporte_solicitado_al_fondo"]

      else
        valida_pregunta__aporte_del_postulante = 0
        cumple1 = 'NO'
        cumple2 = 'NO'

        costos_seguimiento_0_aporte_propio_liquido = "0"
        costos_seguimiento_0_aporte_propio_valorado = "0"
        costos_seguimiento_0_aporte_solicitado_al_fondo = "0"

      end
    
      if costos_seguimiento[1] != nil
        # Redondear el valor a dos decimales
        confinanciamiento = confinanciamiento_empresa[1].round(2)
        # Formatear el valor como porcentaje con coma como separador decimal
        confinanciamiento_formateado = sprintf("%.2f", confinanciamiento).gsub('.', ',') + " %"

        valida_pregunta__aporte_del_empresa = ((costos_seguimiento[1]["aporte_solicitado_al_fondo"] + costos_seguimiento[1]["aporte_propio_valorado"] + costos_seguimiento[1]["aporte_propio_liquido"]) * confinanciamiento_empresa[1]) / 100
        if costos_seguimiento[1]["aporte_propio_valorado"].to_f + costos_seguimiento[1]["aporte_propio_liquido"].to_f >= valida_pregunta__aporte_del_empresa && costos_seguimiento[1]["aporte_propio_valorado"].present?
          cumple3 = 'SI'
        else
          cumple3 = 'NO'
        end

        costos_seguimiento_1_aporte_propio_liquido = costos_seguimiento[1]["aporte_propio_liquido"]
        costos_seguimiento_1_aporte_propio_valorado = costos_seguimiento[1]["aporte_propio_valorado"]
        costos_seguimiento_1_aporte_solicitado_al_fondo = costos_seguimiento[1]["aporte_solicitado_al_fondo"]

      else
        cumple3 = 'NO'
        confinanciamiento_formateado = "0"
        valida_pregunta__aporte_del_empresa = "0"

        costos_seguimiento_1_aporte_propio_liquido = "0"
        costos_seguimiento_1_aporte_propio_valorado = "0"
        costos_seguimiento_1_aporte_solicitado_al_fondo = "0"

      end

      if costos_seguimiento[1] != nil
        monto_cofinanciamiento = confinanciamiento_empresa[0]

        if costos_seguimiento[1]["aporte_solicitado_al_fondo"] <= monto && costos_seguimiento[1]["aporte_solicitado_al_fondo"] != ''
          cumple4 = 'SI'
        else
          cumple4 = 'NO'
        end
      else
        cumple4 = 'NO'
        monto_cofinanciamiento = "0"
      end

      if costos != nil
        valida_pregunta_aporte_propio_liquido = ((costos.costo_total_de_la_propuesta)* Gasto::PORCENTAJE_APORTE_LIQUIDO_MINIMO_DIAGNOSTICO) / 100
        if costos.aporte_propio_liquido >= valida_pregunta_aporte_propio_liquido && costos.costo_total_de_la_propuesta != ''
          cumple5 = 'SI'
        else
          cumple5 = 'NO'
        end

        valida_pregunta_gastos_administrativos = (costos.costo_total_de_la_propuesta * Gasto::PORCENTAJE_GASTO_ADMINISTRACION_DIAGNOSTICO) / 100
        if costos.gastos_administrativos <= valida_pregunta_gastos_administrativos && costos.costo_total_de_la_propuesta != ''
          cumple6 = 'SI'
        else
          cumple6 = 'NO'
        end

        costos_aporte_propio_liquido = costos.aporte_propio_liquido
        costos_gastos_administrativos = costos.gastos_administrativos

      else
        valida_pregunta_aporte_propio_liquido = "0"
        valida_pregunta_gastos_administrativos = "0"
        cumple5 = 'NO'
        cumple6 = 'NO'

        costos_aporte_propio_liquido = "0"
        costos_gastos_administrativos = "0"
      end
  
      # Datos de la tabla validación
      data_validacion = [
        ["Tipo de Actividades", "Glosa", "Monto", "Criterio", "Límite", "Cumple?"],
        ["De apoyo general al postulante", "Aporte del postulante", sprintf("$%<costo>.0f", costo: costos_seguimiento_0_aporte_propio_liquido + costos_seguimiento_0_aporte_propio_valorado).gsub(/(\d)(?=(\d\d\d)+(?!\d))/, "\\1."), "Mayor o igual al #{Gasto::PORCENTAJE_APORTE_PROPIO_MINIMO_DIAGNOSTICO}% del total de actividades de Tipo A", sprintf("$%<valida>.0f", valida: valida_pregunta__aporte_del_postulante).gsub(/(\d)(?=(\d\d\d)+(?!\d))/, "\\1."), cumple1],
        ["De apoyo general al postulante", "Cofinanciamiento ASCC", sprintf("$%<costo>.0f", costo: costos_seguimiento_0_aporte_solicitado_al_fondo).gsub(/(\d)(?=(\d\d\d)+(?!\d))/, "\\1."), "Menor o igual a " + sprintf("$%<costo>.0f", costo: monto).gsub(/(\d)(?=(\d\d\d)+(?!\d))/, "\\1."), sprintf("$%<costo>.0f", costo: monto).gsub(/(\d)(?=(\d\d\d)+(?!\d))/, "\\1."), cumple2],
        ["De apoyo directo a las empresas de menor tamaño", "Aporte del postulante", sprintf("$%<costo>.0f", costo: costos_seguimiento_1_aporte_propio_liquido + costos_seguimiento_1_aporte_propio_valorado).gsub(/(\d)(?=(\d\d\d)+(?!\d))/, "\\1."), "Mayor o igual al " + confinanciamiento_formateado + " del total Actividades Tipo B", sprintf("$%<valida>.0f", valida: valida_pregunta__aporte_del_empresa).gsub(/(\d)(?=(\d\d\d)+(?!\d))/, "\\1."), cumple3],
        ["De apoyo directo a las empresas de menor tamaño", "Cofinanciamiento ASCC", sprintf("$%<costo>.0f", costo: costos_seguimiento_1_aporte_solicitado_al_fondo).gsub(/(\d)(?=(\d\d\d)+(?!\d))/, "\\1."), "Menor o igual a " + sprintf("$%<costo>.0f", costo: monto_cofinanciamiento).gsub(/(\d)(?=(\d\d\d)+(?!\d))/, "\\1."), sprintf("$%<costo>.0f", costo: monto_cofinanciamiento).gsub(/(\d)(?=(\d\d\d)+(?!\d))/, "\\1."), cumple4],
        ["Total Proyecto", "Aporte líquido del postulante", sprintf("$%<costo>.0f", costo: costos_aporte_propio_liquido).gsub(/(\d)(?=(\d\d\d)+(?!\d))/, "\\1."), "Mayor o igual al #{Gasto::PORCENTAJE_APORTE_LIQUIDO_MINIMO_DIAGNOSTICO}% del total del proyecto", sprintf("$%<valida>.0f", valida: valida_pregunta_aporte_propio_liquido).gsub(/(\d)(?=(\d\d\d)+(?!\d))/, "\\1."), cumple5],
        ["Total Proyecto", "Gastos de Administración", sprintf("$%<costo>.0f", costo: costos_gastos_administrativos).gsub(/(\d)(?=(\d\d\d)+(?!\d))/, "\\1."), "Menor o igual al #{Gasto::PORCENTAJE_GASTO_ADMINISTRACION_DIAGNOSTICO}% del total del proyecto", sprintf("$%<valida>.0f", valida: valida_pregunta_gastos_administrativos).gsub(/(\d)(?=(\d\d\d)+(?!\d))/, "\\1."), cumple6]
      ]
      pdf.table(data_validacion, header: true, column_widths: [100, 100, 75, 75, 75, 75], cell_style: { size: 9, padding: [4, 8] }) do |table|

      end
      pdf.move_down 10
    rescue => e
      Rails.logger.error "Error creando la tabla en el PDF: #{e.message}"
      puts "Error creando la tabla en el PDF: #{e.message}"
    end
  end

  def pdf_tabla_detalle_costos_x_actividad(pdf, flujo_id)
    planes = PlanActividad.cabecera_objetivos_y_plan_actividades(flujo_id)

    planes.each do |plan|

      detalle = PlanActividad.detalle_objetivos_y_plan_actividades(flujo_id, plan.id)
      
      if detalle.present?

        # ===== OBJETIVO =====
        pdf.table(
          [["Objetivo", plan.objetivo]],
          column_widths: [100, 440],
          cell_style: { size: 9, padding: [4, 6] },
          header: false
        )

        # ===== ACTIVIDAD =====
        pdf.table(
          [["Actividad", plan.plan_actividad]],
          column_widths: [100, 440],
          cell_style: { size: 9, padding: [4, 6] },
          header: false
        )

        pdf.move_down 6

        # ===== DETALLE =====
        headers = ["Item Gasto", "Nombre / Item", "Cantidad", "Unidad", "Tipo Aporte", "Valor", "Total"]
        data = [headers]
        
        detalle.each do |det|
          data << [
            det.item_gasto,
            det.nombre_item,
            det.cantidad,
            det.unidad,
            det.tipo_aporte,
            sprintf("$%<valor>.0f", valor: det.valor).gsub(/(\d)(?=(\d\d\d)+(?!\d))/, "\\1."),
            sprintf("$%<total>.0f", total: det.total).gsub(/(\d)(?=(\d\d\d)+(?!\d))/, "\\1.")
          ]
        end
         pdf.table(
          data,
          header: true,
          column_widths: [80, 160, 60, 60, 60, 60, 60],
          cell_style: { size: 9, padding: [4, 6] }
        )

        pdf.move_down 15
      end
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

  def self.calcular_suma_y_porcentaje(flujo_id,aporte_micro,aporte_pequena,aporte_mediana,tope_maximo)
    resultados = where(flujo_id: flujo_id)
      .group(:id)
      .select(
        "SUM(cantidad_micro_empresa * #{aporte_micro}) +
         SUM(cantidad_pequeña_empresa * #{aporte_pequena}) +
         SUM(cantidad_mediana_empresa * #{aporte_mediana}) AS suma_total",
        "(#{PORCENTAJE_APORTE_BENEFICIARIO_MICRO_EMPRESA} * SUM(cantidad_micro_empresa) + 
          #{PORCENTAJE_APORTE_BENEFICIARIO_PEQUEÑA_EMPRESA} * SUM(cantidad_pequeña_empresa) + 
          #{PORCENTAJE_APORTE_BENEFICIARIO_MEDIANA_EMPRESA} * SUM(cantidad_mediana_empresa)) /
          (SUM(cantidad_micro_empresa) + 
           SUM(cantidad_pequeña_empresa) + 
           SUM(cantidad_mediana_empresa)) * 100 AS porcentaje_empresa"
      ).first

    if resultados.present?
      suma_total = 0
      if resultados.suma_total.to_f >= tope_maximo.to_f
        suma_total = tope_maximo.to_f
      else
        suma_total = resultados.suma_total.to_f
      end
      porcentaje_empresa = resultados.porcentaje_empresa.to_f
      return suma_total, porcentaje_empresa
    else
      return nil, nil
    end
  end

  # Método para crear una tabla con cuatro campos en el PDF
  def pdf_tabla_cuestionario(pdf, flujo_id, tipo_contribuyentes_id, tipo_descargable)
    #obtiene custionarios 
    cuestionario = CuestionarioFpl.obtener_cuestionarios(flujo_id, tipo_contribuyentes_id, tipo_descargable)

    begin
      # Encabezados de la tabla
      headers = ["Criterios", "Cumple?", "Observación"]

      # Datos de la tabla
      data = [headers] # Comienza con los encabezados

      # Agregar cada objetivo específico a la tabla
      cuestionario.each do |resp|
      if resp[:nota].to_s == "1"
        nota = "Cumple"
      else
        nota = "No Cumple"
      end

        fila = [
          resp[:nombre].to_s,
          nota,
          resp[:justificacion].to_s,
        ]
        data << fila
      end

      pdf.table(data, header: true, column_widths: [170, 170, 170], cell_style: { size: 9, padding: [4, 8] }) do |table|
        # Sin estilos adicionales por ahora
      end

      pdf.move_down 10 # Espacio después de la tabla

    rescue => e
      Rails.logger.error "Error creando la tabla en el PDF: #{e.message}"
      puts "Error creando la tabla en el PDF: #{e.message}"
    end
  end

  def pdf_tabla_cuestionario_ejecutor(pdf, flujo_id)
    #obtiene custionarios 
    cuestionario = CuestionarioFpl.obtener_cuestionario_ejecutor(flujo_id)

    begin
      # Encabezados de la tabla
      headers = ["Criterios", "Cumple?", "Observación"]

      # Datos de la tabla
      data = [headers] # Comienza con los encabezados

      # Agregar cada objetivo específico a la tabla
      cuestionario.each do |resp|
      if resp[:nota].to_s == "1"
        nota = "Cumple"
      else
        nota = "No Cumple"
      end

        fila = [
          resp[:nombre].to_s,
          nota,
          resp[:justificacion].to_s,
        ]
        data << fila
      end

      pdf.table(data, header: true, column_widths: [170, 170, 170], cell_style: { size: 9, padding: [4, 8] }) do |table|
        # Sin estilos adicionales por ahora
      end

      pdf.move_down 10 # Espacio después de la tabla

    rescue => e
      Rails.logger.error "Error creando la tabla en el PDF: #{e.message}"
      puts "Error creando la tabla en el PDF: #{e.message}"
    end
  end

  def pdf_tabla_observaciones(pdf, comentarios)
     begin
      # Encabezados de la tabla
      headers = ["Fecha y Hora", "Usuario", "Tarea", "Comentario"]

      # Datos de la tabla
      data = [headers] # Comienza con los encabezados

      # Agregar cada objetivo específico a la tabla
      comentarios.each do |resp|
        fila = [
          resp[:created_at].strftime('%d-%m-%Y %H:%M:%S'),
          resp.user.nombre_completo,
          resp.tarea.codigo,
          resp[:comentario]
        ]
        data << fila
      end
      pdf.table(data, header: true, column_widths: [127, 127, 127, 127], cell_style: { size: 9, padding: [4, 8] }) do |table|
        # Sin estilos adicionales por ahora
      end

      pdf.move_down 10 # Espacio después de la tabla

    rescue => e
      Rails.logger.error "Error creando la tabla en el PDF: #{e.message}"
      puts "Error creando la tabla en el PDF: #{e.message}"
    end
  end

  def obtiene_contribuyente(id)
    Contribuyente.find(id)
  end

  # Método para crear una tabla con cuatro campos en el PDF
  def pdf_tabla_cuestionario_tecnico(pdf, flujo_id)
    #obtiene custionarios 
    #cuestionario = CuestionarioFpl.obtener_cuestionarios(flujo_id, tipo_contribuyentes_id, tipo_descargable)
    preguntas = CuestionarioFpl.preguntas_tecnicas
    cuestionario = CuestionarioFpl.where(flujo_id: flujo_id, tipo_cuestionario_id: 2).order(:criterio_id)

    begin
      # Encabezados de la tabla
      headers = ["Subcriterios", "Cumple?", "Justificación"]

      # Datos de la tabla
      data = [headers] # Comienza con los encabezados

      # Agregar cada objetivo específico a la tabla
      preguntas.each do |preg|
        cuestionario.each do |resp|
          if preg[:id] == resp[:criterio_id]
            fila = [
              preg[:pregunta].to_s,
              resp[:nota].to_s,
              resp[:justificacion].to_s,
            ]
            data << fila
          end
        end
      end

      pdf.table(data, header: true, column_widths: [170, 170, 170], cell_style: { size: 9, padding: [4, 8] }) do |table|
        # Sin estilos adicionales por ahora
      end
      pdf.move_down 10 # Espacio después de la tabla

    rescue => e
      Rails.logger.error "Error creando la tabla en el PDF: #{e.message}"
      puts "Error creando la tabla en el PDF: #{e.message}"
    end
  end

   # Método para crear una tabla con cuatro campos en el PDF
   def pdf_tabla_cuestionario_financiero(pdf, flujo_id)
    #obtiene custionarios 
    #cuestionario = CuestionarioFpl.obtener_cuestionarios(flujo_id, tipo_contribuyentes_id, tipo_descargable)
    preguntas = CuestionarioFpl.preguntas_financiamiento
    cuestionario = CuestionarioFpl.where(flujo_id: flujo_id, tipo_cuestionario_id: 1).order(:criterio_id)

    begin
      # Encabezados de la tabla
      headers = ["Subcriterios", "Cumple?", "Justificación"]

      # Datos de la tabla
      data = [headers] # Comienza con los encabezados

      # Agregar cada objetivo específico a la tabla
      preguntas.each do |preg|
        cuestionario.each do |resp|
          if preg[:id] == resp[:criterio_id]
            fila = [
              preg[:pregunta].to_s,
              resp[:nota].to_s,
              resp[:justificacion].to_s,
            ]
            data << fila
          end
        end
      end

      pdf.table(data, header: true, column_widths: [170, 170, 170], cell_style: { size: 9, padding: [4, 8] }) do |table|
        # Sin estilos adicionales por ahora
      end
      pdf.move_down 10 # Espacio después de la tabla

    rescue => e
      Rails.logger.error "Error creando la tabla en el PDF: #{e.message}"
      puts "Error creando la tabla en el PDF: #{e.message}"
    end
  end

  # Método generador del Informe de Evaluación de Rendición de Gastos en PDF con Prawn
  def generar_informe_gastos_pdf(revision = nil, fondo_produccion_limpia = nil, rendicion = nil, actividades = nil, detalles_fpl = nil, detalles_beneficiaria = nil)
    t_inicio = Time.now
    Rails.logger.info "=== [PDF INFORME GASTOS] INICIANDO GENERACIÓN (t=0s) ==="

    pdf = Prawn::Document.new(page_size: 'LETTER', page_layout: :portrait, margin: [30, 30, 30, 30])

    # ---------------------------------------------------------------------------
    # CONFIGURACIÓN DE FAMILIA DE FUENTES
    # ---------------------------------------------------------------------------
    font_path_regular     = Rails.root.join("app/assets/fonts/DejaVuSans.ttf").to_s
    font_path_bold        = Rails.root.join("app/assets/fonts/DejaVuSans-Bold.ttf").to_s
    font_path_italic      = Rails.root.join("app/assets/fonts/DejaVuSans-Oblique.ttf").to_s # Ajusta el nombre si tienes el archivo
    font_path_bold_italic = Rails.root.join("app/assets/fonts/DejaVuSans-BoldOblique.ttf").to_s

    pdf.font_families.update("DejaVuSans" => {
      normal:      font_path_regular,
      bold:        File.exist?(font_path_bold) ? font_path_bold : font_path_regular,
      italic:      File.exist?(font_path_italic) ? font_path_italic : font_path_regular,
      bold_italic: File.exist?(font_path_bold_italic) ? font_path_bold_italic : (File.exist?(font_path_bold) ? font_path_bold : font_path_regular)
    })
    pdf.font "DejaVuSans"

    # ---------------------------------------------------------------------------
    # HEADER REPETITIVO EN TODAS LAS PÁGINAS
    # ---------------------------------------------------------------------------
    pdf.repeat :all do
      pdf.bounding_box [pdf.bounds.left, pdf.bounds.top], width: pdf.bounds.width do
        pdf.image Rails.root.join("app/assets/images/logo-ascc-nuevo.png"), width: 119 if File.exist?(Rails.root.join("app/assets/images/logo-ascc-nuevo.png"))
        pdf.bounding_box [pdf.bounds.left, pdf.bounds.bottom], width: pdf.bounds.width do
          pdf.font "DejaVuSans", style: :bold do
            pdf.text "INFORME DE EVALUACIÓN DE RENDICIÓN DE GASTOS - FPL", size: 10, color: "003DA6", align: :right
          end
        end
        pdf.move_down 5
        pdf.stroke do
          pdf.stroke_color '003DA6'
          pdf.line_width 3
          pdf.stroke_horizontal_rule
        end
      end
    end

    fpl = fondo_produccion_limpia || self
    contribuyente = obtiene_contribuyente(fpl&.institucion_entregables_id) rescue nil
    razon_social = contribuyente&.razon_social || "Nombre Beneficiaria"
    rut_beneficiaria = contribuyente.present? ? "#{contribuyente.rut}-#{contribuyente.dv}" : "RUT Beneficiaria"

    flujo_mdi = FondoProduccionLimpia.where(id: fpl.id).pluck(:flujo_apl_id) rescue []
    mdi_id = Flujo.where(id: flujo_mdi).pluck(:manifestacion_de_interes_id) rescue []
    nombre_acuerdo = ManifestacionDeInteres.where(id: mdi_id).pluck(:nombre_acuerdo).first rescue nil

    cod_fpl = fpl.respond_to?(:codigo_proyecto_fpl) ? fpl.codigo_proyecto_fpl : fpl.try(:codigo_proyecto).to_s
    titulo_proyecto = nombre_acuerdo.present? ? "#{cod_fpl} - #{nombre_acuerdo}" : cod_fpl
    programa_texto = fpl.try(:programa).presence || "--"

    # =========================================================================
    # LÓGICA DE VALIDACIÓN DE IMPUTACIÓN
    # =========================================================================
    prog_clean = programa_texto.to_s.strip
    imputacion_texto = if prog_clean.include?('01 - Ley Presupuesto') || prog_clean.include?('07 - DPS') || prog_clean =~ /^01|^07|Ley Presupuesto|DPS/i
                         '24.01.070'
                       elsif prog_clean.downcase.include?('extrapresupuestario')
                         '92.01.618'
                       else
                         programa_texto
                       end

    postulante = User.find_by(id: fpl.try(:usuario_entregables_id))
    nombre_postulante = postulante.try(:nombre_completo)
    rut_postulante = postulante.try(:rut)

    mes_actual_num  = rendicion&.mes_a_rendir.to_i
    flujo_actual_id = fpl.try(:flujo_id) || rendicion.try(:flujo_id)

    fecha_res = fpl.try(:fecha_resolucion)
    mes_nombre = nil
    if fecha_res.present? && mes_actual_num > 0
      fecha_target = fecha_res.to_date + (mes_actual_num - 1).months
      mes_nombre = (I18n.l(fecha_target, format: '%B %Y') rescue fecha_target.strftime('%B %Y')).capitalize
    end
    texto_mes_display = mes_nombre.present? ? "#{mes_nombre} (Rendición #{mes_actual_num})" : "Rendición #{mes_actual_num}"

    # =========================================================================
    # MAPA DUAL Y TRADUCCIÓN DE IDs
    # =========================================================================
    map_planes_by_id = PlanActividad.where(flujo_id: flujo_actual_id).index_by(&:id)
    map_planes_by_act_id = PlanActividad.where(flujo_id: flujo_actual_id).index_by(&:actividad_id)
    get_act_id = lambda { |db_id| plan = map_planes_by_id[db_id.to_i]; plan.try(:actividad_id).to_i > 0 ? plan.actividad_id.to_i : db_id.to_i }

    # IDENTIFICACIÓN ROBUSTA DE ACTIVIDADES REITIMIZADAS
    arr_planes = map_planes_by_id.values
    reitimizadas_ids = arr_planes.select { |p| [true, 'true', '1', 1, 't'].include?(p.autorizado) || p.try(:archivo_reitimizacion).to_s.present? }.flat_map { |p| [p.actividad_id.to_i, p.id.to_i] }.compact.reject(&:zero?).uniq

    # FECHAS TAREAS
    tarea_fondo_fpl_14 = Tarea.find_by_codigo(Tarea::COD_FPL_14) rescue nil
    tarea_fondo_fpl_16 = Tarea.find_by_codigo(Tarea::COD_FPL_16) rescue nil

    extraer_mes_data = lambda do |tp|
      return nil if tp&.data.blank?
      d = tp.data
      if d.is_a?(String)
        begin
          d = YAML.safe_load(d, permitted_classes: [Symbol, Date, Time, ActiveSupport::HashWithIndifferentAccess]) rescue YAML.load(d)
        rescue StandardError
        end
      end
      if d.is_a?(Hash) || d.respond_to?(:[])
        h = d.respond_to?(:with_indifferent_access) ? d.with_indifferent_access : d
        if rendicion.present? && (h[:rendicion_fpl_id].present? || h[:rendicion_id].present?)
          rend_id = h[:rendicion_fpl_id] || h[:rendicion_id]
          return mes_actual_num if rend_id.to_i == rendicion.id.to_i
        end
        val_mes = h[:mes_a_rendir] || h.dig(:params, :mes_a_rendir)
        return val_mes.to_i if val_mes.present?
      end
      match = d.to_s.match(/mes_a_rendir["']?\s*[:=>]+\s*["']?(\d+)/i)
      match ? match[1].to_i : nil
    end

    tps_14_todas = TareaPendiente.where(tarea_id: tarea_fondo_fpl_14&.id, flujo_id: flujo_actual_id).order(created_at: :asc)
    tps_14_mes   = tps_14_todas.select { |tp| extraer_mes_data.call(tp) == mes_actual_num }
    tp_14_primera = tps_14_mes.first

    tps_16 = TareaPendiente.where(tarea_id: tarea_fondo_fpl_16&.id, flujo_id: flujo_actual_id).order(created_at: :asc).first

    f_recepcion_raw  = tp_14_primera&.created_at
    f_evaluacion_raw = tps_16&.created_at || tps_16&.updated_at

    fecha_recepcion  = f_recepcion_raw.respond_to?(:strftime)  ? f_recepcion_raw.strftime('%d/%m/%Y')  : "--"
    fecha_evaluacion = f_evaluacion_raw.respond_to?(:strftime) ? f_evaluacion_raw.strftime('%d/%m/%Y') : "--"

    obtener_gastos = lambda do |act_id, tipos_validos|
      rec_int = PlanActividad.recursos_internos(flujo_actual_id, act_id).select { |r| tipos_validos.any? { |t| r.try(:tipo_aporte).to_s.downcase.include?(t) } } rescue []
      rec_ext = PlanActividad.recursos_externos(flujo_actual_id, act_id).select { |r| tipos_validos.any? { |t| r.try(:tipo_aporte).to_s.downcase.include?(t) } } rescue []
      g_op    = PlanActividad.gastos_operaciones(flujo_actual_id, act_id).select { |g| tipos_validos.any? { |t| g.try(:tipo_aporte).to_s.downcase.include?(t) } } rescue []
      g_adm   = PlanActividad.gastos_administraciones(flujo_actual_id, act_id).select { |g| tipos_validos.any? { |t| g.try(:tipo_aporte).to_s.downcase.include?(t) } } rescue []
      { rrhh_propios: rec_int, rrhh_externos: rec_ext, operaciones: g_op, administracion: g_adm }
    end

    # Mapeo dual de Gastos Rendidos
    rendicion_gastos_map = {}
    if rendicion.present?
      rendicion.rendicion_gastos_fpl.each do |g|
        p_id = g.plan_actividad_id.to_i
        cat_s = g.categoria.to_s.strip.downcase
        item_s = g.item_origen_id.to_s.strip
        plan = map_planes_by_id[p_id]

        rendicion_gastos_map["#{p_id}_#{cat_s}_#{item_s}"] = g
        rendicion_gastos_map["#{plan.actividad_id.to_i}_#{cat_s}_#{item_s}"] = g if plan.present? && plan.actividad_id.present?
      end
    end

    totales_resumen = {
      rrhh_propios: { fpl: 0.0, aporte: 0.0 },
      rrhh_externos: { fpl: 0.0, aporte: 0.0 },
      operaciones: { fpl: 0.0, aporte: 0.0 },
      administracion: { fpl: 0.0, aporte: 0.0 }
    }

    total_fpl = 0.0
    total_aporte = 0.0

    fmt_clp = lambda { |m| ActiveSupport::NumberHelper.number_to_currency(m.to_f, delimiter: '.', precision: 0, format: "%u%n", unit: "$") }
    fmt_pct = lambda { |p| ActiveSupport::NumberHelper.number_to_percentage(p.to_f, precision: 1, separator: ',') rescue "#{p.round(1)}%" }

    pdf.bounding_box [pdf.bounds.left, pdf.bounds.top - 60], width: pdf.bounds.width do

      self.pdf_titulo_formato(pdf, "INFORME DE EVALUACIÓN DE RENDICIÓN DE GASTOS") rescue nil
      self.pdf_sub_titulo_formato(pdf, "PROYECTOS EN EJECUCIÓN FONDO DE PROMOCIÓN DE LA PRODUCCIÓN LIMPIA") rescue nil
      self.pdf_separador(pdf, 10) rescue nil

      # 1. ANTECEDENTES GENERALES
      self.pdf_sub_titulo_formato(pdf, "ANTECEDENTES GENERALES DEL PROYECTO") rescue nil

      tabla_antecedentes = [
        [ { content: "<b>Código:</b>", inline_format: true }, fpl&.codigo_proyecto.to_s, { content: "<b>Programa:</b>", inline_format: true }, programa_texto ],
        [ { content: "<b>Título del proyecto:</b>", inline_format: true }, titulo_proyecto, { content: "<b>Imputación:</b>", inline_format: true }, imputacion_texto ],
        [ { content: "<b>Nombre Entidad Beneficiaria:</b>", inline_format: true }, { content: razon_social, colspan: 3 } ],
        [ { content: "<b>N° de informe:</b>", inline_format: true }, { content: texto_mes_display, colspan: 3 } ],
        [ { content: "<b>Fecha aprobación informe evaluación actividades:</b>", inline_format: true }, fecha_recepcion, { content: "<b>Fecha de evaluación de gastos:</b>", inline_format: true }, fecha_evaluacion ]
      ]

      pdf.table(tabla_antecedentes, width: pdf.bounds.width, cell_style: { size: 8, padding: 4, border_color: 'CCCCCC', inline_format: true }) do
        column(0).background_color = 'E0EFF6'
        column(2).background_color = 'E0EFF6'
      end

      self.pdf_separador(pdf, 20) rescue nil

      # 2. DESCRIPCIÓN DE ACTIVIDADES
      self.pdf_titulo_formato(pdf, "DESCRIPCIÓN DE ACTIVIDADES") rescue nil
      pdf.text "Indicar y describir en forma detallada las actividades realizadas y el estado en el marco del Plan de actividades comprometido en el proyecto aprobado.", size: 8, style: :italic

      self.pdf_separador(pdf, 8) rescue nil

      tabla_actividades = [
        [ "Nº", "Etapa / Actividades", "Descripción de las actividades realizadas", "Estado\n(Nivel de avance)" ]
      ]

      if actividades.present?
        actividades.each do |act|
          act_id_num = act.id.to_i
          plan_act = map_planes_by_act_id[act_id_num] || map_planes_by_id[act_id_num]
          pk_id_num = plan_act.try(:id).to_i
          mis_ids = [act_id_num, pk_id_num].reject(&:zero?).uniq
          es_reitimizada = (mis_ids & reitimizadas_ids).any?

          nombre_actividad_display = act.try(:nombre) || "Actividad"
          if es_reitimizada
            nombre_actividad_display += " <color rgb='6F42C1'><b>(Reitimizada)</b></color>"
          end

          detalle_tecnico = rendicion.rendicion_detalles_fpl.find do |d|
            act_ids = (d.rendicion_detalle_actividades_fpl.to_a.map(&:plan_actividad_id) rescue []).compact.map(&get_act_id)
            act_ids += (d.rendicion_detalle_actividades_fpl.to_a.map(&:plan_actividad_id) rescue []).compact.map(&:to_i)
            (d.tecnica? rescue false) && act_ids.include?(act_id_num)
          end rescue nil

          avance_num = detalle_tecnico&.nivel_avance.to_i
          estado_label = "#{avance_num}%"
          descripcion_avance = avance_num >= 100 ? "Finalizado" : "en Ejecución"

          tabla_actividades << [
            act.try(:correlativo) || "-",
            nombre_actividad_display,
            descripcion_avance,
            estado_label
          ]
        end
      else
        tabla_actividades << [ "-", "-", "-", "-" ]
      end

      pdf.table(tabla_actividades, width: pdf.bounds.width, cell_style: { size: 8, padding: 4, border_color: 'CCCCCC', inline_format: true }) do
        row(0).background_color = 'E0EFF6'
        row(0).font_style = :bold
        column(0).width = 30
        column(0).align = :center
        column(3).width = 80
        column(3).align = :center
      end

      self.pdf_separador(pdf, 20) rescue nil

      # 3. PLANILLA DE RENDICIÓN DE GASTOS - FPL (ESTILO EVALUACIÓN TÉCNICA)
      pdf.start_new_page
      self.pdf_titulo_formato(pdf, "PLANILLA DE RENDICIÓN DE GASTOS A CARGO DEL FPL") rescue nil
      self.pdf_separador(pdf, 10) rescue nil

      filas_fpl_presentes = false

      if actividades.present?
        actividades.each do |actividad|
          act_id_num = actividad.id.to_i
          plan_act = map_planes_by_act_id[act_id_num] || map_planes_by_id[act_id_num]
          pk_id_num = plan_act.try(:id).to_i
          mis_ids = [act_id_num, pk_id_num].reject(&:zero?).uniq
          es_reitimizada = (mis_ids & reitimizadas_ids).any?

          gastos_fpl = obtener_gastos.call(actividad.id, ['solicitado al fondo', 'solicitado_al_fondo'])

          items_actividad = []
          [:rrhh_propios, :rrhh_externos, :operaciones, :administracion].each do |cat_key|
            gastos_fpl[cat_key].to_a.each do |item|
              v_unitario = (item.try(:valor_hh) || item.try(:valor_unitario) || item.try(:valor)).to_f
              cat_key_str = cat_key.to_s.strip.downcase
              item_id_num = item.id.to_i

              g_guardado = rendicion_gastos_map["#{pk_id_num}_#{cat_key_str}_#{item_id_num}"] || rendicion_gastos_map["#{act_id_num}_#{cat_key_str}_#{item_id_num}"]
              monto_rendido = g_guardado.present? ? g_guardado.costo_rendido.to_f : 0.0
              cant_rendida = g_guardado.present? ? g_guardado.cantidad_rendida.to_f : 0.0

              totales_resumen[cat_key][:fpl] += monto_rendido
              total_fpl += monto_rendido

              items_actividad << [
                cat_key.to_s.humanize.titleize,
                item.try(:user_name) || item.try(:item) || item.try(:nombre) || '--',
                item.try(:tipo_aporte).to_s,
                ActiveSupport::NumberHelper.number_to_currency(v_unitario, delimiter: '.', precision: 0, format: "%u%n", unit: "$"),
                cant_rendida.to_s,
                ActiveSupport::NumberHelper.number_to_currency(monto_rendido, delimiter: '.', precision: 0, format: "%u%n", unit: "$")
              ]
            end
          end

          if items_actividad.present?
            filas_fpl_presentes = true
            
            header_act_text = "<color rgb='003DA6'><b>#{actividad.correlativo}</b></color> <b>#{actividad.nombre}</b>"
            if es_reitimizada
              header_act_text += " <color rgb='6F42C1'><b>(Reitimizada)</b></color>"
            end

            header_tabla_act = [ [ { content: header_act_text, inline_format: true } ] ]
            pdf.table(header_tabla_act, width: pdf.bounds.width, cell_style: { size: 9, padding: 3, border_color: 'B8DAFF', background_color: 'E0EFF6' })

            tabla_items_act = [
              [ "Categoría", "Ítem / Nombre", "Detalle / Aporte", "Valor Un.", "Cantidad", "Gasto [$]" ]
            ] + items_actividad

            pdf.table(tabla_items_act, width: pdf.bounds.width, cell_style: { size: 7, padding: 3, border_color: 'CCCCCC', inline_format: true }) do
              row(0).background_color = 'F8F9FA'
              row(0).font_style = :bold
              column(0).width = 95
              column(1).width = 155
              column(2).width = 110
              column(3).width = 65
              column(3).align = :right
              column(4).width = 45
              column(4).align = :center
              column(5).width = 82
              column(5).align = :right
            end

            pdf.move_down 8
          end
        end
      end

      unless filas_fpl_presentes
        pdf.text "<i>No hay gastos a cargo del FPL registrados.</i>", size: 8, style: :italic, align: :center
        pdf.move_down 10
      end

      # TOTALIZADOR FPL
      tabla_total_fpl = [
        [ { content: "<b>TOTAL RENDICIÓN FPL:</b>", inline_format: true, align: :right }, "<b>#{ActiveSupport::NumberHelper.number_to_currency(total_fpl, delimiter: '.', precision: 0, format: "%u%n", unit: "$")}</b>" ]
      ]
      pdf.table(tabla_total_fpl, width: pdf.bounds.width, cell_style: { size: 8, padding: 4, background_color: 'F0F0F0', border_color: 'CCCCCC', inline_format: true }) do
        column(0).width = pdf.bounds.width - 100
        column(1).width = 100
        column(1).align = :right
      end

      self.pdf_separador(pdf, 20) rescue nil

      # 4. PLANILLA DE RENDICIÓN DE GASTOS - BENEFICIARIA (ESTILO EVALUACIÓN TÉCNICA)
      self.pdf_titulo_formato(pdf, "PLANILLA DE RENDICIÓN DE GASTOS A CARGO DE LA BENEFICIARIA") rescue nil
      self.pdf_separador(pdf, 10) rescue nil

      filas_ben_presentes = false

      if actividades.present?
        actividades.each do |actividad|
          act_id_num = actividad.id.to_i
          plan_act = map_planes_by_act_id[act_id_num] || map_planes_by_id[act_id_num]
          pk_id_num = plan_act.try(:id).to_i
          mis_ids = [act_id_num, pk_id_num].reject(&:zero?).uniq
          es_reitimizada = (mis_ids & reitimizadas_ids).any?

          gastos_aporte = obtener_gastos.call(actividad.id, ['aporte propio valorado', 'aporte propio liquido', 'aporte_propio_valorado', 'aporte_propio_liquido'])

          items_actividad = []
          [:rrhh_propios, :rrhh_externos, :operaciones, :administracion].each do |cat_key|
            gastos_aporte[cat_key].to_a.each do |item|
              v_unitario = (item.try(:valor_hh) || item.try(:valor_unitario) || item.try(:valor)).to_f
              cat_key_str = cat_key.to_s.strip.downcase
              item_id_num = item.id.to_i

              g_guardado = rendicion_gastos_map["#{pk_id_num}_#{cat_key_str}_#{item_id_num}"] || rendicion_gastos_map["#{act_id_num}_#{cat_key_str}_#{item_id_num}"]
              monto_rendido = g_guardado.present? ? g_guardado.costo_rendido.to_f : 0.0
              cant_rendida = g_guardado.present? ? g_guardado.cantidad_rendida.to_f : 0.0

              totales_resumen[cat_key][:aporte] += monto_rendido
              total_aporte += monto_rendido

              items_actividad << [
                cat_key.to_s.humanize.titleize,
                item.try(:user_name) || item.try(:item) || item.try(:nombre) || '--',
                item.try(:tipo_aporte).to_s,
                ActiveSupport::NumberHelper.number_to_currency(v_unitario, delimiter: '.', precision: 0, format: "%u%n", unit: "$"),
                cant_rendida.to_s,
                ActiveSupport::NumberHelper.number_to_currency(monto_rendido, delimiter: '.', precision: 0, format: "%u%n", unit: "$")
              ]
            end
          end

          if items_actividad.present?
            filas_ben_presentes = true
            
            header_act_text = "<color rgb='003DA6'><b>#{actividad.correlativo}</b></color> <b>#{actividad.nombre}</b>"
            if es_reitimizada
              header_act_text += " <color rgb='6F42C1'><b>(Reitimizada)</b></color>"
            end

            header_tabla_act = [ [ { content: header_act_text, inline_format: true } ] ]
            pdf.table(header_tabla_act, width: pdf.bounds.width, cell_style: { size: 9, padding: 3, border_color: 'B8DAFF', background_color: 'E0EFF6' })

            tabla_items_act = [
              [ "Categoría", "Ítem / Nombre", "Detalle / Aporte", "Valor Un.", "Cantidad", "Gasto [$]" ]
            ] + items_actividad

            pdf.table(tabla_items_act, width: pdf.bounds.width, cell_style: { size: 7, padding: 3, border_color: 'CCCCCC', inline_format: true }) do
              row(0).background_color = 'F8F9FA'
              row(0).font_style = :bold
              column(0).width = 95
              column(1).width = 155
              column(2).width = 110
              column(3).width = 65
              column(3).align = :right
              column(4).width = 45
              column(4).align = :center
              column(5).width = 82
              column(5).align = :right
            end

            pdf.move_down 8
          end
        end
      end

      unless filas_ben_presentes
        pdf.text "<i>No hay aportes a cargo de la beneficiaria registrados.</i>", size: 8, style: :italic, align: :center
        pdf.move_down 10
      end

      # TOTALIZADOR APORTE PROPIO
      tabla_total_ben = [
        [ { content: "<b>TOTAL APORTE PROPIO BENEFICIARIA:</b>", inline_format: true, align: :right }, "<b>#{ActiveSupport::NumberHelper.number_to_currency(total_aporte, delimiter: '.', precision: 0, format: "%u%n", unit: "$")}</b>" ]
      ]
      pdf.table(tabla_total_ben, width: pdf.bounds.width, cell_style: { size: 8, padding: 4, background_color: 'F0F0F0', border_color: 'CCCCCC', inline_format: true }) do
        column(0).width = pdf.bounds.width - 100
        column(1).width = 100
        column(1).align = :right
      end

      self.pdf_separador(pdf, 25) rescue nil

      # =========================================================================
      # 5. ESTRUCTURA DE COSTOS Y RESUMEN FINANCIERO CONSOLIDADO DEL PROYECTO
      # =========================================================================
      self.pdf_sub_titulo_formato(pdf, "RESUMEN FINANCIERO DEL PROYECTO") rescue nil
      self.pdf_separador(pdf, 10) rescue nil

      items_costo = [
        { key: :rrhh_propios, nombre: 'RR HH Propios' },
        { key: :rrhh_externos, nombre: 'RR HH Externos' },
        { key: :gastos_operacion, nombre: 'Gastos de Operación' },
        { key: :gastos_administracion, nombre: 'Gastos de Administración' }
      ]

      base_presupuesto_fpl = Hash.new(0.0)
      base_presupuesto_apo = Hash.new(0.0)

      # Sumar presupuestos aprobados por actividad para todo el proyecto
      all_plan_acts = PlanActividad.where(flujo_id: flujo_actual_id)
      all_plan_acts.each do |p_act|
        act_id = p_act.actividad_id.presence || p_act.id
        g_fpl = obtener_gastos.call(act_id, ['solicitado al fondo', 'solicitado_al_fondo'])
        g_apo = obtener_gastos.call(act_id, ['aporte propio valorado', 'aporte propio liquido', 'aporte_propio_valorado', 'aporte_propio_liquido'])

        [:rrhh_propios, :rrhh_externos, :operaciones, :administracion].each do |cat_k|
          k_std = cat_k == :operaciones ? :gastos_operacion : (cat_k == :administracion ? :gastos_administracion : cat_k)

          g_fpl[cat_k].to_a.each do |item|
            v_u = (item.try(:valor_hh) || item.try(:valor_unitario) || item.try(:valor)).to_f
            cant = (item.try(:hh) || item.try(:cantidad)).to_f
            costo = item.try(:costo).presence || item.try(:total).presence || (v_u * cant)
            base_presupuesto_fpl[k_std] += costo.to_f
          end

          g_apo[cat_k].to_a.each do |item|
            v_u = (item.try(:valor_hh) || item.try(:valor_unitario) || item.try(:valor)).to_f
            cant = (item.try(:hh) || item.try(:cantidad)).to_f
            costo = item.try(:costo).presence || item.try(:total).presence || (v_u * cant)
            base_presupuesto_apo[k_std] += costo.to_f
          end
        end
      end

      # Gastos rendidos acumulados de todas las rendiciones del proyecto
      rend_ids_todas = RendicionFpl.where(flujo_id: flujo_actual_id).pluck(:id)
      todos_los_gastos = RendicionGastoFpl.where(rendicion_fpl_id: rend_ids_todas).to_a rescue []

      cat_key_map = { 
        'rrhh_propios' => :rrhh_propios, 
        'rrhh_externos' => :rrhh_externos, 
        'operaciones' => :gastos_operacion, 
        'gastos_operacion' => :gastos_operacion, 
        'administracion' => :gastos_administracion, 
        'gastos_administracion' => :gastos_administracion 
      }

      ren_acum_fpl = Hash.new(0.0)
      ren_acum_apo = Hash.new(0.0)

      todos_los_gastos.each do |g|
        c_key = cat_key_map[g.categoria.to_s.downcase] || g.categoria.to_s.to_sym
        val_rend = g.costo_rendido.to_f
        es_fpl_item = g.tipo_aporte.to_s.downcase.include?('solicitado') || g.tipo_aporte.to_s.downcase.include?('fondo')

        if es_fpl_item
          ren_acum_fpl[c_key] += val_rend
        else
          ren_acum_apo[c_key] += val_rend
        end
      end

      data_costos = { total: {}, fpl: {}, aporte: {} }
      items_costo.each do |item|
        k = item[:key]

        tot_f = base_presupuesto_fpl[k].to_f
        ren_f = ren_acum_fpl[k].to_f

        tot_a = base_presupuesto_apo[k].to_f
        ren_a = ren_acum_apo[k].to_f

        data_costos[:fpl][k] = { tot: tot_f, ren: ren_f }
        data_costos[:aporte][k] = { tot: tot_a, ren: ren_a }
        data_costos[:total][k] = { tot: tot_f + tot_a, ren: ren_f + ren_a }
      end

      ancho_medio = (pdf.bounds.width - 10) / 2.0
      y_pos_tablas = pdf.cursor

      # TABLA 5.1: A Cargo del Fondo PL
      pdf.bounding_box([pdf.bounds.left, y_pos_tablas], width: ancho_medio) do
        header_fpl_box = [ [ { content: "<b>A Cargo del Fondo PL</b>", inline_format: true } ] ]
        pdf.table(header_fpl_box, width: ancho_medio, cell_style: { size: 8, padding: 4, background_color: 'E0EFF6', border_color: 'B8DAFF' })

        nodes_fpl = data_costos[:fpl]
        rows_fpl = [ [ "Ítem de Gasto", "Total", "Gastos Rendidos", "por Rendir", "% Ejec." ] ]

        items_costo.each do |item|
          k = item[:key]
          node = nodes_fpl[k] || { tot: 0.0, ren: 0.0 }
          tot = node[:tot].to_f
          ren = node[:ren].to_f
          por_ren = tot - ren
          pct = tot > 0 ? (ren / tot * 100) : 0.0

          rows_fpl << [
            item[:nombre],
            fmt_clp.call(tot),
            fmt_clp.call(ren),
            fmt_clp.call(por_ren),
            fmt_pct.call(pct)
          ]
        end

        tot_gen_f = nodes_fpl.values.sum { |v| v[:tot].to_f }
        ren_gen_f = nodes_fpl.values.sum { |v| v[:ren].to_f }
        por_ren_f = tot_gen_f - ren_gen_f
        pct_gen_f = tot_gen_f > 0 ? (ren_gen_f / tot_gen_f * 100) : 0.0

        rows_fpl << [
          "<b>TOTAL</b>",
          "<b>#{fmt_clp.call(tot_gen_f)}</b>",
          "<b>#{fmt_clp.call(ren_gen_f)}</b>",
          "<b>#{fmt_clp.call(por_ren_f)}</b>",
          "<b>#{fmt_pct.call(pct_gen_f)}</b>"
        ]

        pdf.table(rows_fpl, width: ancho_medio, cell_style: { size: 6.5, padding: 3, border_color: 'CCCCCC', inline_format: true }) do
          row(0).background_color = 'E0EFF6'
          row(0).font_style = :bold
          column(0).width = 85
          column(1).align = :right
          column(2).align = :right
          column(3).align = :right
          column(4).align = :center
          row(-1).background_color = 'F0F0F0'
        end
      end

      height_fpl = y_pos_tablas - pdf.cursor

      # TABLA 5.2: A Cargo del Beneficiario
      pdf.bounding_box([pdf.bounds.left + ancho_medio + 10, y_pos_tablas], width: ancho_medio) do
        header_apo_box = [ [ { content: "<b>A Cargo del Beneficiario</b>", inline_format: true } ] ]
        pdf.table(header_apo_box, width: ancho_medio, cell_style: { size: 8, padding: 4, background_color: 'E0EFF6', border_color: 'B8DAFF' })

        nodes_apo = data_costos[:aporte]
        rows_apo = [ [ "Ítem de Gasto", "Total", "Gastos Rendidos", "por Rendir", "% Ejec." ] ]

        items_costo.each do |item|
          k = item[:key]
          node = nodes_apo[k] || { tot: 0.0, ren: 0.0 }
          tot = node[:tot].to_f
          ren = node[:ren].to_f
          por_ren = tot - ren
          pct = tot > 0 ? (ren / tot * 100) : 0.0

          rows_apo << [
            item[:nombre],
            fmt_clp.call(tot),
            fmt_clp.call(ren),
            fmt_clp.call(por_ren),
            fmt_pct.call(pct)
          ]
        end

        tot_gen_a = nodes_apo.values.sum { |v| v[:tot].to_f }
        ren_gen_a = nodes_apo.values.sum { |v| v[:ren].to_f }
        por_ren_a = tot_gen_a - ren_gen_a
        pct_gen_a = tot_gen_a > 0 ? (ren_gen_a / tot_gen_a * 100) : 0.0

        rows_apo << [
          "<b>TOTAL</b>",
          "<b>#{fmt_clp.call(tot_gen_a)}</b>",
          "<b>#{fmt_clp.call(ren_gen_a)}</b>",
          "<b>#{fmt_clp.call(por_ren_a)}</b>",
          "<b>#{fmt_pct.call(pct_gen_a)}</b>"
        ]

        pdf.table(rows_apo, width: ancho_medio, cell_style: { size: 6.5, padding: 3, border_color: 'CCCCCC', inline_format: true }) do
          row(0).background_color = 'E0EFF6'
          row(0).font_style = :bold
          column(0).width = 85
          column(1).align = :right
          column(2).align = :right
          column(3).align = :right
          column(4).align = :center
          row(-1).background_color = 'F0F0F0'
        end
      end

      pdf.move_cursor_to(y_pos_tablas - height_fpl)
      self.pdf_separador(pdf, 12) rescue nil

      # TABLA 5.3: Total del Proyecto (Consolidado)
      header_total_box = [
        [
          { content: "<b>Total del Proyecto (Consolidado)</b>", inline_format: true },
          { content: "Resumen General", align: :right, inline_format: true }
        ]
      ]
      pdf.table(header_total_box, width: pdf.bounds.width, cell_style: { size: 8.5, padding: 4, background_color: '5D759E', text_color: 'FFFFFF', border_color: '5D759E' })

      rows_tot = [ [ "Ítem de Gasto", "Presupuesto Total", "Gastos Rendidos", "Pendiente por Rendir", "% Ejecución Acumulada" ] ]

      nodes_tot = data_costos[:total]
      items_costo.each do |item|
        k = item[:key]
        node = nodes_tot[k] || { tot: 0.0, ren: 0.0 }
        tot = node[:tot].to_f
        ren = node[:ren].to_f
        por_ren = tot - ren
        pct = tot > 0 ? (ren / tot * 100) : 0.0

        rows_tot << [
          "<b>#{item[:nombre]}</b>",
          fmt_clp.call(tot),
          fmt_clp.call(ren),
          fmt_clp.call(por_ren),
          fmt_pct.call(pct)
        ]
      end

      tot_gen_t = nodes_tot.values.sum { |v| v[:tot].to_f }
      ren_gen_t = nodes_tot.values.sum { |v| v[:ren].to_f }
      por_ren_t = tot_gen_t - ren_gen_t
      pct_gen_t = tot_gen_t > 0 ? (ren_gen_t / tot_gen_t * 100) : 0.0

      rows_tot << [
        "<color rgb='004085'><b>TOTAL CONSOLIDADO PROYECTO</b></color>",
        "<color rgb='004085'><b>#{fmt_clp.call(tot_gen_t)}</b></color>",
        "<color rgb='28A745'><b>#{fmt_clp.call(ren_gen_t)}</b></color>",
        "<color rgb='DC3545'><b>#{fmt_clp.call(por_ren_t)}</b></color>",
        "<b>#{fmt_pct.call(pct_gen_t)}</b>"
      ]

      pdf.table(rows_tot, width: pdf.bounds.width, cell_style: { size: 7.5, padding: 4, border_color: 'CCCCCC', inline_format: true }) do
        row(0).background_color = 'E0EFF6'
        row(0).font_style = :bold
        column(0).width = 150
        column(1).align = :right
        column(2).align = :right
        column(3).align = :right
        column(4).align = :center
        row(-1).background_color = 'E0EFF6'
      end

      self.pdf_separador(pdf, 25) rescue nil

      texto_declaracion = "La información que respalda esta rendición de gastos, se encuentra disponible en las dependencias de <b>#{razon_social}</b>, para consulta o revisión del Agencia de Sustentabilidad y Cambio Climático u otro organismo fiscalizador.\n\nDeclaro bajo juramento que los datos contenidos en esta rendición de gastos son verídicos. Asimismo, declaro conocer las disposiciones relativas a sanciones en caso de suministrar información incompleta, falsa o errónea."
      pdf.font_size(7) do
        pdf.text texto_declaracion, inline_format: true, align: :justify, color: '333333'
      end

      self.pdf_separador(pdf, 35) rescue nil

      ancho_firma = 220
      posicion_x = pdf.bounds.width - ancho_firma

      pdf.bounding_box([posicion_x, pdf.cursor], width: ancho_firma, height: 80) do
        logo_firma_path = Rails.root.join("app/assets/images/logo_ascc_firma.png")
        
        if File.exist?(logo_firma_path)
          y_inicio = pdf.cursor
          # Dibujar el logo en el fondo con opacidad tenue sin desplazar el cursor
          pdf.transparent(0.25) do
            pdf.image logo_firma_path, width: 75, at: [(ancho_firma - 75) / 2, y_inicio]
          end
        end

        # Posicionar la línea a la mitad del logo para que quede sobrepuesto
        pdf.move_down 35

        pdf.stroke_color '333333'
        pdf.line_width 0.8

        pdf.move_down 4

        pdf.font "DejaVuSans", style: :bold do
          pdf.text nombre_postulante.to_s.upcase, size: 8, align: :center, color: '000000'
        end

        pdf.font "DejaVuSans", style: :bold do
          pdf.text rut_postulante.to_s.upcase, size: 8, align: :center, color: '000000'
        end

        pdf.font "DejaVuSans", style: :normal do
          pdf.text "Revisor Contable", size: 7.5, align: :center, color: '555555'
        end
      end

    end

    # SUBIDA RÁPIDA VÍA CARRIERWAVE
    pdf_string = pdf.render
    pdf_file_name = "informe_gastos_#{self.try(:id) || 'temp'}_#{revision}.pdf"

    ruta_temporal = Rails.root.join("tmp", pdf_file_name)
    File.binwrite(ruta_temporal, pdf_string)

    File.open(ruta_temporal) do |archivo_fisico|
      uploader_class = Class.new(CarrierWave::Uploader::Base) do
        def store_dir
          "accion/public/uploads/fondo_produccion_limpia/informe_gastos"
        end
      end

      uploader = uploader_class.new
      uploader.store!(archivo_fisico)
    end

    File.delete(ruta_temporal) if File.exist?(ruta_temporal)

    pdf_string

  rescue StandardError => e
    tiempo_total = Time.now - t_inicio
    Rails.logger.error "=== [PDF INFORME GASTOS ERROR] FALLA a los #{tiempo_total}s: #{e.class} - #{e.message} ==="
    Rails.logger.error e.backtrace.join("\n")
    nil
  end

  def number_to_clp(numero)
    ActiveSupport::NumberHelper.number_to_currency(numero, delimiter: '.', separator: ',', precision: 0, format: "%u%n", unit: "$")
  end

  def nombre
    nombre_acuerdo.presence || codigo_proyecto
  end

  # Método generador del Informe de Ejecución de Actividades en PDF con Prawn
  def generar_informe_actividades_pdf(revision = nil, fondo_produccion_limpia = nil, rendicion = nil, actividades = nil)
    t_inicio = Time.now
    Rails.logger.info "=== [PDF INFORME ACTIVIDADES MODELO] INICIANDO GENERACIÓN CORREGIDA ==="

    # Margen superior ajustado a 60 para alojar el encabezado sin requerir un bounding_box externo
    pdf = Prawn::Document.new(page_size: 'LETTER', page_layout: :landscape, margin: [60, 30, 25, 30])

    # Configuración de Fuentes DejaVuSans
    font_path_regular = Rails.root.join("app/assets/fonts/DejaVuSans.ttf").to_s
    font_path_bold    = Rails.root.join("app/assets/fonts/DejaVuSans-Bold.ttf").to_s

    pdf.font_families.update("DejaVuSans" => {
      normal: font_path_regular,
      bold:   File.exist?(font_path_bold) ? font_path_bold : font_path_regular
    })
    pdf.font "DejaVuSans"

    # Header repetitivo posicionado dentro del margen superior
    pdf.repeat :all do
      pdf.bounding_box [pdf.bounds.left, pdf.bounds.top + 48], width: pdf.bounds.width, height: 45 do
        logo_path = Rails.root.join("app/assets/images/logo-ascc-nuevo.png")
        pdf.image logo_path, width: 115 if File.exist?(logo_path)

        pdf.bounding_box [pdf.bounds.width - 300, 43], width: 300, height: 18 do
          pdf.font "DejaVuSans", style: :bold do
            pdf.text "INFORME DE EJECUCIÓN DE ACTIVIDADES", size: 9, color: "003DA6", align: :right
          end
        end

        pdf.move_cursor_to 5
        pdf.stroke do
          pdf.stroke_color '003DA6'
          pdf.line_width 2
          pdf.stroke_horizontal_rule
        end
      end
    end

    fpl = fondo_produccion_limpia || self
    contribuyente = obtiene_contribuyente(fpl&.institucion_entregables_id) rescue nil
    razon_social = contribuyente&.razon_social || "Nombre Beneficiaria"
    rut_beneficiaria = contribuyente.present? ? "#{contribuyente.rut}-#{contribuyente.dv}" : "RUT Beneficiaria"
    programa_texto = fpl.try(:programa).presence || "--"
    
    flujo_mdi = FondoProduccionLimpia.where(id: fpl.id).pluck(:flujo_apl_id) rescue []
    mdi_id = Flujo.where(id: flujo_mdi).pluck(:manifestacion_de_interes_id) rescue []
    nombre_acuerdo = ManifestacionDeInteres.where(id: mdi_id).pluck(:nombre_acuerdo).first rescue nil
    
    cod_fpl = fpl.respond_to?(:codigo_proyecto_fpl) ? fpl.codigo_proyecto_fpl : fpl.try(:codigo_proyecto).to_s
    titulo_proyecto = nombre_acuerdo.present? ? "#{cod_fpl} - #{nombre_acuerdo}" : cod_fpl

    postulante = User.find_by(id: (fpl.try(:usuario_entregables_id)))
    nombre_postulante = postulante.try(:nombre_completo)
    rut_postulante = postulante.try(:rut)
    
    mes_actual_num = rendicion&.mes_a_rendir.to_i
    fecha_res = fpl.try(:fecha_resolucion)
    mes_nombre = nil

    if fecha_res.present? && mes_actual_num > 0
      fecha_target = fecha_res.to_date + (mes_actual_num - 1).months
      mes_nombre = (I18n.l(fecha_target, format: '%B %Y') rescue fecha_target.strftime('%B %Y')).capitalize
    end

    texto_mes_display = mes_nombre.present? ? "#{mes_nombre} (Rendición #{mes_actual_num})" : "Rendición #{mes_actual_num}"

    # MAPA DUAL DE TRADUCCIÓN DE IDs DE PLAN ACTIVIDADES
    flujo_id_ref = fpl.try(:flujo_id) || rendicion.try(:flujo_id)
    map_planes_by_id = PlanActividad.where(flujo_id: flujo_id_ref).index_by(&:id)
    get_act_id = lambda { |db_id| plan = map_planes_by_id[db_id.to_i]; plan.try(:actividad_id).to_i > 0 ? plan.actividad_id.to_i : db_id.to_i }

    # IDENTIFICACIÓN ROBUSTA DE ACTIVIDADES REITIMIZADAS
    arr_planes = map_planes_by_id.values
    reitimizadas_ids = arr_planes.select { |p| [true, 'true', '1', 1, 't'].include?(p.autorizado) || p.try(:archivo_reitimizacion).to_s.present? }.flat_map { |p| [p.actividad_id.to_i, p.id.to_i] }.compact.reject(&:zero?).uniq

    tarea_fondo_fpl_13 = Tarea.find_by_codigo(Tarea::COD_FPL_13)

    extraer_mes_data = lambda do |tp|
      return nil if tp&.data.blank?
      d = tp.data
      if d.is_a?(Hash) || d.respond_to?(:[])
        d[:mes_a_rendir] || d['mes_a_rendir'] || d.dig(:params, :mes_a_rendir) || d.dig('params', 'mes_a_rendir')
      else
        match = d.to_s.match(/mes_a_rendir[^\d]*(\d+)/)
        match ? match[1] : nil
      end
    end

    tps_13 = TareaPendiente.where(tarea_id: tarea_fondo_fpl_13&.id, flujo_id: fpl.flujo_id)
    tp_13  = tps_13.find { |tp| extraer_mes_data.call(tp).to_i == mes_actual_num } || tps_13.last

    f_envio_raw  = tp_13&.created_at
    fecha_envio_informe  = f_envio_raw.respond_to?(:strftime)  ? f_envio_raw.strftime('%d/%m/%Y')  : "--"
  
    es_tecnica_tab = lambda do |d|
      return true if d.respond_to?(:tecnica?) && d.tecnica?
      tipo = d.try(:tipo_tab).to_s.downcase
      tipo == 'tecnica' || tipo == '0'
    end

    pdf.font "DejaVuSans", style: :bold do
      pdf.text "INFORME DE EJECUCIÓN DE ACTIVIDADES", size: 11, color: "000000"
    end
    pdf.move_down 6

    # Sección I
    self.pdf_sub_titulo_formato(pdf, "I.- IDENTIFICACIÓN DEL SERVICIO O ENTIDAD QUE TRANSFIRIÓ LOS RECURSOS") rescue nil

    tabla_i = [
      [ { content: "<b>Nombre servicio otorgante:</b>", inline_format: true }, "Agencia de Sustentabilidad y Cambio Climático", { content: "<b>Tipo Informe:</b>", inline_format: true }, "MENSUAL" ],
      [ { content: "<b>Origen recursos:</b>", inline_format: true }, "FPL", { content: "<b>Mes / Año:</b>", inline_format: true }, texto_mes_display ]
    ]

    pdf.table(tabla_i, width: pdf.bounds.width, cell_style: { size: 7.5, padding: 3, border_color: 'CCCCCC', inline_format: true }) do
      column(0).background_color = 'E0EFF6'
      column(2).background_color = 'E0EFF6'
    end

    pdf.move_down 6

    # Sección II
    self.pdf_sub_titulo_formato(pdf, "II.- IDENTIFICACIÓN DEL SERVICIO O ENTIDAD QUE RECIBIÓ Y EJECUTÓ LOS RECURSOS") rescue nil

    tabla_ii = [
      [ { content: "<b>Entidad receptora:</b>", inline_format: true }, razon_social, { content: "<b>RUT:</b>", inline_format: true }, rut_beneficiaria ],
      [ { content: "<b>Programa:</b>", inline_format: true }, { content: programa_texto, colspan: 3 } ],
      [ { content: "<b>Aplica SISREC:</b>", inline_format: true }, "No Aplica", { content: "<b>Código SISREC:</b>", inline_format: true }, 'No Aplica' ],
      [ { content: "<b>Código Externo:</b>", inline_format: true }, fpl.try(:codigo_proyecto).to_s, { content: "<b>Nombre del Proyecto:</b>", inline_format: true }, { content: titulo_proyecto } ],
      [ { content: "<b>Período de Rendición:</b>", inline_format: true }, { content: texto_mes_display, colspan: 3 } ],
      [ { content: "<b>Fecha de Envío de Informe:</b>", inline_format: true }, { content: fecha_envio_informe, colspan: 3 } ],
    ]

    pdf.table(tabla_ii, width: pdf.bounds.width, cell_style: { size: 7.5, padding: 3, border_color: 'CCCCCC', inline_format: true }) do
      column(0).background_color = 'E0EFF6'
      column(2).background_color = 'E0EFF6'
    end

    pdf.move_down 6

    # Sección III
    self.pdf_sub_titulo_formato(pdf, "III.- GRADO DE CUMPLIMIENTO DE LAS ACTIVIDADES REALIZADAS") rescue nil

    tabla_act = [
      [ "N°", "Nombre de la Actividad", "Fecha Inicio", "Fecha Término", "Monto Rendido", "%", "Descripción del Avance", "Medio de Verificación" ]
    ]

    detalles_fpl_array = (rendicion.present? && rendicion.respond_to?(:rendicion_detalles_fpl)) ? rendicion.rendicion_detalles_fpl.to_a : []
    gastos_fpl_array   = (rendicion.present? && rendicion.respond_to?(:rendicion_gastos_fpl)) ? rendicion.rendicion_gastos_fpl.to_a : []

    if actividades.present?
      actividades.each do |act|
        act_id_num = act.id.to_i
        
        # Recuperar ID interno y validación de reitimización
        plan_act = map_planes_by_id.values.find { |p| p.actividad_id.to_i == act_id_num || p.id.to_i == act_id_num }
        pk_id_num = plan_act.try(:id).to_i
        mis_ids = [act_id_num, pk_id_num].reject(&:zero?).uniq
        es_reitimizada = (mis_ids & reitimizadas_ids).any?

        nombre_actividad_display = act.try(:nombre).to_s
        if es_reitimizada
          nombre_actividad_display += "\n<color rgb='6F42C1'><b>(Reitemización autorizada)</b></color>"
        end

        # BÚSQUEDA TRADUCIDA DEL DETALLE TÉCNICO
        detalle_tecnico = detalles_fpl_array.find do |d|
          act_ids = (d.rendicion_detalle_actividades_fpl.to_a.map(&:plan_actividad_id) rescue []).compact.map(&get_act_id)
          act_ids += (d.rendicion_detalle_actividades_fpl.to_a.map(&:plan_actividad_id) rescue []).compact.map(&:to_i)
          es_tecnica_tab.call(d) && act_ids.include?(act_id_num)
        end

        # SUMA DE GASTOS ASOCIADOS TRADUCIDA
        gastos_asociados = gastos_fpl_array.select do |g|
          p_id = g.try(:plan_actividad_id).to_i
          p_id == act_id_num || get_act_id.call(p_id) == act_id_num
        end

        monto_rendido_total = gastos_asociados.sum { |g| g.try(:costo_rendido).to_f }

        avance_num = detalle_tecnico&.nivel_avance.to_i
        porcentaje = "#{avance_num}%"
        descripcion_avance = avance_num >= 100 ? "Finalizado" : "en Ejecución"

        archivos_actividad = []

        if detalle_tecnico.present? && detalle_tecnico.archivo.present?
          nom = detalle_tecnico.try(:archivo_identifier) || detalle_tecnico.archivo.try(:identifier) || (File.basename(detalle_tecnico.archivo.to_s) rescue nil)
          archivos_actividad << nom if nom.present?
        end

        if archivos_actividad.empty?
          detalles_docs_fin = detalles_fpl_array.select do |d|
            next false unless d.archivo.present?
            act_ids = (d.rendicion_detalle_actividades_fpl.to_a.map(&:plan_actividad_id) rescue []).compact.map(&get_act_id)
            act_ids += (d.rendicion_detalle_actividades_fpl.to_a.map(&:plan_actividad_id) rescue []).compact.map(&:to_i)
            !es_tecnica_tab.call(d) && act_ids.include?(act_id_num)
          end

          detalles_docs_fin.each do |d|
            nom = d.try(:archivo_identifier) || d.archivo.try(:identifier) || (File.basename(d.archivo.to_s) rescue nil)
            archivos_actividad << nom if nom.present?
          end
        end

        nombres_archivos = archivos_actividad.compact.uniq.join(", ")
        nombres_archivos = "Sin adjuntos" if nombres_archivos.blank?

        f_inicio = detalle_tecnico&.fecha_inicio
        f_inicio_str = f_inicio.respond_to?(:strftime) ? f_inicio.strftime('%d/%m/%Y') : f_inicio.to_s.presence || "--"

        f_termino = detalle_tecnico&.fecha_termino
        f_termino_str = f_termino.respond_to?(:strftime) ? f_termino.strftime('%d/%m/%Y') : f_termino.to_s.presence || "--"

        monto_fmt = ActiveSupport::NumberHelper.number_to_currency(monto_rendido_total, delimiter: '.', precision: 0, format: "%u%n", unit: "$")

        tabla_act << [
          act.try(:correlativo).to_s,
          nombre_actividad_display,
          f_inicio_str,
          f_termino_str,
          monto_fmt,
          porcentaje,
          descripcion_avance,
          nombres_archivos
        ]
      end
    else
      tabla_act << [ "-", "Sin actividades reportadas", "-", "-", "$0", "0%", "-", "-" ]
    end

    pdf.table(tabla_act, width: pdf.bounds.width, cell_style: { size: 7, padding: 3, border_color: 'CCCCCC', inline_format: true }) do
      row(0).background_color = 'E0EFF6'
      row(0).font_style = :bold
      column(0).width = 25
      column(0).align = :center
      column(2).width = 55
      column(2).align = :center
      column(3).width = 55
      column(3).align = :center
      column(4).width = 65
      column(4).align = :right
      column(5).width = 30
      column(5).align = :center
    end

    pdf.move_down 6

    pdf.font_size(7.5) do
      pdf.text "<b>RESULTADO DE LAS ACTIVIDADES REALIZADAS:</b>", inline_format: true
      pdf.text rendicion&.resultado_actividades_realizadas.presence || "No especificado.", color: '333333'
      pdf.move_down 4

      pdf.text "<b>INFORMACIÓN ADICIONAL (OPCIONAL):</b>", inline_format: true
      pdf.text rendicion&.informacion_adicional.presence || "No especificada.", color: '333333'
      pdf.move_down 4

      pdf.text "<b>CONCLUSIÓN:</b>", inline_format: true
      pdf.text rendicion&.conclusion.presence || "No especificada.", color: '333333'
    end

    pdf.move_down 8

    self.pdf_sub_titulo_formato(pdf, "IV.- DATOS DE LOS FUNCIONARIOS RESPONSABLES DE LA EJECUCIÓN DE LAS ACTIVIDADES") rescue nil
    pdf.move_down 5

    tabla_funcionarios = [
      [ "Nombre del Responsable", "___________________________", "", "Nombre del Responsable", "___________________________" ],
      [ "RUT",                    "___________________________", "", "RUT",                    "___________________________" ],
      [ "Cargo",                  "___________________________", "", "Cargo",                  "___________________________" ],
      [ "Dependencia",            "___________________________", "", "Dependencia",            "___________________________" ]
    ]

    pdf.table(tabla_funcionarios, cell_style: { size: 7.5, padding: 2, borders: [] }) do
      column(0).font_style = :bold
      column(3).font_style = :bold
      column(2).width = 50
    end

    pdf.move_down 12

    ancho_firma = 220
    posicion_x = pdf.bounds.width - ancho_firma

    pdf.bounding_box([posicion_x, pdf.cursor], width: ancho_firma, height: 80) do
      logo_firma_path = Rails.root.join("app/assets/images/logo_ascc_firma.png")
      
      if File.exist?(logo_firma_path)
        y_inicio = pdf.cursor
        # Dibujar el logo en el fondo con opacidad tenue sin desplazar el cursor
        pdf.transparent(0.25) do
          pdf.image logo_firma_path, width: 75, at: [(ancho_firma - 75) / 2, y_inicio]
        end
      end

      # Posicionar la línea a la mitad del logo para que quede sobrepuesto
      pdf.move_down 35

      pdf.stroke_color '333333'
      pdf.line_width 0.8
      
      pdf.move_down 4

      pdf.font "DejaVuSans", style: :bold do
        pdf.text nombre_postulante.to_s.upcase, size: 8, align: :center, color: '000000'
      end

      pdf.font "DejaVuSans", style: :bold do
        pdf.text rut_postulante.to_s.upcase, size: 8, align: :center, color: '000000'
      end

      pdf.font "DejaVuSans", style: :normal do
        pdf.text "Responsable Postulante", size: 7.5, align: :center, color: '555555'
      end
    end

    pdf_string = pdf.render
    pdf_file_name = "informe_ejecucion_actividades_#{self.try(:id) || 'temp'}.pdf"

    ruta_temporal = Rails.root.join("tmp", pdf_file_name)
    File.binwrite(ruta_temporal, pdf_string)

    File.open(ruta_temporal) do |archivo_fisico|
      uploader_class = Class.new(CarrierWave::Uploader::Base) do
        def store_dir
          "accion/public/uploads/fondo_produccion_limpia/informe_actividades"
        end
      end
      uploader = uploader_class.new
      uploader.store!(archivo_fisico)
    end

    File.delete(ruta_temporal) if File.exist?(ruta_temporal)

    pdf_string
  rescue StandardError => e
    Rails.logger.error "=== [ERROR GENERANDO PDF ACTIVIDADES MODELO] #{e.class} - #{e.message} ==="
    Rails.logger.error e.backtrace.join("\n")
    nil
  end

  # Método generador del Informe Técnico de Evaluación por Actividad en PDF (Prawn)
  def generar_informe_evaluacion_tecnica_pdf(revision = nil, fondo_produccion_limpia = nil, rendicion = nil, actividades = nil)
    t_inicio = Time.now
    Rails.logger.info "=== [PDF INFORME TÉCNICO ACTIVIDADES] INICIANDO GENERACIÓN ==="

    pdf = Prawn::Document.new(page_size: 'LETTER', page_layout: :landscape, margin: [30, 30, 30, 30])

    font_path_regular = Rails.root.join("app/assets/fonts/DejaVuSans.ttf").to_s
    font_path_bold    = Rails.root.join("app/assets/fonts/DejaVuSans-Bold.ttf").to_s

    pdf.font_families.update("DejaVuSans" => {
      normal: font_path_regular,
      bold:   File.exist?(font_path_bold) ? font_path_bold : font_path_regular
    })
    pdf.font "DejaVuSans"

    pdf.repeat :all do
      pdf.bounding_box [pdf.bounds.left, pdf.bounds.top], width: pdf.bounds.width, height: 50 do
        logo_path = Rails.root.join("app/assets/images/logo-ascc-nuevo.png")
        pdf.image logo_path, width: 119 if File.exist?(logo_path)

        pdf.bounding_box [pdf.bounds.width - 300, 48], width: 300, height: 20 do
          pdf.font "DejaVuSans", style: :bold do
            pdf.text "INFORME DE EVALUACIÓN DE ACTIVIDADES", size: 9, color: "003DA6", align: :right
          end
        end

        pdf.move_cursor_to 8
        pdf.stroke do
          pdf.stroke_color '003DA6'
          pdf.line_width 2.5
          pdf.stroke_horizontal_rule
        end
      end
    end

    fpl = fondo_produccion_limpia || self
    contribuyente = obtiene_contribuyente(fpl&.institucion_entregables_id) rescue nil
    razon_social = contribuyente&.razon_social || "Nombre Beneficiaria"
    rut_beneficiaria = contribuyente.present? ? "#{contribuyente.rut}-#{contribuyente.dv}" : "RUT Beneficiaria"
    programa_texto = fpl.try(:programa).presence || "--"
    
    flujo_mdi = FondoProduccionLimpia.where(id: fpl.id).pluck(:flujo_apl_id) rescue []
    mdi_id = Flujo.where(id: flujo_mdi).pluck(:manifestacion_de_interes_id) rescue []
    nombre_acuerdo = ManifestacionDeInteres.where(id: mdi_id).pluck(:nombre_acuerdo).first rescue nil
    
    cod_fpl = fpl.respond_to?(:codigo_proyecto_fpl) ? fpl.codigo_proyecto_fpl : fpl.try(:codigo_proyecto).to_s
    titulo_proyecto = nombre_acuerdo.present? ? "#{cod_fpl} - #{nombre_acuerdo}" : cod_fpl

    revisor = User.find_by(id: (rendicion.try(:revisor_tecnico_id)))
    nombre_revisor = revisor.try(:nombre_completo)
    rut_revisor = revisor.try(:rut)

    mes_actual_num = rendicion&.mes_a_rendir.to_i
    fecha_res = fpl.try(:fecha_resolucion)
    mes_nombre = nil

    if fecha_res.present? && mes_actual_num > 0
      fecha_target = fecha_res.to_date + (mes_actual_num - 1).months
      mes_nombre = (I18n.l(fecha_target, format: '%B %Y') rescue fecha_target.strftime('%B %Y')).capitalize
    end

    texto_mes_display = mes_nombre.present? ? "#{mes_nombre} (Rendición #{mes_actual_num})" : "Rendición #{mes_actual_num}"

    es_tecnica_tab = lambda do |d|
      return true if d.respond_to?(:tecnica?) && d.tecnica?
      tipo = d.try(:tipo_tab).to_s.downcase
      tipo == 'tecnica' || tipo == '0'
    end

    detalles_fpl_array = (rendicion.present? && rendicion.respond_to?(:rendicion_detalles_fpl)) ? rendicion.rendicion_detalles_fpl.to_a : []
    flujo_id_ref = fpl.try(:flujo_id) || rendicion.try(:flujo_id)
    
    map_planes_by_id = PlanActividad.where(flujo_id: flujo_id_ref).index_by(&:id)
    get_act_id = lambda { |db_id| plan = map_planes_by_id[db_id.to_i]; plan.try(:actividad_id).to_i > 0 ? plan.actividad_id.to_i : db_id.to_i }
    detalles_hash = PlanActividad.where(flujo_id: flujo_id_ref).index_by { |d| (d.try(:actividad_id).presence || d.id).to_i } rescue {}

    # IDENTIFICACIÓN ROBUSTA DE ACTIVIDADES REITIMIZADAS
    arr_planes = map_planes_by_id.values
    reitimizadas_ids = arr_planes.select { |p| [true, 'true', '1', 1, 't'].include?(p.autorizado) || p.try(:archivo_reitimizacion).to_s.present? }.flat_map { |p| [p.actividad_id.to_i, p.id.to_i] }.compact.reject(&:zero?).uniq

    tarea_fondo_fpl_13 = Tarea.find_by_codigo(Tarea::COD_FPL_13)
    tarea_fondo_fpl_15 = Tarea.find_by_codigo(Tarea::COD_FPL_15)

    extraer_mes_data = lambda do |tp|
      return nil if tp&.data.blank?
      d = tp.data
      if d.is_a?(Hash) || d.respond_to?(:[])
        d[:mes_a_rendir] || d['mes_a_rendir'] || d.dig(:params, :mes_a_rendir) || d.dig('params', 'mes_a_rendir')
      else
        match = d.to_s.match(/mes_a_rendir[^\d]*(\d+)/)
        match ? match[1] : nil
      end
    end

    tps_13 = TareaPendiente.where(tarea_id: tarea_fondo_fpl_13&.id, flujo_id: flujo_id_ref)
    tp_13  = tps_13.find { |tp| extraer_mes_data.call(tp).to_i == mes_actual_num } || tps_13.last

    tps_15 = TareaPendiente.where(tarea_id: tarea_fondo_fpl_15&.id, flujo_id: flujo_id_ref)
    tp_15  = tps_15.find { |tp| extraer_mes_data.call(tp).to_i == mes_actual_num } || tps_15.last

    f_recepcion_raw  = tp_13&.created_at
    f_evaluacion_raw = tp_15&.updated_at || tp_15&.created_at

    fecha_recepcion  = f_recepcion_raw.respond_to?(:strftime)  ? f_recepcion_raw.strftime('%d/%m/%Y')  : "--"
    fecha_evaluacion = f_evaluacion_raw.respond_to?(:strftime) ? f_evaluacion_raw.strftime('%d/%m/%Y') : "--"
    
    pdf.bounding_box [pdf.bounds.left, pdf.bounds.top - 65], width: pdf.bounds.width do

      pdf.font "DejaVuSans", style: :bold do
        pdf.text "INFORME DE EVALUACIÓN DE ACTIVIDADES", size: 11, color: "000000"
      end
      pdf.move_down 8

      # Sección I
      self.pdf_sub_titulo_formato(pdf, "I.- IDENTIFICACIÓN DEL SERVICIO O ENTIDAD QUE TRANSFIRIÓ LOS RECURSOS") rescue nil

      tabla_i = [
        [ { content: "<b>Nombre servicio otorgante:</b>", inline_format: true }, "Agencia de Sustentabilidad y Cambio Climático", { content: "<b>Tipo Informe:</b>", inline_format: true }, "MENSUAL" ],
        [ { content: "<b>Origen recursos:</b>", inline_format: true }, "FPL", { content: "<b>Mes / Año:</b>", inline_format: true }, texto_mes_display ]
      ]

      pdf.table(tabla_i, width: pdf.bounds.width, cell_style: { size: 7.5, padding: 3, border_color: 'CCCCCC', inline_format: true }) do
        column(0).background_color = 'E0EFF6'
        column(2).background_color = 'E0EFF6'
      end

      pdf.move_down 8

      # Sección II
      self.pdf_sub_titulo_formato(pdf, "II.- IDENTIFICACIÓN DEL SERVICIO O ENTIDAD QUE RECIBIÓ Y EJECUTÓ LOS RECURSOS") rescue nil

      tabla_ii = [
        [ { content: "<b>Entidad receptora:</b>", inline_format: true }, razon_social, { content: "<b>RUT:</b>", inline_format: true }, rut_beneficiaria ],
        [ { content: "<b>Programa:</b>", inline_format: true }, { content: programa_texto, colspan: 3 } ],
        [ { content: "<b>Código Externo:</b>", inline_format: true }, fpl.try(:codigo_proyecto).to_s, { content: "<b>Nombre del Proyecto:</b>", inline_format: true }, { content: titulo_proyecto } ],
        [ { content: "<b>Fecha Recepción Informe:</b>", inline_format: true }, fecha_recepcion, { content: "<b>Fecha Evaluación de Actividades:</b>", inline_format: true }, fecha_evaluacion ]
      ]

      pdf.table(tabla_ii, width: pdf.bounds.width, cell_style: { size: 7.5, padding: 3, border_color: 'CCCCCC', inline_format: true }) do
        column(0).background_color = 'E0EFF6'
        column(2).background_color = 'E0EFF6'
      end

      pdf.move_down 10

      # Sección III
      self.pdf_sub_titulo_formato(pdf, "III.- EVALUACIÓN DE ACTIVIDADES REALIZADAS") rescue nil
      pdf.move_down 6

      if actividades.present?
        est_global = (rendicion.read_attribute_before_type_cast(:estado) rescue rendicion.try(:estado)).to_i

        actividades.each do |act|
          act_id_num = act.id.to_i

          plan_act = detalles_hash[act_id_num] || PlanActividad.find_by(id: act_id_num) || act
          pk_id_num = plan_act.try(:id).to_i
          mis_ids = [act_id_num, pk_id_num].reject(&:zero?).uniq
          es_reitimizada = (mis_ids & reitimizadas_ids).any?

          obj_esp_id = plan_act.respond_to?(:attributes) ? (plan_act.attributes['objetivos_especifico_id'] || plan_act.attributes['objetivo_especifico_id']) : nil
          obj_esp_id ||= PlanActividad.where(actividad_id: plan_act.try(:id), flujo_id: flujo_id_ref).pluck(:objetivos_especifico_id).first if plan_act.present?
          obj_esp = ObjetivosEspecifico.find_by(id: obj_esp_id) if obj_esp_id.present?
          indicador_texto = obj_esp.try(:indicadores).presence || obj_esp.try(:descripcion).presence || "Sin indicador registrado."

          # BÚSQUEDA DEL DETALLE TÉCNICO CON TRADUCCIÓN INVERSA DE IDs
          detalle_tecnico = detalles_fpl_array.find do |d|
            act_ids = (d.rendicion_detalle_actividades_fpl.to_a.map(&:plan_actividad_id) rescue []).compact.map(&get_act_id)
            act_ids += (d.rendicion_detalle_actividades_fpl.to_a.map(&:plan_actividad_id) rescue []).compact.map(&:to_i)
            es_tecnica_tab.call(d) && act_ids.include?(act_id_num)
          end

          val_cumple = if detalle_tecnico.present?
                         (detalle_tecnico.read_attribute_before_type_cast(:cumple) rescue detalle_tecnico.try(:cumple)).to_i
                       else
                         0
                       end

          es_observado = false
          estado_html = if val_cumple == 1
                          "<color rgb='28A745'><b>APROBADO</b></color>"
                        elsif val_cumple == 2
                          es_observado = true
                          "<color rgb='DC3545'><b>OBSERVADO</b></color>"
                        else
                          if [5, 6].include?(est_global)
                            "<color rgb='28A745'><b>APROBADO</b></color>"
                          elsif [3, 4].include?(est_global)
                            es_observado = true
                            "<color rgb='DC3545'><b>OBSERVADO</b></color>"
                          elsif [1, 2].include?(est_global)
                            "<color rgb='FD7E14'><b>EN REVISIÓN</b></color>"
                          else
                            "<color rgb='6C757D'><b>EN BORRADOR</b></color>"
                          end
                        end

          f_inicio = detalle_tecnico&.fecha_inicio
          f_inicio_str = f_inicio.respond_to?(:strftime) ? f_inicio.strftime('%d/%m/%Y') : f_inicio.to_s.presence || "dd-mm-aaaa"

          f_termino = detalle_tecnico&.fecha_termino
          f_termino_str = f_termino.respond_to?(:strftime) ? f_termino.strftime('%d/%m/%Y') : f_termino.to_s.presence || "dd-mm-aaaa"

          porcentaje_str = "#{detalle_tecnico&.nivel_avance.to_i}%"
          obs_texto = detalle_tecnico&.observacion.presence || "--"

          nom_archivo = if detalle_tecnico.present? && detalle_tecnico.archivo.present?
                          detalle_tecnico.try(:archivo_identifier) || detalle_tecnico.archivo.try(:identifier) || (File.basename(detalle_tecnico.archivo.to_s) rescue nil)
                        end
          nom_archivo = nom_archivo.presence || "Sin adjuntos"

          nombre_actividad_display = act.try(:nombre).to_s
          if es_reitimizada
            nombre_actividad_display += " <color rgb='6F42C1'><b>(Reitimizada)</b></color>"
          end

          header_card = [
            [
              { content: "<color rgb='003DA6'><b>#{act.try(:correlativo)}</b></color> <b>#{nombre_actividad_display}</b>", inline_format: true },
              { content: estado_html, align: :right, inline_format: true }
            ]
          ]

          indicador_card = [
            [ { content: "<color rgb='004085'><b>Indicador asociado al objetivo:</b> #{indicador_texto}</color>", inline_format: true } ]
          ]

          tabla_campos = [
            [ "Fecha de Inicio", "Fecha de Término", "Nivel de avance", "Descripción del Avance" ],
            [ f_inicio_str, f_termino_str, porcentaje_str, obs_texto ]
          ]

          pdf.table(header_card, width: pdf.bounds.width, cell_style: { size: 9, padding: 3, border_color: 'B8DAFF', background_color: 'E0EFF6' })
          pdf.table(indicador_card, width: pdf.bounds.width, cell_style: { size: 7, padding: 3, border_color: 'B8DAFF', background_color: 'D0E7FF' })
          pdf.table(tabla_campos, width: pdf.bounds.width, cell_style: { size: 7, padding: 3, border_color: 'CCCCCC', align: :center }) do
            row(0).background_color = 'F8F9FA'
            row(0).font_style = :bold
            column(0).width = 80
            column(1).width = 80
            column(2).width = 75
            column(3).align = :left
          end

          pdf.indent(2) do
            pdf.move_down 2
            pdf.font_size(6.5) do
              pdf.text "<b>Documento de Respaldo técnico:</b> #{nom_archivo}", color: '555555', inline_format: true
            end
          end

          if es_observado
            comentario_revisor = detalle_tecnico.try(:comentario_revisor).presence ||
                                 detalle_tecnico.try(:comentario_evaluacion).presence ||
                                 detalle_tecnico.try(:comentario_tecnico).presence ||
                                 detalle_tecnico.try(:comentario).presence ||
                                 detalle_tecnico.try(:observacion_revisor).presence ||
                                 "Actividad observada durante la revisión técnica."

            tabla_comentario = [
              [ { content: "<color rgb='721C24'><b>Comentario del Revisor:</b> #{comentario_revisor}</color>", inline_format: true } ]
            ]
            pdf.move_down 3
            pdf.table(tabla_comentario, width: pdf.bounds.width, cell_style: { size: 9, padding: 3, border_color: 'F5C6CB', background_color: 'F8D7DA' })
          end

          pdf.move_down 8
        end
      else
        pdf.text "Sin actividades reportadas.", size: 8, style: :italic
      end

      pdf.move_down 15

      ancho_firma = 220
      posicion_x = pdf.bounds.width - ancho_firma

      pdf.bounding_box([posicion_x, pdf.cursor], width: ancho_firma, height: 80) do
        logo_firma_path = Rails.root.join("app/assets/images/logo_ascc_firma.png")
        
        if File.exist?(logo_firma_path)
          y_inicio = pdf.cursor
          # Dibujar el logo en el fondo con opacidad tenue sin desplazar el cursor
          pdf.transparent(0.25) do
            pdf.image logo_firma_path, width: 75, at: [(ancho_firma - 75) / 2, y_inicio]
          end
        end

        # Posicionar la línea a la mitad del logo para que quede sobrepuesto
        pdf.move_down 35

        pdf.stroke_color '333333'
        pdf.line_width 0.8
        
        pdf.move_down 4

        pdf.font "DejaVuSans", style: :bold do
          pdf.text nombre_revisor.to_s.upcase, size: 8, align: :center, color: '000000'
        end

        pdf.font "DejaVuSans", style: :bold do
          pdf.text rut_revisor.to_s.upcase, size: 8, align: :center, color: '000000'
        end

        pdf.font "DejaVuSans", style: :normal do
          pdf.text "Revisor Técnico", size: 7.5, align: :center, color: '555555'
        end
      end

    end

    pdf_string = pdf.render
    pdf_file_name = "informe_evaluacion_tecnica_#{self.try(:id) || 'temp'}.pdf"

    ruta_temporal = Rails.root.join("tmp", pdf_file_name)
    File.binwrite(ruta_temporal, pdf_string)

    File.open(ruta_temporal) do |archivo_fisico|
      uploader_class = Class.new(CarrierWave::Uploader::Base) do
        def store_dir
          "accion/public/uploads/fondo_produccion_limpia/informe_actividades"
        end
      end
      uploader = uploader_class.new
      uploader.store!(archivo_fisico)
    end

    File.delete(ruta_temporal) if File.exist?(ruta_temporal)

    pdf_string
  rescue StandardError => e
    Rails.logger.error "=== [ERROR GENERANDO PDF EVALUACIÓN TÉCNICA] #{e.class} - #{e.message} ==="
    Rails.logger.error e.backtrace.join("\n")
    nil
  end

  def codigo_proyecto_fpl
    case self.flujo.tipo_instrumento_id
    when TipoInstrumento::FPL_LINEA_1_1, TipoInstrumento::FPL_LINEA_5_1, TipoInstrumento::FPL_EXTRAPRESUPUESTARIO_DIAGNOSTICO
      "DyAPL"        
    when TipoInstrumento::FPL_LINEA_1_2_1, TipoInstrumento::FPL_LINEA_1_2_2, TipoInstrumento::FPL_EXTRAPRESUPUESTARIO_SEGUIMIENTO, TipoInstrumento::FPL_EXTRAPRESUPUESTARIO_SEGUIMIENTO_2
      "SyC"           
    else
      nil
    end
  end

end
