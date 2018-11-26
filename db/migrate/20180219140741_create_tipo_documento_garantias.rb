class CreateTipoDocumentoGarantias < ActiveRecord::Migration[5.1]
  def change
    create_table :tipo_documento_garantias do |t|
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
      INSERT INTO "tipo_documento_garantias" ("id", "nombre") VALUES
        (1, 'Boleta garantía'),
        (2, 'Póliza seguro'),
        (3, 'Vale vista'),
        (4, 'Endoso');
      
      SELECT SETVAL('tipo_documento_garantias_id_seq', (SELECT MAX(id) FROM tipo_documento_garantias));
    SQL
  end
end
