class RemoveMetaFromMateriaSustancias < ActiveRecord::Migration[5.1]
  def change
    remove_foreign_key :materia_sustancias, column: :meta_id
    remove_column :materia_sustancias, :meta_id
  end
end
