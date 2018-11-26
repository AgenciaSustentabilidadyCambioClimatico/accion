class CreateTipoDocumentoDiagnosticos < ActiveRecord::Migration[5.1]
  def change
    create_table :tipo_documento_diagnosticos do |t|
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
      INSERT INTO tipo_documento_diagnosticos (nombre,descripcion) VALUES
        ('Diagnóstico sectorial', 'Falta descripción'),
        ('Análisis socio ambiental',  'Falta descripción'),
        ('Diagnóstico compartido',  'Falta descripción'),
        ('Plan de participación',  'Falta descripción');
    SQL
  end
end