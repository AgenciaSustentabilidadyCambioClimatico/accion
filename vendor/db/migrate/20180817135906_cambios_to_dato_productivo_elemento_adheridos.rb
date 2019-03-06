class CambiosToDatoProductivoElementoAdheridos < ActiveRecord::Migration[5.1]
  def change
  	remove_index :dato_productivo_elemento_adheridos, :propuesta_de_acuerdo_id 
  	rename_column :dato_productivo_elemento_adheridos, :propuesta_de_acuerdo_id, :set_metas_accion_id
  	add_foreign_key :dato_productivo_elemento_adheridos, :set_metas_acciones, column: :set_metas_accion_id
  	add_index :dato_productivo_elemento_adheridos, :set_metas_accion_id
  end
end
