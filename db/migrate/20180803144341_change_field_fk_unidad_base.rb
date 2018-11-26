class ChangeFieldFkUnidadBase < ActiveRecord::Migration[5.1]
  def change
  	remove_column :materia_sustancias, :unidad_base_id
  	add_column :materia_sustancias, :unidad_base, :string
  end
end
