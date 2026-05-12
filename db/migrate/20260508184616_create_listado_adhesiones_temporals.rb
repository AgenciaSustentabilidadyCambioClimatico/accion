class CreateListadoAdhesionesTemporals < ActiveRecord::Migration[6.0]
  def change
    create_table :listado_adhesiones_temporals do |t|
      t.string :fecha_adhesion
      t.string :rut_institucion
      t.string :nombre_institucion
      t.string :sector_productivo
      t.string :tipo_institucion
      t.string :tamano_empresa
      t.string :direccion_casa_matriz
      t.string :comuna_casa_matriz
      t.string :rut_encargado
      t.string :nombre_encargado
      t.string :cargo_encargado
      t.string :fono_encargado
      t.string :email_encargado
      t.string :alcance
      t.string :nombre_instalacion
      t.string :direccion_instalacion
      t.string :comuna_instalacion
      t.string :tipo_elemento
      t.string :identificador
      t.string :patente
      t.string :nombre_elemento
      t.string :nombre_archivo
      t.integer :flujo_id

      t.timestamps
    end
    add_index :listado_adhesiones_temporals, :flujo_id
  end
end
