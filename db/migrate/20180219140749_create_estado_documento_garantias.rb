class CreateEstadoDocumentoGarantias < ActiveRecord::Migration[5.1]
  def change
    create_table :estado_documento_garantias do |t|
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
      INSERT INTO "estado_documento_garantias" ("id", "nombre") VALUES
        (1, 'Vencido'),
        (2, 'Devuelto'),
        (3, 'Cobrado');
      SELECT SETVAL('estado_documento_garantias_id_seq', (SELECT MAX(id) FROM estado_documento_garantias));
    SQL
  end
end