class CreateTipoComentarios < ActiveRecord::Migration[5.1]
  def change
    create_table :tipo_comentarios do |t|
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
      INSERT INTO tipo_comentarios (nombre) VALUES
      ('Error del sistema'),
      ('Sugerencia del sistema');
    SQL
  end
end