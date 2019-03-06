class AgregarProgramaProyectoPropuestaRepresentanteId < ActiveRecord::Migration[5.1]
  def change
  	add_column :programa_proyecto_propuestas, :representante_institucion_para_solicitud_id, :integer, null: true
  end
end
