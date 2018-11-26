class CreateGlosas < ActiveRecord::Migration[5.1]
  def change
    create_table :glosas do |t|
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
      INSERT INTO "glosas" ("id", "nombre") VALUES
        (1, 'RRHH propio'),
        (2, 'RRHH externo'),
        (3, 'Gastos operacionales'),
        (4, 'Gastos administrativos');
      SELECT SETVAL('glosas_id_seq', (SELECT MAX(id) FROM glosas));
    SQL
  end
end