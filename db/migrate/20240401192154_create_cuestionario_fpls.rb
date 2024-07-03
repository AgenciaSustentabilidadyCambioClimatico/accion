class CreateCuestionarioFpls < ActiveRecord::Migration[5.1]
  def change
    create_table :cuestionario_fpls do |t|
      t.references :flujo, foreign_key: true
      t.integer :criterio_id
      t.integer :nota
      t.string :justificacion
      t.integer :tipo_cuestionario_id

      t.timestamps
    end
  end
end
