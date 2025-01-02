class DropComentarioFlujos < ActiveRecord::Migration[5.1]
  def change
    drop_table :comentario_flujos
  end
end
