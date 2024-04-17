class RenameFieldsInFondoProduccionLimpia < ActiveRecord::Migration[5.1]
  def change
    rename_column :fondo_produccion_limpia, :institucion_postulante_fpl_id, :institucion_entregables_id
    rename_column :fondo_produccion_limpia, :persona_postulante_fpl_id, :usuario_entregables_id
  end
end
