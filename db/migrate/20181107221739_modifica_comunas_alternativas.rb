class ModificaComunasAlternativas < ActiveRecord::Migration[5.1]
  def up
  	# DZC 2018-11-07 19:18:12 agregamos la columna region_id
  	add_column :comunas_alternativas, :region_id, :integer, null: true

  	# DZC 2018-11-07 19:18:23 copiamos el id de la región desde la tabla
  	execute <<-SQL
  		UPDATE comunas_alternativas
  		SET
				region_id = c2.id
			FROM (
					SELECT id, nombre
					FROM regiones) c2
			WHERE
				c2.nombre = comunas_alternativas.region;
		SQL

		# DZC 2018-11-07 19:20:00 copiamos el id de la región a la tabla provincias
		execute <<-SQL
  		UPDATE provincias
  		SET
				region_id = c2.region_id
			FROM (
					SELECT region_id, provincia_id
					FROM comunas_alternativas) c2
			WHERE
				c2.provincia_id = provincias.id;
		SQL
 
 		# DZC 2018-11-07 19:21:52 volvemos a crear la relación provicias - region
 		add_foreign_key "provincias", "regiones"

		# DZC 2018-11-07 20:00:35 volvemos a dejar la region_id not null
  	change_column_null :provincias, :region_id, false

  	# DZC 2018-11-07 20:05:31 volvemos a crear la relación pais - region
  	add_foreign_key "regiones", "paises"
 		
  end

  def down

  end
end
