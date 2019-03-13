class CorrigeNombresDeComunas < ActiveRecord::Migration[5.1]
  def change
  	# DZC 2018-11-07 16:55:33 reemplazamos los nombres en la tabla comunas, por los nombres en la tabla comunas_alternativas
  	execute <<-SQL
  		UPDATE comunas
  		SET
				nombre = c2.nombre
			FROM (
					SELECT id_antiguo, nombre
					FROM comunas_alternativas) c2
			WHERE
				c2.id_antiguo = comunas.id;
		SQL
  end
end
