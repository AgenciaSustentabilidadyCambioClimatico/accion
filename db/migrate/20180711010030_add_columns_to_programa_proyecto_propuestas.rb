class AddColumnsToProgramaProyectoPropuestas < ActiveRecord::Migration[5.1]
  def change
  	add_column :programa_proyecto_propuestas, :fecha_postulacion, :date
  	add_column :programa_proyecto_propuestas, :documento_recepcion_postulacion, :text
  	add_column :programa_proyecto_propuestas, :resultado_postulacion, :integer
  	add_column :programa_proyecto_propuestas, :fecha_entrega_resultados, :date
  	add_column :programa_proyecto_propuestas, :motivos_resultado, :text
  	add_column :programa_proyecto_propuestas, :monto_aprobado, :integer
  	add_column :programa_proyecto_propuestas, :organismo_ejecutor_id, :integer
  	add_column :programa_proyecto_propuestas, :responsable_coordinacion_ejecucion_seguimiento_id, :integer
  	add_column :programa_proyecto_propuestas, :documentos_administrativos_aprobando_el_proyecto, :text
  	add_column :programa_proyecto_propuestas, :fecha_inicio_legal_proyecto, :date
  	add_column :programa_proyecto_propuestas, :codigo_bip, :string
  	add_column :programa_proyecto_propuestas, :plazo_ejecucion_legal, :text
  	add_column :programa_proyecto_propuestas, :fecha_inicio_efectiva, :date
  	add_column :programa_proyecto_propuestas, :fecha_finalizacion_efectiva, :date
  	add_column :programa_proyecto_propuestas, :institucion_visitas_id, :integer
  	add_column :programa_proyecto_propuestas, :usuario_visitas_id, :integer
  	add_column :programa_proyecto_propuestas, :comentarios_visitas, :text
  	add_column :programa_proyecto_propuestas, :institucion_carga_datos_id, :integer
  	add_column :programa_proyecto_propuestas, :usuario_carga_datos_id, :integer
  	add_column :programa_proyecto_propuestas, :comentarios_carga_datos, :text

  	add_foreign_key :programa_proyecto_propuestas, :contribuyentes, column: :organismo_ejecutor_id
  	add_foreign_key :programa_proyecto_propuestas, :personas, column: :responsable_coordinacion_ejecucion_seguimiento_id
  	add_foreign_key :programa_proyecto_propuestas, :contribuyentes, column: :institucion_visitas_id
  	add_foreign_key :programa_proyecto_propuestas, :personas, column: :usuario_visitas_id
  	add_foreign_key :programa_proyecto_propuestas, :contribuyentes, column: :institucion_carga_datos_id
  	add_foreign_key :programa_proyecto_propuestas, :personas, column: :usuario_carga_datos_id
  end
end