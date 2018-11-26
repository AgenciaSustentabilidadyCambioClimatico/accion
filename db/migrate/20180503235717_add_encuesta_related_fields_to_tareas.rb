class AddEncuestaRelatedFieldsToTareas < ActiveRecord::Migration[5.1]
  def change
  	add_foreign_key :tareas, :encuestas
  end
end