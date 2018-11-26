class CreatePropuestaDeAcuerdos < ActiveRecord::Migration[5.1]
  def change
    create_table :propuesta_de_acuerdos do |t|
      t.integer :accion_id, null: false
      t.integer :materia_sustancia_id, null: false
      t.integer :meta_id, null: false
      t.integer :unidad_base_id, null: false
      t.integer :alcance_id, null: false
      t.string :valor_referencia, null: false
      t.integer :criterio_inclusion_exclusion, null: false
      t.text :descripcion_accion, null: false
      t.text :detalle_medio_verificacion, null: false
      t.integer :plazo_valor, null: false
      t.integer :plazo_unidad_tiempo, null: false
    end
    add_foreign_key :propuesta_de_acuerdos, :acciones
    add_foreign_key :propuesta_de_acuerdos, :materia_sustancias
    add_foreign_key :propuesta_de_acuerdos, :clasificaciones, column: :meta_id 
    add_foreign_key :propuesta_de_acuerdos, :unidad_bases
    add_foreign_key :propuesta_de_acuerdos, :alcances
  end
end