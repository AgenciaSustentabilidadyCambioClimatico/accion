class AddDuracionToTarea < ActiveRecord::Migration[5.1]
  def change
    add_column :tareas, :duracion, :integer
  end
end
