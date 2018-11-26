class CreateMateriaRubroDatoRelacions < ActiveRecord::Migration[5.1]
  def change
    create_table :materia_rubro_dato_relacions do |t|
      t.integer :materia_rubro_relacion_id
      t.integer :dato_recolectado_id
      t.timestamps
    end
    add_foreign_key :materia_rubro_dato_relacions, :materia_rubro_relacions
  end
end
