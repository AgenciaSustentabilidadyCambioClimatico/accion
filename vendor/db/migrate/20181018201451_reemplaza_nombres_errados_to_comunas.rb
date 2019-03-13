class ReemplazaNombresErradosToComunas < ActiveRecord::Migration[5.1]
  def change
  	#DZC 2018-10-18 17:25:08 reemplaza los nombres de las comunas por los nombres en comunas_arregladas
  	execute <<-SQL
  		UPDATE comunas
  		SET
				nombre = c2.nombre
			FROM (
					SELECT id, nombre
					FROM comunas_arregladas) c2
			WHERE
				c2.id = comunas.id;
		SQL
  end
end
