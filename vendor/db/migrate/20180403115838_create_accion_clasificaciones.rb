class CreateAccionClasificaciones < ActiveRecord::Migration[5.1]
  def change
    create_table :accion_clasificaciones do |t|
      t.integer :accion_id, null: false
      t.integer :clasificacion_id, null: false
    end
    add_foreign_key :accion_clasificaciones, :acciones
    add_foreign_key :accion_clasificaciones, :clasificaciones
  end
end