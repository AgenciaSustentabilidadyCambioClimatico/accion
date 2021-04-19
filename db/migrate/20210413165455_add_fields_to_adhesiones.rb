class AddFieldsToAdhesiones < ActiveRecord::Migration[5.1]
  def change
    add_column :adhesiones, :rut_institucion_adherente, :string
    add_column :adhesiones, :nombre_institucion_adherente, :text
    add_column :adhesiones, :matriz_direccion, :text
    add_reference :adhesiones, :matriz_region, foreign_key: { to_table: :regiones }
    add_reference :adhesiones, :matriz_comuna, foreign_key: { to_table: :comunas }
    add_reference :adhesiones, :tipo_contribuyente, foreign_key: true

    add_column :adhesiones, :rut_representante_legal, :string
    add_column :adhesiones, :nombre_representante_legal, :text
    add_column :adhesiones, :fono_representante_legal, :integer
    add_column :adhesiones, :email_representante_legal, :text

    add_column :adhesiones, :externa, :boolean, default: false
  end
end
