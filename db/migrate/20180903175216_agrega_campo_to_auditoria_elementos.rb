class AgregaCampoToAuditoriaElementos < ActiveRecord::Migration[5.1]
  def change
		add_column :auditoria_elementos, :validacion_observaciones, :text, null: true
		add_timestamps :auditoria_elementos, null: true

	  # rellena los registros preexistentes
	  ahora = DateTime.now
	  AuditoriaElemento.update_all(created_at: ahora, updated_at: ahora)

	  # devuelve la condición not null
	  change_column_null :auditoria_elementos, :created_at, false
	  change_column_null :auditoria_elementos, :updated_at, false		
  end
end
