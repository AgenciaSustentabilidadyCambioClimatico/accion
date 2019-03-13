class CreateTipoDeMedios < ActiveRecord::Migration[5.1]
  def change
    create_table :tipo_de_medios do |t|
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
      INSERT INTO tipo_de_medios (nombre) VALUES
      ('Aviso Publicitario'),
      ('Diarios y Prensa escrita'),
      ('Medio Digítal / Web'),
      ('Medio Impreso Digítal'),
      ('Radio'),
      ('Revistas'),
      ('Sitios gubernamentales'),
      ('Televisión');
    SQL
  end
end