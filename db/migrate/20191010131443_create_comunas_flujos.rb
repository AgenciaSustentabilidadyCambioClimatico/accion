class CreateComunasFlujos < ActiveRecord::Migration[5.1]
  def change
    create_table :comunas_flujos do |t|
      t.references :comuna, foreign_key: true
      t.references :flujo, foreign_key: true
      t.timestamps
    end
  end
end
