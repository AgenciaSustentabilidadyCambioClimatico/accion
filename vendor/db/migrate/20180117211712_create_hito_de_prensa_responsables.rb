class CreateHitoDePrensaResponsables < ActiveRecord::Migration[5.1]
  def change
    create_table :hito_de_prensa_responsables do |t|
      t.integer :hitos_de_prensa_id
      t.integer :user_id
    end
    add_foreign_key :hito_de_prensa_responsables, :hitos_de_prensa
    add_foreign_key :hito_de_prensa_responsables, :users
  end
end
