class CreateEquipoEmpresas < ActiveRecord::Migration[5.1]
  def change
    create_table :equipo_empresas do |t|
      t.integer :id_empresa
      t.references :flujo, foreign_key: true
      t.references :contribuyente, foreign_key: true

      t.timestamps
    end
  end
end
