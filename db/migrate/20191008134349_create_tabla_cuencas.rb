class CreateTablaCuencas < ActiveRecord::Migration[5.1]
  def change
    create_table :cuencas do |t|
      t.string :codigo_cuenca
      t.string :nombre_cuenca
      t.string :region
      t.timestamps
    end
  end
end
