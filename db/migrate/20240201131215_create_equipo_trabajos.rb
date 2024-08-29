class CreateEquipoTrabajos < ActiveRecord::Migration[5.1]
  def change
    create_table :equipo_trabajos do |t|
      t.string :profesion
      t.string :funciones_proyecto
      t.integer :valor_hh
      t.string :copia_ci
      t.string :curriculum
      t.integer :tipo_equipo
      t.references :user, foreign_key: true
      t.references :flujo, foreign_key: true
      t.references :contribuyente, foreign_key: true

      t.timestamps
    end
  end
end
