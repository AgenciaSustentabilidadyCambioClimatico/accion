class CreateEncuestas < ActiveRecord::Migration[5.1]
  def change
    create_table :encuestas do |t|
      t.string :titulo, null: false
      t.integer :valor_tiempo_para_contestar, null: false
      t.integer :unidad_tiempo_para_contestar, null: false
      t.boolean :solo_dias_habiles, null: false, default: true
    end
  end
end
