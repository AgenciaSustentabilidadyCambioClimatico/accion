class AddElementosToFondoProduccionLimpia < ActiveRecord::Migration[5.1]
  def change
    add_column :fondo_produccion_limpia, :elementos_micro_empresa, :integer
    add_column :fondo_produccion_limpia, :elementos_pequena_empresa, :integer
    add_column :fondo_produccion_limpia, :elementos_mediana_empresa, :integer
    add_column :fondo_produccion_limpia, :elementos_grande_empresa, :integer
  end
end
