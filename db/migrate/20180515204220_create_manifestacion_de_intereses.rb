class CreateManifestacionDeIntereses < ActiveRecord::Migration[5.1]
  def change
    create_table :manifestacion_de_intereses do |t|
      t.text :descripcion_acuerdo
      t.string :proponente
      t.string :institucion_gestora_acuerdo
      t.string :rut_institucion_gestora_acuerdo
      t.integer :tipo_instrumento_id
      t.integer :contribuyente_id
      t.string :direccion_institucion_gestora_acuerdo
      t.string :lugar_institucion_gestora_acuerdo
      t.string :ubicacion_exacta
      t.string :tipo_contribuyente_de_institucion_gestora
      t.integer :numero_de_socios_institucion_gestora
      t.text :experiencia_en_gestion_de_proyectos
      t.date :fecha_creacion_institucion
      t.string :nombre_representante_para_acuerdo
      t.string :rut_representante_para_acuerdo
      t.string :telefono_representante_para_acuerdo
      t.string :email_representante_para_acuerdo
      t.string :carta_de_interes_institucion_gestora_firmada
      t.text :sectores_economicos
      t.text :territorios_regiones
      t.text :territorios_provincias
      t.text :territorios_comunas
      t.text :coordernadas_territorios
      t.text :caracterizacion_sector_territorio
      t.text :principales_actores
      t.string :mapa_de_actores
      t.integer :numero_empresas
      t.float :porcentaje_mipymes
      t.string :produccion
      t.integer :ventas
      t.float :porcentaje_exportaciones
      t.text :principales_mercados
      t.integer :numero_trabajadores
      t.text :vulnerabilidad_al_cambio_climatico_del_sector
      t.text :principales_impactos_socioambientales_del_sector
      t.text :principales_problemas_y_desafios
      t.text :principales_conflictos
      t.text :estudios_sectoriales_territoriales_relevantes
      t.text :otro_contexto_sector
      t.string :nombre_proyecto
      t.text :descripcion_proyecto
      t.text :justificacion_proyecto
      
      t.string :area_influencia_proyecto_archivo
      t.text :area_influencia_proyecto_data
      t.string :alternativas_instalacion_archivo
      t.text :alternativas_instalacion_data

      t.integer :monto_inversion
      t.string :tecnologia
      t.string :estado_proyecto
      t.string :estudio_de_mercado
      t.string :anteproyecto
      t.string :gantt_proyecto
      t.string :operador
      t.text :otros_proyectos_en_territorios_cercanos
      t.string :otros_estudios
      t.text :otro_datos_proyecto
      t.string :nombre_acuerdo
      t.text :motivacion_y_objetivos
      t.text :equipo_de_trabajo_comprometido
      t.string :organigrama
      t.text :patrocinadores
      t.integer :monto_total_comprometido
      t.text :otros_recursos_comprometidos
      t.string :carta_de_apoyo_y_compromiso
      t.integer :numero_participantes
      t.text :lista_participantes
      t.text :priorizacion
      t.text :otras_iniciativas_relacionadas_en_ejecucion
      t.integer :diagnostico_id
      t.integer :estandar_de_certificacion_id
      t.text :otros_objetivos_acuerdo
      t.string :otros_estudios_relevantes

      t.text :secciones_observadas_admisibilidad
      t.integer :resultado_admisibilidad
      t.text :respuesta_observaciones_admisibilidad
      t.text :comentario_jefe_de_linea
      t.text :observaciones_admisibilidad
      t.string :archivo_admisibilidad
      t.text :secciones_observadas_pertinencia_factibilidad
      t.integer :resultado_pertinencia
      t.text :observaciones_pertinencia_factibilidad
      t.text :compromiso_pertinencia_factibilidad
      t.string :archivo_pertinencia_factibilidad
      t.text :respuesta_observaciones_pertinencia_factibilidad
      t.integer :respuesta_resultado_pertinencia
      t.string :archivo_respuesta_pertinencia_factibilidad
      t.text :respuesta_otros_pertinencia_factibilidad
      t.boolean :acepta_condiciones_pertinencia

      t.integer :usuario_entregables_diagnostico_general_id
      t.string :usuario_entregables_diagnostico_general_archivo
      t.text :usuario_entregables_diagnostico_general_comentario
      t.text :usuario_entregables_diagnostico_general_otros

      t.timestamps
    end
  end
end
