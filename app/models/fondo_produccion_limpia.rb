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
    require 'stringio'

    pdf = Prawn::Document.new
    pdf.font Rails.root.join("app/assets/fonts/Open_Sans/OpenSans-Regular.ttf")

    # HEADER
    pdf.repeat :all do
      pdf.bounding_box [pdf.bounds.left, pdf.bounds.top], width: pdf.bounds.width do
        pdf.image Rails.root.join("app/assets/images/logo-ascc-nuevo.png"), width: 119
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
        #implementar tabla elementos 
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
      self.pdf_tabla_empresa(pdf, empresa)
      self.pdf_separador(pdf, 20)
      self.pdf_tabla_equipo_trabajo(pdf, consultores)
      self.pdf_separador(pdf, 20)
      self.pdf_sub_titulo_formato(pdf, "Indicar fortalezas del o los consultores")
      self.pdf_contenido_formato(pdf, self.fortalezas_consultores)
      self.pdf_separador(pdf, 20)

      self.pdf_titulo_formato(pdf, I18n.t(:plan_actividades))
      if tipo_instrumento == TipoInstrumento::FPL_LINEA_1_1 || tipo_instrumento == TipoInstrumento::FPL_LINEA_5_1 || tipo_instrumento == TipoInstrumento::FPL_EXTRAPRESUPUESTARIO_DIAGNOSTICO   
        self.pdf_tabla_plan_actividades(pdf, planes)
      else
        self.pdf_tabla_plan_actividades_tipos(pdf, planes)
      end  
      self.pdf_separador(pdf, 20)

      #self.pdf_titulo_formato(pdf, I18n.t(:documentacion_legal))
      #self.pdf_sub_titulo_formato(pdf, "Antecedentes que se deben adjuntar")
      #self.pdf_separador(pdf, 20)

      self.pdf_titulo_formato(pdf, I18n.t(:costos))
      self.pdf_sub_titulo_formato(pdf, "Resumen")
      self.pdf_tabla_costos(pdf, costos)
      self.pdf_separador(pdf, 20)
      self.pdf_sub_titulo_formato(pdf, "Validación")
      if tipo_instrumento == TipoInstrumento::FPL_LINEA_1_1 || tipo_instrumento == TipoInstrumento::FPL_LINEA_5_1 || tipo_instrumento == TipoInstrumento::FPL_EXTRAPRESUPUESTARIO_DIAGNOSTICO
        self.pdf_tabla_validacion(pdf, costos)
      else
        self.pdf_tabla_validacion_tipos(pdf, costos, costos_seguimiento, confinanciamiento_empresa)
      end
      self.pdf_separador(pdf, 20)
    end

    # Ruta temporal en el sistema local para el PDF
    pdf_temp = StringIO.new(pdf.render)
    pdf_temp.seek(0) # Asegúrate de leer desde el inicio del archivo temporal

    # Nombre del archivo en S3
    pdf_file_name = "fondo_produccion_limpia_#{self.id}_#{revision}.pdf"

    # Subir a S3 utilizando aws-sdk versión 3
    s3 = Aws::S3::Resource.new

    obj = s3.bucket(ENV['S3_BUCKET_NAME']).object("accion/public/uploads/fondo_produccion_limpia/pdf/#{pdf_file_name}")
    obj.put(body: pdf_temp)

    # Retorna la URL pública del archivo en S3
    s3_url = obj.public_url
    s3_url

    rescue StandardError => e
      Rails.logger.error "Error generando PDF: #{e.message}"
    nil
  end

  def generar_admisibilidad_juridica_pdf(revision = nil, flujo_id = nil, tipo_contribuyentes_id = nil, fondo_produccion_limpia = nil, manifestacion_de_interes = nil, tipo_instrumento = nil)
    require 'stringio'
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

    ####CONTENIDO ENCUESTA####

    validaciones = self.get_campos_validaciones

    pdf.bounding_box [pdf.bounds.left, pdf.bounds.top - 100], width: pdf.bounds.width do
      # Aquí se agregan los elementos del PDF, según el contenido necesario.
      proyecto_fpl = "Proyecto: #{fondo_produccion_limpia.codigo_proyecto}"
      proyecto_apl = "APL: #{manifestacion_de_interes.flujo.nombre_instrumento}"
      beneficiario = "Beneficiario: #{obtiene_contribuyente(fondo_produccion_limpia.institucion_entregables_id).razon_social}"
      rut_beneficiario = "Rut: #{obtiene_contribuyente(fondo_produccion_limpia.institucion_entregables_id).rut}-#{obtiene_contribuyente(fondo_produccion_limpia.institucion_entregables_id).dv}"
      
      self.pdf_titulo_formato(pdf, TipoInstrumento::STR_FONDO_DE_PRODUCCION_LIMPIA)
      
      self.pdf_sub_titulo_formato(pdf, tipo_instrumento)
      self.pdf_sub_titulo_formato(pdf, proyecto_fpl)
      self.pdf_sub_titulo_formato(pdf, proyecto_apl)
      self.pdf_sub_titulo_formato(pdf, beneficiario)
      self.pdf_sub_titulo_formato(pdf, rut_beneficiario)
      self.pdf_separador(pdf, 20)

      self.pdf_titulo_formato(pdf, I18n.t(:documentacion_legal))

      self.pdf_sub_titulo_formato(pdf, "A) Postulante")
      self.pdf_tabla_cuestionario(pdf, flujo_id, tipo_contribuyentes_id, 1)
      self.pdf_separador(pdf, 20)

      self.pdf_sub_titulo_formato(pdf, "B) Receptor cofinanciamiento")
      self.pdf_tabla_cuestionario(pdf, flujo_id, tipo_contribuyentes_id, 2)
      self.pdf_separador(pdf, 20)

      self.pdf_sub_titulo_formato(pdf, "C) Ejecutor")
      self.pdf_tabla_cuestionario_ejecutor(pdf, flujo_id)
      self.pdf_separador(pdf, 20)
    end
    
    # Ruta temporal en el sistema local para el PDF
    pdf_temp = StringIO.new(pdf.render)
    pdf_temp.seek(0) # Asegúrate de leer desde el inicio del archivo temporal

    # Nombre del archivo en S3
    pdf_file_name = "admisibilidad_juridica_#{self.id}_#{revision}.pdf"

    # Subir a S3 utilizando aws-sdk versión 3
    s3 = Aws::S3::Resource.new

    obj = s3.bucket(ENV['S3_BUCKET_NAME']).object("accion/public/uploads/fondo_produccion_limpia/admisibilidad/#{pdf_file_name}")
    obj.put(body: pdf_temp)

    # Retorna la URL pública del archivo en S3
    s3_url = obj.public_url

    s3_url

    rescue StandardError => e
      Rails.logger.error "Error generando PDF: #{e.message}"
      nil
  end

  def generar_formulario_fpl(objetivo_especificos = nil, postulantes = nil, consultores = nil, empresa = nil, planes = nil, costos = nil, tipo_instrumento = nil, 
                  costos_seguimiento = nil, confinanciamiento_empresa = nil, fondo_produccion_limpia = nil, manifestacion_de_interes = nil, nombre_tipo_instrumento = nil,
                  comentarios = nil, adheridas = nil)
    require 'stringio'

    pdf = Prawn::Document.new
    pdf.font Rails.root.join("app/assets/fonts/Open_Sans/OpenSans-Regular.ttf")

    # HEADER
    pdf.repeat :all do
      pdf.bounding_box [pdf.bounds.left, pdf.bounds.top], width: pdf.bounds.width do
        pdf.image Rails.root.join("app/assets/images/logo-ascc-nuevo.png"), width: 119
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
      self.pdf_tabla_empresa(pdf, empresa)
      self.pdf_separador(pdf, 20)
      self.pdf_tabla_equipo_trabajo(pdf, consultores)
      self.pdf_separador(pdf, 20)
      self.pdf_sub_titulo_formato(pdf, "Indicar fortalezas del o los consultores")
      self.pdf_contenido_formato(pdf, self.fortalezas_consultores)
      self.pdf_separador(pdf, 20)

      self.pdf_titulo_formato(pdf, I18n.t(:plan_actividades))
      if tipo_instrumento == TipoInstrumento::FPL_LINEA_1_1 || tipo_instrumento == TipoInstrumento::FPL_LINEA_5_1 || tipo_instrumento == TipoInstrumento::FPL_EXTRAPRESUPUESTARIO_DIAGNOSTICO   
        self.pdf_tabla_plan_actividades(pdf, planes)
      else
        self.pdf_tabla_plan_actividades_tipos(pdf, planes)
      end  
      self.pdf_separador(pdf, 20)

      self.pdf_titulo_formato(pdf, I18n.t(:costos))
      self.pdf_sub_titulo_formato(pdf, "Resumen")
      self.pdf_tabla_costos(pdf, costos)
      self.pdf_separador(pdf, 20)
      self.pdf_sub_titulo_formato(pdf, "Validación")
      if tipo_instrumento == TipoInstrumento::FPL_LINEA_1_1 || tipo_instrumento == TipoInstrumento::FPL_LINEA_5_1 || tipo_instrumento == TipoInstrumento::FPL_EXTRAPRESUPUESTARIO_DIAGNOSTICO
        self.pdf_tabla_validacion(pdf, costos)
      else
        self.pdf_tabla_validacion_tipos(pdf, costos, costos_seguimiento, confinanciamiento_empresa)
      end
      self.pdf_separador(pdf, 20)
    end

    # Ruta temporal en el sistema local para el PDF
    pdf_temp = StringIO.new(pdf.render)
    pdf_temp.seek(0) # Asegúrate de leer desde el inicio del archivo temporal

    # Nombre del archivo en S3
    pdf_file_name = "formulario_fpl_#{self.id}.pdf"

    # Subir a S3 utilizando aws-sdk versión 3
    s3 = Aws::S3::Resource.new

    obj = s3.bucket(ENV['S3_BUCKET_NAME']).object("accion/public/uploads/fondo_produccion_limpia/formulario_fpl/#{pdf_file_name}")
    obj.put(body: pdf_temp)

    # Retorna la URL pública del archivo en S3
    s3_url = obj.public_url
    s3_url
    
    rescue StandardError => e
      Rails.logger.error "Error generando PDF: #{e.message}"
    nil
  end

  # Método para crear una tabla con cuatro campos en el PDF
  def pdf_tabla_objetivos(pdf, objetivo_especificos)

    begin
      # Encabezados de la tabla
      headers = ["Descripción", "Metodología", "Resultado", "Indicadores"]

      # Datos de la tabla
      data = [headers] # Comienza con los encabezados

      # Agregar cada objetivo específico a la tabla
      objetivo_especificos.each do |objetivo|
        fila = [
          objetivo[:descripcion].to_s,
          objetivo[:metodologia].to_s,
          objetivo[:resultado].to_s,
          objetivo[:indicadores].to_s
        ]
        data << fila
      end

      pdf.table(data, header: true, column_widths: [130, 130, 130, 130], cell_style: { size: 9, padding: [4, 8] }) do |table|
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
        ["Micro","Micro", "Pequeña", "Mediana", "Grande"], # Encabezados de la tabla
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
          equipo.valor_hh.to_s
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
      headers = ["Etapa / Actividades", "1", "2", "3", "4", "Recursos Humanos Propios", "Recursos Humanos Externos", "Gastos de Operación", "Gastos de Administración"]

      # Datos de la tabla
      data = [headers] # Comienza con los encabezados

      # Agregar cada objetivo específico a la tabla
      duracion_total = self.duracion
      planes.each do |plan|
        fila = [
          plan.nombre,
          *Array.new(duracion_total) do |index|
            mes = index + 1
            if plan.duracion.split(',').include?(mes.to_s)
              'X'
            else
              ''
            end
          end,
          plan.valor_hh_tipo_3,
          plan.valor_hh_tipos_1_2,
          plan.total_gastos_tipo_1,
          plan.total_gastos_tipo_2
        ]
        data << fila
      end
      pdf.table(data, header: true, column_widths: [100,45,45,45,45,60,60,60,60], cell_style: { size: 9, padding: [4, 8] }) do |table|
        # Sin estilos adicionales por ahora
      end

      pdf.move_down 10 # Espacio después de la tabla

    rescue => e
      Rails.logger.error "Error creando la tabla en el PDF: #{e.message}"
      puts "Error creando la tabla en el PDF: #{e.message}"
    end
  end

  def pdf_tabla_plan_actividades_tipos(pdf, planes)
    begin
      # Encabezados de la tabla
      headers = ["Actividades", "Periodos", "Recursos Humanos Propios", "Recursos Humanos Externos", "Gastos de Operación", "Gastos de Administración"]
  
      # Datos de la tabla
      data = [headers] # Comienza con los encabezados
  
      # Agregar cada objetivo específico a la tabla
      duracion_total = self.duracion.to_i
      planes.each do |plan|
        # Verifica si duracion_total y plan.duracion son válidos
        #meses = plan.duracion.to_s.split(',').map(&:to_i) # Asegúrate de convertir a entero

        meses = plan.duracion.to_s.split(',').map(&:strip).join(' - ')
        fila = [
          plan.nombre,
          meses,
          #*Array.new(duracion_total) do |index|
          #  mes = index + 1
          #  meses.include?(mes) ? 'X' : ''
          #end,
          plan.valor_hh_tipo_3,
          plan.valor_hh_tipos_1_2,
          plan.total_gastos_tipo_1,
          plan.total_gastos_tipo_2
        ]
        data << fila
      end
  
      # Generar la tabla en el PDF
      pdf.table(data, header: true, column_widths: [90,90,90,90,90,90], cell_style: { size: 9, padding: [4, 8] }) do |table|
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
        else
          nil
        end
      else
        nil
      end
    
      if costos_seguimiento[0] != nil
        valida_pregunta__aporte_del_postulante = ((costos_seguimiento[0].aporte_solicitado_al_fondo + costos_seguimiento[0].aporte_propio_valorado + costos_seguimiento[0].aporte_propio_liquido) * Gasto::PORCENTAJE_APORTE_PROPIO_MINIMO_DIAGNOSTICO) / 100
        if costos_seguimiento[0].aporte_propio_valorado.to_f + costos_seguimiento[0].aporte_propio_liquido.to_f >= valida_pregunta__aporte_del_postulante && costos_seguimiento[0].aporte_propio_valorado.present?
          cumple1 = 'SI'
        else
          cumple1 = 'NO'
        end


        if costos_seguimiento[0].aporte_solicitado_al_fondo <= monto && costos_seguimiento[0].aporte_solicitado_al_fondo.present?
          cumple2 = 'SI'
        else
          cumple2 = 'NO'
        end

        costos_seguimiento_0_aporte_propio_liquido = costos_seguimiento[0].aporte_propio_liquido
        costos_seguimiento_0_aporte_propio_valorado = costos_seguimiento[0].aporte_propio_valorado
        costos_seguimiento_0_aporte_solicitado_al_fondo = costos_seguimiento[0].aporte_solicitado_al_fondo

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

        valida_pregunta__aporte_del_empresa = ((costos_seguimiento[1].aporte_solicitado_al_fondo + costos_seguimiento[1].aporte_propio_valorado + costos_seguimiento[1].aporte_propio_liquido) * confinanciamiento_empresa[1]) / 100
        if costos_seguimiento[1].aporte_propio_valorado.to_f + costos_seguimiento[1].aporte_propio_liquido.to_f >= valida_pregunta__aporte_del_empresa && costos_seguimiento[1].aporte_propio_valorado.present?
          cumple3 = 'SI'
        else
          cumple3 = 'NO'
        end

        costos_seguimiento_1_aporte_propio_liquido = costos_seguimiento[1].aporte_propio_liquido
        costos_seguimiento_1_aporte_propio_valorado = costos_seguimiento[1].aporte_propio_valorado
        costos_seguimiento_1_aporte_solicitado_al_fondo = costos_seguimiento[1].aporte_solicitado_al_fondo

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

        if costos_seguimiento[1].aporte_solicitado_al_fondo <= monto_cofinanciamiento && costos_seguimiento[1].aporte_solicitado_al_fondo != ''
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
        if costos.aporte_solicitado_al_fondo <= monto && costos.costo_total_de_la_propuesta != ''
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

end
