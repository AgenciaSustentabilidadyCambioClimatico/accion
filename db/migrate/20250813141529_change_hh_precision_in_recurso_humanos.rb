class ChangeHhPrecisionInRecursoHumanos < ActiveRecord::Migration[6.0]
  def change
    change_column :recurso_humanos, :hh, :decimal, precision: 5, scale: 2
  end
end
