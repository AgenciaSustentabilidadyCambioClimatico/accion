class AddSeguimientoFieldsToProgramaProyectoPropuestas < ActiveRecord::Migration[5.1]
  def change
  	add_column :programa_proyecto_propuestas, :proyecto_adjudicado, :boolean
  	add_column :programa_proyecto_propuestas, :motivos_adjudicacion, :text
  	add_column :programa_proyecto_propuestas, :fecha_adjudicacion, :date
  	add_column :programa_proyecto_propuestas, :monto_adjudicado, :integer
    add_column :programa_proyecto_propuestas, :documento_proyecto, :text
    add_column :programa_proyecto_propuestas, :fecha_inicio, :date
  	add_column :programa_proyecto_propuestas, :enlace_proyecto, :text
  	add_column :programa_proyecto_propuestas, :participacion_agencia, :text
    add_column :programa_proyecto_propuestas, :instrumento_asociados_id, :text
    add_column :programa_proyecto_propuestas, :productos_y_resultados, :text
    add_column :programa_proyecto_propuestas, :documento_resultados, :text
    add_column :programa_proyecto_propuestas, :fecha_finalizacion, :date
    add_column :programa_proyecto_propuestas, :finalizado, :boolean
  end
end