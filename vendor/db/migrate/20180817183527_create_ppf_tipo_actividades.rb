class CreatePpfTipoActividades < ActiveRecord::Migration[5.1]
  def change
    create_table :ppf_tipo_actividades do |t|
    	t.string :nombre
    	t.string :descripcion
      t.timestamps
    end
    # populate the table
      PpfTipoActividad.create :nombre => "Convocatoria", :descripcion => "1"
      PpfTipoActividad.create :nombre => "Visita Diagnóstico", :descripcion => "1"
      PpfTipoActividad.create :nombre => "Visita Seguimiento", :descripcion => "1"
  end
end
