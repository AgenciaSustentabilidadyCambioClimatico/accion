class CambiosToAuditoriaElementos < ActiveRecord::Migration[5.1]
  def change
  	rename_column :auditoria_elementos, :propuesta_de_acuerdo_id, :set_metas_accion_id
  	add_column :auditoria_elementos, :validacion_aceptada, :boolean, null: true
  	add_column :auditoria_elementos, :validacion_fecha, :timestamp, null: true
  	add_column :auditoria_elementos, :aprobacion_fecha, :timestamp, null: true
  	rename_column :auditoria_elementos, :aceptado, :auditoria_aprobada
  end
end
