class PoblaIdAntiguoToComunasAlternativas < ActiveRecord::Migration[5.1]
  def up
  	# DZC 2018-11-07 15:25:10 obtiene los ids de las comunas que existen en la tabla original de comunas
  	# DZC 2018-11-07 15:27:31 obtiene los id de los registros con inconsistencias en el nombre
  	execute <<-SQL
  		UPDATE comunas_alternativas
  		SET
				id_antiguo = c2.id
			FROM (
					SELECT id, nombre
					FROM comunas) c2
			WHERE
				c2.nombre = comunas_alternativas.nombre;
		SQL
		
		execute <<-SQL
  		UPDATE comunas_alternativas
  		SET
				id_antiguo = c2.id
			FROM (
					SELECT id, nombre
					FROM comunas) c2
			WHERE
				c2.nombre = 'Tiltil' AND comunas_alternativas.nombre = 'Til Til';
		SQL
		
		execute <<-SQL
  		UPDATE comunas_alternativas
  		SET
				id_antiguo = c2.id
			FROM (
					SELECT id, nombre
					FROM comunas) c2
			WHERE
				c2.nombre = 'Coihaique' AND comunas_alternativas.nombre = 'Coyhaique';
		SQL
		
		execute <<-SQL
  		UPDATE comunas_alternativas
  		SET
				id_antiguo = c2.id
			FROM (
					SELECT id, nombre
					FROM comunas) c2
			WHERE
				c2.nombre = 'Cabo de Hornos (Ex-Navarino)' AND comunas_alternativas.nombre = 'Cabo de Hornos';
		SQL
		
		execute <<-SQL
  		UPDATE comunas_alternativas
  		SET
				id_antiguo = c2.id
			FROM (
					SELECT id, nombre
					FROM comunas) c2
			WHERE
				c2.nombre = 'Calera' AND comunas_alternativas.nombre = 'La Calera';
		SQL
		
		execute <<-SQL
  		UPDATE comunas_alternativas
  		SET
				id_antiguo = c2.id
			FROM (
					SELECT id, nombre
					FROM comunas) c2
			WHERE
				c2.nombre = 'Pedro  Aguirre Cerda' AND comunas_alternativas.nombre = 'Pedro Aguirre Cerda';
		SQL
		
		execute <<-SQL
  		UPDATE comunas_alternativas
  		SET
				id_antiguo = c2.id
			FROM (
					SELECT id, nombre
					FROM comunas) c2
			WHERE
				c2.nombre = 'Los Alamos' AND comunas_alternativas.nombre = 'Los Álamos';
		SQL
		
		execute <<-SQL
  		UPDATE comunas_alternativas
  		SET
				id_antiguo = c2.id
			FROM (
					SELECT id, nombre
					FROM comunas) c2
			WHERE
				c2.nombre = 'H ualpén' AND comunas_alternativas.nombre = 'Hualpén';
		SQL
		
		execute <<-SQL
  		UPDATE comunas_alternativas
  		SET
				id_antiguo = c2.id
			FROM (
					SELECT id, nombre
					FROM comunas) c2
			WHERE
				c2.nombre = 'San Pedro de la Paz' AND comunas_alternativas.nombre = 'San Pedro de La Paz';
		SQL
		
		execute <<-SQL
  		UPDATE comunas_alternativas
  		SET
				id_antiguo = c2.id
			FROM (
					SELECT id, nombre
					FROM comunas) c2
			WHERE
				c2.nombre = 'Los Angeles' AND comunas_alternativas.nombre = 'Los Ángeles';
		SQL
		
		execute <<-SQL
  		UPDATE comunas_alternativas
  		SET
				id_antiguo = c2.id
			FROM (
					SELECT id, nombre
					FROM comunas) c2
			WHERE
				c2.nombre = 'Paiguano' AND comunas_alternativas.nombre = 'Paihuano';
		SQL

  end

  def down
  	# DZC 2018-11-07 15:59:17 No hace nada para poder ejecutar futuras sentencias SQL sin afectar al resto
  end
end
