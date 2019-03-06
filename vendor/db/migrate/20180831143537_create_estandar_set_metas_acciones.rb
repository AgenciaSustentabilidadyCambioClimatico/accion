class CreateEstandarSetMetasAcciones < ActiveRecord::Migration[5.1]
  def change
    create_table :estandar_set_metas_acciones do |t|
      t.belongs_to :estandar_homologacion, foreign_key: true, index: true
    	t.belongs_to :accion, foreign_key: true, index: true
    	t.belongs_to :materia_sustancia, foreign_key: true, index: true
    	t.integer :meta_id
    	t.belongs_to :alcance, foreign_key: true, index: true
    	t.string :criterio_inclusion_exclusion
    	t.string :descripcion_accion
    	t.string :detalle_medio_verificacion

      t.timestamps
    end
    add_foreign_key :estandar_set_metas_acciones, :clasificaciones, column: :meta_id
  end
end
