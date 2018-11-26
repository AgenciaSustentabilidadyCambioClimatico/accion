class CambiaInstrumentoRelacionaPpp < ActiveRecord::Migration[5.1]
  def change
  	remove_column :programa_proyecto_propuestas, :instrumentos_relacionados_id
  	add_reference :programa_proyecto_propuestas, :instrumento_relacionado, polymorphic: true, index: {:name => "instrumentos_relacionados"}
  end
end
