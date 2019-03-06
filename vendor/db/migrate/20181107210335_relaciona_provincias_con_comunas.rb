class RelacionaProvinciasConComunas < ActiveRecord::Migration[5.1]
  def up
  	# DZC 2018-11-07 17:31:32 nulificamos el campo provincia_id en la tabla comunas
  	Comuna.update_all(provincia_id: nil)	

		# DZC 2018-11-07 17:29:23 copiamos el id de la provincia desde la tabla provincias en el campo provincia_id a la tabla comunas_alternativas
  	execute <<-SQL
  		UPDATE comunas_alternativas
  		SET
				provincia_id = c2.id
			FROM (
					SELECT id, nombre
					FROM provincias) c2
			WHERE
				c2.nombre = comunas_alternativas.provincia;
		SQL

		# DZC 2018-11-07 18:42:19 copiamos provincia_id desde comunas_alternativas a comunas
		execute <<-SQL
  		UPDATE comunas
  		SET
				provincia_id = c2.provincia_id
			FROM (
					SELECT provincia_id, id_antiguo
					FROM comunas_alternativas) c2
			WHERE
				c2.id_antiguo = comunas.id;
		SQL

		# DZC 2018-11-07 18:45:31 volvemos a crear la relación provicias - comunas
		add_foreign_key "comunas", "provincias"

  end

  def down

  end
end
