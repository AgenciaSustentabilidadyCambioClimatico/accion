class UpdateFieldsAdhesiones < ActiveRecord::Migration[5.1]
  def change
    remove_column :adhesiones, :persona_id
    remove_column :adhesiones, :aceptado
    remove_column :adhesiones, :observaciones
    add_reference :adhesiones, :manifestacion_de_interes
  end
end
