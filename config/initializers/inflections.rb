# Be sure to restart your server when you modify this file.

# Add new inflection rules using the following format. Inflections
# are locale specific, and you may define rules for as many different
# locales as you wish. All of these examples are active by default:
ActiveSupport::Inflector.inflections do |inflect|
	inflect.irregular 'set_metas_accion', 'set_metas_acciones' #DZC 2018-08-17
	inflect.irregular 'rendicion', 'rendiciones'
	inflect.irregular 'reunion', 'reuniones'
	inflect.irregular 'modalidad', 'modalidades'
	inflect.irregular 'rol', 'roles'
	inflect.irregular 'conversion', 'conversiones'
	inflect.irregular 'accion', 'acciones'
	inflect.irregular 'clasificacion', 'clasificaciones'
	inflect.irregular 'sustancia', 'sustancias'
	inflect.irregular 'base', 'bases'
	inflect.irregular 'proveedor', 'proveedores'
	inflect.irregular 'certificacion', 'certificaciones'
	inflect.irregular 'presupuestaria', 'presupuestarias'
	inflect.irregular 'sectorial', 'sectoriales'
	inflect.irregular 'maquinaria', 'maquinarias'
	# inflect.irregular 'meta', 'metas' #DZC REVISAR
	inflect.irregular 'auditoria', 'auditorias'
	inflect.irregular 'institucion', 'instituciones'
	inflect.irregular 'revision', 'revisiones'
	inflect.irregular 'lugar', 'lugares'
	inflect.irregular 'manifestacion', 'manifestaciones'
	inflect.irregular 'interes', 'intereses'
	inflect.irregular 'adhesion', 'adhesiones'
	inflect.irregular 'admisibilidad', 'admisibilidades'
	inflect.irregular 'contribuyente', 'contribuyentes'
	inflect.irregular 'admisibilidad', 'admisibilidades'
	inflect.irregular 'region', 'regiones'
	inflect.irregular 'regional', 'regionales'
	inflect.irregular 'propuesta', 'propuestas'
	inflect.irregular 'pais', 'paises'
	inflect.irregular 'exclusion', 'exclusiones'
	inflect.irregular 'inclusion', 'inclusiones'
	inflect.irregular 'habilidad', 'habilidades'
	inflect.irregular 'notificacion', 'notificaciones'
	inflect.irregular 'actividad', 'actividades'
	inflect.irregular 'garantia', 'garantias'
	inflect.irregular 'provincia', 'provincias'
	inflect.irregular 'actor', 'actores'
	inflect.irregular 'observacion', 'observaciones'
	inflect.irregular 'encuesta', 'encuestas'
	inflect.irregular 'pregunta', 'preguntas'
	inflect.irregular 'respuesta', 'respuestas'
	inflect.irregular 'convocatoria', 'convocatorias'
	inflect.irregular 'postulacion', 'postulaciones'
	inflect.irregular 'archivo', 'archivos'
	inflect.irregular 'adjunto', 'adjuntos'
	inflect.irregular 'destinatario', 'destinatarios'	
	inflect.irregular 'minuta', 'minutas'
	inflect.irregular 'participante', 'participantes'
	inflect.irregular 'hito_de_prensa', 'hitos_de_prensa' #DZC 2018-06-20
	inflect.irregular 'permiso', 'permisos' #DZC 2018-06-22
	inflect.irregular 'estandar_homologacion', 'estandar_homologaciones'
	inflect.irregular 'estandar_set_metas_accion', 'estandar_set_metas_acciones'
	inflect.irregular 'reporte', 'reportes'
	inflect.irregular 'reporte_automatizado_avance', 'reporte_automatizado_avances'
	inflect.irregular 'registro_apertura_correo', 'registro_apertura_correos'	
	inflect.uncountable %w(unidad_tiempo_para_contestar)
	#inflect.uncountable %w( interes )
	#inflect.irregular 'actividad', 'actividades'
	#inflect.irregular 'actividad_economica', 'actividades_economicas'
#   inflect.plural /^(ox)$/i, '\1en'
#   inflect.singular /^(ox)en/i, '\1'
#   	º
#   inflect.uncountable %w( fish sheep )
end

# These inflection rules are supported but not enabled by default:
# ActiveSupport::Inflector.inflections(:en) do |inflect|
#   inflect.acronym 'RESTful'
# end
