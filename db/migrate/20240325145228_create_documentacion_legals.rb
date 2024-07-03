class CreateDocumentacionLegals < ActiveRecord::Migration[5.1]
  def change
    create_table :documentacion_legals do |t|
      t.integer :estado
      t.references :descargable_tareas
      t.references :tipo_contribuyentes

      t.timestamps
    end
  end
end
