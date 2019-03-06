class CreateRangoVentaContribuyentes < ActiveRecord::Migration[5.1]
  def change
    create_table :rango_venta_contribuyentes do |t|
      t.integer :tamano_contribuyente_id
      t.string :rango
      t.string :venta_anual_en_uf
    end
    add_foreign_key :rango_venta_contribuyentes, :tamano_contribuyentes
  end

  def migrate(direction)
    super
    if direction == :up
      query
    end
  end

  def query
    execute <<-SQL
      INSERT INTO rango_venta_contribuyentes (tamano_contribuyente_id, rango, venta_anual_en_uf) VALUES
      (1, NULL, 'Corresponde a contribuyentes cuya información tributaria declarada, no permite determinar un monto estimado de ventas'),
      (2, '1er', '0,01 a 200,00'),
      (2, '2do', '200,00 a 600,00'),
      (2, '3ro', '600,00 a 2.400,00'),
      (3, '1er', '2.400,00 a 5.000,00'),
      (3, '2do', '5.000,00 a 10.000,00'),
      (3, '3er', '10.000,00 a 25.000,00'),
      (4, '1er', '25.000,00 a 50.000,00'),
      (4, '2do', '50.000,00 a 100.000,00'),
      (5, '1er', '100.000,00 a 200.000,00'),
      (5, '2do', '200.000,00 a 600.000,00'),
      (5, '3er', '600.000,00 a 1.000.000,00'),
      (5, '4to', 'más de 1.000.000,00');
    SQL
  end
end