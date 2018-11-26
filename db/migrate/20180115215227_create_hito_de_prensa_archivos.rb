class CreateHitoDePrensaArchivos < ActiveRecord::Migration[5.1]
  def change
    create_table :hito_de_prensa_archivos do |t|
      t.integer :hitos_de_prensa_id, null: false
      t.string :archivo, null: false
      t.timestamps null: false
    end
    add_foreign_key :hito_de_prensa_archivos, :hitos_de_prensa, column: "hitos_de_prensa_id" #DZC 2018-10-16 17:42:09 se agrega columna para evitar error porque rails busca la columna en singular
  end
end
