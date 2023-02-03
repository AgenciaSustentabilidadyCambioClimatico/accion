# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20230203132612) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "accion_clasificaciones", force: :cascade do |t|
    t.integer "accion_id", null: false
    t.integer "clasificacion_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "accion_relacionadas", force: :cascade do |t|
    t.integer "accion_id", null: false
    t.integer "accion_relacionada_id", null: false
    t.text "descripcion", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "acciones", force: :cascade do |t|
    t.integer "meta_id"
    t.string "nombre", null: false
    t.text "descripcion", null: false
    t.boolean "debe_asociar_materia_sustancia", default: true, null: false
    t.text "medio_de_verificacion_generico", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "actividad_economica_contribuyentes", force: :cascade do |t|
    t.integer "actividad_economica_id"
    t.integer "contribuyente_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "actividad_economica_flujos", force: :cascade do |t|
    t.bigint "actividad_economica_id"
    t.bigint "flujo_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["actividad_economica_id"], name: "index_actividad_economica_flujos_on_actividad_economica_id"
    t.index ["flujo_id"], name: "index_actividad_economica_flujos_on_flujo_id"
  end

  create_table "actividad_economicas", force: :cascade do |t|
    t.string "codigo_ciiuv2"
    t.text "descripcion"
    t.text "descripcion_ciiuv2"
    t.string "codigo_ciiuv4"
    t.text "descripcion_ciiuv4"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "actividad_items", force: :cascade do |t|
    t.string "nombre"
    t.integer "proyecto_actividad_id"
    t.integer "glosa_id"
    t.integer "tipo_aporte_id"
    t.integer "monto"
    t.json "archivos_tecnica"
    t.json "archivos_respaldo"
    t.integer "estado_tecnica_id", default: 1
    t.integer "estado_respaldo_id", default: 1
    t.string "observacion_tecnica"
    t.string "observacion_respaldo"
    t.datetime "fecha_ultima_rendicion"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "actividad_por_lineas", force: :cascade do |t|
    t.integer "actividad_id", null: false
    t.integer "tipo_instrumento_id", null: false
    t.integer "tipo_permiso", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "actividades", force: :cascade do |t|
    t.string "nombre", null: false
    t.text "descripcion", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "adhesion_elemento_retirados", force: :cascade do |t|
    t.bigint "adhesion_id"
    t.bigint "persona_id"
    t.bigint "alcance_id"
    t.bigint "establecimiento_contribuyente_id"
    t.bigint "maquinaria_id"
    t.bigint "otro_id"
    t.string "archivo_adhesion"
    t.string "archivo_respaldo"
    t.string "archivo_retiro"
    t.text "fila"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["adhesion_id"], name: "index_adhesion_elemento_retirados_on_adhesion_id"
    t.index ["alcance_id"], name: "index_adhesion_elemento_retirados_on_alcance_id"
    t.index ["establecimiento_contribuyente_id"], name: "idx_aer_ec"
    t.index ["maquinaria_id"], name: "index_adhesion_elemento_retirados_on_maquinaria_id"
    t.index ["otro_id"], name: "index_adhesion_elemento_retirados_on_otro_id"
    t.index ["persona_id"], name: "index_adhesion_elemento_retirados_on_persona_id"
  end

  create_table "adhesion_elementos", force: :cascade do |t|
    t.bigint "adhesion_id"
    t.bigint "persona_id"
    t.bigint "alcance_id"
    t.bigint "establecimiento_contribuyente_id"
    t.bigint "maquinaria_id"
    t.bigint "otro_id"
    t.string "archivo_adhesion"
    t.string "archivo_respaldo"
    t.text "fila"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "adhesion_externa_id"
    t.index ["adhesion_externa_id"], name: "index_adhesion_elementos_on_adhesion_externa_id"
    t.index ["adhesion_id"], name: "index_adhesion_elementos_on_adhesion_id"
    t.index ["alcance_id"], name: "index_adhesion_elementos_on_alcance_id"
    t.index ["establecimiento_contribuyente_id"], name: "index_adhesion_elementos_on_establecimiento_contribuyente_id"
    t.index ["maquinaria_id"], name: "index_adhesion_elementos_on_maquinaria_id"
    t.index ["otro_id"], name: "index_adhesion_elementos_on_otro_id"
    t.index ["persona_id"], name: "index_adhesion_elementos_on_persona_id"
  end

  create_table "adhesiones", force: :cascade do |t|
    t.json "archivos_adhesion_y_documentacion"
    t.string "archivo_elementos"
    t.text "adhesiones_data"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.bigint "manifestacion_de_interes_id"
    t.bigint "flujo_id"
    t.string "rut_institucion_adherente"
    t.text "nombre_institucion_adherente"
    t.text "matriz_direccion"
    t.bigint "matriz_region_id"
    t.bigint "matriz_comuna_id"
    t.bigint "tipo_contribuyente_id"
    t.string "rut_representante_legal"
    t.text "nombre_representante_legal"
    t.bigint "fono_representante_legal"
    t.text "email_representante_legal"
    t.boolean "externa", default: false
    t.bigint "rol_id"
    t.index ["flujo_id"], name: "index_adhesiones_on_flujo_id"
    t.index ["matriz_comuna_id"], name: "index_adhesiones_on_matriz_comuna_id"
    t.index ["matriz_region_id"], name: "index_adhesiones_on_matriz_region_id"
    t.index ["rol_id"], name: "index_adhesiones_on_rol_id"
    t.index ["tipo_contribuyente_id"], name: "index_adhesiones_on_tipo_contribuyente_id"
  end

  create_table "alcances", force: :cascade do |t|
    t.string "nombre", null: false
    t.text "descripcion", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "auditoria_elemento_archivos", force: :cascade do |t|
    t.string "archivo"
    t.bigint "auditoria_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["auditoria_id"], name: "index_auditoria_elemento_archivos_on_auditoria_id"
  end

  create_table "auditoria_elementos", force: :cascade do |t|
    t.bigint "auditoria_id"
    t.bigint "adhesion_elemento_id"
    t.bigint "set_metas_accion_id"
    t.boolean "aplica", default: true
    t.text "motivo"
    t.boolean "cumple", default: false
    t.string "archivo_informe"
    t.string "archivo_evidencia"
    t.date "fecha_auditoria"
    t.string "rut_auditor"
    t.text "observacion"
    t.boolean "validacion_aceptada"
    t.datetime "validacion_fecha"
    t.datetime "aprobacion_fecha"
    t.integer "estado", limit: 2, default: 1
    t.text "validacion_observaciones"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "archivo_informe_id"
    t.bigint "archivo_evidencia_id"
    t.index ["adhesion_elemento_id"], name: "index_auditoria_elementos_on_adhesion_elemento_id"
    t.index ["archivo_evidencia_id"], name: "index_auditoria_elementos_on_archivo_evidencia_id"
    t.index ["archivo_informe_id"], name: "index_auditoria_elementos_on_archivo_informe_id"
    t.index ["auditoria_id"], name: "index_auditoria_elementos_on_auditoria_id"
    t.index ["set_metas_accion_id"], name: "index_auditoria_elementos_on_set_metas_accion_id"
  end

  create_table "auditoria_historicos", force: :cascade do |t|
    t.bigint "manifestacion_de_interes_id"
    t.string "tipo"
    t.integer "numero"
    t.date "fecha"
    t.string "resultado_ponderado"
    t.string "documento_respaldo"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["manifestacion_de_interes_id"], name: "index_auditoria_historicos_on_manifestacion_de_interes_id"
  end

  create_table "auditoria_niveles", force: :cascade do |t|
    t.bigint "auditoria_id"
    t.bigint "estandar_nivel_id"
    t.integer "plazo"
    t.index ["auditoria_id"], name: "index_auditoria_niveles_on_auditoria_id"
    t.index ["estandar_nivel_id"], name: "index_auditoria_niveles_on_estandar_nivel_id"
  end

  create_table "auditoria_validaciones", force: :cascade do |t|
    t.bigint "auditoria_id"
    t.bigint "user_id"
    t.text "validaciones"
    t.string "archivo"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["auditoria_id"], name: "index_auditoria_validaciones_on_auditoria_id"
    t.index ["user_id"], name: "index_auditoria_validaciones_on_user_id"
  end

  create_table "auditorias", force: :cascade do |t|
    t.bigint "manifestacion_de_interes_id"
    t.string "nombre"
    t.integer "plazo"
    t.boolean "con_certificacion"
    t.boolean "con_validacion"
    t.boolean "final"
    t.bigint "flujo_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "auditoria_id"
    t.bigint "convocatoria_id"
    t.date "ceremonia_certificacion_fecha"
    t.string "ceremonia_certificacion_direccion"
    t.decimal "ceremonia_certificacion_lat"
    t.decimal "ceremonia_certificacion_lng"
    t.text "ceremonia_certificacion_firmantes"
    t.json "ceremonia_certificacion_archivo"
    t.boolean "archivo_correcto"
    t.integer "plazo_apertura"
    t.integer "plazo_cierre"
    t.boolean "con_mantencion", default: false
    t.string "archivo_revision"
    t.index ["flujo_id"], name: "index_auditorias_on_flujo_id"
  end

  create_table "campo_tareas", force: :cascade do |t|
    t.bigint "campo_id"
    t.bigint "tarea_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["campo_id"], name: "index_campo_tareas_on_campo_id"
    t.index ["tarea_id"], name: "index_campo_tareas_on_tarea_id"
  end

  create_table "campos", force: :cascade do |t|
    t.string "clase", null: false
    t.string "atributo", null: false
    t.string "tipo", null: false
    t.string "nombre"
    t.boolean "validacion_contenido_obligatorio", default: true
    t.boolean "validaciones_activas", default: true
    t.string "validacion_vacio_mensaje"
    t.bigint "validacion_min"
    t.bigint "validacion_max"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "validacion_min_activa", default: true
    t.boolean "validacion_max_activa", default: true
    t.string "tooltip"
    t.string "ayuda"
    t.boolean "tooltip_activo", default: true
    t.boolean "ayuda_activo", default: true
    t.text "id_referencial"
  end

  create_table "cargos", id: :serial, force: :cascade do |t|
    t.string "nombre", limit: 50, null: false
    t.text "descripcion", null: false
    t.boolean "agencia", default: true
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["nombre"], name: "index_cargos_on_nombre", unique: true
  end

  create_table "centro_de_costos", force: :cascade do |t|
    t.string "nombre", null: false
    t.text "descripcion", null: false
    t.integer "ano_asignacion", null: false
    t.bigint "monto_asignacion", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "certificacion_adhesion_historicos", force: :cascade do |t|
    t.bigint "adhesion_elemento_id"
    t.date "fecha_certificacion_1"
    t.date "vigencia_certificacion_1"
    t.string "rut_auditor_cert_1"
    t.string "nombre_archivo_respaldo_certificacion_1"
    t.date "fecha_certificacion_2"
    t.date "vigencia_certificacion_2"
    t.string "rut_auditor_cert_2"
    t.string "nombre_archivo_respaldo_certificacion_2"
    t.date "fecha_certificacion_3"
    t.date "vigencia_certificacion_3"
    t.string "rut_auditor_cert_3"
    t.string "nombre_archivo_respaldo_certificacion_3"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["adhesion_elemento_id"], name: "index_certificacion_adhesion_historicos_on_adhesion_elemento_id"
  end

  create_table "certificado_proveedores", force: :cascade do |t|
    t.bigint "registro_proveedor_id"
    t.bigint "materia_sustancia_id"
    t.bigint "actividad_economica_id"
    t.string "archivo_certificado"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["actividad_economica_id"], name: "index_certificado_proveedores_on_actividad_economica_id"
    t.index ["materia_sustancia_id"], name: "index_certificado_proveedores_on_materia_sustancia_id"
    t.index ["registro_proveedor_id"], name: "index_certificado_proveedores_on_registro_proveedor_id"
  end

  create_table "ckeditor_assets", force: :cascade do |t|
    t.string "data_file_name", null: false
    t.string "data_content_type"
    t.integer "data_file_size"
    t.string "type", limit: 30
    t.integer "width"
    t.integer "height"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["type"], name: "index_ckeditor_assets_on_type"
  end

  create_table "clasificaciones", force: :cascade do |t|
    t.integer "clasificacion_id"
    t.string "nombre", null: false
    t.text "descripcion", null: false
    t.text "referencia", null: false
    t.boolean "es_meta", default: false, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "imagen"
    t.string "icono"
    t.string "color"
  end

  create_table "comentario_archivos", force: :cascade do |t|
    t.integer "comentario_id"
    t.string "archivo"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "comentarios", force: :cascade do |t|
    t.integer "user_id"
    t.integer "tipo_comentario_id", null: false
    t.text "comentario", null: false
    t.string "email_contacto", null: false
    t.string "url_referencia"
    t.boolean "leido"
    t.boolean "resuelto"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "comentarios_informe_acuerdos", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "informe_acuerdo_id", null: false
    t.string "nombre", null: false
    t.string "rut", null: false
    t.string "email"
    t.text "comentario", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["informe_acuerdo_id"], name: "index_comentarios_informe_acuerdos_on_informe_acuerdo_id"
    t.index ["user_id"], name: "index_comentarios_informe_acuerdos_on_user_id"
  end

  create_table "comentarios_metas_acciones", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "set_metas_accion_id", null: false
    t.string "nombre", null: false
    t.string "rut", null: false
    t.string "email"
    t.text "comentario", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["set_metas_accion_id"], name: "index_comentarios_metas_acciones_on_set_metas_accion_id"
    t.index ["user_id"], name: "index_comentarios_metas_acciones_on_user_id"
  end

  create_table "comunas", id: :serial, force: :cascade do |t|
    t.integer "provincia_id"
    t.string "nombre", limit: 40
    t.string "codigo", limit: 5
    t.boolean "vigente", default: true, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "comunas_alternativas", force: :cascade do |t|
    t.bigint "id_antiguo"
    t.string "nombre", limit: 40
    t.string "provincia", limit: 50
    t.string "region", limit: 50
    t.bigint "provincia_id"
    t.string "codigo", limit: 5
    t.boolean "vigente", default: true
    t.integer "region_id"
  end

  create_table "comunas_flujos", force: :cascade do |t|
    t.bigint "comuna_id"
    t.bigint "flujo_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["comuna_id"], name: "index_comunas_flujos_on_comuna_id"
    t.index ["flujo_id"], name: "index_comunas_flujos_on_flujo_id"
  end

  create_table "contribuyentes", force: :cascade do |t|
    t.integer "rut"
    t.string "dv", limit: 1
    t.string "razon_social"
    t.text "fields_visibility"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "temporal", default: false
    t.bigint "flujo_id"
    t.bigint "contribuyente_id"
    t.index ["contribuyente_id"], name: "index_contribuyentes_on_contribuyente_id"
    t.index ["flujo_id"], name: "index_contribuyentes_on_flujo_id"
    t.index ["razon_social"], name: "contribuyentes_razon_social"
    t.index ["rut"], name: "index_contribuyentes_on_rut"
  end

  create_table "convocatoria_destinatarios", force: :cascade do |t|
    t.integer "convocatoria_id"
    t.integer "destinatario_id"
    t.datetime "fecha_correo"
    t.boolean "asistio", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "convocatoria_tipos", force: :cascade do |t|
    t.string "descripcion"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "tarea_codigo"
  end

  create_table "convocatorias", force: :cascade do |t|
    t.integer "manifestacion_de_interes_id"
    t.date "fecha"
    t.string "direccion"
    t.decimal "lat"
    t.decimal "lng"
    t.string "mensaje_encabezado"
    t.string "mensaje_cuerpo"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.json "archivo_adjunto"
    t.text "caracterizacion"
    t.boolean "terminada", default: false
    t.bigint "flujo_id"
    t.string "tarea_codigo"
    t.integer "tipo"
    t.text "nombre"
    t.datetime "fecha_hora"
    t.integer "tipo_reunion", default: 0
    t.index ["flujo_id"], name: "index_convocatorias_on_flujo_id"
  end

  create_table "cuencas", force: :cascade do |t|
    t.string "codigo_cuenca"
    t.string "nombre_cuenca"
    t.string "region"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "cuencas_flujos", force: :cascade do |t|
    t.bigint "flujo_id"
    t.bigint "cuenca_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["cuenca_id"], name: "index_cuencas_flujos_on_cuenca_id"
    t.index ["flujo_id"], name: "index_cuencas_flujos_on_flujo_id"
  end

  create_table "dato_anual_contribuyentes", force: :cascade do |t|
    t.integer "contribuyente_id"
    t.integer "tipo_contribuyente_id"
    t.integer "rango_venta_contribuyente_id"
    t.integer "periodo"
    t.integer "numero_trabajadores"
    t.bigint "f22c_645"
    t.bigint "f22c_646"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "dato_levantado_mensuals", force: :cascade do |t|
    t.bigint "dato_productivo_elemento_adherido_id"
    t.string "nombre_archivo_evidencia"
    t.date "fecha_levantamiento"
    t.string "rut_levantador"
    t.string "unidad_declarada"
    t.string "mes"
    t.string "año"
    t.string "tipo_de_valor"
    t.float "valor"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["dato_productivo_elemento_adherido_id"], name: "dpea_dlm_id"
  end

  create_table "dato_productivo_elemento_adheridos", force: :cascade do |t|
    t.bigint "set_metas_accion_id"
    t.bigint "adhesion_elemento_id"
    t.bigint "dato_recolectado_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["adhesion_elemento_id"], name: "adhe_ele_id"
    t.index ["dato_recolectado_id"], name: "dat_rec_id"
    t.index ["set_metas_accion_id"], name: "index_dato_productivo_elemento_adheridos_on_set_metas_accion_id"
  end

  create_table "dato_recolectados", force: :cascade do |t|
    t.string "nombre"
    t.text "descripcion"
    t.string "cpc"
    t.string "medios_verificacion"
    t.string "unidad_base"
    t.string "unidades_compatibles"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "datos_publicos", force: :cascade do |t|
    t.text "visibilidad_documentos"
    t.text "visibilidad_empresas_adheridas"
    t.text "visibilidad_empresas_certificadas"
    t.integer "extension_reporte"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "delayed_jobs", force: :cascade do |t|
    t.integer "priority", default: 0, null: false
    t.integer "attempts", default: 0, null: false
    t.text "handler", null: false
    t.text "last_error"
    t.datetime "run_at"
    t.datetime "locked_at"
    t.datetime "failed_at"
    t.string "locked_by"
    t.string "queue"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["priority", "run_at"], name: "delayed_jobs_priority"
  end

  create_table "descargable_tareas", force: :cascade do |t|
    t.integer "tarea_id", null: false
    t.integer "formato", null: false
    t.text "contenido"
    t.string "nombre"
    t.string "codigo"
    t.string "archivo"
    t.boolean "subido", default: false, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["codigo"], name: "index_descargable_tareas_on_codigo", unique: true
  end

  create_table "documento_diagnosticos", force: :cascade do |t|
    t.integer "manifestacion_de_interes_id", null: false
    t.integer "tipo_documento_diagnostico_id"
    t.string "nombre"
    t.string "archivo"
    t.boolean "publico", default: false, null: false
    t.boolean "requiere_correcciones", default: false, null: false
    t.date "fecha_documento"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "documento_garantias", force: :cascade do |t|
    t.bigint "proyecto_id"
    t.bigint "tipo_documento_garantia_id"
    t.bigint "documento_garantia_id"
    t.bigint "numero_documento"
    t.date "fecha_vencimiento"
    t.date "fecha_vencimiento_original"
    t.bigint "monto"
    t.string "archivo"
    t.bigint "estado_documento_garantia_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["documento_garantia_id"], name: "index_documento_garantias_on_documento_garantia_id"
    t.index ["estado_documento_garantia_id"], name: "index_documento_garantias_on_estado_documento_garantia_id"
    t.index ["proyecto_id"], name: "index_documento_garantias_on_proyecto_id"
    t.index ["tipo_documento_garantia_id"], name: "index_documento_garantias_on_tipo_documento_garantia_id"
  end

  create_table "documento_registro_proveedores", force: :cascade do |t|
    t.string "archivo"
    t.string "description"
    t.bigint "registro_proveedor_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["registro_proveedor_id"], name: "index_documento_registro_proveedores_on_registro_proveedor_id"
  end

  create_table "ejecucion_presupuestarias", force: :cascade do |t|
    t.integer "programa_proyecto_propuesta_id", null: false
    t.integer "centro_de_costo_id"
    t.integer "año"
    t.date "fecha_transferencia"
    t.integer "montos_transferidos"
    t.integer "montos_ejecutados"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "encuesta_descarga_roles", force: :cascade do |t|
    t.bigint "tarea_id"
    t.bigint "rol_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["rol_id"], name: "index_encuesta_descarga_roles_on_rol_id"
    t.index ["tarea_id"], name: "index_encuesta_descarga_roles_on_tarea_id"
  end

  create_table "encuesta_ejecucion_roles", force: :cascade do |t|
    t.bigint "tarea_id"
    t.bigint "rol_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["rol_id"], name: "index_encuesta_ejecucion_roles_on_rol_id"
    t.index ["tarea_id"], name: "index_encuesta_ejecucion_roles_on_tarea_id"
  end

  create_table "encuesta_preguntas", force: :cascade do |t|
    t.integer "encuesta_id", null: false
    t.integer "pregunta_id", null: false
    t.integer "orden", limit: 2, default: 0, null: false
    t.boolean "obligatorio", default: false, null: false
    t.boolean "base", default: false, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "encuesta_user_respuestas", force: :cascade do |t|
    t.integer "encuesta_id", null: false
    t.integer "user_id", null: false
    t.integer "pregunta_id", null: false
    t.text "respuesta", null: false
    t.integer "flujo_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "institucion_proveedor_id"
    t.bigint "tarea_pendiente_id"
    t.index ["tarea_pendiente_id"], name: "index_encuesta_user_respuestas_on_tarea_pendiente_id"
  end

  create_table "encuestas", force: :cascade do |t|
    t.string "titulo", null: false
    t.integer "valor_tiempo_para_contestar", null: false
    t.integer "unidad_tiempo_para_contestar", null: false
    t.boolean "solo_dias_habiles", default: false, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "base", default: false, null: false
  end

  create_table "establecimiento_contribuyentes", force: :cascade do |t|
    t.integer "contribuyente_id", null: false
    t.boolean "casa_matriz", default: false
    t.string "direccion"
    t.string "ciudad"
    t.integer "pais_id"
    t.integer "region_id"
    t.integer "comuna_id"
    t.float "latitud"
    t.float "longitud"
    t.string "nombre_de_establecimiento"
    t.string "tipo_de_establecimiento"
    t.string "telefono"
    t.string "email"
    t.text "fields_visibility"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "fecha_eliminacion"
    t.integer "establecimiento_contribuyente_id"
  end

  create_table "estado_admisibilidades", force: :cascade do |t|
    t.string "nombre", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "estado_documento_garantias", force: :cascade do |t|
    t.string "nombre", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "estado_rendiciones", force: :cascade do |t|
    t.string "nombre"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "estado_tarea_pendientes", force: :cascade do |t|
    t.string "nombre", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "estandar_homologaciones", force: :cascade do |t|
    t.string "nombre"
    t.json "referencias"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.text "descripcion"
    t.string "url_referencia"
  end

  create_table "estandar_niveles", force: :cascade do |t|
    t.integer "numero"
    t.string "nombre"
    t.decimal "porcentaje", precision: 5, scale: 2
    t.string "archivo"
    t.bigint "estandar_homologacion_id"
    t.index ["estandar_homologacion_id"], name: "index_estandar_niveles_on_estandar_homologacion_id"
  end

  create_table "estandar_set_metas_acciones", force: :cascade do |t|
    t.bigint "estandar_homologacion_id"
    t.bigint "accion_id"
    t.bigint "materia_sustancia_id"
    t.integer "meta_id"
    t.bigint "alcance_id"
    t.string "criterio_inclusion_exclusion"
    t.string "descripcion_accion"
    t.string "detalle_medio_verificacion"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "puntaje"
    t.bigint "estandar_nivel_id"
    t.index ["accion_id"], name: "index_estandar_set_metas_acciones_on_accion_id"
    t.index ["alcance_id"], name: "index_estandar_set_metas_acciones_on_alcance_id"
    t.index ["estandar_homologacion_id"], name: "index_estandar_set_metas_acciones_on_estandar_homologacion_id"
    t.index ["estandar_nivel_id"], name: "index_estandar_set_metas_acciones_on_estandar_nivel_id"
    t.index ["materia_sustancia_id"], name: "index_estandar_set_metas_acciones_on_materia_sustancia_id"
  end

  create_table "etapas", force: :cascade do |t|
    t.integer "etapa_id"
    t.integer "orden"
    t.string "nombre", null: false
    t.text "descripcion"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "feriados", force: :cascade do |t|
    t.date "fecha", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "flujo_tareas", force: :cascade do |t|
    t.integer "tarea_entrada_id", null: false
    t.integer "tarea_salida_id"
    t.text "rol_destinatarios", null: false
    t.text "condicion_de_salida", null: false
    t.string "mensaje_salida_asunto"
    t.text "mensaje_salida_cuerpo"
    t.boolean "sin_salida", default: false, null: false
    t.text "descripcion_flujo"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "flujos", force: :cascade do |t|
    t.integer "contribuyente_id"
    t.integer "tipo_instrumento_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "proyecto_id"
    t.integer "manifestacion_de_interes_id"
    t.integer "programa_proyecto_propuesta_id"
    t.boolean "terminado", default: false
    t.string "codigo"
  end

  create_table "glosas", force: :cascade do |t|
    t.string "nombre"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "hito_de_prensa_archivos", force: :cascade do |t|
    t.integer "hitos_de_prensa_id", null: false
    t.string "archivo", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "hito_de_prensa_instrumentos", force: :cascade do |t|
    t.integer "hitos_de_prensa_id"
    t.integer "flujo_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["flujo_id"], name: "index_hito_de_prensa_instrumentos_on_flujo_id"
  end

  create_table "hito_de_prensa_responsables", force: :cascade do |t|
    t.integer "hitos_de_prensa_id"
    t.integer "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "hitos_de_prensa", force: :cascade do |t|
    t.integer "tipo_de_medio_id", null: false
    t.string "nombre", null: false
    t.string "medio", null: false
    t.date "fecha_publicacion", null: false
    t.string "enlace"
    t.text "observaciones"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "flujo_id"
    t.index ["flujo_id"], name: "index_hitos_de_prensa_on_flujo_id"
  end

  create_table "informe_acuerdos", force: :cascade do |t|
    t.bigint "manifestacion_de_interes_id"
    t.text "fundamentos"
    t.text "antecedentes"
    t.text "normativas_aplicables"
    t.text "alcance"
    t.text "campo_de_aplicacion"
    t.text "definiciones"
    t.text "objetivo_general"
    t.text "objetivo_especifico"
    t.text "mecanismo_de_implementacion"
    t.integer "tipo_acuerdo"
    t.integer "plazo_maximo_adhesion"
    t.integer "plazo_finalizacion_implementacion"
    t.text "mecanismo_evaluacion_cumplimiento"
    t.boolean "adhesiones"
    t.text "derechos"
    t.text "obligaciones"
    t.text "difusion"
    t.text "promocion"
    t.text "incentivos"
    t.text "sanciones"
    t.text "personerias"
    t.text "ejemplares"
    t.text "firmas"
    t.json "archivos_anexos", default: []
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "con_extension"
    t.boolean "nuevo", default: true, null: false
    t.json "archivos_anexos_posteriores_firmas", default: []
    t.boolean "necesita_evidencia", default: false
    t.integer "plazo_maximo_neto"
    t.integer "plazo_maximo"
    t.text "vigencia_acuerdo"
    t.integer "plazo_vigencia_acuerdo"
    t.text "vigencia_certificacion"
    t.integer "vigencia_certificacion_final"
    t.text "respuesta_observaciones"
    t.index ["manifestacion_de_interes_id"], name: "index_informe_acuerdos_on_manifestacion_de_interes_id"
  end

  create_table "informe_impactos", force: :cascade do |t|
    t.bigint "manifestacion_de_interes_id"
    t.text "observacion"
    t.text "documento"
    t.boolean "publico", default: false, null: false
    t.string "nombre_documento"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.date "fecha_informe_impacto"
    t.index ["manifestacion_de_interes_id"], name: "index_informe_impactos_on_manifestacion_de_interes_id"
  end

  create_table "instrumentos", force: :cascade do |t|
    t.integer "tipo_instrumento_id"
    t.integer "nivel"
    t.string "nombre"
    t.text "poligono_ubicacion"
    t.string "glosario"
    t.string "certificaciones_homologables"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "lugar_coordenadas", force: :cascade do |t|
    t.string "lugar"
    t.float "latitud"
    t.float "longitud"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["lugar"], name: "index_lugar_coordenadas_on_lugar"
  end

  create_table "manifestacion_de_intereses", force: :cascade do |t|
    t.text "descripcion_acuerdo"
    t.string "proponente"
    t.string "institucion_gestora_acuerdo"
    t.string "rut_institucion_gestora_acuerdo"
    t.integer "tipo_instrumento_id"
    t.integer "contribuyente_id"
    t.string "direccion_institucion_gestora_acuerdo"
    t.string "lugar_institucion_gestora_acuerdo"
    t.string "ubicacion_exacta"
    t.string "tipo_contribuyente_de_institucion_gestora"
    t.integer "numero_de_socios_institucion_gestora"
    t.text "experiencia_en_gestion_de_proyectos"
    t.date "fecha_creacion_institucion"
    t.string "nombre_representante_para_acuerdo"
    t.string "rut_representante_para_acuerdo"
    t.string "telefono_representante_para_acuerdo"
    t.string "email_representante_para_acuerdo"
    t.string "carta_de_interes_institucion_gestora_firmada"
    t.text "sectores_economicos"
    t.text "territorios_regiones"
    t.text "territorios_provincias"
    t.text "territorios_comunas"
    t.text "coordernadas_territorios"
    t.text "caracterizacion_sector_territorio"
    t.text "principales_actores"
    t.string "mapa_de_actores_archivo"
    t.text "numero_empresas"
    t.float "porcentaje_mipymes"
    t.text "produccion"
    t.text "ventas"
    t.text "porcentaje_exportaciones"
    t.text "principales_mercados"
    t.text "numero_trabajadores"
    t.text "vulnerabilidad_al_cambio_climatico_del_sector"
    t.text "principales_impactos_socioambientales_del_sector"
    t.text "principales_problemas_y_desafios"
    t.text "principales_conflictos"
    t.text "estudios_sectoriales_territoriales_relevantes"
    t.text "otro_contexto_sector"
    t.string "nombre_proyecto"
    t.text "descripcion_proyecto"
    t.text "justificacion_proyecto"
    t.string "area_influencia_proyecto_archivo"
    t.text "area_influencia_proyecto_data"
    t.string "alternativas_instalacion_archivo"
    t.text "alternativas_instalacion_data"
    t.integer "monto_inversion"
    t.string "tecnologia"
    t.string "estado_proyecto"
    t.string "estudio_de_mercado"
    t.string "anteproyecto"
    t.string "gantt_proyecto"
    t.string "operador"
    t.text "otros_proyectos_en_territorios_cercanos"
    t.string "otros_estudios"
    t.text "otro_datos_proyecto"
    t.string "nombre_acuerdo"
    t.text "motivacion_y_objetivos"
    t.text "equipo_de_trabajo_comprometido"
    t.string "organigrama"
    t.text "patrocinadores"
    t.integer "monto_total_comprometido"
    t.text "otros_recursos_comprometidos"
    t.string "carta_de_apoyo_y_compromiso"
    t.integer "numero_participantes"
    t.text "lista_participantes"
    t.text "priorizacion"
    t.text "otras_iniciativas_relacionadas_en_ejecucion"
    t.integer "diagnostico_id"
    t.integer "estandar_de_certificacion_id"
    t.text "otros_objetivos_acuerdo"
    t.string "otros_estudios_relevantes"
    t.text "secciones_observadas_admisibilidad"
    t.integer "resultado_admisibilidad"
    t.text "respuesta_observaciones_admisibilidad"
    t.text "comentario_jefe_de_linea"
    t.text "observaciones_admisibilidad"
    t.string "archivo_admisibilidad"
    t.text "secciones_observadas_pertinencia_factibilidad"
    t.integer "resultado_pertinencia"
    t.text "observaciones_pertinencia_factibilidad"
    t.text "compromiso_pertinencia_factibilidad"
    t.string "archivo_pertinencia_factibilidad"
    t.text "respuesta_observaciones_pertinencia_factibilidad"
    t.integer "respuesta_resultado_pertinencia"
    t.string "archivo_respuesta_pertinencia_factibilidad"
    t.text "respuesta_otros_pertinencia_factibilidad"
    t.boolean "acepta_condiciones_pertinencia"
    t.integer "usuario_entregables_id"
    t.string "archivo_usuario_entregables"
    t.text "usuario_entregables_comentario"
    t.text "usuario_entregables_otros"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.text "mapa_de_actores_data"
    t.text "comentarios_y_observaciones_actualizacion_mapa_de_actores"
    t.date "firma_fecha"
    t.string "firma_direccion"
    t.decimal "firma_lat"
    t.decimal "firma_lng"
    t.text "firma_firmantes"
    t.json "firma_archivo"
    t.string "archivo_carga_auditoria"
    t.integer "roles_especificos_institucion_entregables"
    t.integer "roles_especificos_usuario_entregables"
    t.text "roles_especificos_comentarios_entregables"
    t.integer "roles_especificos_institucion_carga_datos"
    t.integer "roles_especificos_usuario_carga_datos"
    t.text "roles_especificos_comentarios_carga_datos"
    t.text "informe"
    t.text "observaciones_documentos_diagnostico"
    t.integer "user_carga_actores_id"
    t.text "comentarios_y_observaciones_documento_diagnosticos"
    t.text "comentarios_y_observaciones_set_metas_acciones"
    t.string "archivo_acta_comite_informe"
    t.datetime "fecha_observaciones_admisibilidad"
    t.datetime "fecha_observaciones_pertinencia"
    t.text "comentarios_y_observaciones_negociacion_acuerdo"
    t.datetime "fecha_termino_negociacion"
    t.date "ceremonia_certificacion_fecha"
    t.string "ceremonia_certificacion_direccion"
    t.decimal "ceremonia_certificacion_lat"
    t.decimal "ceremonia_certificacion_lng"
    t.text "ceremonia_certificacion_firmantes"
    t.json "ceremonia_certificacion_archivo"
    t.text "tarea_codigo"
    t.text "comentarios_y_observaciones_termino_acuerdo"
    t.datetime "fecha_termino_acuerdo"
    t.datetime "diagnostico_fecha_termino"
    t.text "instrumentos_relacionados_historico"
    t.date "fecha_manifestacion"
    t.json "documentos_historicos"
    t.string "texto_apl"
    t.integer "proponente_institucion_id"
    t.integer "representante_institucion_para_solicitud_id"
    t.text "relacion_de_politicas"
    t.text "fuente_de_fondos"
    t.text "justificacion_de_estimacion_de_fondos_requeridos"
    t.text "nombre_de_estandar_certificable"
    t.text "diagnostico_de_acuerdo_propuesto"
    t.text "estandar_certificable"
    t.text "diagnostico_de_acuerdo_anterior"
    t.text "informe_de_acuerdo_anterior"
    t.integer "acuerdo_previo_con_informe_id"
    t.text "programas_o_proyectos_relacionados_ids"
    t.text "cadena_de_valor"
    t.text "otras_caracteristicas_relevantes"
    t.boolean "acuerdo_de_alcance_nacional"
    t.text "comentarios_cifras"
    t.integer "sucursal_ligada"
    t.text "justificacion_de_seleccion"
    t.text "registro_en_linea"
    t.text "detalle_de_localizacion"
    t.text "detalle_de_alternativa_de_instalacion"
    t.text "unidad_de_medida_volumen"
    t.text "secciones_observadas_admisibilidad_juridica"
    t.integer "resultado_admisibilidad_juridica"
    t.text "observaciones_admisibilidad_juridica"
    t.text "respuesta_observaciones_admisibilidad_juridica"
    t.string "archivo_admisibilidad_juridica"
    t.datetime "fecha_observaciones_admisibilidad_juridica"
    t.integer "institucion_entregables_id"
    t.string "institucion_entregables_name"
    t.string "usuario_entregable_name"
    t.text "observaciones_propuesta_acuerdo"
    t.integer "firma_tipo_reunion", default: 0
    t.datetime "firma_fecha_hora"
    t.integer "ceremonia_certificacion_tipo_reunion", default: 0
    t.datetime "ceremonia_certificacion_fecha_hora"
    t.text "comentarios_y_observaciones_detencion_acuerdo"
    t.datetime "fecha_detencion_acuerdo"
    t.boolean "detenido", default: false
  end

  create_table "mapa_de_actores", force: :cascade do |t|
    t.integer "flujo_id", null: false
    t.integer "rol_id", null: false
    t.integer "persona_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "persona_cargo_id"
  end

  create_table "maquinarias", force: :cascade do |t|
    t.bigint "establecimiento_contribuyente_id"
    t.string "nombre_maquinaria"
    t.string "numero_serie"
    t.string "patente"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "contribuyente_id"
    t.text "tipo"
    t.json "archivos_imagen"
    t.text "fields_visibility"
    t.datetime "fecha_eliminacion"
    t.index ["contribuyente_id"], name: "index_maquinarias_on_contribuyente_id"
    t.index ["establecimiento_contribuyente_id"], name: "index_maquinarias_on_establecimiento_contribuyente_id"
  end

  create_table "materia_rubro_dato_relacions", force: :cascade do |t|
    t.integer "materia_rubro_relacion_id"
    t.integer "dato_recolectado_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "materia_rubro_relacions", force: :cascade do |t|
    t.bigint "materia_sustancia_id"
    t.bigint "actividad_economica_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["actividad_economica_id"], name: "index_materia_rubro_relacions_on_actividad_economica_id"
    t.index ["materia_sustancia_id"], name: "index_materia_rubro_relacions_on_materia_sustancia_id"
  end

  create_table "materia_sustancia_clasificaciones", force: :cascade do |t|
    t.integer "materia_sustancia_id", null: false
    t.integer "clasificacion_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "materia_sustancia_metas", force: :cascade do |t|
    t.bigint "materia_sustancia_id"
    t.bigint "clasificacion_id"
    t.index ["clasificacion_id"], name: "index_materia_sustancia_metas_on_clasificacion_id"
    t.index ["materia_sustancia_id"], name: "index_materia_sustancia_metas_on_materia_sustancia_id"
  end

  create_table "materia_sustancias", force: :cascade do |t|
    t.string "nombre", null: false
    t.text "descripcion", null: false
    t.boolean "posee_una_magnitud_fisica_asociada", default: false, null: false
    t.string "unidad_base"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "minutas", force: :cascade do |t|
    t.integer "convocatoria_id"
    t.date "fecha"
    t.string "direccion"
    t.decimal "lat"
    t.decimal "lng"
    t.json "acta"
    t.json "lista_asistencia"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "fecha_acta"
    t.text "mensaje_encabezado"
    t.text "mensaje_cuerpo"
    t.datetime "fecha_hora"
    t.integer "tipo_reunion", default: 0
  end

  create_table "modalidades", force: :cascade do |t|
    t.string "nombre"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "modificacion_calendarios", force: :cascade do |t|
    t.integer "proyecto_id"
    t.text "atributos_proyecto"
    t.text "atributos_proyecto_actividades"
    t.text "atributos_rendiciones"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "otros", force: :cascade do |t|
    t.bigint "establecimiento_contribuyente_id"
    t.bigint "alcance_id"
    t.bigint "contribuyente_id"
    t.string "nombre"
    t.string "tipo"
    t.string "identificador_unico"
    t.json "imagen"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.text "fields_visibility"
    t.datetime "fecha_eliminacion"
    t.index ["alcance_id"], name: "index_otros_on_alcance_id"
    t.index ["contribuyente_id"], name: "index_otros_on_contribuyente_id"
    t.index ["establecimiento_contribuyente_id"], name: "index_otros_on_establecimiento_contribuyente_id"
  end

  create_table "paises", id: :serial, force: :cascade do |t|
    t.integer "capital_id"
    t.string "nombre", limit: 52, null: false
    t.string "nombre_local", limit: 45
    t.string "continente", limit: 12
    t.string "region", limit: 30
    t.string "codigo_corto", limit: 2
    t.string "codigo_largo", limit: 3
    t.string "gentilicio"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "vigente", default: true, null: false
  end

  create_table "persona_cargos", force: :cascade do |t|
    t.integer "persona_id", null: false
    t.integer "cargo_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "establecimiento_contribuyente_id"
    t.index ["establecimiento_contribuyente_id"], name: "index_persona_cargos_on_establecimiento_contribuyente_id"
  end

  create_table "personas", force: :cascade do |t|
    t.integer "user_id", null: false
    t.integer "contribuyente_id", null: false
    t.integer "establecimiento_contribuyente_id"
    t.string "email_institucional"
    t.string "telefono_institucional"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "ppf_actividades", force: :cascade do |t|
    t.bigint "contribuyente_id"
    t.bigint "comuna_id"
    t.bigint "programa_proyecto_propuesta_id"
    t.bigint "ppf_tipo_actividad_id"
    t.string "direccion"
    t.boolean "estado_tecnica_id", default: false
    t.text "observaciones"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.date "fecha"
    t.index ["comuna_id"], name: "index_ppf_actividades_on_comuna_id"
    t.index ["contribuyente_id"], name: "index_ppf_actividades_on_contribuyente_id"
    t.index ["ppf_tipo_actividad_id"], name: "index_ppf_actividades_on_ppf_tipo_actividad_id"
    t.index ["programa_proyecto_propuesta_id"], name: "index_ppf_actividades_on_programa_proyecto_propuesta_id"
  end

  create_table "ppf_metas_comentarios", force: :cascade do |t|
    t.bigint "ppf_metas_establecimiento_id"
    t.bigint "user_id"
    t.string "comentario"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["ppf_metas_establecimiento_id"], name: "index_ppf_metas_comentarios_on_ppf_metas_establecimiento_id"
    t.index ["user_id"], name: "index_ppf_metas_comentarios_on_user_id"
  end

  create_table "ppf_metas_establecimientos", force: :cascade do |t|
    t.bigint "establecimiento_contribuyente_id"
    t.bigint "flujo_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "estado", limit: 2, default: 0
    t.index ["flujo_id"], name: "index_ppf_metas_establecimientos_on_flujo_id"
  end

  create_table "ppf_tipo_actividades", force: :cascade do |t|
    t.string "nombre"
    t.string "descripcion"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "preguntas", force: :cascade do |t|
    t.text "texto", null: false
    t.integer "tipo_respuestas", null: false
    t.boolean "base", default: true, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "privacidad_permisos", force: :cascade do |t|
    t.string "entidad"
    t.text "fields_visibility"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "programa_proyecto_propuestas", force: :cascade do |t|
    t.integer "tipo_instrumento_id"
    t.integer "proponente_id"
    t.string "proponente"
    t.text "descripcion"
    t.integer "institucion_que_solicita_apoyo_id"
    t.string "rut_institucion_que_solicita_apoyo"
    t.string "direccion_institucion_que_solicita_apoyo"
    t.string "lugar_institucion_que_solicita_apoyo"
    t.string "ubicacion_exacta_institucion_que_solicita_apoyo"
    t.string "nombre_representante_institucion_para_solicitud"
    t.string "rut_representante_institucion_para_solicitud"
    t.string "telefono_representante_institucion_para_solicitud"
    t.string "email_representante_institucion_para_solicitud"
    t.string "nombre_propuesta"
    t.text "motivacion_y_objetivos"
    t.text "equipo_de_trabajo_comprometido"
    t.text "instituciones_participantes_propuesta"
    t.integer "monto_aproximado_a_solicitar"
    t.date "fecha_aproximada_postulacion"
    t.date "fecha_aproximada_decision"
    t.text "motivos_relevantes_para_postular"
    t.integer "institucion_a_la_cual_se_presentara_la_propuesta_id"
    t.integer "sucursal_institucion_a_la_cual_se_presentara_la_propuesta_id"
    t.string "nombre_del_fondo_al_cual_se_esta_postulando"
    t.string "documento_con_programa_proyecto_existente"
    t.integer "programa_proyecto_propuesta_base_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.text "comentario_al_asignar_revisor"
    t.text "secciones_observadas_revision"
    t.integer "resultado_de_la_revision"
    t.text "actual_respuesta_proponente_revision"
    t.text "actual_observaciones_y_comentarios_revision"
    t.text "historia_respuesta_proponente_revision"
    t.text "historia_observaciones_y_comentarios_revision"
    t.boolean "revisada", default: false
    t.boolean "resuelta", default: false
    t.text "documento_proponente_revision"
    t.text "carta_de_apoyo_coordinador"
    t.boolean "proyecto_adjudicado"
    t.text "motivos_adjudicacion"
    t.date "fecha_adjudicacion"
    t.bigint "monto_adjudicado"
    t.text "documento_proyecto"
    t.date "fecha_inicio"
    t.text "enlace_proyecto"
    t.text "participacion_agencia"
    t.text "instrumento_asociados_id"
    t.text "productos_y_resultados"
    t.text "documento_resultados"
    t.date "fecha_finalizacion"
    t.boolean "finalizado"
    t.string "archivo_propuesta_elaboracion"
    t.text "comentarios_observaciones_tecnicas"
    t.string "archivo_observaciones_tecnicas"
    t.date "fecha_observaciones_tecnicas"
    t.integer "resultado_observaciones_tecnicas"
    t.date "fecha_postulacion"
    t.text "documento_recepcion_postulacion"
    t.integer "resultado_postulacion"
    t.date "fecha_entrega_resultados"
    t.text "motivos_resultado"
    t.integer "monto_aprobado"
    t.integer "organismo_ejecutor_id"
    t.text "documentos_administrativos_aprobando_el_proyecto"
    t.date "fecha_inicio_legal_proyecto"
    t.string "codigo_bip"
    t.date "fecha_inicio_efectiva"
    t.date "fecha_finalizacion_efectiva"
    t.integer "institucion_visitas_id"
    t.text "comentarios_visitas"
    t.integer "institucion_carga_datos_id"
    t.text "comentarios_carga_datos"
    t.boolean "proyecto_con_atencion_directa_a_beneficiarios"
    t.text "sectores_economicos"
    t.text "territorios_regiones"
    t.text "territorios_provincias"
    t.text "territorios_comunas"
    t.text "instrumentos_relacionados_historico"
    t.text "url_enlace"
    t.date "fecha_elaboracion_propuesta"
    t.date "fecha_carta_de_apoyo"
    t.string "documento_productos_resultados"
    t.string "instrumento_relacionado_type"
    t.bigint "instrumento_relacionado_id"
    t.integer "representante_institucion_para_solicitud_id"
    t.string "tipo_contribuyente_institucion_que_solicita_apoyo"
    t.date "plazo_ejecucion_legal"
    t.index ["instrumento_relacionado_type", "instrumento_relacionado_id"], name: "instrumentos_relacionados"
  end

  create_table "proveedor_tipo_proveedores", force: :cascade do |t|
    t.integer "proveedor_id", null: false
    t.integer "tipo_proveedor_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "proveedores", force: :cascade do |t|
    t.integer "contribuyente_id", null: false
    t.integer "tipo_instrumento_id"
    t.integer "materia_sustancia_id"
    t.integer "clasificacion_id"
    t.integer "alcance_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "evaluacion"
  end

  create_table "provincias", force: :cascade do |t|
    t.integer "region_id", null: false
    t.string "nombre", limit: 30, null: false
    t.boolean "vigente", default: true, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "proyecto_actividades", force: :cascade do |t|
    t.integer "proyecto_id"
    t.string "nombre"
    t.date "fecha_finalizacion"
    t.date "fecha_realizacion_compromiso"
    t.integer "duracion"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "proyecto_pagos", force: :cascade do |t|
    t.bigint "proyecto_id"
    t.datetime "fecha_pago", default: -> { "now()" }, null: false
    t.integer "monto", null: false
    t.integer "numero_orden_pago"
    t.date "fecha_pago_efectiva"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["proyecto_id"], name: "index_proyecto_pagos_on_proyecto_id"
  end

  create_table "proyectos", force: :cascade do |t|
    t.string "codigo"
    t.string "nombre"
    t.integer "contribuyente_id"
    t.string "estado"
    t.date "fecha_informe"
    t.boolean "iniciado", default: false
    t.date "fecha_iniciacion"
    t.boolean "oculto", default: false
    t.string "archivo_minuta_reunion"
    t.integer "coordinador_id"
    t.integer "cogestor_id"
    t.integer "revisor_tecnico_id"
    t.integer "centro_costos_id"
    t.date "fecha_inicio_contrato"
    t.date "fecha_fin_contrato"
    t.string "archivo_resolucion"
    t.string "archivo_contrato"
    t.integer "monto_pagar"
    t.integer "numero_orden_pago"
    t.date "fecha_pago_efectiva"
    t.date "fecha_restitucion"
    t.integer "monto_restitucion"
    t.bigint "tipo_instrumento_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "total_anticipo", default: 0
    t.integer "total_reembolso", default: 0
    t.integer "total_nuevo_anticipo", default: 0
    t.integer "total_cofinanciamiento", default: 0, null: false
    t.text "comentario_modificacion"
    t.text "instrumentos_relacionados"
    t.text "territorios_regiones"
    t.text "territorios_provincias"
    t.text "territorios_comunas"
    t.text "instrumentos_relacionados_historico"
    t.text "sectores_economicos"
    t.text "motivacion_y_objetivos"
    t.index ["tipo_instrumento_id"], name: "index_proyectos_on_tipo_instrumento_id"
  end

  create_table "rango_venta_contribuyentes", force: :cascade do |t|
    t.integer "tamano_contribuyente_id"
    t.string "rango"
    t.string "venta_anual_en_uf"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "regiones", id: :serial, force: :cascade do |t|
    t.string "nombre", limit: 42
    t.bigint "pais_id"
    t.boolean "vigente", default: true, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["pais_id"], name: "index_regiones_on_pais_id"
  end

  create_table "registro_apertura_correos", force: :cascade do |t|
    t.bigint "user_id"
    t.bigint "flujo_id"
    t.bigint "flujo_tarea_id"
    t.bigint "convocatoria_destinatario_id"
    t.datetime "fecha_envio_correo"
    t.datetime "fecha_apertura_correo"
    t.boolean "estado", default: false
    t.boolean "asistio", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["convocatoria_destinatario_id"], name: "index_registro_apertura_correos_on_convocatoria_destinatario_id"
    t.index ["flujo_id"], name: "index_registro_apertura_correos_on_flujo_id"
    t.index ["flujo_tarea_id"], name: "index_registro_apertura_correos_on_flujo_tarea_id"
    t.index ["user_id"], name: "index_registro_apertura_correos_on_user_id"
  end

  create_table "registro_proveedores", force: :cascade do |t|
    t.string "rut"
    t.string "nombre"
    t.string "apellido"
    t.string "email"
    t.string "telefono"
    t.string "profesion"
    t.string "direccion"
    t.string "region"
    t.string "comuna"
    t.string "ciudad"
    t.boolean "terminos_y_servicion", default: false
    t.boolean "asociar_institucion", default: false
    t.string "documentos"
    t.bigint "contribuyente_id"
    t.bigint "tipo_contribuyente_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "rut_institucion"
    t.string "nombre_institucion"
    t.integer "tipo_contribuyente"
    t.string "direccion_casa_matriz"
    t.string "region_casa_matriz"
    t.string "comuna_casa_matriz"
    t.string "ciudad_casa_matriz"
    t.bigint "tipo_proveedor_id"
    t.integer "estado", default: 0
    t.integer "user_encargado"
    t.integer "rechazo", default: 0
    t.string "comentario"
    t.index ["contribuyente_id"], name: "index_registro_proveedores_on_contribuyente_id"
    t.index ["tipo_contribuyente_id"], name: "index_registro_proveedores_on_tipo_contribuyente_id"
    t.index ["tipo_proveedor_id"], name: "index_registro_proveedores_on_tipo_proveedor_id"
  end

  create_table "rendiciones", force: :cascade do |t|
    t.integer "proyecto_id"
    t.date "fecha_rendicion"
    t.integer "modalidad_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "reporte_sustentabilidads", force: :cascade do |t|
    t.string "titulo_intro"
    t.text "cuerpo_intro"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "reporteria_datos", force: :cascade do |t|
    t.string "ruta"
    t.integer "clasificacion_id"
    t.integer "acuerdo_id"
    t.string "vista"
    t.text "datos"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "responsables", force: :cascade do |t|
    t.integer "tipo_instrumento_id", null: false
    t.integer "rol_id", null: false
    t.integer "cargo_id"
    t.integer "contribuyente_id"
    t.integer "actividad_economica_id"
    t.integer "tipo_contribuyente_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "reunion_destinatarios", force: :cascade do |t|
    t.integer "reunion_id"
    t.integer "destinatario_id"
    t.boolean "visto"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "reuniones", force: :cascade do |t|
    t.integer "proyecto_id"
    t.date "fecha"
    t.string "direccion"
    t.decimal "lat"
    t.decimal "lng"
    t.string "encabezado"
    t.string "mensaje"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "roles", force: :cascade do |t|
    t.string "nombre"
    t.text "descripcion"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "mostrar_en_excel", default: true
  end

  create_table "sessions", force: :cascade do |t|
    t.string "session_id", null: false
    t.text "data"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["session_id"], name: "index_sessions_on_session_id", unique: true
    t.index ["updated_at"], name: "index_sessions_on_updated_at"
  end

  create_table "set_metas_acciones", force: :cascade do |t|
    t.integer "accion_id"
    t.integer "materia_sustancia_id"
    t.integer "meta_id"
    t.string "tipo_cuantitativa"
    t.integer "alcance_id"
    t.string "valor_referencia"
    t.text "criterio_inclusion_exclusion"
    t.text "descripcion_accion"
    t.text "detalle_medio_verificacion"
    t.integer "plazo_valor"
    t.integer "plazo_unidad_tiempo"
    t.integer "manifestacion_de_interes_id"
    t.text "comentario"
    t.text "comentario_respuesta"
    t.string "archivo_acta_comite"
    t.boolean "anexo", default: false
    t.bigint "flujo_id"
    t.bigint "ppf_metas_establecimiento_id"
    t.integer "estado", limit: 2, default: 1
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "puntaje"
    t.bigint "estandar_nivel_id"
    t.bigint "id_referencia"
    t.string "modelo_referencia"
    t.index ["estandar_nivel_id"], name: "index_set_metas_acciones_on_estandar_nivel_id"
    t.index ["flujo_id"], name: "index_set_metas_acciones_on_flujo_id"
    t.index ["ppf_metas_establecimiento_id"], name: "index_set_metas_acciones_on_ppf_metas_establecimiento_id"
  end

  create_table "tamano_contribuyentes", force: :cascade do |t|
    t.string "nombre"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "tarea_pendientes", force: :cascade do |t|
    t.integer "flujo_id", null: false
    t.integer "tarea_id", null: false
    t.integer "estado_tarea_pendiente_id", null: false
    t.integer "user_id"
    t.text "data"
    t.text "resultado"
    t.datetime "created_at", default: -> { "now()" }, null: false
    t.datetime "updated_at", default: -> { "now()" }, null: false
    t.boolean "primera_ejecucion", default: true
    t.bigint "persona_id"
    t.index ["persona_id"], name: "index_tarea_pendientes_on_persona_id"
  end

  create_table "tareas", force: :cascade do |t|
    t.integer "etapa_id"
    t.integer "tipo_instrumento_id", null: false
    t.integer "rol_id", null: false
    t.string "nombre", null: false
    t.text "descripcion"
    t.string "recordatorio_tarea_asunto"
    t.text "recordatorio_tarea_cuerpo"
    t.string "recordatorio_tarea_frecuencia"
    t.boolean "posee_formulario"
    t.boolean "cualquiera_con_rol_o_usuario_asignado"
    t.text "condicion_de_acceso"
    t.boolean "es_una_encuesta", default: false, null: false
    t.integer "encuesta_id"
    t.string "codigo"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "duracion"
    t.index ["codigo"], name: "index_tareas_on_codigo"
  end

  create_table "tipo_aportes", force: :cascade do |t|
    t.string "nombre", null: false
    t.text "descripcion", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "tipo_comentarios", force: :cascade do |t|
    t.string "nombre", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "tipo_contribuyentes", force: :cascade do |t|
    t.integer "tipo_contribuyente_id"
    t.string "nombre", null: false
    t.text "descripcion"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "tipo_de_medios", force: :cascade do |t|
    t.string "nombre"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "tipo_documento_diagnosticos", force: :cascade do |t|
    t.string "nombre", null: false
    t.text "descripcion", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "tipo_documento_garantias", force: :cascade do |t|
    t.string "nombre"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "tipo_instrumentos", force: :cascade do |t|
    t.string "nombre", null: false
    t.text "descripcion", null: false
    t.integer "tipo_instrumento_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["nombre"], name: "index_tipo_instrumentos_on_nombre", unique: true
  end

  create_table "tipo_proveedores", force: :cascade do |t|
    t.string "nombre", null: false
    t.text "descripcion", null: false
    t.boolean "solo_asignable_por_ascc", default: false, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "traspaso_instrumentos", force: :cascade do |t|
    t.bigint "origen_id"
    t.bigint "flujo_id"
    t.bigint "destino_id"
    t.integer "tipo_traspaso"
    t.date "fecha_retorno"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.text "cambios_mapa_de_actores"
    t.text "cambios_tareas_pendientes"
    t.index ["destino_id"], name: "index_traspaso_instrumentos_on_destino_id"
    t.index ["flujo_id"], name: "index_traspaso_instrumentos_on_flujo_id"
    t.index ["origen_id"], name: "index_traspaso_instrumentos_on_origen_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "rut", null: false
    t.string "telefono"
    t.string "email", default: "", null: false
    t.string "web_o_red_social_1"
    t.string "web_o_red_social_2"
    t.text "fields_visibility"
    t.text "session"
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet "current_sign_in_ip"
    t.inet "last_sign_in_ip"
    t.string "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string "unconfirmed_email"
    t.integer "failed_attempts", default: 0, null: false
    t.string "unlock_token"
    t.datetime "locked_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "nombre_completo", null: false
    t.string "invitation_token"
    t.datetime "invitation_created_at"
    t.datetime "invitation_sent_at"
    t.datetime "invitation_accepted_at"
    t.integer "invitation_limit"
    t.string "invited_by_type"
    t.bigint "invited_by_id"
    t.integer "invitations_count", default: 0
    t.boolean "temporal", default: false
    t.bigint "flujo_id"
    t.bigint "user_id"
    t.index ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true
    t.index ["email"], name: "index_users_on_email"
    t.index ["flujo_id"], name: "index_users_on_flujo_id"
    t.index ["invitation_token"], name: "index_users_on_invitation_token", unique: true
    t.index ["invitations_count"], name: "index_users_on_invitations_count"
    t.index ["invited_by_id"], name: "index_users_on_invited_by_id"
    t.index ["invited_by_type", "invited_by_id"], name: "index_users_on_invited_by_type_and_invited_by_id"
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
    t.index ["rut"], name: "index_users_on_rut"
    t.index ["unlock_token"], name: "index_users_on_unlock_token", unique: true
    t.index ["user_id"], name: "index_users_on_user_id"
  end

  create_table "variables", force: :cascade do |t|
    t.string "nombre", limit: 20, null: false
    t.text "valor", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_foreign_key "accion_clasificaciones", "acciones"
  add_foreign_key "accion_clasificaciones", "clasificaciones"
  add_foreign_key "accion_relacionadas", "acciones"
  add_foreign_key "accion_relacionadas", "acciones", column: "accion_relacionada_id"
  add_foreign_key "acciones", "clasificaciones", column: "meta_id"
  add_foreign_key "actividad_economica_contribuyentes", "actividad_economicas"
  add_foreign_key "actividad_economica_contribuyentes", "contribuyentes"
  add_foreign_key "actividad_economica_flujos", "actividad_economicas"
  add_foreign_key "actividad_economica_flujos", "flujos"
  add_foreign_key "actividad_por_lineas", "actividades"
  add_foreign_key "actividad_por_lineas", "tipo_instrumentos"
  add_foreign_key "adhesion_elemento_retirados", "adhesiones"
  add_foreign_key "adhesion_elemento_retirados", "alcances"
  add_foreign_key "adhesion_elemento_retirados", "establecimiento_contribuyentes"
  add_foreign_key "adhesion_elemento_retirados", "maquinarias"
  add_foreign_key "adhesion_elemento_retirados", "otros"
  add_foreign_key "adhesion_elemento_retirados", "personas"
  add_foreign_key "adhesion_elementos", "adhesiones"
  add_foreign_key "adhesion_elementos", "adhesiones", column: "adhesion_externa_id"
  add_foreign_key "adhesion_elementos", "alcances"
  add_foreign_key "adhesion_elementos", "establecimiento_contribuyentes"
  add_foreign_key "adhesion_elementos", "maquinarias"
  add_foreign_key "adhesion_elementos", "otros"
  add_foreign_key "adhesion_elementos", "personas"
  add_foreign_key "adhesiones", "comunas", column: "matriz_comuna_id"
  add_foreign_key "adhesiones", "flujos"
  add_foreign_key "adhesiones", "regiones", column: "matriz_region_id"
  add_foreign_key "adhesiones", "roles"
  add_foreign_key "adhesiones", "tipo_contribuyentes"
  add_foreign_key "auditoria_elemento_archivos", "auditorias"
  add_foreign_key "auditoria_elementos", "adhesion_elementos"
  add_foreign_key "auditoria_elementos", "auditoria_elemento_archivos", column: "archivo_evidencia_id"
  add_foreign_key "auditoria_elementos", "auditoria_elemento_archivos", column: "archivo_informe_id"
  add_foreign_key "auditoria_elementos", "auditorias"
  add_foreign_key "auditoria_elementos", "set_metas_acciones"
  add_foreign_key "auditoria_historicos", "manifestacion_de_intereses"
  add_foreign_key "auditoria_niveles", "auditorias"
  add_foreign_key "auditoria_niveles", "estandar_niveles"
  add_foreign_key "auditoria_validaciones", "auditorias"
  add_foreign_key "auditoria_validaciones", "users"
  add_foreign_key "auditorias", "convocatorias"
  add_foreign_key "auditorias", "flujos"
  add_foreign_key "auditorias", "manifestacion_de_intereses"
  add_foreign_key "campo_tareas", "campos"
  add_foreign_key "campo_tareas", "tareas"
  add_foreign_key "certificacion_adhesion_historicos", "adhesion_elementos"
  add_foreign_key "certificado_proveedores", "actividad_economicas"
  add_foreign_key "certificado_proveedores", "materia_sustancias"
  add_foreign_key "certificado_proveedores", "registro_proveedores"
  add_foreign_key "clasificaciones", "clasificaciones"
  add_foreign_key "comentario_archivos", "comentarios"
  add_foreign_key "comentarios", "tipo_comentarios"
  add_foreign_key "comentarios_informe_acuerdos", "informe_acuerdos"
  add_foreign_key "comentarios_informe_acuerdos", "users"
  add_foreign_key "comentarios_metas_acciones", "set_metas_acciones"
  add_foreign_key "comentarios_metas_acciones", "users"
  add_foreign_key "comunas", "provincias"
  add_foreign_key "comunas_flujos", "comunas"
  add_foreign_key "comunas_flujos", "flujos"
  add_foreign_key "contribuyentes", "contribuyentes"
  add_foreign_key "contribuyentes", "flujos"
  add_foreign_key "convocatoria_destinatarios", "convocatorias"
  add_foreign_key "convocatoria_destinatarios", "personas", column: "destinatario_id"
  add_foreign_key "convocatorias", "flujos"
  add_foreign_key "convocatorias", "manifestacion_de_intereses"
  add_foreign_key "cuencas_flujos", "cuencas"
  add_foreign_key "cuencas_flujos", "flujos"
  add_foreign_key "dato_anual_contribuyentes", "contribuyentes"
  add_foreign_key "dato_anual_contribuyentes", "rango_venta_contribuyentes"
  add_foreign_key "dato_anual_contribuyentes", "tipo_contribuyentes"
  add_foreign_key "dato_productivo_elemento_adheridos", "set_metas_acciones"
  add_foreign_key "descargable_tareas", "tareas"
  add_foreign_key "documento_diagnosticos", "manifestacion_de_intereses"
  add_foreign_key "documento_diagnosticos", "tipo_documento_diagnosticos"
  add_foreign_key "documento_garantias", "documento_garantias"
  add_foreign_key "documento_garantias", "estado_documento_garantias"
  add_foreign_key "documento_garantias", "proyectos"
  add_foreign_key "documento_garantias", "tipo_documento_garantias"
  add_foreign_key "documento_registro_proveedores", "registro_proveedores"
  add_foreign_key "ejecucion_presupuestarias", "centro_de_costos"
  add_foreign_key "ejecucion_presupuestarias", "programa_proyecto_propuestas"
  add_foreign_key "encuesta_descarga_roles", "roles"
  add_foreign_key "encuesta_descarga_roles", "tareas"
  add_foreign_key "encuesta_ejecucion_roles", "roles"
  add_foreign_key "encuesta_ejecucion_roles", "tareas"
  add_foreign_key "encuesta_preguntas", "encuestas"
  add_foreign_key "encuesta_preguntas", "preguntas"
  add_foreign_key "encuesta_user_respuestas", "encuestas"
  add_foreign_key "encuesta_user_respuestas", "preguntas"
  add_foreign_key "encuesta_user_respuestas", "tarea_pendientes"
  add_foreign_key "encuesta_user_respuestas", "users"
  add_foreign_key "establecimiento_contribuyentes", "comunas"
  add_foreign_key "establecimiento_contribuyentes", "contribuyentes"
  add_foreign_key "establecimiento_contribuyentes", "paises"
  add_foreign_key "estandar_niveles", "estandar_homologaciones"
  add_foreign_key "estandar_set_metas_acciones", "acciones"
  add_foreign_key "estandar_set_metas_acciones", "alcances"
  add_foreign_key "estandar_set_metas_acciones", "clasificaciones", column: "meta_id"
  add_foreign_key "estandar_set_metas_acciones", "estandar_homologaciones"
  add_foreign_key "estandar_set_metas_acciones", "estandar_niveles"
  add_foreign_key "estandar_set_metas_acciones", "materia_sustancias"
  add_foreign_key "etapas", "etapas"
  add_foreign_key "flujo_tareas", "tareas", column: "tarea_entrada_id"
  add_foreign_key "flujo_tareas", "tareas", column: "tarea_salida_id"
  add_foreign_key "flujos", "contribuyentes"
  add_foreign_key "flujos", "manifestacion_de_intereses"
  add_foreign_key "flujos", "manifestacion_de_intereses", name: "flujos_manifestacion_de_interes_id_fkey"
  add_foreign_key "flujos", "programa_proyecto_propuestas"
  add_foreign_key "flujos", "proyectos"
  add_foreign_key "flujos", "tipo_instrumentos"
  add_foreign_key "hito_de_prensa_archivos", "hitos_de_prensa", column: "hitos_de_prensa_id"
  add_foreign_key "hito_de_prensa_instrumentos", "flujos"
  add_foreign_key "hito_de_prensa_instrumentos", "hitos_de_prensa", column: "hitos_de_prensa_id"
  add_foreign_key "hito_de_prensa_responsables", "hitos_de_prensa", column: "hitos_de_prensa_id"
  add_foreign_key "hito_de_prensa_responsables", "users"
  add_foreign_key "hitos_de_prensa", "flujos"
  add_foreign_key "hitos_de_prensa", "tipo_de_medios"
  add_foreign_key "informe_acuerdos", "manifestacion_de_intereses"
  add_foreign_key "informe_impactos", "manifestacion_de_intereses"
  add_foreign_key "instrumentos", "tipo_instrumentos"
  add_foreign_key "mapa_de_actores", "flujos"
  add_foreign_key "mapa_de_actores", "persona_cargos"
  add_foreign_key "mapa_de_actores", "personas"
  add_foreign_key "mapa_de_actores", "roles"
  add_foreign_key "maquinarias", "contribuyentes"
  add_foreign_key "maquinarias", "establecimiento_contribuyentes"
  add_foreign_key "materia_rubro_dato_relacions", "materia_rubro_relacions"
  add_foreign_key "materia_rubro_relacions", "actividad_economicas"
  add_foreign_key "materia_rubro_relacions", "materia_sustancias"
  add_foreign_key "materia_sustancia_clasificaciones", "clasificaciones"
  add_foreign_key "materia_sustancia_clasificaciones", "materia_sustancias"
  add_foreign_key "materia_sustancia_metas", "clasificaciones"
  add_foreign_key "materia_sustancia_metas", "materia_sustancias"
  add_foreign_key "minutas", "convocatorias"
  add_foreign_key "modificacion_calendarios", "proyectos"
  add_foreign_key "otros", "alcances"
  add_foreign_key "otros", "contribuyentes"
  add_foreign_key "otros", "establecimiento_contribuyentes"
  add_foreign_key "persona_cargos", "cargos"
  add_foreign_key "persona_cargos", "personas"
  add_foreign_key "personas", "contribuyentes"
  add_foreign_key "personas", "establecimiento_contribuyentes"
  add_foreign_key "personas", "users"
  add_foreign_key "ppf_metas_comentarios", "ppf_metas_establecimientos"
  add_foreign_key "ppf_metas_comentarios", "users"
  add_foreign_key "ppf_metas_establecimientos", "flujos"
  add_foreign_key "programa_proyecto_propuestas", "contribuyentes", column: "institucion_a_la_cual_se_presentara_la_propuesta_id"
  add_foreign_key "programa_proyecto_propuestas", "contribuyentes", column: "institucion_carga_datos_id"
  add_foreign_key "programa_proyecto_propuestas", "contribuyentes", column: "institucion_que_solicita_apoyo_id"
  add_foreign_key "programa_proyecto_propuestas", "contribuyentes", column: "institucion_visitas_id"
  add_foreign_key "programa_proyecto_propuestas", "contribuyentes", column: "organismo_ejecutor_id"
  add_foreign_key "programa_proyecto_propuestas", "establecimiento_contribuyentes", column: "sucursal_institucion_a_la_cual_se_presentara_la_propuesta_id"
  add_foreign_key "programa_proyecto_propuestas", "programa_proyecto_propuestas", column: "programa_proyecto_propuesta_base_id"
  add_foreign_key "programa_proyecto_propuestas", "tipo_instrumentos"
  add_foreign_key "programa_proyecto_propuestas", "users", column: "proponente_id"
  add_foreign_key "proveedor_tipo_proveedores", "proveedores"
  add_foreign_key "proveedor_tipo_proveedores", "tipo_proveedores"
  add_foreign_key "proveedores", "alcances"
  add_foreign_key "proveedores", "clasificaciones"
  add_foreign_key "proveedores", "contribuyentes"
  add_foreign_key "proveedores", "materia_sustancias"
  add_foreign_key "proveedores", "tipo_instrumentos"
  add_foreign_key "provincias", "regiones"
  add_foreign_key "proyecto_pagos", "proyectos"
  add_foreign_key "rango_venta_contribuyentes", "tamano_contribuyentes"
  add_foreign_key "regiones", "paises"
  add_foreign_key "registro_apertura_correos", "convocatoria_destinatarios"
  add_foreign_key "registro_apertura_correos", "flujo_tareas"
  add_foreign_key "registro_apertura_correos", "flujos"
  add_foreign_key "registro_apertura_correos", "users"
  add_foreign_key "registro_proveedores", "contribuyentes"
  add_foreign_key "registro_proveedores", "tipo_contribuyentes"
  add_foreign_key "registro_proveedores", "tipo_proveedores"
  add_foreign_key "responsables", "actividad_economicas"
  add_foreign_key "responsables", "cargos"
  add_foreign_key "responsables", "contribuyentes"
  add_foreign_key "responsables", "roles"
  add_foreign_key "responsables", "tipo_contribuyentes"
  add_foreign_key "responsables", "tipo_instrumentos"
  add_foreign_key "set_metas_acciones", "acciones"
  add_foreign_key "set_metas_acciones", "alcances"
  add_foreign_key "set_metas_acciones", "clasificaciones", column: "meta_id"
  add_foreign_key "set_metas_acciones", "estandar_niveles"
  add_foreign_key "set_metas_acciones", "flujos"
  add_foreign_key "set_metas_acciones", "materia_sustancias"
  add_foreign_key "set_metas_acciones", "ppf_metas_establecimientos"
  add_foreign_key "tarea_pendientes", "estado_tarea_pendientes"
  add_foreign_key "tarea_pendientes", "flujos"
  add_foreign_key "tarea_pendientes", "personas"
  add_foreign_key "tarea_pendientes", "tareas"
  add_foreign_key "tarea_pendientes", "users"
  add_foreign_key "tareas", "encuestas"
  add_foreign_key "tareas", "etapas"
  add_foreign_key "tareas", "roles"
  add_foreign_key "tareas", "tipo_instrumentos"
  add_foreign_key "tipo_contribuyentes", "tipo_contribuyentes"
  add_foreign_key "tipo_instrumentos", "tipo_instrumentos"
  add_foreign_key "traspaso_instrumentos", "flujos"
  add_foreign_key "traspaso_instrumentos", "users", column: "destino_id"
  add_foreign_key "traspaso_instrumentos", "users", column: "origen_id"
  add_foreign_key "users", "flujos"
  add_foreign_key "users", "users"
end
