class CreateEstadoRendiciones < ActiveRecord::Migration[5.1]
  def change
    create_table :estado_rendiciones do |t|
    	t.string :nombre
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
      INSERT INTO "estado_rendiciones" ("id", "nombre") VALUES
        (1, 'No enviada'),
        (2, 'En revisión'),
        (3, 'Aceptada'),
        (4, 'Observada');
      SELECT SETVAL('estado_rendiciones_id_seq', (SELECT MAX(id) FROM estado_rendiciones));
    SQL
  end
end
