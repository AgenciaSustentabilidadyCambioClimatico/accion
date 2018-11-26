class CreateDatoRecolectados < ActiveRecord::Migration[5.1]
  def change
    create_table :dato_recolectados do |t|
    	t.string :nombre
    	t.text :descripcion
    	t.string :cpc
    	t.string :medios_verificacion
    	t.string :unidad_base
    	t.string :unidades_compatibles
      t.timestamps
    end
  end
end
