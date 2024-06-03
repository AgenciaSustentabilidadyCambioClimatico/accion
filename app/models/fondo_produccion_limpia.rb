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

end
