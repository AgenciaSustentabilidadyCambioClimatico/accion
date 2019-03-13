class CreateDocumentoDiagnosticos < ActiveRecord::Migration[5.1]
  def change
    create_table :documento_diagnosticos do |t|
      t.integer :manifestacion_de_interes_id, null: false
      t.integer :tipo_documento_diagnostico_id, null: false
      t.string :nombre, null: false
      t.string :archivo, null: false
      t.boolean :publico, null: false, default: false
      t.boolean :requiere_correcciones, null: false, default: false
    end
    add_foreign_key :documento_diagnosticos, :manifestacion_de_intereses
    add_foreign_key :documento_diagnosticos, :tipo_documento_diagnosticos
  end
end