class CreatePpfActividades < ActiveRecord::Migration[5.1]
  def change
    create_table :ppf_actividades do |t|
    	t.belongs_to :contribuyente
    	t.belongs_to :comuna
    	t.belongs_to :programa_proyecto_propuesta
    	t.belongs_to :ppf_tipo_actividad
    	t.string :direccion
    	t.boolean :estado_tecnica_id, default: false
    	t.text :observaciones

      t.timestamps
    end
  end
end
