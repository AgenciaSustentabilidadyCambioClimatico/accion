class CreateDatoProductivoElementoAdheridos < ActiveRecord::Migration[5.1]
  def change
    create_table :dato_productivo_elemento_adheridos do |t|
    	t.belongs_to :propuesta_de_acuerdo, index:  {:name => "pro_acu_id"}
    	t.belongs_to :adhesion_elemento, index: {:name => "adhe_ele_id"}
    	t.belongs_to :dato_recolectado, index: {:name => "dat_rec_id"}
    	# t.string :nombre_archivo_evidencia
    	# t.date :fecha_levantamiento
    	# t.string :rut_levantador
    	# t.string :unidad_declarada
    	# t.string :mes
    	# t.string :año
    	# t.string :tipo_de_valor
    	# t.float :valor

      t.timestamps
    end
  end
end
