class CambiarDecimalesCantidadPostulada < ActiveRecord::Migration[6.0]
  def up
    # Aumenta a 20 dígitos en total, de los cuales 10 son decimales
    change_column :rendicion_gastos_fpl, :cantidad_postulada, :decimal, precision: 20, scale: 10

    # NOTA: Te recomiendo cambiar también cantidad_rendida si necesitas guardar lo que el usuario digita
    change_column :rendicion_gastos_fpl, :cantidad_rendida, :decimal, precision: 20, scale: 10
  end

  def down
    change_column :rendicion_gastos_fpl, :cantidad_postulada, :decimal, precision: 10, scale: 2
    change_column :rendicion_gastos_fpl, :cantidad_rendida, :decimal, precision: 10, scale: 2
  end
end