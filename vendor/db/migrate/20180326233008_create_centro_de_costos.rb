class CreateCentroDeCostos < ActiveRecord::Migration[5.1]
  def change
    create_table :centro_de_costos do |t|
      t.string :nombre, null: false
      t.text :descripcion, null: false
      t.integer :ano_asignacion, null: false, limit: 4
      t.integer :monto_asignacion, null: false
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
    	INSERT INTO "centro_de_costos" ("id", "nombre", "descripcion", "ano_asignacion", "monto_asignacion") VALUES
				(1,	'Centro de Costo Acuerdos de Producción Limpia NCH ASCC Central',	'Centro de costos para ejecución de proyectos de línea 1 financiadas por nivel central',	2018,	600000000),
				(2,	'Centro de Costo Acuerdos de Producción Limpia Territoriales Central',	'Centro de costos para ejecución de Acuerdos Territoriales',	2018,	100000000);
    	SELECT SETVAL('centro_de_costos_id_seq', (SELECT MAX(id) FROM centro_de_costos));
    SQL
  end
end