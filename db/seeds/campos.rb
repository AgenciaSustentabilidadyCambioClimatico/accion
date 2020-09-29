#DZC 2019-07-12 17:24:31 pobla tabla campos


# LEER COMENTARIOS ANTES DE EDITAR
# LEER COMENTARIOS ANTES DE EDITAR
# LEER COMENTARIOS ANTES DE EDITAR
# LEER COMENTARIOS ANTES DE EDITAR
# LEER COMENTARIOS ANTES DE EDITAR

# DOSSA 24-07-2019 se pobla la tabla campos con los datos entregados por el cliente según documento "APL-001 Completar Manifestación de Interés".
#
# DOSSA 2019-07-25 LEER COMENTARIOS ANTES DE EDITAR
# DOSSA 2019-08-19 15:16 SOLICITAR ACCESO A DOCUMENTO "APL-001 Completar Manifestación de Interés" ANTES DE EDITAR SEED PARA COMPRENDER LOS DATOS INGRESADOS
#
# Los campos requeridos para el ingreso son: clase, atributo y tipo.
# El campo "clase" debe contener el nombre de la clase del modelo a la cual pertenece la tarea(por ejempo: ManifestacionDeInteres).
# El campo "atributo" debe contener el nombre del atributo (campo) especificado en la BD (o modelo, si se trata de un atributo no persistente).
# El campo "tipo" debe contener el tipo de dato que podrá ingresar el usuario en ese campo de la tarea (text, integer, double, boolean, map, button, upload).
#
# Los campos de tipo mapa tienen un atributo asignado, sin embargo, no están considerados en el modelo de manifestación de interés ya que no constituyen un campo como tal.
#
# A pesar de que los botones para descargar un archivo subido por el mismo usuario se encuentran presentes en el documento "APL-001 Completar Manifestación de Interés" como campos, no fueron considerados pàra
#  poblar la tabla ya que estos ya poseen una validación propia la cual ya cumple con el comportamiento esperado por el cliente. 
#
# Cada campo se encuentra señalado como Campo nuevo o antiguo según el documento, los campos nuevos tienen como atributo un nombre tentativo el cual puede ser modificado cuando se agregue este a la BD,
#  los atributos asignados a estos campos fueron buscados en el proyecto y no son usados en ningun otro lugar.
#
# Cada campo posee un atributo llamado "validacion_contenido_obligatorio", el cual es de tipo booleano, es de vital importancia saber que este valor es ingresado y modificado por nosotros directamente en este
#  seed, esto quiere decir que el usuario no tiene la posibilidad de modificarlo, ya que posee un gran impacto en el resto del código, actualmente ese atributo está poblado en función del documento 
#  "APL-001 Completar Manifestación de Interés", allí el cliente especificó la obligatoriedad de cada campo. 

# LEER COMENTARIOS ANTES DE EDITAR
# LEER COMENTARIOS ANTES DE EDITAR
# LEER COMENTARIOS ANTES DE EDITAR
# LEER COMENTARIOS ANTES DE EDITAR
# LEER COMENTARIOS ANTES DE EDITAR

# DZC 2019-07-17 13:51:46 resetea las tablas. COMENTAR CUANDO SE HAYA PROGRAMADO CORRECTAMENTE EL POBLAMIENTO
# DZC 2019-07-25 17:08:49 destruye las tablas

puts "Cargando campos para el mantenedor..."
CampoTarea.destroy_all
Campo.destroy_all
# DZC 2019-07-25 17:08:37 resetea el sequencer de las tablas
ActiveRecord::Base.connection.execute("
  ALTER SEQUENCE campo_tareas_id_seq RESTART WITH 1;
  ALTER SEQUENCE campos_id_seq RESTART WITH 1;
")

#--------------------------------------------------------------------------------------------------------------------------------------------#
# Campo antiguo
atributos_obligatorios = {
  clase: "ManifestacionDeInteres",
  atributo: "nombre_acuerdo",
  tipo: "text" 
}
atributos_opcionales = {
  nombre: "Nombre acuerdo",
  validacion_contenido_obligatorio: true,
  validaciones_activas: true,
  validacion_vacio_mensaje: "Campo no puede estar vacío",
  validacion_min: 10,
  validacion_max: 300,
  validacion_min_activa: true,
  validacion_max_activa: true,
  tooltip: "Nombre tentativo del acuerdo.",
  ayuda: "Nombre tentativo del acuerdo. que de cuenta en pocas palabras del sector/territorio involucrado así como objetivos del mismo.",
  id_referencial:"1"
}
campo = Campo.find_by(atributos_obligatorios)
campo = campo.present? ? campo : Campo.new(atributos_obligatorios)
campo.sin_validaciones = true 
campo.update(atributos_opcionales)
campo.tareas = Tarea.where(id: 1)

#--------------------------------------------------------------------------------------------------------------------------------------------#
# Campo antiguo
atributos_obligatorios = {
  clase: "ManifestacionDeInteres",
  atributo: "motivacion_y_objetivos",
  tipo: "text"
}
atributos_opcionales = {
  nombre: "Motivación, objetivos e impactos esperados",
  validacion_contenido_obligatorio: true,
  validaciones_activas: true,
  validacion_vacio_mensaje: "Campo no puede estar vacío",
  validacion_min: 500,
  validacion_max: 5000,
  validacion_min_activa: true,
  validacion_max_activa: true,
  tooltip: "Razones principales para efectuar el acuerdo.",
  ayuda: "¿Por qué se desea realizar este Acuerdo?
          ¿Cuál es el objetivo de este Acuerdo?
          ¿Cuáles son los resultados e impactos que espera lograr con este Acuerdo?",
  id_referencial:"2"
}
campo = Campo.find_by(atributos_obligatorios)
campo = campo.present? ? campo : Campo.new(atributos_obligatorios)
campo.sin_validaciones = true 
campo.update(atributos_opcionales)
campo.tareas = Tarea.where(id: 1)

#--------------------------------------------------------------------------------------------------------------------------------------------#
# Campo nuevo
atributos_obligatorios = {
  clase: "ManifestacionDeInteres",
  atributo: "relacion_de_politicas",
  tipo: "text"
}
atributos_opcionales = {
   nombre: "Relación del Acuerdo propuesto con estrategias, planes o programas; regionales, sectoriales, nacionales según corresponda",
   validacion_contenido_obligatorio: false,
   validaciones_activas: true,
   validacion_vacio_mensaje: "Campo no puede estar vacío",
   validacion_min: "",
   validacion_max: 2000,
   validacion_min_activa: false,
   validacion_max_activa: true,
   tooltip: "Señalar políticas principalmente políticas públicas que apoyen el acuerdo.",
   ayuda: "Indicar las políticas, con énfasis en políticas públicas, que actualmente están apoyando al sector, territorio u objetivos del acuerdo, que los priorizan o los declaran como prioritarios.",
   id_referencial: "3"
}
campo = Campo.find_by(atributos_obligatorios)
campo = campo.present? ? campo : Campo.new(atributos_obligatorios)
campo.sin_validaciones = true 
campo.update(atributos_opcionales)
campo.tareas = Tarea.where(id: 1)

#--------------------------------------------------------------------------------------------------------------------------------------------#
# Campo nuevo
atributos_obligatorios = {
   clase: "ManifestacionDeInteres",
   atributo: "programas_o_proyectos_relacionados_ids",
   tipo: "select"
}
atributos_opcionales = {
   nombre: "Programa o proyecto relacionado",
   validacion_contenido_obligatorio: false,
   validaciones_activas: false,
    validacion_vacio_mensaje: "",
   validacion_min: "",
   validacion_max: "",
   validacion_min_activa: false,
   validacion_max_activa: false,
   tooltip: "Programa(s) relacionado(s) con el acuerdo.",
   ayuda: "Señalar los nombres de los programas o proyectos regionales que tengan relación o estén apoyando este acuerdo.",
   id_referencial: "3.1"
}
campo = Campo.find_by(atributos_obligatorios)
campo = campo.present? ? campo : Campo.new(atributos_obligatorios)
campo.sin_validaciones = true 
campo.update(atributos_opcionales)
campo.tareas = Tarea.where(id: 1)

#--------------------------------------------------------------------------------------------------------------------------------------------#
# Campo nuevo
atributos_obligatorios = {
   clase: "ManifestacionDeInteres",
   atributo: "otras_iniciativas_relacionadas_en_ejecucion",
   tipo: "text"
}
atributos_opcionales = {
   nombre: "Iniciativas relacionadas (programas, proyectos, iniciativas de diálogo, etc.)",
   validacion_contenido_obligatorio: false,
   validaciones_activas: true,
    validacion_vacio_mensaje: "",
   validacion_min: "",
   validacion_max: 2000,
   validacion_min_activa: false,
   validacion_max_activa: true,
   tooltip: "Señalar iniciativas asociadas con nombre y ejecutor de la iniciativa.",
   ayuda: "Indicar otras iniciativas asociadas a los objetivos del Acuerdo propuesto. Señalar nombre de la iniciativa y quien la está ejecutando.",
   id_referencial: "4"
}
campo = Campo.find_by(atributos_obligatorios)
campo = campo.present? ? campo : Campo.new(atributos_obligatorios)
campo.sin_validaciones = true 
campo.update(atributos_opcionales)
campo.tareas = Tarea.where(id: 1)

#--------------------------------------------------------------------------------------------------------------------------------------------#
# Campo nuevo
atributos_obligatorios = {
   clase: "ManifestacionDeInteres",
   atributo: "fuente_de_fondos",
   tipo: "text"
}
atributos_opcionales = {
   nombre: "Señalar si el Acuerdo propuesto ya posee fondos comprometidos para su ejecución.",
   validacion_contenido_obligatorio: true,
   validaciones_activas: true,
    validacion_vacio_mensaje: "Campo no puede estar vacío",
   validacion_min: 10,
   validacion_max: 5000,
   validacion_min_activa: true,
   validacion_max_activa: true,
   tooltip: "Origen de fondos a utilizar (montos, plazos y etapas).",
   ayuda: "Indicar la fuente de los fondos, los montos, los plazos y las etapas del Acuerdo que serán financiadas por estos fondos. ",
   id_referencial: "5"
}
campo = Campo.find_by(atributos_obligatorios)
campo = campo.present? ? campo : Campo.new(atributos_obligatorios)
campo.sin_validaciones = true 
campo.update(atributos_opcionales)
campo.tareas = Tarea.where(id: 1)

#--------------------------------------------------------------------------------------------------------------------------------------------#
# Campo nuevo
atributos_obligatorios = {
   clase: "ManifestacionDeInteres",
   atributo: "justificacion_de_estimacion_de_fondos_requeridos",
   tipo: "text"
}
atributos_opcionales = {
   nombre: "Señalar si el Acuerdo requerirá fondos para su ejecución.",
   validacion_contenido_obligatorio: true,
   validaciones_activas: true,
   validacion_vacio_mensaje: "Campo no puede estar vacío",
   validacion_min: 10,
   validacion_max: 4000,
   validacion_min_activa: true,
   validacion_max_activa: true,
   tooltip: "Señalar orden estimado de magnitud de los fondos requeridos, fuentes y justificaciones.",
   ayuda: "Indicar el orden de magnitud estimado de los fondos requeridos, las fuentes contempladas y una justificación de esa estimación.
          La Agencia de Sustentabilidad hoy puede cofinanciar proyectos de apoyo a los Acuerdos en sus diferentes etapas según Línea 1 y Línea 5.",
   id_referencial: "6"
}
campo = Campo.find_by(atributos_obligatorios)
campo = campo.present? ? campo : Campo.new(atributos_obligatorios)
campo.sin_validaciones = true 
campo.update(atributos_opcionales)
campo.tareas = Tarea.where(id: 1)

#--------------------------------------------------------------------------------------------------------------------------------------------#
# Campo nuevo
atributos_obligatorios = {
   clase: "ManifestacionDeInteres",
   atributo: "nombre_de_estandar_certificable",
   tipo: "text"
}
atributos_opcionales = {
   nombre: "Señalar si el Acuerdo se utilizará para facilitar la implementación de un estándar certificable ya existente por parte de las organizaciones que adherirán al mismo.",
   validacion_contenido_obligatorio: false,
   validaciones_activas: true,
    validacion_vacio_mensaje: "",
   validacion_min: "",
   validacion_max: 2000,
   validacion_min_activa: false,
   validacion_max_activa: true,
   tooltip: "Subir archivo correspondiente al estándar.",
   ayuda: "Indicar nombre de estándar certificable a implementar a través del Acuerdo y adjuntar la documentación de referencia del mismo.",
   id_referencial: "7"
}
campo = Campo.find_by(atributos_obligatorios)
campo = campo.present? ? campo : Campo.new(atributos_obligatorios)
campo.sin_validaciones = true 
campo.update(atributos_opcionales)
campo.tareas = Tarea.where(id: 1)

#--------------------------------------------------------------------------------------------------------------------------------------------#
# Campo nuevo
atributos_obligatorios = {
   clase: "ManifestacionDeInteres",
   atributo: "estandar_certificable",
   tipo: "upload"
}
atributos_opcionales = {
   nombre: "Estandar Certificable",
   validacion_contenido_obligatorio: false,
   validaciones_activas: false,
    validacion_vacio_mensaje: "",
   validacion_min: "",
   validacion_max: "",
   validacion_min_activa: false,
   validacion_max_activa: false,
   tooltip: "",
   ayuda: "",
   id_referencial: "7.1"
}
campo = Campo.find_by(atributos_obligatorios)
campo = campo.present? ? campo : Campo.new(atributos_obligatorios)
campo.sin_validaciones = true 
campo.update(atributos_opcionales)
campo.tareas = Tarea.where(id: 1)

#--------------------------------------------------------------------------------------------------------------------------------------------#
# Campo antiguo
atributos_obligatorios = {
   clase: "ManifestacionDeInteres",
   atributo: "estandar_de_certificacion_id",
   tipo: "select"
}
atributos_opcionales = {
   nombre: "Estándar de homologación",
   validacion_contenido_obligatorio: false,
   validaciones_activas: false,
    validacion_vacio_mensaje: "",
   validacion_min: "",
   validacion_max: "",
   validacion_min_activa: false,
   validacion_max_activa: false,
   tooltip: "Indicar estándar que será implementado en el sector",
   ayuda: "Indicar estándar que será implementado en el sector",
   id_referencial: "7.2"
}
campo = Campo.find_by(atributos_obligatorios)
campo = campo.present? ? campo : Campo.new(atributos_obligatorios)
campo.sin_validaciones = true 
campo.update(atributos_opcionales)
campo.tareas = Tarea.where(id: 1)

#--------------------------------------------------------------------------------------------------------------------------------------------#
# Campo antiguo
atributos_obligatorios = {
   clase: "ManifestacionDeInteres",
   atributo: "descarga_estandar_seleccionado",
   tipo: "button"
}
atributos_opcionales = {
   nombre: "Descarga Estándar Seleccionado",
   validacion_contenido_obligatorio: false,
   validaciones_activas: false,
   validacion_vacio_mensaje: "",
   validacion_min: "",
   validacion_max: "",
   validacion_min_activa: false,
   validacion_max_activa: false,
   tooltip: "Descargar Estándar Seleccionado por si se desea revisar.",
   ayuda: "Descargar Estándar Seleccionado por si se desea revisar.",
   id_referencial: "7.3"
}
campo = Campo.find_by(atributos_obligatorios)
campo = campo.present? ? campo : Campo.new(atributos_obligatorios)
campo.sin_validaciones = true 
campo.update(atributos_opcionales)
campo.tareas = Tarea.where(id: 1)

#--------------------------------------------------------------------------------------------------------------------------------------------#
# Campo nuevo
atributos_obligatorios = {
   clase: "ManifestacionDeInteres",
   atributo: "diagnostico_de_acuerdo_propuesto",
   tipo: "text"
}
atributos_opcionales = {
   nombre: "Señalar si el Acuerdo Propuesto ya cuenta con un Diagnóstico General según lo establecido en el artículo 2 de la ley de Acuerdos de Producción Limpia.",
   validacion_contenido_obligatorio: false,
   validaciones_activas: true,
    validacion_vacio_mensaje: "",
   validacion_min: "",
   validacion_max: 300,
   validacion_min_activa: false,
   validacion_max_activa: true,
   tooltip: "No es cualquier tipo de diagnóstico, debe haber sido elaborado de manera homóloga a lo establecido en la guía operativa de acuerdos territoriales o la guía para la elaboración de un diagnóstico como base para proponer un Acuerdo de Producción Limpia.",
   ayuda: "No es cualquier tipo de diagnóstico, debe haber sido elaborado de manera homóloga a lo establecido en la guía operativa de acuerdos territoriales o la guía para la elaboración de un diagnóstico como base para proponer un Acuerdo de Producción Limpia.",
   id_referencial: "8"
}
campo = Campo.find_by(atributos_obligatorios)
campo = campo.present? ? campo : Campo.new(atributos_obligatorios)
campo.sin_validaciones = true 
campo.update(atributos_opcionales)
campo.tareas = Tarea.where(id: 1)

#--------------------------------------------------------------------------------------------------------------------------------------------#
# Campo nuevo
atributos_obligatorios = {
   clase: "ManifestacionDeInteres",
   atributo: "diagnostico_de_acuerdo_anterior",
   tipo: "upload"
}
atributos_opcionales = {
   nombre: "Adjuntar diagnóstico de existir",
   validacion_contenido_obligatorio: false,
   validaciones_activas: false,
    validacion_vacio_mensaje: "",
   validacion_min: "",
   validacion_max: "",
   validacion_min_activa: false,
   validacion_max_activa: false,
   tooltip: "",
   ayuda: "",
   id_referencial: "8.1"
}
campo = Campo.find_by(atributos_obligatorios)
campo = campo.present? ? campo : Campo.new(atributos_obligatorios)
campo.sin_validaciones = true 
campo.update(atributos_opcionales)
campo.tareas = Tarea.where(id: 1)

#--------------------------------------------------------------------------------------------------------------------------------------------#
# Campo antiguo
atributos_obligatorios = {
   clase: "ManifestacionDeInteres",
   atributo: "diagnostico_id",
   tipo: "select"
}
atributos_opcionales = {
   nombre: "Diagnóstico de acuerdo anterior. En el caso de haber realizado un Acuerdo previamente.",
   validacion_contenido_obligatorio: false,
   validaciones_activas: false,
    validacion_vacio_mensaje: "",
   validacion_min: "",
   validacion_max: "",
   validacion_min_activa: false,
   validacion_max_activa: false,
   tooltip: "Indicar nombre de Acuerdo cuyo diagnóstico se usará como base para este acuerdo.",
   ayuda: "Indicar nombre de Acuerdo cuyo diagnóstico se usará como base para este acuerdo.",
   id_referencial: "8.2"
}
campo = Campo.find_by(atributos_obligatorios)
campo = campo.present? ? campo : Campo.new(atributos_obligatorios)
campo.sin_validaciones = true 
campo.update(atributos_opcionales)
campo.tareas = Tarea.where(id: 1)

#--------------------------------------------------------------------------------------------------------------------------------------------#
# Campo nuevo
atributos_obligatorios = {
   clase: "ManifestacionDeInteres",
   atributo: "informe_de_acuerdo_anterior",
   tipo: "upload"
}
atributos_opcionales = {
   nombre: "En el caso de haber realizado un Acuerdo previamente adjuntar además el Informe de Impacto de dicho Acuerdo.",
   validacion_contenido_obligatorio: false,
   validaciones_activas: false,
    validacion_vacio_mensaje: "",
   validacion_min: "",
   validacion_max: "",
   validacion_min_activa: false,
   validacion_max_activa: false,
   tooltip: "Adjuntar Informe de Impacto de existir no es cualquier tipo de Evaluación de Impacto, debe haber sido elaborado de manera homóloga a lo establecido en la Guía n°2 - Guía para la elaboración de un estudio de impacto como resultado de un APL.",
   ayuda: "Adjuntar Informe de Impacto de existir no es cualquier tipo de Evaluación de Impacto, debe haber sido elaborado de manera homóloga a lo establecido en la Guía n°2 - Guía para la elaboración de un estudio de impacto como resultado de un APL.",
   id_referencial: "8.3"
}
campo = Campo.find_by(atributos_obligatorios)
campo = campo.present? ? campo : Campo.new(atributos_obligatorios)
campo.sin_validaciones = true 
campo.update(atributos_opcionales)
campo.tareas = Tarea.where(id: 1)

#--------------------------------------------------------------------------------------------------------------------------------------------#
# Campo nuevo
atributos_obligatorios = {
   clase: "ManifestacionDeInteres",
   atributo: "acuerdo_previo_con_informe_id",
   tipo: "select"
}
atributos_opcionales = {
   nombre: "Informe de Impacto de acuerdo anterior. En el caso de haber realizado un Acuerdo previamente.",
   validacion_contenido_obligatorio: false,
   validaciones_activas: false,
    validacion_vacio_mensaje: "",
   validacion_min: "",
   validacion_max: "",
   validacion_min_activa: false,
   validacion_max_activa: false,
   tooltip: "Indicar nombre de Acuerdo previo.",
   ayuda: "Indicar nombre de Acuerdo previo.",
   id_referencial: "8.4"
}
campo = Campo.find_by(atributos_obligatorios)
campo = campo.present? ? campo : Campo.new(atributos_obligatorios)
campo.sin_validaciones = true 
campo.update(atributos_opcionales)
campo.tareas = Tarea.where(id: 1)

#--------------------------------------------------------------------------------------------------------------------------------------------#
# Campo nuevo
atributos_obligatorios = {
   clase: "ManifestacionDeInteres",
   atributo: "acuerdo_de_alcance_nacional",
   tipo: "boolean"
}
atributos_opcionales = {
   nombre: "¿Es un acuerdo de alcance Nacional?",
   validacion_contenido_obligatorio: true,
   validaciones_activas: false,
    validacion_vacio_mensaje: "Campo no puede estar vacío",
   validacion_min: "",
   validacion_max: "",
   validacion_min_activa: false,
   validacion_max_activa: false,
   tooltip: "",
   ayuda: "",
   id_referencial: "10"
}
campo = Campo.find_by(atributos_obligatorios)
campo = campo.present? ? campo : Campo.new(atributos_obligatorios)
campo.sin_validaciones = true 
campo.update(atributos_opcionales)
campo.tareas = Tarea.where(id: 1)

#--------------------------------------------------------------------------------------------------------------------------------------------#
# Campo antiguo
atributos_obligatorios = {
   clase: "ManifestacionDeInteres",
   atributo: "mapa_territorios_regiones",
   tipo: "map"
}
atributos_opcionales = {
   nombre: "Representación en Mapa Selecciones",
   validacion_contenido_obligatorio: false,
   validaciones_activas: false,
    validacion_vacio_mensaje: "Campo no puede estar vacío",
   validacion_min: "",
   validacion_max: "",
   validacion_min_activa: false,
   validacion_max_activa: false,
   tooltip: "",
   ayuda: "",
   id_referencial: "10.2"
}
campo = Campo.find_by(atributos_obligatorios)
campo = campo.present? ? campo : Campo.new(atributos_obligatorios)
campo.sin_validaciones = true 
campo.update(atributos_opcionales)
campo.tareas = Tarea.where(id: 1)

#--------------------------------------------------------------------------------------------------------------------------------------------#
# Campo antiguo
atributos_obligatorios = {
   clase: "ManifestacionDeInteres",
   atributo: "caracterizacion_sector_territorio",
   tipo: "text"
}
atributos_opcionales = {
   nombre: "Caracterización del (los) territorio(s) involucrado(s) de ser pertinente a los Objetivos del Acuerdo",
   validacion_contenido_obligatorio: true,
   validaciones_activas: true,
    validacion_vacio_mensaje: "Campo no puede estar vacío",
   validacion_min: 500,
   validacion_max: 5000,
   validacion_min_activa: true,
   validacion_max_activa: true,
   tooltip: "Caracterizar el territorio en el cual se desea realizar el acuerdo, teniendo en consideración los objetivos propuestos para el Acuerdo. Caracterizar en los ámbitos: Demográfico, Geográfico, Socioeconómico, Cultural (Antropológico) y de Bienestar Social Básico de Acuerdo a Guía técnica caracterización. En el caso que se considere que la caracterización del territorio no es relevante a los Objetivos del Acuerdo, justificarlo. La unidad territorial de análisis debiese ser coherente con lo declarado en el campo anterior.",
   ayuda: "Caracterizar el territorio en el cual se desea realizar el acuerdo, teniendo en consideración los objetivos propuestos para el Acuerdo. Caracterizar en los ámbitos: Demográfico, Geográfico, Socioeconómico, Cultural (Antropológico) y de Bienestar Social Básico de Acuerdo a Guía técnica caracterización. En el caso que se considere que la caracterización del territorio no es relevante a los Objetivos del Acuerdo, justificarlo. La unidad territorial de análisis debiese ser coherente con lo declarado en el campo anterior.",
   id_referencial: "11"
}
campo = Campo.find_by(atributos_obligatorios)
campo = campo.present? ? campo : Campo.new(atributos_obligatorios)
campo.sin_validaciones = true 
campo.update(atributos_opcionales)
campo.tareas = Tarea.where(id: 1)

#--------------------------------------------------------------------------------------------------------------------------------------------#
# Campo nuevo
atributos_obligatorios = {
   clase: "ManifestacionDeInteres",
   atributo: "caracteristicas_de_actividades_economicas",
   tipo: "title"
}
atributos_opcionales = {
   nombre: "Caracterización de la(s) Principal(es) Actividad(es) Económica(s) involucrada(s)",
   validacion_contenido_obligatorio: true,
   validaciones_activas: false,
    validacion_vacio_mensaje: "Campo no puede estar vacío",
   validacion_min: "",
   validacion_max: "",
   validacion_min_activa: false,
   validacion_max_activa: false,
   tooltip: "Caracterizar la(s) Principal(es) Actividad(es) Económica(s) a involucrar en el acuerdo, teniendo en consideración los objetivos propuestos para el Acuerdo. 
              La información tributaria del Servicio de Impuestos Internos, puede servir de referencia <a href='http://www.sii.cl/sobre_el_sii/estadisticas_de_empresas.html' target='_blank'>Enlace</a>",
   ayuda: "Caracterizar la(s) Principal(es) Actividad(es) Económica(s) a involucrar en el acuerdo, teniendo en consideración los objetivos propuestos para el Acuerdo. 
              La información tributaria del Servicio de Impuestos Internos, puede servir de referencia <a href='http://www.sii.cl/sobre_el_sii/estadisticas_de_empresas.html' target='_blank'>Enlace</a>",
   id_referencial: "12"
}
campo = Campo.find_by(atributos_obligatorios)
campo = campo.present? ? campo : Campo.new(atributos_obligatorios)
campo.sin_validaciones = true 
campo.update(atributos_opcionales)
campo.tareas = Tarea.where(id: 1)

#--------------------------------------------------------------------------------------------------------------------------------------------#
# Campo antiguo
atributos_obligatorios = {
   clase: "ManifestacionDeInteres",
   atributo: "numero_empresas",
   tipo: "integer"
}
atributos_opcionales = {
   nombre: "Número de Empresas por tamaño",
   validacion_contenido_obligatorio: true,
   validaciones_activas: false,
    validacion_vacio_mensaje: "Campo no puede estar vacío",
   validacion_min: 50,
   validacion_max: 200,
   validacion_min_activa: true,
   validacion_max_activa: true,
   tooltip: "Indicar Número de Empresas por tamaño de la(s) Principal(es) Actividad(es) Económica(s) involucrada(s)",
   ayuda: "Indicar Número de Empresas por tamaño de la(s) Principal(es) Actividad(es) Económica(s) involucrada(s)",
   id_referencial: "12.1",
   ayuda_activo: false
}
campo = Campo.find_by(atributos_obligatorios)
campo = campo.present? ? campo : Campo.new(atributos_obligatorios)
campo.sin_validaciones = true 
campo.update(atributos_opcionales)
campo.tareas = Tarea.where(id: 1)

#--------------------------------------------------------------------------------------------------------------------------------------------#
# Campo antiguo
atributos_obligatorios = {
   clase: "ManifestacionDeInteres",
   atributo: "produccion",
   tipo: "integer"
}
atributos_opcionales = {
   nombre: "Productos y volumen de producción",
   validacion_contenido_obligatorio: true,
   validaciones_activas: false,
    validacion_vacio_mensaje: "Campo no puede estar vacío",
   validacion_min: 50,
   validacion_max: 1000,
   validacion_min_activa: true,
   validacion_max_activa: true,
   tooltip: "Indicar volumen de los principales productos de la(s) Principal(es) Actividad(es) Económica(s) involucrada(s) (Indicar unidad de medida)",
   ayuda: "Indicar volumen de los principales productos de la(s) Principal(es) Actividad(es) Económica(s) involucrada(s) (Indicar unidad de medida)",
   id_referencial: "12.2",
   ayuda_activo: false
}
campo = Campo.find_by(atributos_obligatorios)
campo = campo.present? ? campo : Campo.new(atributos_obligatorios)
campo.sin_validaciones = true 
campo.update(atributos_opcionales)
campo.tareas = Tarea.where(id: 1)

#--------------------------------------------------------------------------------------------------------------------------------------------#
# Campo antiguo
atributos_obligatorios = {
   clase: "ManifestacionDeInteres",
   atributo: "unidad_de_medida_volumen",
   tipo: "select"
}
atributos_opcionales = {
   nombre: "Unidad",
   validacion_contenido_obligatorio: true,
   validaciones_activas: false,
    validacion_vacio_mensaje: "Campo no puede estar vacío",
   validacion_min: 50,
   validacion_max: 1000,
   validacion_min_activa: true,
   validacion_max_activa: true,
   tooltip: "Indicar unidad de medida de volumen",
   ayuda: "Indicar unidad de medida de volumen",
   id_referencial: "12.22",
   ayuda_activo: false
}
campo = Campo.find_by(atributos_obligatorios)
campo = campo.present? ? campo : Campo.new(atributos_obligatorios)
campo.sin_validaciones = true 
campo.update(atributos_opcionales)
campo.tareas = Tarea.where(id: 1)

#--------------------------------------------------------------------------------------------------------------------------------------------#
# Campo antiguo
atributos_obligatorios = {
   clase: "ManifestacionDeInteres",
   atributo: "ventas",
   tipo: "integer"
}
atributos_opcionales = {
   nombre: "Ventas",
   validacion_contenido_obligatorio: true,
   validaciones_activas: false,
    validacion_vacio_mensaje: "Campo no puede estar vacío",
   validacion_min: "",
   validacion_max: 1000000000000000,
   validacion_min_activa: false,
   validacion_max_activa: true,
   tooltip: "Indicar Ventas de la(s) Principal(es) Actividad(es) Económica(s) involucrada(s) en el último año en pesos $.",
   ayuda: "Indicar Ventas de la(s) Principal(es) Actividad(es) Económica(s) involucrada(s) en el último año en pesos $.",
   id_referencial: "12.3",
   ayuda_activo: false
}
campo = Campo.find_by(atributos_obligatorios)
campo = campo.present? ? campo : Campo.new(atributos_obligatorios)
campo.sin_validaciones = true 
campo.update(atributos_opcionales)
campo.tareas = Tarea.where(id: 1)

#--------------------------------------------------------------------------------------------------------------------------------------------#
# Campo antiguo
atributos_obligatorios = {
   clase: "ManifestacionDeInteres",
   atributo: "porcentaje_exportaciones",
   tipo: "double"
}
atributos_opcionales = {
   nombre: "Exportaciones",
   validacion_contenido_obligatorio: true,
   validaciones_activas: false,
   validacion_vacio_mensaje: "Campo no puede estar vacío",
   validacion_min: 0,
   validacion_max: 100,
   validacion_min_activa: true,
   validacion_max_activa: true,
   tooltip: "Indicar Porcentaje de la producción que es exportada a otros países de la(s) Principal(es) Actividad(es) Económica(s) involucrada(s)",
   ayuda: "Indicar Porcentaje de la producción que es exportada a otros países de la(s) Principal(es) Actividad(es) Económica(s) involucrada(s)",
   id_referencial: "12.4",
   ayuda_activo: false
}
campo = Campo.find_by(atributos_obligatorios)
campo = campo.present? ? campo : Campo.new(atributos_obligatorios)
campo.sin_validaciones = true 
campo.update(atributos_opcionales)
campo.tareas = Tarea.where(id: 1)

#--------------------------------------------------------------------------------------------------------------------------------------------#
# Campo antiguo
atributos_obligatorios = {
   clase: "ManifestacionDeInteres",
   atributo: "principales_mercados",
   tipo: "text"
}
atributos_opcionales = {
   nombre: "Mercados de destino",
   validacion_contenido_obligatorio: true,
   validaciones_activas: true,
    validacion_vacio_mensaje: "Campo no puede estar vacío",
   validacion_min: 50,
   validacion_max: 1000,
   validacion_min_activa: true,
   validacion_max_activa: true,
   tooltip: "Señalar principales mercados de destino de la producción de la(s) Principal(es) Actividad(es) Económica(s) involucrada(s)",
   ayuda: "Señalar principales mercados de destino de la producción de la(s) Principal(es) Actividad(es) Económica(s) involucrada(s)",
   id_referencial: "12.5"
}
campo = Campo.find_by(atributos_obligatorios)
campo = campo.present? ? campo : Campo.new(atributos_obligatorios)
campo.sin_validaciones = true 
campo.update(atributos_opcionales)
campo.tareas = Tarea.where(id: 1)

#--------------------------------------------------------------------------------------------------------------------------------------------#
# Campo antiguo
atributos_obligatorios = {
   clase: "ManifestacionDeInteres",
   atributo: "numero_trabajadores",
   tipo: "integer"
}
atributos_opcionales = {
   nombre: "Número de trabajadores",
   validacion_contenido_obligatorio: true,
   validaciones_activas: false,
    validacion_vacio_mensaje: "Campo no puede estar vacío",
   validacion_min: "",
   validacion_max: "",
   validacion_min_activa: false,
   validacion_max_activa: false,
   tooltip: "Indicar cantidad de Trabajadores de la(s) Principal(es) Actividad(es) Económica(s) involucrada(s)",
   ayuda: "Indicar cantidad de Trabajadores de la(s) Principal(es) Actividad(es) Económica(s) involucrada(s)",
   id_referencial: "12.6",
   ayuda_activo: false
}
campo = Campo.find_by(atributos_obligatorios)
campo = campo.present? ? campo : Campo.new(atributos_obligatorios)
campo.sin_validaciones = true 
campo.update(atributos_opcionales)
campo.tareas = Tarea.where(id: 1)

#--------------------------------------------------------------------------------------------------------------------------------------------#
# Campo nuevo
atributos_obligatorios = {
   clase: "ManifestacionDeInteres",
   atributo: "cadena_de_valor",
   tipo: "text"
}
atributos_opcionales = {
   nombre: "Cadena de valor",
   validacion_contenido_obligatorio: true,
   validaciones_activas: true,
    validacion_vacio_mensaje: "Campo no puede estar vacío",
   validacion_min: 50,
   validacion_max: 1000,
   validacion_min_activa: true,
   validacion_max_activa: true,
   tooltip: "Indicar cadena de valor a la que pertenece(n) la(s) Principal(es) Actividad(es) Económica(s) involucrada(s)",
   ayuda: "Indicar cadena de valor a la que pertenece(n) la(s) Principal(es) Actividad(es) Económica(s) involucrada(s)",
   id_referencial: "12.7"
}
campo = Campo.find_by(atributos_obligatorios)
campo = campo.present? ? campo : Campo.new(atributos_obligatorios)
campo.sin_validaciones = true 
campo.update(atributos_opcionales)
campo.tareas = Tarea.where(id: 1)

#--------------------------------------------------------------------------------------------------------------------------------------------#
# Campo nuevo
atributos_obligatorios = {
   clase: "ManifestacionDeInteres",
   atributo: "otras_caracteristicas_relevantes",
   tipo: "text"
}
atributos_opcionales = {
   nombre: "Otras características",
   validacion_contenido_obligatorio: false,
   validaciones_activas: true,
    validacion_vacio_mensaje: "",
   validacion_min: "",
   validacion_max: 1000,
   validacion_min_activa: false,
   validacion_max_activa: true,
   tooltip: "Otras caracteristicas relevantes no indicadas en los campos anteriores",
   ayuda: "Otras caracteristicas relevantes no indicadas en los campos anteriores",
   id_referencial: "12.8"
}
campo = Campo.find_by(atributos_obligatorios)
campo = campo.present? ? campo : Campo.new(atributos_obligatorios)
campo.sin_validaciones = true 
campo.update(atributos_opcionales)
campo.tareas = Tarea.where(id: 1)

#--------------------------------------------------------------------------------------------------------------------------------------------#
# Campo antiguo
atributos_obligatorios = {
   clase: "ManifestacionDeInteres",
   atributo: "comentarios_cifras",
   tipo: "text"
}
atributos_opcionales = {
   nombre: "Comentarios",
   validacion_contenido_obligatorio: false,
   validaciones_activas: false,
   validacion_vacio_mensaje: "Campo no puede estar vacío",
   validacion_min: 50,
   validacion_max: 200,
   validacion_min_activa: true,
   validacion_max_activa: true,
   tooltip: "Comentarios cifras sectores económicos",
   ayuda: "Comentarios cifras sectores económicos",
   id_referencial: "12.9",
   ayuda_activo: false
}
campo = Campo.find_by(atributos_obligatorios)
campo = campo.present? ? campo : Campo.new(atributos_obligatorios)
campo.sin_validaciones = true 
campo.update(atributos_opcionales)
campo.tareas = Tarea.where(id: 1)

#--------------------------------------------------------------------------------------------------------------------------------------------#
# Campo antiguo
atributos_obligatorios = {
   clase: "ManifestacionDeInteres",
   atributo: "vulnerabilidad_al_cambio_climatico_del_sector",
   tipo: "text"
}
atributos_opcionales = {
   nombre: "Vulnerabilidad al cambio climático del (los) sector(es)/territorio(s)",
   validacion_contenido_obligatorio: true,
   validaciones_activas: true,
    validacion_vacio_mensaje: "Campo no puede estar vacío",
   validacion_min: 10,
   validacion_max: 5000,
   validacion_min_activa: true,
   validacion_max_activa: true,
   tooltip: "Señalar los principales efectos y dificultades que generará el cambio climático al sector/territorio, incluyendo, capacidad adaptativa, sensibilidad y exposición. La información del Ministerio de Medioambiente puede servir de referencia <a href='https://mma.gob.cl/cambio-climatico/vulnerabilidad-y-adaptacion/' target='_blank'>Enlace</a>. Si se desconoce, señalar desconocido.",
   ayuda: "Señalar los principales efectos y dificultades que generará el cambio climático al sector/territorio, incluyendo, capacidad adaptativa, sensibilidad y exposición. La información del Ministerio de Medioambiente puede servir de referencia <a href='https://mma.gob.cl/cambio-climatico/vulnerabilidad-y-adaptacion/' target='_blank'>Enlace</a>. Si se desconoce, señalar desconocido.",
   id_referencial: "13"
}
campo = Campo.find_by(atributos_obligatorios)
campo = campo.present? ? campo : Campo.new(atributos_obligatorios)
campo.sin_validaciones = true 
campo.update(atributos_opcionales)
campo.tareas = Tarea.where(id: 1)

#--------------------------------------------------------------------------------------------------------------------------------------------#
# Campo antiguo
atributos_obligatorios = {
   clase: "ManifestacionDeInteres",
   atributo: "principales_impactos_socioambientales_del_sector",
   tipo: "text"
}
atributos_opcionales = {
   nombre: "Principales impactos socio ambientales del (los) sector(es) en territorio(s)",
   validacion_contenido_obligatorio: true,
   validaciones_activas: true,
    validacion_vacio_mensaje: "Campo no puede estar vacío",
   validacion_min: 10,
   validacion_max: 5000,
   validacion_min_activa: true,
   validacion_max_activa: true,
   tooltip: "Señalar los principales impactos negativos y positivos en el (los) territorio(s) de la(s) Principal(es) Actividad(es) Económica(s) a involucrar en el Acuerdo, tanto en términos ambientales como sociales, intentar cuantificarlos de ser posible. Para el caso de impactos ambientales se pueden consultar datos del Registro de emisiones y Transferencia de contaminantes http://www.retc.cl/datos-retc o del Sistema Nacional de Información Ambiental http://sinia.mma.gob.cl/. Si se desconocen, señalar que estos no son conocidos. Se pueden adjuntar o referenciar documentos, pero este campo debe contener al menos un resumen.",
   ayuda: "Señalar los principales impactos negativos y positivos en el (los) territorio(s) de la(s) Principal(es) Actividad(es) Económica(s) a involucrar en el Acuerdo, tanto en términos ambientales como sociales, intentar cuantificarlos de ser posible. Para el caso de impactos ambientales se pueden consultar datos del Registro de emisiones y Transferencia de contaminantes http://www.retc.cl/datos-retc o del Sistema Nacional de Información Ambiental http://sinia.mma.gob.cl/. Si se desconocen, señalar que estos no son conocidos. Se pueden adjuntar o referenciar documentos, pero este campo debe contener al menos un resumen.",
   id_referencial: "14"
}
campo = Campo.find_by(atributos_obligatorios)
campo = campo.present? ? campo : Campo.new(atributos_obligatorios)
campo.sin_validaciones = true 
campo.update(atributos_opcionales)
campo.tareas = Tarea.where(id: 1)

#--------------------------------------------------------------------------------------------------------------------------------------------#
# Campo antiguo
atributos_obligatorios = {
   clase: "ManifestacionDeInteres",
   atributo: "principales_problemas_y_desafios",
   tipo: "text"
}
atributos_opcionales = {
   nombre: "Principales problemas y desafíos productivos de la(s) Actividad(es) Económica(s) y/o del (los) Territorio(s)",
   validacion_contenido_obligatorio: true,
   validaciones_activas: true,
    validacion_vacio_mensaje: "",
   validacion_min: 10,
   validacion_max: 5000,
   validacion_min_activa: true,
   validacion_max_activa: true,
   tooltip: "Señalar los principales desafíos de competitividad y productividad de las actividad(es)/territorio(s), señalar aquellos puntos del proceso o de la cadena de valor que consideran crítico mejorar. Si se desconoce, señalar desconocido.",
   ayuda: "Señalar los principales desafíos de competitividad y productividad de las actividad(es)/territorio(s), señalar aquellos puntos del proceso o de la cadena de valor que consideran crítico mejorar. Si se desconoce, señalar desconocido.",
   id_referencial: "15"
}
campo = Campo.find_by(atributos_obligatorios)
campo = campo.present? ? campo : Campo.new(atributos_obligatorios)
campo.sin_validaciones = true 
campo.update(atributos_opcionales)
campo.tareas = Tarea.where(id: 1)

#--------------------------------------------------------------------------------------------------------------------------------------------#
# Campo antiguo
atributos_obligatorios = {
   clase: "ManifestacionDeInteres",
   atributo: "principales_conflictos",
   tipo: "text"
}
atributos_opcionales = {
   nombre: "Principales conflictos de la(s) Actividad(es) Económica(s)/Territorio(s)",
   validacion_contenido_obligatorio: true,
   validaciones_activas: true,
    validacion_vacio_mensaje: "Campo no puede estar vacío",
   validacion_min: 10,
   validacion_max: 5000,
   validacion_min_activa: true,
   validacion_max_activa: true,
   tooltip: "Señalar los principales conflictos socio ambientales que han tenido lugar en el(los) Territorio(s) o involucrado a la(s) Actividad(es) Económica(s) en los últimos 5 años. Si se desconoce, señalar desconocido.",
   ayuda: "Señalar los principales conflictos socio ambientales que han tenido lugar en el(los) Territorio(s) o involucrado a la(s) Actividad(es) Económica(s) en los últimos 5 años. Si se desconoce, señalar desconocido.",
   id_referencial: "16"
}
campo = Campo.find_by(atributos_obligatorios)
campo = campo.present? ? campo : Campo.new(atributos_obligatorios)
campo.sin_validaciones = true 
campo.update(atributos_opcionales)
campo.tareas = Tarea.where(id: 1)

#--------------------------------------------------------------------------------------------------------------------------------------------#
# Campo antiguo
atributos_obligatorios = {
   clase: "ManifestacionDeInteres",
   atributo: "otro_contexto_sector",
   tipo: "text"
}
atributos_opcionales = {
   nombre: "Condicionantes y riesgos para el desarrollo del Acuerdo propuesto",
   validacion_contenido_obligatorio: true,
   validaciones_activas: true,
    validacion_vacio_mensaje: "Campo no puede estar vacío",
   validacion_min: 10,
   validacion_max: 5000,
   validacion_min_activa: true,
   validacion_max_activa: true,
   tooltip: "Señalar las principales condicionantes y riesgos para el desarrollo del Acuerdo propuesto.",
   ayuda: "Señalar las principales condicionantes y riesgos para el desarrollo del Acuerdo propuesto.",
   id_referencial: "17"
}
campo = Campo.find_by(atributos_obligatorios)
campo = campo.present? ? campo : Campo.new(atributos_obligatorios)
campo.sin_validaciones = true 
campo.update(atributos_opcionales)
campo.tareas = Tarea.where(id: 1)

#--------------------------------------------------------------------------------------------------------------------------------------------#
# Campo antiguo
atributos_obligatorios = {
   clase: "ManifestacionDeInteres",
   atributo: "principales_actores",
   tipo: "text"
}
atributos_opcionales = {
   nombre: "Principales actores y posibles participantes",
   validacion_contenido_obligatorio: true,
   validaciones_activas: true,
    validacion_vacio_mensaje: "Campo no puede estar vacío",
   validacion_min: 100,
   validacion_max: 5000,
   validacion_min_activa: true,
   validacion_max_activa: true,
   tooltip: "Señalar los principales actores del sector/territorio con una mirada en torno al Acuerdo que se desea realizar, indicando si son patrocinadores, instituciones que podrían comprometer recursos,instituciones que podrían comprometer acciones, u otro tipo de parte interesada. Completar el Listado de actores con los datos disponibles.",
   ayuda: "Señalar los principales actores del sector/territorio con una mirada en torno al Acuerdo que se desea realizar, indicando si son patrocinadores, instituciones que podrían comprometer recursos,instituciones que podrían comprometer acciones, u otro tipo de parte interesada. Completar el Listado de actores con los datos disponibles.",
   id_referencial: "20"
}
campo = Campo.find_by(atributos_obligatorios)
campo = campo.present? ? campo : Campo.new(atributos_obligatorios)
campo.sin_validaciones = true 
campo.update(atributos_opcionales)
campo.tareas = Tarea.where(id: 1)

#--------------------------------------------------------------------------------------------------------------------------------------------#
# Campo antiguo
atributos_obligatorios = {
   clase: "ManifestacionDeInteres",
   atributo: "descarga_formato_listado_de_actores",
   tipo: "button"
}
atributos_opcionales = {
   nombre: "Descargar Listado de Actores",
   validacion_contenido_obligatorio: false,
   validaciones_activas: false,
    validacion_vacio_mensaje: "Campo no puede estar vacío",
   validacion_min: "",
   validacion_max: "",
   validacion_min_activa: false,
   validacion_max_activa: false,
   tooltip: "Descargar Formato Listado de Actores",
   ayuda: "Descargar Formato Listado de Actores",
   id_referencial: "20.1"
}
campo = Campo.find_by(atributos_obligatorios)
campo = campo.present? ? campo : Campo.new(atributos_obligatorios)
campo.sin_validaciones = true 
campo.update(atributos_opcionales)
campo.tareas = Tarea.where(id: 1)

#--------------------------------------------------------------------------------------------------------------------------------------------#
# Campo antiguo
atributos_obligatorios = {
   clase: "ManifestacionDeInteres",
   atributo: "mapa_de_actores_archivo",
   tipo: "upload"
}
atributos_opcionales = {
   nombre: "Subir Listado de Actores actualizado",
   validacion_contenido_obligatorio: true,
   validaciones_activas: false,
    validacion_vacio_mensaje: "Campo no puede estar vacío",
   validacion_min: "",
   validacion_max: "",
   validacion_min_activa: false,
   validacion_max_activa: false,
   tooltip: "",
   ayuda: "",
   id_referencial: "20.2"
}
campo = Campo.find_by(atributos_obligatorios)
campo = campo.present? ? campo : Campo.new(atributos_obligatorios)
campo.sin_validaciones = true 
campo.update(atributos_opcionales)
campo.tareas = Tarea.where(id: 1)

#--------------------------------------------------------------------------------------------------------------------------------------------#
# Campo antiguo
atributos_obligatorios = {
   clase: "ManifestacionDeInteres",
   atributo: "descarga_formato_cartas_de_patrocinio",
   tipo: "button"
}
atributos_opcionales = {
   nombre: "Descargar Formato Cartas de Patrocinio",
   validacion_contenido_obligatorio: false,
   validaciones_activas: false,
    validacion_vacio_mensaje: "Campo no puede estar vacío",
   validacion_min: "",
   validacion_max: "",
   validacion_min_activa: false,
   validacion_max_activa: false,
   tooltip: "Descargar Formato Cartas de Patrocinio",
   ayuda: "Descargar Formato Cartas de Patrocinio",
   id_referencial: "20.3"
}
campo = Campo.find_by(atributos_obligatorios)
campo = campo.present? ? campo : Campo.new(atributos_obligatorios)
campo.sin_validaciones = true 
campo.update(atributos_opcionales)
campo.tareas = Tarea.where(id: 1)

#--------------------------------------------------------------------------------------------------------------------------------------------#
# Campo antiguo
atributos_obligatorios = {
   clase: "ManifestacionDeInteres",
   atributo: "carta_de_apoyo_y_compromiso",
   tipo: "upload"
}
atributos_opcionales = {
   nombre: "Subir Cartas de Patrocinio al Acuerdo",
   validacion_contenido_obligatorio: true,
   validaciones_activas: false,
    validacion_vacio_mensaje: "Campo no puede estar vacío",
   validacion_min: "",
   validacion_max: "",
   validacion_min_activa: false,
   validacion_max_activa: false,
   tooltip: "",
   ayuda: "",
   id_referencial: "20.4"
}
campo = Campo.find_by(atributos_obligatorios)
campo = campo.present? ? campo : Campo.new(atributos_obligatorios)
campo.sin_validaciones = true 
campo.update(atributos_opcionales)
campo.tareas = Tarea.where(id: 1)
#--------------------------------------------------------------------------------------------------------------------------------------------#
# Campo antiguo
atributos_obligatorios = {
   clase: "ManifestacionDeInteres",
   atributo: "otros_recursos_comprometidos",
   tipo: "text"
}
atributos_opcionales = {
   nombre: "Recursos que podrían comprometer los Patrocinadores",
   validacion_contenido_obligatorio: true,
   validaciones_activas: false,
    validacion_vacio_mensaje: "Campo no puede estar vacío",
   validacion_min: 100,
   validacion_max: 5000,
   validacion_min_activa: false,
   validacion_max_activa: false,
   tooltip: "Señalar si hay lugares para reunión, horas hombre, uso de marcas y otros recursos valorados comprometidos por las instituciones patrocinantes",
   ayuda: "Señalar si hay lugares para reunión, horas hombre, uso de marcas y otros recursos valorados comprometidos por las instituciones patrocinantes",
   id_referencial: "21"
}
campo = Campo.find_by(atributos_obligatorios)
campo = campo.present? ? campo : Campo.new(atributos_obligatorios)
campo.sin_validaciones = true 
campo.update(atributos_opcionales)
campo.tareas = Tarea.where(id: 1)

#--------------------------------------------------------------------------------------------------------------------------------------------#
# Campo antiguo
atributos_obligatorios = {
   clase: "ManifestacionDeInteres",
   atributo: "descarga_formato_cartas",
   tipo: "button"
}
atributos_opcionales = {
   nombre: "Descargar Formato Cartas de Patrocinio al Acuerdo",
   validacion_contenido_obligatorio: false,
   validaciones_activas: false,
    validacion_vacio_mensaje: "Campo no puede estar vacío",
   validacion_min: "",
   validacion_max: "",
   validacion_min_activa: false,
   validacion_max_activa: false,
   tooltip: "Descargar Formato Cartas de Interés en el desarrollo del Acuerdo.",
   ayuda: "Descargar Formato Cartas de Interés en el desarrollo del Acuerdo.",
   id_referencial: "21.1"
}
campo = Campo.find_by(atributos_obligatorios)
campo = campo.present? ? campo : Campo.new(atributos_obligatorios)
campo.sin_validaciones = true 
campo.update(atributos_opcionales)
campo.tareas = Tarea.where(id: 1)

#--------------------------------------------------------------------------------------------------------------------------------------------#
# Campo antiguo
atributos_obligatorios = {
   clase: "ManifestacionDeInteres",
   atributo: "carta_de_interes_institucion_gestora_firmada",
   tipo: "upload"
}
atributos_opcionales = {
   nombre: "Subir Cartas de Patrocinio al Acuerdo.",
   validacion_contenido_obligatorio: true,
   validaciones_activas: false,
    validacion_vacio_mensaje: "Campo no puede estar vacío",
   validacion_min: "",
   validacion_max: "",
   validacion_min_activa: false,
   validacion_max_activa: false,
   tooltip: "Subir Cartas de Interés en el desarrollo del Acuerdo.",
   ayuda: "Subir Cartas de Interés en el desarrollo del Acuerdo.",
   id_referencial: "21.2"
}
campo = Campo.find_by(atributos_obligatorios)
campo = campo.present? ? campo : Campo.new(atributos_obligatorios)
campo.sin_validaciones = true 
campo.update(atributos_opcionales)
campo.tareas = Tarea.where(id: 1)

#--------------------------------------------------------------------------------------------------------------------------------------------#
# Campo antiguo
atributos_obligatorios = {
   clase: "ManifestacionDeInteres",
   atributo: "proponente",
   tipo: "text"
}
atributos_opcionales = {
   nombre: "Nombre de representante de Institución Proponente",
   validacion_contenido_obligatorio: true,
   validaciones_activas: false,
    validacion_vacio_mensaje: "Campo no puede estar vacío",
   validacion_min: "",
   validacion_max: "",
   validacion_min_activa: false,
   validacion_max_activa: false,
   tooltip: "Nombre de persona natural de la institución proponente que la representará durante el procedimiento de Manifestación de Interés.",
   ayuda: "Nombre de persona natural de la institución proponente que la representará durante el procedimiento de Manifestación de Interés.",
   id_referencial: "22"
}
campo = Campo.find_by(atributos_obligatorios)
campo = campo.present? ? campo : Campo.new(atributos_obligatorios)
campo.sin_validaciones = true 
campo.update(atributos_opcionales)
campo.tareas = Tarea.where(id: 1)

#--------------------------------------------------------------------------------------------------------------------------------------------#
# Campo antiguo
atributos_obligatorios = {
   clase: "ManifestacionDeInteres",
   atributo: "proponente_institucion_id",
   tipo: "integer"
}
atributos_opcionales = {
   nombre: "Institución Proponente",
   validacion_contenido_obligatorio: true,
   validaciones_activas: false,
    validacion_vacio_mensaje: "Campo no puede estar vacío",
   validacion_min: "",
   validacion_max: "",
   validacion_min_activa: false,
   validacion_max_activa: false,
   tooltip: "La institución proponente es la Institución que gestionará el procedimiento de Manifestación de Interés en representación de la institución Gestora.",
   ayuda: "La institución proponente es la Institución que gestionará el procedimiento de Manifestación de Interés en representación de la institución Gestora.",
   id_referencial: "23"
}
campo = Campo.find_by(atributos_obligatorios)
campo = campo.present? ? campo : Campo.new(atributos_obligatorios)
campo.sin_validaciones = true 
campo.update(atributos_opcionales)
campo.tareas = Tarea.where(id: 1)

#--------------------------------------------------------------------------------------------------------------------------------------------#
# Campo antiguo
atributos_obligatorios = {
   clase: "ManifestacionDeInteres",
   atributo: "buscar_institución_gestora",
   tipo: "button"
}
atributos_opcionales = {
   nombre: "Elegir institución Gestora del Acuerdo",
   validacion_contenido_obligatorio: true,
   validaciones_activas: false,
    validacion_vacio_mensaje: "Campo no puede estar vacío",
   validacion_min: "",
   validacion_max: "",
   validacion_min_activa: false,
   validacion_max_activa: false,
   tooltip: "Institución que actuará como contraparte directa de la Agencia en la ejecución del Acuerdo",
   ayuda: "Institución que actuará como contraparte directa de la Agencia en la ejecución del Acuerdo",
   id_referencial: "24"
}
campo = Campo.find_by(atributos_obligatorios)
campo = campo.present? ? campo : Campo.new(atributos_obligatorios)
campo.sin_validaciones = true 
campo.update(atributos_opcionales)
campo.tareas = Tarea.where(id: 1)

#--------------------------------------------------------------------------------------------------------------------------------------------#
# Campo antiguo
atributos_obligatorios = {
   clase: "ManifestacionDeInteres",
   atributo: "institucion_gestora_acuerdo",
   tipo: "text_selection"
}
atributos_opcionales = {
   nombre: "Institución Gestora del Acuerdo",
   validacion_contenido_obligatorio: true,
   validaciones_activas: false,
    validacion_vacio_mensaje: "Campo no puede estar vacío",
   validacion_min: "",
   validacion_max: "",
   validacion_min_activa: false,
   validacion_max_activa: false,
   tooltip: "Nombre institucion Gestora Acuerdo",
   ayuda: "Nombre institucion Gestora Acuerdo",
   id_referencial: "24.1"
}
campo = Campo.find_by(atributos_obligatorios)
campo = campo.present? ? campo : Campo.new(atributos_obligatorios)
campo.sin_validaciones = true 
campo.update(atributos_opcionales)
campo.tareas = Tarea.where(id: 1)

#--------------------------------------------------------------------------------------------------------------------------------------------#
# Campo antiguo
atributos_obligatorios = {
   clase: "ManifestacionDeInteres",
   atributo: "rut_institucion_gestora_acuerdo",
   tipo: "text_selection"
}
atributos_opcionales = {
   nombre: "RUT institucion Gestora del Acuerdo",
   validacion_contenido_obligatorio: true,
   validaciones_activas: false,
    validacion_vacio_mensaje: "Campo no puede estar vacío",
   validacion_min: "",
   validacion_max: "",
   validacion_min_activa: false,
   validacion_max_activa: false,
   tooltip: "RUT institución Gestora Acuerdo",
   ayuda: "RUT institución Gestora Acuerdo",
   id_referencial: "24.2"
}
campo = Campo.find_by(atributos_obligatorios)
campo = campo.present? ? campo : Campo.new(atributos_obligatorios)
campo.sin_validaciones = true 
campo.update(atributos_opcionales)
campo.tareas = Tarea.where(id: 1)

#--------------------------------------------------------------------------------------------------------------------------------------------#
# Campo antiguo
atributos_obligatorios = {
   clase: "ManifestacionDeInteres",
   atributo: "direccion_institucion_gestora_acuerdo",
   tipo: "text_selection"
}
atributos_opcionales = {
   nombre: "Dirección institucion Gestora del Acuerdo",
   validacion_contenido_obligatorio: true,
   validaciones_activas: false,
    validacion_vacio_mensaje: "Campo no puede estar vacío",
   validacion_min: "",
   validacion_max: "",
   validacion_min_activa: false,
   validacion_max_activa: false,
   tooltip: "Dirección de Casa Matriz o central de la institucion Gestora",
   ayuda: "Dirección de Casa Matriz o central de la institucion Gestora",
   id_referencial: "24.3"
}
campo = Campo.find_by(atributos_obligatorios)
campo = campo.present? ? campo : Campo.new(atributos_obligatorios)
campo.sin_validaciones = true 
campo.update(atributos_opcionales)
campo.tareas = Tarea.where(id: 1)

#--------------------------------------------------------------------------------------------------------------------------------------------#
# Campo antiguo
atributos_obligatorios = {
   clase: "ManifestacionDeInteres",
   atributo: "ubicacion_exacta",
   tipo: "text_selection"
}
atributos_opcionales = {
   nombre: "Ubicación Exacta",
   validacion_contenido_obligatorio: true,
   validaciones_activas: false,
    validacion_vacio_mensaje: "Campo no puede estar vacío",
   validacion_min: "",
   validacion_max: "",
   validacion_min_activa: false,
   validacion_max_activa: false,
   tooltip: "Coordenadas",
   ayuda: "Coordenadas",
   id_referencial: "24.4"
}
campo = Campo.find_by(atributos_obligatorios)
campo = campo.present? ? campo : Campo.new(atributos_obligatorios)
campo.sin_validaciones = true 
campo.update(atributos_opcionales)
campo.tareas = Tarea.where(id: 1)

#--------------------------------------------------------------------------------------------------------------------------------------------#
# Campo antiguo
atributos_obligatorios = {
   clase: "ManifestacionDeInteres",
   atributo: "tipo_contribuyente_de_institucion_gestora",
   tipo: "text_selection"
}
atributos_opcionales = {
   nombre: "Naturaleza jurídica de institucion Gestora del Acuerdo",
   validacion_contenido_obligatorio: true,
   validaciones_activas: false,
    validacion_vacio_mensaje: "Campo no puede estar vacío",
   validacion_min: "",
   validacion_max: "",
   validacion_min_activa: false,
   validacion_max_activa: false,
   tooltip: "Tipo de institucion Gestora",
   ayuda: "Tipo de institucion Gestora",
   id_referencial: "24.5"
}
campo = Campo.find_by(atributos_obligatorios)
campo = campo.present? ? campo : Campo.new(atributos_obligatorios)
campo.sin_validaciones = true 
campo.update(atributos_opcionales)
campo.tareas = Tarea.where(id: 1)

#--------------------------------------------------------------------------------------------------------------------------------------------#
# Campo antiguo
atributos_obligatorios = {
   clase: "ManifestacionDeInteres",
   atributo: "numero_de_socios_institucion_gestora",
   tipo: "integer"
}
atributos_opcionales = {
   nombre: "Número de Socios institucion Gestora",
   validacion_contenido_obligatorio: false,
   validaciones_activas: false,
    validacion_vacio_mensaje: "",
   validacion_min: "",
   validacion_max: "",
   validacion_min_activa: false,
   validacion_max_activa: false,
   tooltip: "Solo si la naturaleza de la institución así lo hace pertinente, indicar número de socios.",
   ayuda: "Solo si la naturaleza de la institución así lo hace pertinente, indicar número de socios.",
   id_referencial: "24.6"
}
campo = Campo.find_by(atributos_obligatorios)
campo = campo.present? ? campo : Campo.new(atributos_obligatorios)
campo.sin_validaciones = true 
campo.update(atributos_opcionales)
campo.tareas = Tarea.where(id: 1)

#--------------------------------------------------------------------------------------------------------------------------------------------#
# Campo antiguo
atributos_obligatorios = {
   clase: "ManifestacionDeInteres",
   atributo: "fecha_creacion_institucion",
   tipo: "date"
}
atributos_opcionales = {
   nombre: "Fecha Creación institucion",
   validacion_contenido_obligatorio: true,
   validaciones_activas: false,
    validacion_vacio_mensaje: "Campo no puede estar vacío",
   validacion_min: "",
   validacion_max: "",
   validacion_min_activa: false,
   validacion_max_activa: false,
   tooltip: "Ingresar fecha creación de la institucion que estará a cargo de este Acuerdo.",
   ayuda: "Ingresar fecha creación de la institucion que estará a cargo de este Acuerdo.",
   id_referencial: "24.7"
}
campo = Campo.find_by(atributos_obligatorios)
campo = campo.present? ? campo : Campo.new(atributos_obligatorios)
campo.sin_validaciones = true 
campo.update(atributos_opcionales)
campo.tareas = Tarea.where(id: 1)

#--------------------------------------------------------------------------------------------------------------------------------------------#
# Campo nuevo
atributos_obligatorios = {
   clase: "ManifestacionDeInteres",
   atributo: "sucursal_ligada",
   tipo: "select"
}
atributos_opcionales = {
   nombre: "Establecimiento (Sucursal) ligada al acuerdo",
   validacion_contenido_obligatorio: true,
   validaciones_activas: false,
    validacion_vacio_mensaje: "Campo no puede estar vacío",
   validacion_min: "",
   validacion_max: "",
   validacion_min_activa: false,
   validacion_max_activa: false,
   tooltip: "Establecimiento de la institución Gestora que es más pertinente al Acuerdo propuesto.
              De no marcar alguna, el acuerdo quedará ligado a la casa matriz.",
   ayuda: "Establecimiento de la institución Gestora que es más pertinente al Acuerdo propuesto.
              De no marcar alguna, el acuerdo quedará ligado a la casa matriz.",
   id_referencial: "25"
}
campo = Campo.find_by(atributos_obligatorios)
campo = campo.present? ? campo : Campo.new(atributos_obligatorios)
campo.sin_validaciones = true 
campo.update(atributos_opcionales)
campo.tareas = Tarea.where(id: 1)

#--------------------------------------------------------------------------------------------------------------------------------------------#
# Campo antiguo
atributos_obligatorios = {
   clase: "ManifestacionDeInteres",
   atributo: "descarga_formato_carta_manifestacion_de_interes",
   tipo: "button"
}
atributos_opcionales = {
   nombre: "Formato Carta de Manifestación de Interés",
   validacion_contenido_obligatorio: true,
   validaciones_activas: false,
    validacion_vacio_mensaje: "Campo no puede estar vacío",
   validacion_min: "",
   validacion_max: "",
   validacion_min_activa: false,
   validacion_max_activa: false,
   tooltip: "Se debe adjuntar una Carta de Manifestación de Interés con el siguiente formato, incluyendo la documentación que acredite que quien firma la carta posee facultades para comprometer a la institución con un rol de Gestor del mismo.",
   ayuda: "Se debe adjuntar una Carta de Manifestación de Interés con el siguiente formato, incluyendo la documentación que acredite que quien firma la carta posee facultades para comprometer a la institución con un rol de Gestor del mismo.",
   id_referencial: "26"
}
campo = Campo.find_by(atributos_obligatorios)
campo = campo.present? ? campo : Campo.new(atributos_obligatorios)
campo.sin_validaciones = true 
campo.update(atributos_opcionales)
campo.tareas = Tarea.where(id: 1)

#--------------------------------------------------------------------------------------------------------------------------------------------#
# Campo antiguo
atributos_obligatorios = {
   clase: "ManifestacionDeInteres",
   atributo: "equipo_de_trabajo_comprometido",
   tipo: "text"
}
atributos_opcionales = {
   nombre: "Equipo de trabajo comprometido",
   validacion_contenido_obligatorio: true,
   validaciones_activas: true,
    validacion_vacio_mensaje: "Campo no puede estar vacío",
   validacion_min: 10,
   validacion_max: 2000,
   validacion_min_activa: true,
   validacion_max_activa: true,
   tooltip: "Individualización de las personas de la institución Gestora que apoyarán la consecución de este acuerdo, incluyendo algún dato de contacto y su rol dentro del acuerdo.",
   ayuda: "Individualización de las personas de la institución Gestora que apoyarán la consecución de este acuerdo, incluyendo algún dato de contacto y su rol dentro del acuerdo.",
   id_referencial: "27"
}
campo = Campo.find_by(atributos_obligatorios)
campo = campo.present? ? campo : Campo.new(atributos_obligatorios)
campo.sin_validaciones = true 
campo.update(atributos_opcionales)
campo.tareas = Tarea.where(id: 1)

#--------------------------------------------------------------------------------------------------------------------------------------------#
# Campo antiguo
atributos_obligatorios = {
   clase: "ManifestacionDeInteres",
   atributo: "experiencia_en_gestion_de_proyectos",
   tipo: "text"
}
atributos_opcionales = {
   nombre: "Experiencia en gestión de proyectos con recursos de terceros",
   validacion_contenido_obligatorio: true,
   validaciones_activas: true,
    validacion_vacio_mensaje: "Campo no puede estar vacío",
   validacion_min: 5,
   validacion_max: 2000,
   validacion_min_activa: true,
   validacion_max_activa: true,
   tooltip: "Identificar proyectos gestionados en los últimos dos (2) años por la institución, nombre de la institución que co-financió dicho proyecto y montos involucrados. Si no se posee experiencia en los últimos dos años, señalar 'ninguno'.",
   ayuda: "Identificar proyectos gestionados en los últimos dos (2) años por la institución, nombre de la institución que co-financió dicho proyecto y montos involucrados. Si no se posee experiencia en los últimos dos años, señalar 'ninguno'.",
   id_referencial: "28"
}
campo = Campo.find_by(atributos_obligatorios)
campo = campo.present? ? campo : Campo.new(atributos_obligatorios)
campo.sin_validaciones = true 
campo.update(atributos_opcionales)
campo.tareas = Tarea.where(id: 1)
#--------------------------------------------------------------------------------------------------------------------------------------------#
# Campo nuevo
atributos_obligatorios = {
   clase: "ManifestacionDeInteres",
   atributo: "justificacion_de_seleccion",
   tipo: "text"
}
atributos_opcionales = {
   nombre: "Justificación de Selección",
   validacion_contenido_obligatorio: false,
   validaciones_activas: true,
    validacion_vacio_mensaje: "Campo no puede estar vacío",
   validacion_min: "",
   validacion_max: 2000,
   validacion_min_activa: false,
   validacion_max_activa: true,
   tooltip: "Justificar por qué el gestor seleccionado no es una asociaciones gremiales u otras entidades sectoriales o multisectoriales existente. Se aceptarán excepciones cuando no exista una institución que cumpla esas condiciones, o la existente no posea la capacidad de gestión adecuada o no sea representativa del grupo específico de empresas que se pretende adhieran al Acuerdo.",
   ayuda: "Justificar por qué el gestor seleccionado no es una asociaciones gremiales u otras entidades sectoriales o multisectoriales existente. Se aceptarán excepciones cuando no exista una institución que cumpla esas condiciones, o la existente no posea la capacidad de gestión adecuada o no sea representativa del grupo específico de empresas que se pretende adhieran al Acuerdo.",
   id_referencial: "24.8"
}
campo = Campo.find_by(atributos_obligatorios)
campo = campo.present? ? campo : Campo.new(atributos_obligatorios)
campo.sin_validaciones = true 
campo.update(atributos_opcionales)
campo.tareas = Tarea.where(id: 1)
#--------------------------------------------------------------------------------------------------------------------------------------------#
# Campo nuevo
atributos_obligatorios = {
   clase: "ManifestacionDeInteres",
   atributo: "registro_en_linea",
   tipo: "text"
}
atributos_opcionales = {
   nombre: "Registro en Línea",
   validacion_contenido_obligatorio: false,
   validaciones_activas: true,
    validacion_vacio_mensaje: "Campo no puede estar vacío",
   validacion_min: "",
   validacion_max: 2000,
   validacion_min_activa: false,
   validacion_max_activa: true,
   tooltip: "Indicar si el documento para verificar la existencia y vigencia de las personerías presentadas puede ser obtenido del “Registro de Empresas y Sociedades” a que se refiere el Título IV la Ley  N° 20.659, del registro de “Cooperativas, Asociaciones Gremiales y Asociaciones de Consumidores del Ministerio de Economía, Fomento y Turismo” u otro registro oficial gratuito disponible en línea.",
   ayuda: "Indicar si el documento para verificar la existencia y vigencia de las personerías presentadas puede ser obtenido del “Registro de Empresas y Sociedades” a que se refiere el Título IV la Ley  N° 20.659, del registro de “Cooperativas, Asociaciones Gremiales y Asociaciones de Consumidores del Ministerio de Economía, Fomento y Turismo” u otro registro oficial gratuito disponible en línea.",
   id_referencial: "24.9"
}
campo = Campo.find_by(atributos_obligatorios)
campo = campo.present? ? campo : Campo.new(atributos_obligatorios)
campo.sin_validaciones = true 
campo.update(atributos_opcionales)
campo.tareas = Tarea.where(id: 1)

#--------------------------------------------------------------------------------------------------------------------------------------------#
# Campo nuevo
atributos_obligatorios = {
   clase: "ManifestacionDeInteres",
   atributo: "elegir_representante_institucion",
   tipo: "button"
}
atributos_opcionales = {
   nombre: "Elegir representante de Institución Gestora",
   validacion_contenido_obligatorio: true,
   validaciones_activas: false,
    validacion_vacio_mensaje: "Campo no puede estar vacío",
   validacion_min: "",
   validacion_max: "",
   validacion_min_activa: false,
   validacion_max_activa: false,
   tooltip: "Persona natural de la institución gestora que la representará durante el Acuerdo.",
   ayuda: "Persona natural de la institución gestora que la representará durante el Acuerdo.",
   id_referencial: "29"
}
campo = Campo.find_by(atributos_obligatorios)
campo = campo.present? ? campo : Campo.new(atributos_obligatorios)
campo.sin_validaciones = true 
campo.update(atributos_opcionales)
campo.tareas = Tarea.where(id: 1)

#--------------------------------------------------------------------------------------------------------------------------------------------#
# Campo antiguo
atributos_obligatorios = {
   clase: "ManifestacionDeInteres",
   atributo: "nombre_representante_para_acuerdo",
   tipo: "text_selection"
}
atributos_opcionales = {
   nombre: "Nombre Representante de Institución Gestora",
   validacion_contenido_obligatorio: true,
   validaciones_activas: false,
    validacion_vacio_mensaje: "Campo no puede estar vacío",
   validacion_min: "",
   validacion_max: "",
   validacion_min_activa: false,
   validacion_max_activa: false,
   tooltip: "",
   ayuda: "",
   id_referencial: "29.1"
}
campo = Campo.find_by(atributos_obligatorios)
campo = campo.present? ? campo : Campo.new(atributos_obligatorios)
campo.sin_validaciones = true 
campo.update(atributos_opcionales)
campo.tareas = Tarea.where(id: 1)

#--------------------------------------------------------------------------------------------------------------------------------------------#
# Campo antiguo
atributos_obligatorios = {
   clase: "ManifestacionDeInteres",
   atributo: "rut_representante_para_acuerdo",
   tipo: "text_selection"
}
atributos_opcionales = {
   nombre: "RUT Representante de Institución Gestora",
   validacion_contenido_obligatorio: true,
   validaciones_activas: false,
    validacion_vacio_mensaje: "Campo no puede estar vacío",
   validacion_min: "",
   validacion_max: "",
   validacion_min_activa: false,
   validacion_max_activa: false,
   tooltip: "",
   ayuda: "",
   id_referencial: "29.2"
}
campo = Campo.find_by(atributos_obligatorios)
campo = campo.present? ? campo : Campo.new(atributos_obligatorios)
campo.sin_validaciones = true 
campo.update(atributos_opcionales)
campo.tareas = Tarea.where(id: 1)

#--------------------------------------------------------------------------------------------------------------------------------------------#
# Campo antiguo
atributos_obligatorios = {
   clase: "ManifestacionDeInteres",
   atributo: "telefono_representante_para_acuerdo",
   tipo: "text_selection"
}
atributos_opcionales = {
   nombre: "Teléfono Representante de Institución Gestora",
   validacion_contenido_obligatorio: true,
   validaciones_activas: false,
    validacion_vacio_mensaje: "Campo no puede estar vacío",
   validacion_min: "",
   validacion_max: "",
   validacion_min_activa: false,
   validacion_max_activa: false,
   tooltip: "",
   ayuda: "",
   id_referencial: "29.3"
}
campo = Campo.find_by(atributos_obligatorios)
campo = campo.present? ? campo : Campo.new(atributos_obligatorios)
campo.sin_validaciones = true 
campo.update(atributos_opcionales)
campo.tareas = Tarea.where(id: 1)

#--------------------------------------------------------------------------------------------------------------------------------------------#
# Campo antiguo
atributos_obligatorios = {
   clase: "ManifestacionDeInteres",
   atributo: "email_representante_para_acuerdo",
   tipo: "text_selection"
}
atributos_opcionales = {
   nombre: "Mail Representante de Institución Gestora",
   validacion_contenido_obligatorio: true,
   validaciones_activas: false,
    validacion_vacio_mensaje: "Campo no puede estar vacío",
   validacion_min: "",
   validacion_max: "",
   validacion_min_activa: false,
   validacion_max_activa: false,
   tooltip: "",
   ayuda: "",
   id_referencial: "29.4"
}
campo = Campo.find_by(atributos_obligatorios)
campo = campo.present? ? campo : Campo.new(atributos_obligatorios)
campo.sin_validaciones = true 
campo.update(atributos_opcionales)
campo.tareas = Tarea.where(id: 1)

#--------------------------------------------------------------------------------------------------------------------------------------------#
# Campo antiguo
atributos_obligatorios = {
   clase: "ManifestacionDeInteres",
   atributo: "nombre_proyecto",
   tipo: "text"
}
atributos_opcionales = {
   nombre: "Nombre del proyecto de inversión.",
   validacion_contenido_obligatorio: false,
   validaciones_activas: true,
    validacion_vacio_mensaje: "",
   validacion_min: "",
   validacion_max: 100,
   validacion_min_activa: false,
   validacion_max_activa: true,
   tooltip: "Nombre del proyecto de inversión.",
   ayuda: "Nombre del proyecto de inversión.",
   id_referencial: "31"
}
campo = Campo.find_by(atributos_obligatorios)
campo = campo.present? ? campo : Campo.new(atributos_obligatorios)
campo.sin_validaciones = true 
campo.update(atributos_opcionales)
campo.tareas = Tarea.where(id: 1)

#--------------------------------------------------------------------------------------------------------------------------------------------#
# Campo antiguo
atributos_obligatorios = {
   clase: "ManifestacionDeInteres",
   atributo: "descripcion_proyecto",
   tipo: "text"
}
atributos_opcionales = {
   nombre: "Descripción del proyecto",
   validacion_contenido_obligatorio: false,
   validaciones_activas: true,
    validacion_vacio_mensaje: "",
   validacion_min: "",
   validacion_max: 5000,
   validacion_min_activa: false,
   validacion_max_activa: true,
   tooltip: "Descripción y caracteristicas del proyecto de inversión.",
   ayuda: "Descripción y caracteristicas del proyecto de inversión.",
   id_referencial: "32"
}
campo = Campo.find_by(atributos_obligatorios)
campo = campo.present? ? campo : Campo.new(atributos_obligatorios)
campo.sin_validaciones = true 
campo.update(atributos_opcionales)
campo.tareas = Tarea.where(id: 1)

#--------------------------------------------------------------------------------------------------------------------------------------------#
# Campo antiguo
atributos_obligatorios = {
   clase: "ManifestacionDeInteres",
   atributo: "justificacion_proyecto",
   tipo: "text"
}
atributos_opcionales = {
   nombre: "Justificación, impactos y oportunidades del Proyecto",
   validacion_contenido_obligatorio: false,
   validaciones_activas: true,
    validacion_vacio_mensaje: "",
   validacion_min: "",
   validacion_max: 10000,
   validacion_min_activa: false,
   validacion_max_activa: true,
   tooltip: "Indicar las razones por las cuales proyecto es favorable al territorio. Detallar los impactos potenciales, así como las oportunidades de desarrollo local.",
   ayuda: "Indicar las razones por las cuales proyecto es favorable al territorio. Detallar los impactos potenciales, así como las oportunidades de desarrollo local.",
   id_referencial: "33"
}
campo = Campo.find_by(atributos_obligatorios)
campo = campo.present? ? campo : Campo.new(atributos_obligatorios)
campo.sin_validaciones = true 
campo.update(atributos_opcionales)
campo.tareas = Tarea.where(id: 1)

#--------------------------------------------------------------------------------------------------------------------------------------------#
# Campo nuevo
atributos_obligatorios = {
   clase: "ManifestacionDeInteres",
   atributo: "detalle_de_localizacion",
   tipo: "text"
}
atributos_opcionales = {
   nombre: "Localización del Proyecto",
   validacion_contenido_obligatorio: false,
   validaciones_activas: true,
    validacion_vacio_mensaje: "",
   validacion_min: "",
   validacion_max: 1000,
   validacion_min_activa: false,
   validacion_max_activa: true,
   tooltip: "Detallar las características de acceso y la ubicación del área geográfica de influencia del proyecto.",
   ayuda: "Detallar las características de acceso y la ubicación del área geográfica de influencia del proyecto.",
   id_referencial: "34"
}
campo = Campo.find_by(atributos_obligatorios)
campo = campo.present? ? campo : Campo.new(atributos_obligatorios)
campo.sin_validaciones = true 
campo.update(atributos_opcionales)
campo.tareas = Tarea.where(id: 1)

#--------------------------------------------------------------------------------------------------------------------------------------------#
# Campo antiguo
atributos_obligatorios = {
   clase: "ManifestacionDeInteres",
   atributo: "area_influencia_proyecto_data",
   tipo: "map"
}
atributos_opcionales = {
   nombre: "Localización del Proyecto Mapa",
   validacion_contenido_obligatorio: false,
   validaciones_activas: false,
    validacion_vacio_mensaje: "",
   validacion_min: "",
   validacion_max: "",
   validacion_min_activa: false,
   validacion_max_activa: false,
   tooltip: "Sobre localización del proyecto. Marcar el área de influencia de localización principal.",
   ayuda: "Sobre localización del proyecto. Marcar el área de influencia de localización principal.",
   id_referencial: "34.1"
}
campo = Campo.find_by(atributos_obligatorios)
campo = campo.present? ? campo : Campo.new(atributos_obligatorios)
campo.sin_validaciones = true 
campo.update(atributos_opcionales)
campo.tareas = Tarea.where(id: 1)

#--------------------------------------------------------------------------------------------------------------------------------------------#
# Campo nuevo
atributos_obligatorios = {
   clase: "ManifestacionDeInteres",
   atributo: "area_influencia_proyecto_archivo",
   tipo: "upload"
}
atributos_opcionales = {
   nombre: "Importar Área Influencia",
   validacion_contenido_obligatorio: false,
   validaciones_activas: false,
    validacion_vacio_mensaje: "",
   validacion_min: "",
   validacion_max: "",
   validacion_min_activa: false,
   validacion_max_activa: false,
   tooltip: "O importe mapa desde un archivo para el Área de influencia del proyecto.",
   ayuda: "O importe mapa desde un archivo para el Área de influencia del proyecto.",
   id_referencial: "34.2"
}
campo = Campo.find_by(atributos_obligatorios)
campo = campo.present? ? campo : Campo.new(atributos_obligatorios)
campo.sin_validaciones = true 
campo.update(atributos_opcionales)
campo.tareas = Tarea.where(id: 1)

#--------------------------------------------------------------------------------------------------------------------------------------------#
# Campo nuevo
atributos_obligatorios = {
   clase: "ManifestacionDeInteres",
   atributo: "detalle_de_alternativa_de_instalacion",
   tipo: "text"
}
atributos_opcionales = {
   nombre: "Alternativas de Instalación",
   validacion_contenido_obligatorio: false,
   validaciones_activas: true,
    validacion_vacio_mensaje: "",
   validacion_min: "",
   validacion_max: 1000,
   validacion_min_activa: false,
   validacion_max_activa: true,
   tooltip: "Detallar locaciones alternativas que hayan sido consideradas.",
   ayuda: "Detallar locaciones alternativas que hayan sido consideradas.",
   id_referencial: "35"
}
campo = Campo.find_by(atributos_obligatorios)
campo = campo.present? ? campo : Campo.new(atributos_obligatorios)
campo.sin_validaciones = true 
campo.update(atributos_opcionales)
campo.tareas = Tarea.where(id: 1)

#--------------------------------------------------------------------------------------------------------------------------------------------#
# Campo antiguo
atributos_obligatorios = {
   clase: "ManifestacionDeInteres",
   atributo: "alternativas_instalacion_data",
   tipo: "map"
}
atributos_opcionales = {
   nombre: "Alternativas Instalación mapa",
   validacion_contenido_obligatorio: false,
   validaciones_activas: false,
    validacion_vacio_mensaje: "",
   validacion_min: "",
   validacion_max: "",
   validacion_min_activa: false,
   validacion_max_activa: false,
   tooltip: "Sobre localización del proyecto. Detallar locaciones alternativas que hayan sido consideradas.",
   ayuda: "Sobre localización del proyecto. Detallar locaciones alternativas que hayan sido consideradas.",
   id_referencial: "35.1"
}
campo = Campo.find_by(atributos_obligatorios)
campo = campo.present? ? campo : Campo.new(atributos_obligatorios)
campo.sin_validaciones = true 
campo.update(atributos_opcionales)
campo.tareas = Tarea.where(id: 1)

#--------------------------------------------------------------------------------------------------------------------------------------------#
# Campo nuevo
atributos_obligatorios = {
   clase: "ManifestacionDeInteres",
   atributo: "alternativas_instalacion_archivo",
   tipo: "upload"
}
atributos_opcionales = {
   nombre: "Importar Alternativas Instalación",
   validacion_contenido_obligatorio: false,
   validaciones_activas: false,
    validacion_vacio_mensaje: "",
   validacion_min: "",
   validacion_max: "",
   validacion_min_activa: false,
   validacion_max_activa: false,
   tooltip: "O importe mapa desde un archivo para las locaciones alternativas.",
   ayuda: "O importe mapa desde un archivo para las locaciones alternativas.",
   id_referencial: "35.2"
}
campo = Campo.find_by(atributos_obligatorios)
campo = campo.present? ? campo : Campo.new(atributos_obligatorios)
campo.sin_validaciones = true 
campo.update(atributos_opcionales)
campo.tareas = Tarea.where(id: 1)

#--------------------------------------------------------------------------------------------------------------------------------------------#
# Campo antiguo
atributos_obligatorios = {
   clase: "ManifestacionDeInteres",
   atributo: "monto_inversion",
   tipo: "integer"
}
atributos_opcionales = {
   nombre: "Monto Inversión",
   validacion_contenido_obligatorio: false,
   validaciones_activas: false,
    validacion_vacio_mensaje: "",
   validacion_min: 100000,
   validacion_max: 10000000000,
   validacion_min_activa: true,
   validacion_max_activa: true,
   tooltip: "¿Cuál es el monto total (en pesos $) de la inversión del proyecto que se postula?",
   ayuda: "¿Cuál es el monto total (en pesos $) de la inversión del proyecto que se postula?",
   id_referencial: "36"
}
campo = Campo.find_by(atributos_obligatorios)
campo = campo.present? ? campo : Campo.new(atributos_obligatorios)
campo.sin_validaciones = true 
campo.update(atributos_opcionales)
campo.tareas = Tarea.where(id: 1)

#--------------------------------------------------------------------------------------------------------------------------------------------#
# Campo antiguo
atributos_obligatorios = {
   clase: "ManifestacionDeInteres",
   atributo: "tecnologia",
   tipo: "text"
}
atributos_opcionales = {
   nombre: "Tecnología",
   validacion_contenido_obligatorio: false,
   validaciones_activas: true,
    validacion_vacio_mensaje: "",
   validacion_min: "",
   validacion_max: 1000,
   validacion_min_activa: false,
   validacion_max_activa: true,
   tooltip: "Descripción de las tecnologías contempladas en la operación del proyecto de inversión.",
   ayuda: "Descripción de las tecnologías contempladas en la operación del proyecto de inversión.",
   id_referencial: "37"
}
campo = Campo.find_by(atributos_obligatorios)
campo = campo.present? ? campo : Campo.new(atributos_obligatorios)
campo.sin_validaciones = true 
campo.update(atributos_opcionales)
campo.tareas = Tarea.where(id: 1)

#--------------------------------------------------------------------------------------------------------------------------------------------#
# Campo antiguo
atributos_obligatorios = {
   clase: "ManifestacionDeInteres",
   atributo: "estado_proyecto",
   tipo: "text"
}
atributos_opcionales = {
   nombre: "Estado Proyecto",
   validacion_contenido_obligatorio: false,
   validaciones_activas: true,
    validacion_vacio_mensaje: "",
   validacion_min: "",
   validacion_max: 3000,
   validacion_min_activa: false,
   validacion_max_activa: true,
   tooltip: "Descripción del estado de la ingeniería, estudios y otras actividades del proyecto, así como la descripción de la etapa en que se encuentra el proyecto de inversión:  Idea de Inversión, Perfil del proyecto, Pre factibilidad, Factibilidad, Diseño Detallado
              Proyecto, Construcción, Operación, Ampliación o Cierre.",
   ayuda: "Descripción del estado de la ingeniería, estudios y otras actividades del proyecto, así como la descripción de la etapa en que se encuentra el proyecto de inversión:  Idea de Inversión, Perfil del proyecto, Pre factibilidad, Factibilidad, Diseño Detallado
              Proyecto, Construcción, Operación, Ampliación o Cierre.",
   id_referencial: "38"
}
campo = Campo.find_by(atributos_obligatorios)
campo = campo.present? ? campo : Campo.new(atributos_obligatorios)
campo.sin_validaciones = true 
campo.update(atributos_opcionales)
campo.tareas = Tarea.where(id: 1)

#--------------------------------------------------------------------------------------------------------------------------------------------#
# Campo antiguo
atributos_obligatorios = {
   clase: "ManifestacionDeInteres",
   atributo: "operador",
   tipo: "text"
}
atributos_opcionales = {
   nombre: "Operador",
   validacion_contenido_obligatorio: false,
   validaciones_activas: true,
    validacion_vacio_mensaje: "",
   validacion_min: "",
   validacion_max: 1000,
   validacion_min_activa: false,
   validacion_max_activa: true,
   tooltip: "Indicar si la empresa es operador o desarrollador. Además, sañalar si el proyecto será operado por la misma entidad gestora u otra empresa.",
   ayuda: "Indicar si la empresa es operador o desarrollador. Además, sañalar si el proyecto será operado por la misma entidad gestora u otra empresa.",
   id_referencial: "39"
}
campo = Campo.find_by(atributos_obligatorios)
campo = campo.present? ? campo : Campo.new(atributos_obligatorios)
campo.sin_validaciones = true 
campo.update(atributos_opcionales)
campo.tareas = Tarea.where(id: 1)

#--------------------------------------------------------------------------------------------------------------------------------------------#
# Campo antiguo
atributos_obligatorios = {
   clase: "ManifestacionDeInteres",
   atributo: "otros_proyectos_en_territorios_cercanos",
   tipo: "text"
}
atributos_opcionales = {
   nombre: "Otros Proyectos del Desarrollador/Operador en territorios cercanos",
   validacion_contenido_obligatorio: false,
   validaciones_activas: true,
    validacion_vacio_mensaje: "",
   validacion_min: "",
   validacion_max: 1000,
   validacion_min_activa: false,
   validacion_max_activa: true,
   tooltip: "Indicar si existen otros proyectos desarrollados por la empresa en el territorio o en otras localidades.",
   ayuda: "Indicar si existen otros proyectos desarrollados por la empresa en el territorio o en otras localidades.",
   id_referencial: "40"
}
campo = Campo.find_by(atributos_obligatorios)
campo = campo.present? ? campo : Campo.new(atributos_obligatorios)
campo.sin_validaciones = true 
campo.update(atributos_opcionales)
campo.tareas = Tarea.where(id: 1)

#--------------------------------------------------------------------------------------------------------------------------------------------#
# Campo antiguo
atributos_obligatorios = {
   clase: "ManifestacionDeInteres",
   atributo: "otro_datos_proyecto",
   tipo: "text"
}
atributos_opcionales = {
   nombre: "Otro datos del proyecto",
   validacion_contenido_obligatorio: false,
   validaciones_activas: true,
    validacion_vacio_mensaje: "",
   validacion_min: "",
   validacion_max: 1000,
   validacion_min_activa: false,
   validacion_max_activa: true,
   tooltip: "Indicar otros datos afines al proyecto.",
   ayuda: "Indicar otros datos afines al proyecto.",
   id_referencial: "41"
}
campo = Campo.find_by(atributos_obligatorios)
campo = campo.present? ? campo : Campo.new(atributos_obligatorios)
campo.sin_validaciones = true 
campo.update(atributos_opcionales)
campo.tareas = Tarea.where(id: 1)

#--------------------------------------------------------------------------------------------------------------------------------------------#
# Campo antiguo
atributos_obligatorios = {
   clase: "ManifestacionDeInteres",
   atributo: "gantt_proyecto",
   tipo: "upload"
}
atributos_opcionales = {
   nombre: "Gantt Proyecto",
   validacion_contenido_obligatorio: false,
   validaciones_activas: false,
    validacion_vacio_mensaje: "",
   validacion_min: "",
   validacion_max: "",
   validacion_min_activa: false,
   validacion_max_activa: false,
   tooltip: "Archivo adjunto con carta gantt proyecto que precise fase en la que se encuentra",
   ayuda: "Archivo adjunto con carta gantt proyecto que precise fase en la que se encuentra",
   id_referencial: "42"
}
campo = Campo.find_by(atributos_obligatorios)
campo = campo.present? ? campo : Campo.new(atributos_obligatorios)
campo.sin_validaciones = true 
campo.update(atributos_opcionales)
campo.tareas = Tarea.where(id: 1)

#--------------------------------------------------------------------------------------------------------------------------------------------#
# Campo antiguo
atributos_obligatorios = {
   clase: "ManifestacionDeInteres",
   atributo: "estudio_de_mercado",
   tipo: "upload"
}
atributos_opcionales = {
   nombre: "Estudio de Mercado",
   validacion_contenido_obligatorio: false,
   validaciones_activas: false,
    validacion_vacio_mensaje: "",
   validacion_min: "",
   validacion_max: "",
   validacion_min_activa: false,
   validacion_max_activa: false,
   tooltip: "Adjunte documento con estudio de mercado.",
   ayuda: "Adjunte documento con estudio de mercado.",
   id_referencial: "43"
}
campo = Campo.find_by(atributos_obligatorios)
campo = campo.present? ? campo : Campo.new(atributos_obligatorios)
campo.sin_validaciones = true 
campo.update(atributos_opcionales)
campo.tareas = Tarea.where(id: 1)

#--------------------------------------------------------------------------------------------------------------------------------------------#
# Campo antiguo
atributos_obligatorios = {
   clase: "ManifestacionDeInteres",
   atributo: "anteproyecto",
   tipo: "upload"
}
atributos_opcionales = {
   nombre: "Anteproyecto",
   validacion_contenido_obligatorio: false,
   validaciones_activas: false,
    validacion_vacio_mensaje: "",
   validacion_min: "",
   validacion_max: "",
   validacion_min_activa: false,
   validacion_max_activa: false,
   tooltip: "Adjunte documento con anteproyecto.",
   ayuda: "Adjunte documento con anteproyecto.",
   id_referencial: "44"
}
campo = Campo.find_by(atributos_obligatorios)
campo = campo.present? ? campo : Campo.new(atributos_obligatorios)
campo.sin_validaciones = true 
campo.update(atributos_opcionales)
campo.tareas = Tarea.where(id: 1)

#--------------------------------------------------------------------------------------------------------------------------------------------#
# Campo antiguo
atributos_obligatorios = {
   clase: "ManifestacionDeInteres",
   atributo: "otros_estudios",
   tipo: "upload"
}
atributos_opcionales = {
   nombre: "Otros Estudios",
   validacion_contenido_obligatorio: false,
   validaciones_activas: false,
    validacion_vacio_mensaje: "Campo no puede estar vacío",
   validacion_min: "",
   validacion_max: "",
   validacion_min_activa: false,
   validacion_max_activa: false,
   tooltip: "Adjuntar otros estudios, ejemplo: análisis y estudios preliminares (títulos, terrenos, entorno, campañas)",
   ayuda: "Adjuntar otros estudios, ejemplo: análisis y estudios preliminares (títulos, terrenos, entorno, campañas)",
   id_referencial: "45"
}
campo = Campo.find_by(atributos_obligatorios)
campo = campo.present? ? campo : Campo.new(atributos_obligatorios)
campo.sin_validaciones = true 
campo.update(atributos_opcionales)
campo.tareas = Tarea.where(id: 1)
#--------------------------------------------------------------------------------------------------------------------------------------------#
# Titulo 1
atributos_obligatorios = {
   clase: "ManifestacionDeInteres",
   atributo: "titulo_cifras_sectores_economicos",
   tipo: "title"
}
atributos_opcionales = {
   nombre: "Cifras de los Sectores económicos",
   validacion_contenido_obligatorio: false,
   validaciones_activas: false,
    validacion_vacio_mensaje: "",
   validacion_min: "",
   validacion_max: "",
   validacion_min_activa: false,
   validacion_max_activa: false,
   tooltip: "Indicar cifras de la(s) Principal(es) Actividad(es) Económica(s) involucrada(s). La información tributaria del Servicio de Impuestos Internos, puede servir de referencia <a href='http://www.sii.cl/sobre_el_sii/estadisticas_de_empresas.html' target='_blank'>Enlace</a>",
   ayuda: "Indicar cifras de la(s) Principal(es) Actividad(es) Económica(s) involucrada(s). La información tributaria del Servicio de Impuestos Internos, puede servir de referencia <a href='http://www.sii.cl/sobre_el_sii/estadisticas_de_empresas.html' target='_blank'>Enlace</a>",
   id_referencial: "12.01"
}
campo = Campo.find_by(atributos_obligatorios)
campo = campo.present? ? campo : Campo.new(atributos_obligatorios)
campo.sin_validaciones = true 
campo.update(atributos_opcionales)
campo.tareas = Tarea.where(id: 1)
#--------------------------------------------------------------------------------------------------------------------------------------------#
# Titulo 2
atributos_obligatorios = {
   clase: "ManifestacionDeInteres",
   atributo: "titulo_caracterizacion_actividades_economicas",
   tipo: "label"
}
atributos_opcionales = {
   nombre: "Caracterización de la(s) Principal(es) Actividad(es) Económica(s) involucrada(s)",
   validacion_contenido_obligatorio: false,
   validaciones_activas: false,
    validacion_vacio_mensaje: "",
   validacion_min: "",
   validacion_max: "",
   validacion_min_activa: false,
   validacion_max_activa: false,
   tooltip: "",
   ayuda: "",
   id_referencial: "47"
}
campo = Campo.find_by(atributos_obligatorios)
campo = campo.present? ? campo : Campo.new(atributos_obligatorios)
campo.sin_validaciones = true 
campo.update(atributos_opcionales)
campo.tareas = Tarea.where(id: 1)
#--------------------------------------------------------------------------------------------------------------------------------------------#
# Lista arbol actividades economicas
atributos_obligatorios = {
   clase: "ManifestacionDeInteres",
   atributo: "actividad_economicas_ids",
   tipo: "list"
}
atributos_opcionales = {
   nombre: "Indicar las Principales Actividades Económicas involucradas en el Acuerdo",
   validacion_contenido_obligatorio: true,
   validaciones_activas: false,
    validacion_vacio_mensaje: "",
   validacion_min: "",
   validacion_max: "",
   validacion_min_activa: false,
   validacion_max_activa: false,
   tooltip: "Indicar las actividades económicas que se espera adquieran compromisos mediante el Acuerdo",
   ayuda: "<a href='http://www.sii.cl/catastro/homologacion_codigos_actividad.pdf' target='_blank'>Homologación de códigos SII</a>",
   id_referencial: "9"
}
campo = Campo.find_by(atributos_obligatorios)
campo = campo.present? ? campo : Campo.new(atributos_obligatorios)
campo.sin_validaciones = true 
campo.update(atributos_opcionales)
campo.tareas = Tarea.where(id: 1)
#--------------------------------------------------------------------------------------------------------------------------------------------#
# Lista arbol comunas
atributos_obligatorios = {
   clase: "ManifestacionDeInteres",
   atributo: "comunas_ids",
   tipo: "list"
}
atributos_opcionales = {
   nombre: "Indicar territorios involucrados en el acuerdo",
   validacion_contenido_obligatorio: true,
   validaciones_activas: false,
    validacion_vacio_mensaje: "",
   validacion_min: "",
   validacion_max: "",
   validacion_min_activa: false,
   validacion_max_activa: false,
   tooltip: "Indicar las comunas, provincias, regiones involucradas en el Acuerdo",
   ayuda: "Indicar las comunas, provincias, regiones involucradas en el Acuerdo",
   id_referencial: "10.1"
}
campo = Campo.find_by(atributos_obligatorios)
campo = campo.present? ? campo : Campo.new(atributos_obligatorios)
campo.sin_validaciones = true 
campo.update(atributos_opcionales)
campo.tareas = Tarea.where(id: 1)
#--------------------------------------------------------------------------------------------------------------------------------------------#
# Lista arbol cuencas
atributos_obligatorios = {
   clase: "ManifestacionDeInteres",
   atributo: "cuencas_ids",
   tipo: "list"
}
atributos_opcionales = {
   nombre: "Indicar cuencas involucradas en el Acuerdo",
   validacion_contenido_obligatorio: false,
   validaciones_activas: false,
    validacion_vacio_mensaje: "",
   validacion_min: "",
   validacion_max: "",
   validacion_min_activa: false,
   validacion_max_activa: false,
   tooltip: "Indicar las cuencas o subcuencas involucradas en el Acuerdo",
   ayuda: "Indicar las cuencas o subcuencas involucradas en el Acuerdo",
   id_referencial: "10.3"
}
campo = Campo.find_by(atributos_obligatorios)
campo = campo.present? ? campo : Campo.new(atributos_obligatorios)
campo.sin_validaciones = true 
campo.update(atributos_opcionales)
campo.tareas = Tarea.where(id: 1)
#--------------------------------------------------------------------------------------------------------------------------------------------#
# Archivo
atributos_obligatorios = {
   clase: "ManifestacionDeInteres",
   atributo: "estudios_sectoriales_territoriales_relevantes",
   tipo: "upload"
}
atributos_opcionales = {
   nombre: "Estudios Sectoriales/Territoriales relevantes",
   validacion_contenido_obligatorio: false,
   validaciones_activas: false,
    validacion_vacio_mensaje: "",
   validacion_min: "",
   validacion_max: "",
   validacion_min_activa: false,
   validacion_max_activa: false,
   tooltip: "",
   ayuda: "",
   id_referencial: "18"
}
campo = Campo.find_by(atributos_obligatorios)
campo = campo.present? ? campo : Campo.new(atributos_obligatorios)
campo.sin_validaciones = true 
campo.update(atributos_opcionales)
campo.tareas = Tarea.where(id: 1)