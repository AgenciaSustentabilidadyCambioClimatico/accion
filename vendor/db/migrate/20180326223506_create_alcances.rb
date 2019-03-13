class CreateAlcances < ActiveRecord::Migration[5.1]
  def change
    create_table :alcances do |t|
      t.string :nombre, null: false
      t.text :descripcion, null: false
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
      INSERT INTO "alcances" ("id", "nombre", "descripcion") VALUES
        (1, 'Organización', 'La acción se realiza a nivel de organización y no es atribuible a un elemento individual de esta. Por ejemplo: Huella de Carbono Corporativa.'),
        (2, 'Establecimiento',  'La acción se realiza a nivel de establecimiento y es atribuible a los procesos productivos o de gestión realizado en el mismo. Por ejemplo: RILES de una instalación'),
        (3, 'Maquinaria', 'La acción se realiza a nivel de equipo, vehículo o maquinaria individual.'),
        (4, 'Producto', 'La acción esta referida al diseño o a los procesos productivos asociados a un producto o servicio y es atribuible o prorrateable entre las unidades producidas o entregadas del mismo.');
      
      SELECT SETVAL('alcances_id_seq', (SELECT MAX(id) FROM alcances));
    SQL
  end
end