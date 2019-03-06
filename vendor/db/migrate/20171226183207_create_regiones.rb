class CreateRegiones < ActiveRecord::Migration[4.2]
  def up
    create_table :regiones do |t|
      t.string :nombre, limit: 42
    end
    execute <<-SQL
    	INSERT INTO regiones (id, nombre) VALUES
				(1,'Tarapacá'),
				(2,'Antofagasta'),
				(3,'Atacama'),
				(4,'Coquimbo'),
				(5,'Valparaíso'),
				(6,'Libertador General Bernardo O''Higgins'),
				(7,'Maule'),
				(8,'Biobío'),
				(9,'La Araucanía'),
				(10,'Los Lagos'),
				(11,'Aysén del General Carlos Ibáñez del Campo'),
				(12,'Magallanes y de la Antártica Chilena'),
				(13,'Metropolitana de Santiago'),
				(14,'Los Ríos'),
				(15,'Arica y Parinacota');

			SELECT SETVAL('regiones_id_seq', (SELECT MAX(id) FROM regiones));
			SQL
  end

  def down
    drop_table :regiones
  end
end