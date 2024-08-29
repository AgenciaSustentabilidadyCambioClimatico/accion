class RenameFieldsInFondoProduccionLimpia < ActiveRecord::Migration[5.1]
  def change
    add_column :fondo_produccion_limpia, :institucion_entregables_id, :integer
    add_column :fondo_produccion_limpia, :usuario_entregables_id, :integer
  end
end
