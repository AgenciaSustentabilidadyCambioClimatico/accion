class PoblaRegiones < ActiveRecord::Migration[5.1]
  def up
  	# DZC 2018-11-07 19:04:12 elimina los registro
  	Region.destroy_all

  	# DZC 2018-11-07 19:04:23 vuelve a poblar la tabla
  	execute <<-SQL
   		INSERT INTO regiones (id, nombre, pais_id) VALUES

				(1, 'Tarapacá', 29),
				(2, 'Antofagasta', 29),
				(3, 'Atacama', 29),
				(4, 'Coquimbo', 29),
				(5, 'Valparaíso', 29),
				(6, 'Libertador General Bernardo O''Higgins', 29),
				(7, 'Maule', 29),
				(8, 'Biobío', 29),
				(9, 'La Araucanía', 29),
				(10, 'Los Lagos', 29),
				(11, 'Aisén del General Carlos Ibáñez del Campo', 29),
				(12, 'Magallanes y Antártica Chilena', 29),
				(13, 'Metropolitana de Santiago', 29),
				(14, 'Los Ríos', 29),																								
				(15, 'Arica y Parinacota', 29),
				(16, 'Ñuble', 29);
			SQL

  end

  def down
  end
end
