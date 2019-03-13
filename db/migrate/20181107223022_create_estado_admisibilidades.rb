class CreateEstadoAdmisibilidades < ActiveRecord::Migration[5.1]
  def change
    create_table :estado_admisibilidades do |t|
      t.string :nombre, null: false
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
      INSERT INTO "estado_admisibilidades" ("id", "nombre") VALUES
        (1, 'Aceptado'),
        (2, 'Rechazado'),
        (3, 'Con observaciones');
      SELECT SETVAL('estado_admisibilidades_id_seq', (SELECT MAX(id) FROM estado_admisibilidades));
    SQL
  end
end
