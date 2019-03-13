class CreatePropuestaDeAcuerdos < ActiveRecord::Migration[5.1]
  def change
    create_table :propuesta_de_acuerdos do |t|
      t.integer :accion_id
      t.integer :materia_sustancia_id, null: false
      t.integer :meta_id
      t.integer :unidad_base_id, null: false
      t.integer :alcance_id
      t.string :valor_referencia
      t.integer :criterio_inclusion_exclusion
      t.text :descripcion_accion
      t.text :detalle_medio_verificacion
      t.integer :plazo_valor
      t.integer :plazo_unidad_tiempo
    end
    add_foreign_key :propuesta_de_acuerdos, :acciones
    add_foreign_key :propuesta_de_acuerdos, :materia_sustancias
    add_foreign_key :propuesta_de_acuerdos, :clasificaciones, column: :meta_id 
    add_foreign_key :propuesta_de_acuerdos, :unidad_bases
    add_foreign_key :propuesta_de_acuerdos, :alcances
  end
end