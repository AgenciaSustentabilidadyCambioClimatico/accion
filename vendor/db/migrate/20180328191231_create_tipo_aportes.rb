class CreateTipoAportes < ActiveRecord::Migration[5.1]
  def change
    create_table :tipo_aportes do |t|
      t.string :nombre, null: false
      t.text :descripcion, null: false
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
      INSERT INTO "tipo_aportes" ("id", "nombre", "descripcion") VALUES
        (1, 'Aporte propio valorado', 'Falta descripción'),
        (2, 'Aporte propio liquido',  'Falta descripción'),
        (3, 'Solicitado al fondo',  'Falta descripción');

      SELECT SETVAL('tipo_aportes_id_seq', (SELECT MAX(id) FROM tipo_aportes));
    SQL
  end
end