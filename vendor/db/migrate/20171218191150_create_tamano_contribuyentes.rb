class CreateTamanoContribuyentes < ActiveRecord::Migration[5.1]
  def change
    create_table :tamano_contribuyentes do |t|
      t.string :nombre
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
      INSERT INTO tamano_contribuyentes (nombre) VALUES
      ('Sin Información'),
      ('Micro'),
      ('Pequeña'),
      ('Mediana'),
      ('Gran');
    SQL
  end
end
