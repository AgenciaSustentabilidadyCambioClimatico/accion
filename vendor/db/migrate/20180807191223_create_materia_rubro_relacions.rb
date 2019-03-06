class CreateMateriaRubroRelacions < ActiveRecord::Migration[5.1]
  def change
    create_table :materia_rubro_relacions do |t|
    	t.references :materia_sustancia, index: true, foreign_key: true
    	t.references :actividad_economica, index: true, foreign_key: true
      t.timestamps
    end
  end
end
