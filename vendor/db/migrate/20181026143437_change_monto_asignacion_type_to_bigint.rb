class ChangeMontoAsignacionTypeToBigint < ActiveRecord::Migration[5.1]
  def change
    change_column :centro_de_costos, :monto_asignacion, :bigint
  end
end
