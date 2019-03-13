class CreateModalidades < ActiveRecord::Migration[5.1]
  def change
    create_table :modalidades do |t|
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
      INSERT INTO "modalidades" ("id", "nombre") VALUES
        (1, 'Anticipo'),
        (2, 'Reembolso');
      SELECT SETVAL('modalidades_id_seq', (SELECT MAX(id) FROM modalidades));
    SQL
  end
end
