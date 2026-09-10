class AddProgramaToFondoProduccionLimpias < ActiveRecord::Migration[6.0]
  def change
    add_column :fondo_produccion_limpia, :programa, :string
  end
end
