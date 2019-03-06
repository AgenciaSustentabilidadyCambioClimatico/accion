class CreateHitoDePrensaInstrumentos < ActiveRecord::Migration[5.1]
  def change
    create_table :hito_de_prensa_instrumentos do |t|
      t.integer :hitos_de_prensa_id
      t.integer :instrumento_id
    end
    add_foreign_key :hito_de_prensa_instrumentos, :hitos_de_prensa
    add_index :hito_de_prensa_instrumentos, :instrumento_id
  end
end
