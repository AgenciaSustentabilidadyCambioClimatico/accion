class CreateActividadItems < ActiveRecord::Migration[5.1]
  def change
    create_table :actividad_items do |t|
      t.string :nombre
      t.integer :proyecto_actividad_id
      t.integer :glosa_id
      t.integer :tipo_aporte_id
      t.integer :monto
      t.json :archivos_tecnica
      t.json :archivos_respaldo
      t.integer :estado_tecnica_id, default: 1
      t.integer :estado_respaldo_id, default: 1
      t.string :observacion_tecnica
      t.string :observacion_respaldo
      t.datetime :fecha_ultima_rendicion
    end
  end
end