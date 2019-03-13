class CreateMateriaSustancias < ActiveRecord::Migration[5.1]
  def change
    create_table :materia_sustancias do |t|
      t.integer :meta_id, null: false
      t.integer :unidad_base_id
      t.string :nombre, null: false
      t.text :descripcion, null: false
      t.boolean :posee_una_magnitud_fisica_asociada, null: false, default: false
    end
    add_foreign_key :materia_sustancias, :clasificaciones, column: :meta_id 
    add_foreign_key :materia_sustancias, :unidad_bases
  end
end