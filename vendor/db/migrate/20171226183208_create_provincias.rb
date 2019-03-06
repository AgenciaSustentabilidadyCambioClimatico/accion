class CreateProvincias < ActiveRecord::Migration[5.1]
  def up
    create_table :provincias do |t|
    	t.integer :region_id, null: false
      t.string :nombre, limit: 30, null: false
    end
    add_foreign_key :provincias, :regiones
    execute <<-SQL
      INSERT INTO provincias (id, region_id, nombre) VALUES
        (1, 15, 'Arica'),
        (2, 15, 'Parinacota'),
        (3, 1, 'Iquique'),
        (4, 1, 'Tamarugal'),
        (5, 2, 'Antofagasta'),
        (6, 2, 'El Loa'),
        (7, 2, 'Tocopilla'),
        (8, 3, 'Copiapó'),
        (9, 3, 'Chañaral'),
        (10, 3, 'Huasco'),
        (11, 4, 'Elqui'),
        (12, 4, 'Choapa'),
        (13, 4, 'Limarí'),
        (14, 5, 'Valparaíso'),
        (15, 5, 'Isla de Pascua'),
        (16, 5, 'Los Andes'),
        (17, 5, 'Petorca'),
        (18, 5, 'Quillota'),
        (19, 5, 'San Antonio'),
        (20, 5, 'San Felipe de Aconcagua'),
        (21, 5, 'Marga Marga'),
        (22, 6, 'Cachapoal'),
        (23, 6, 'Cardenal Caro'),
        (24, 6, 'Colchagua'),
        (25, 7, 'Talca'),
        (26, 7, 'Cauquenes'),
        (27, 7, 'Curicó'),
        (28, 7, 'Linares'),
        (29, 8, 'Concepción'),
        (30, 8, 'Arauco'),
        (31, 8, 'Biobío'),
        (32, 8, 'Ñuble'),
        (33, 9, 'Cautín'),
        (34, 9, 'Malleco'),
        (35, 14, 'Valdivia'),
        (36, 14, 'Ranco'),
        (37, 10, 'Llanquihue'),
        (38, 10, 'Chiloé'),
        (39, 10, 'Osorno'),
        (40, 10, 'Palena'),
        (41, 11, 'Coyhaique'),
        (42, 11, 'Aysén'),
        (43, 11, 'Capitán Prat'),
        (44, 11, 'General Carrera'),
        (45, 12, 'Magallanes'),
        (46, 12, 'Antártica Chilena'),
        (47, 12, 'Tierra del Fuego'),
        (48, 12, 'Última Esperanza'),
        (49, 13, 'Santiago'),
        (50, 13, 'Cordillera'),
        (51, 13, 'Chacabuco'),
        (52, 13, 'Maipo'),
        (53, 13, 'Melipilla'),
        (54, 13, 'Talagante');
		
      SELECT SETVAL('provincias_id_seq', (SELECT MAX(id) FROM provincias));
		SQL
  end

  def down
    drop_table :provincias
  end
end