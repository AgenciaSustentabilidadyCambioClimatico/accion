class CreateEstadoTareaPendientes < ActiveRecord::Migration[5.1]
  def change
    create_table :estado_tarea_pendientes do |t|
      t.string :nombre, null: false
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
      INSERT INTO estado_tarea_pendientes(nombre) VALUES
      ('No iniciada'),
      ('Enviada'),
      ('Devuelta con errores'),
      ('Re-enviada'),
      ('Aceptada'),
      ('Iniciada');
    SQL
  end
end