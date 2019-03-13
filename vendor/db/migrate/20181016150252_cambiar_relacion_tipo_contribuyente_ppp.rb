class CambiarRelacionTipoContribuyentePpp < ActiveRecord::Migration[5.1]
  def change
  	remove_column :programa_proyecto_propuestas, :tipo_contribuyente_institucion_que_solicita_apoyo_id
  	add_column :programa_proyecto_propuestas, :tipo_contribuyente_institucion_que_solicita_apoyo, :string, null: true
  end
end
