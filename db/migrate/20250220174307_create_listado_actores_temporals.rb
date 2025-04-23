class CreateListadoActoresTemporals < ActiveRecord::Migration[6.0]
  def change
    create_table :listado_actores_temporals do |t|
      t.integer :actor_id
      t.integer :rol_en_acuerdo_id
      t.integer :cargo_institucion_id
      t.integer :contribuyente_id
      t.integer :tipo_institucion_id
      t.string :rol_en_acuerdo
      t.string :nombre_actor
      t.string :rut_actor
      t.string :cargo_institucion
      t.string :email_institucional
      t.string :telefono_institucional
      t.string :razon_social_institucion
      t.string :rut_institucion
      t.string :tipo_institucion
      t.string :comuna_institucion
      t.integer :estado
      t.references :manifestacion_de_interes, null: false, foreign_key: true

      t.timestamps
    end
  end
end
