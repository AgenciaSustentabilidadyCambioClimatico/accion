class CreateCuencasFlujos < ActiveRecord::Migration[5.1]
  def change
    create_table :cuencas_flujos do |t|
      t.references :flujo, foreign_key: true
      t.references :cuenca, foreign_key: true
      t.timestamps
    end
  end
end
