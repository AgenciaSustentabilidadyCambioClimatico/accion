class AddFieldToEncuestaUserRespuesta < ActiveRecord::Migration[5.1]
  def change
  	add_column :encuesta_user_respuestas, :flujo_id, :integer, null: true
  	EncuestaUserRespuesta.update_all(flujo_id: 20000)
  	change_column_null :encuesta_user_respuestas, :flujo_id, false
  	add_column :encuesta_user_respuestas, :institucion_proveedor_id, :integer, null: true
  end
end
