class CreateProgramaProyectoPropuestas < ActiveRecord::Migration[5.1]
  def change
    create_table :programa_proyecto_propuestas do |t|
      t.integer :tipo_instrumento_id
      t.integer :proponente_id
      t.string :proponente
      t.text :descripcion
      
      t.integer :institucion_que_solicita_apoyo_id
      t.string :rut_institucion_que_solicita_apoyo
      t.string :direccion_institucion_que_solicita_apoyo
      t.string :lugar_institucion_que_solicita_apoyo
      t.string :ubicacion_exacta_institucion_que_solicita_apoyo
      t.integer :tipo_contribuyente_institucion_que_solicita_apoyo_id
      t.string :nombre_representante_institucion_para_solicitud
      t.string :rut_representante_institucion_para_solicitud
      t.string :telefono_representante_institucion_para_solicitud
      t.string :email_representante_institucion_para_solicitud

			t.string :nombre_propuesta
			t.text :motivacion_y_objetivos
			t.text :equipo_de_trabajo_comprometido
			t.text :instituciones_participantes_propuesta
			t.integer :monto_aproximado_a_solicitar
			t.date :fecha_aproximada_postulacion
			t.date :fecha_aproximada_decision
			t.text :motivos_relevantes_para_postular
			t.integer :instrumentos_relacionados_id
			t.integer :institucion_a_la_cual_se_presentara_la_propuesta_id
      t.integer :sucursal_institucion_a_la_cual_se_presentara_la_propuesta_id
			t.string :nombre_del_fondo_al_cual_se_esta_postulando
			t.string :documento_con_programa_proyecto_existente
			t.integer :programa_proyecto_propuesta_base_id

      t.timestamps
    end
    add_foreign_key :programa_proyecto_propuestas, :tipo_instrumentos
    add_foreign_key :programa_proyecto_propuestas, :users, column: :proponente_id
    add_foreign_key :programa_proyecto_propuestas, :contribuyentes, column: :institucion_que_solicita_apoyo_id
    add_foreign_key :programa_proyecto_propuestas, :actividad_economicas, column: :tipo_contribuyente_institucion_que_solicita_apoyo_id
    add_foreign_key :programa_proyecto_propuestas, :tipo_instrumentos, column: :instrumentos_relacionados_id
    add_foreign_key :programa_proyecto_propuestas, :contribuyentes, column: :institucion_a_la_cual_se_presentara_la_propuesta_id
    add_foreign_key :programa_proyecto_propuestas, :establecimiento_contribuyentes, column: :sucursal_institucion_a_la_cual_se_presentara_la_propuesta_id
    add_foreign_key :programa_proyecto_propuestas, :programa_proyecto_propuestas, column: :programa_proyecto_propuesta_base_id
  end
end
