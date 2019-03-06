class CreateActividadPorLineas < ActiveRecord::Migration[5.1]
  def change
    create_table :actividad_por_lineas do |t|
      t.integer :actividad_id, null: false
      t.integer :tipo_instrumento_id, null: false
      t.integer :tipo_permiso, null: false
    end
    add_foreign_key :actividad_por_lineas, :tipo_instrumentos
    add_foreign_key :actividad_por_lineas, :actividades
  end
  
  def migrate(direction)
    super
    if direction == :up
      query
    end
  end

  def query
    execute <<-SQL
      INSERT INTO "actividad_por_lineas" ("id", "actividad_id", "tipo_instrumento_id", "tipo_permiso") VALUES
        (1, 1,  11, 0),
        (2, 2,  12, 0),
        (3, 3,  12, 0),
        (4, 4,  12, 0),
        (5, 5,  12, 1),
        (6, 6,  12, 1),
        (7, 7,  12, 1),
        (8, 8,  12, 1),
        (9, 9,  12, 1),
        (10,  10, 12, 1),
        (11,  11, 12, 1),
        (13,  12, 12, 1),
        (14,  13, 12, 1),
        (15,  14, 13, 0),
        (16,  15, 13, 0),
        (17,  16, 13, 0),
        (18,  17, 13, 1),
        (19,  18, 13, 1),
        (20,  19, 13, 1),
        (21,  20, 13, 1),
        (22,  21, 14, 0),
        (23,  22, 15, 0),
        (24,  23, 16, 0),
        (25,  24, 16, 0),
        (26,  19, 16, 0),
        (27,  25, 16, 0),
        (28,  26, 17, 1),
        (29,  27, 17, 1),
        (30,  28, 17, 1),
        (31,  29, 17, 1),
        (32,  30, 17, 0),
        (33,  31, 17, 1),
        (34,  32, 17, 1),
        (35,  34, 17, 1),
        (36,  35, 24, 1),
        (37,  36, 24, 1),
        (38,  37, 24, 1),
        (39,  39, 22, 0),
        (40,  40, 22, 0),
        (41,  38, 22, 0),
        (44,  43, 22, 0),
        (45,  44, 22, 0),
        (42,  41, 22, 0),
        (43,  42, 22, 0),
        (46,  45, 21, 0),
        (47,  44, 21, 0),
        (48,  46, 23, 0),
        (49,  47, 23, 0),
        (50,  49, 23, 0),
        (51,  44, 23, 0);

      SELECT SETVAL('actividad_por_lineas_id_seq', (SELECT MAX(id) FROM actividad_por_lineas));
    SQL
  end
end