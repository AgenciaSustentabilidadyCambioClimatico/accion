class CreateCampos < ActiveRecord::Migration[5.1]
  def change
    create_table :campos do |t|
    	t.string :clase
    	t.string :atributo
    	t.string :tipo
    	t.string :nombre
    	t.boolean :obligatorio
    	t.boolean :validacion_activa
    	t.string :validacion_vacio_mensaje
    	t.bigint :validacion_min
    	t.bigint :validacion_max
      t.timestamps
    end
  end
end
