class CreateDatoLevantadoMensuals < ActiveRecord::Migration[5.1]
  def change
    create_table :dato_levantado_mensuals do |t|
    	t.belongs_to :dato_productivo_elemento_adherido, index:  {:name => "dpea_dlm_id"}
    	t.string :nombre_archivo_evidencia
    	t.date :fecha_levantamiento
    	t.string :rut_levantador
    	t.string :unidad_declarada
    	t.string :mes
    	t.string :año
    	t.string :tipo_de_valor
    	t.float :valor

      t.timestamps
    end
  end
end
