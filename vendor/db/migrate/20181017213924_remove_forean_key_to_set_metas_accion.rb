class RemoveForeanKeyToSetMetasAccion < ActiveRecord::Migration[5.1]
  def change
  	remove_foreign_key "set_metas_acciones", "manifestacion_de_intereses"
  end
end
