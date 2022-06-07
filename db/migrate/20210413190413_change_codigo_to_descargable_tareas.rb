class ChangeCodigoToDescargableTareas < ActiveRecord::Migration[5.1]
  def change
    change_column :descargable_tareas, :codigo, :string
  end
end
