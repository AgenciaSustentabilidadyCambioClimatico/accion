class CreateDatoAnualContribuyentes < ActiveRecord::Migration[5.1]
  def change
    create_table :dato_anual_contribuyentes do |t|
      t.integer :contribuyente_id
      t.integer :tipo_contribuyente_id
      t.integer :rango_venta_contribuyente_id
      t.integer :periodo, limit: 4
      t.integer :numero_trabajadores
      t.integer :f22c_645, limit: 5
      t.integer :f22c_646, limit: 5
    end
    add_foreign_key :dato_anual_contribuyentes, :contribuyentes
    add_foreign_key :dato_anual_contribuyentes, :tipo_contribuyentes
    add_foreign_key :dato_anual_contribuyentes, :rango_venta_contribuyentes
  end
end