class CreateTipoProveedores < ActiveRecord::Migration[5.1]
  def change
    create_table :tipo_proveedores do |t|
      t.string :nombre, null: false
      t.text :descripcion, null: false
      t.boolean :solo_asignable_por_ascc, null: false, default: false
    end
  end
  
  def migrate(direction)
    super
    if direction == :up
      query
    end
  end

  def query
    execute <<-SQL
      INSERT INTO "tipo_proveedores" ("id", "nombre", "descripcion", "solo_asignable_por_ascc") VALUES
        (1, 'Auditor APL',  'Auditores registrados y habilitados por la ASCC para realizar auditorías de Acuerdos de Producción Limpia de Acuerdo a NCH 2825',  't'),
        (2, 'Facilitador APL',  'Un facilitador debe guiar el diálogo entre los diferentes actores de un territorio o partes interesadas en el contexto del proceso de construcción del Diagnóstico General y propuesta de un Acuerdo.',  't');
      SELECT SETVAL('tipo_proveedores_id_seq', (SELECT MAX(id) FROM tipo_proveedores));
    SQL
  end
end