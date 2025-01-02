class AddCamposToFondoProduccionLimpia < ActiveRecord::Migration[5.1]
  def change
    add_column :fondo_produccion_limpia, :flujo_apl_id, :integer
    # change_column :fondo_produccion_limpia, :institucion_receptor_cof_fpl_id, :integer
    # change_column :fondo_produccion_limpia, :cantidad_micro_empresa, :integer
    # change_column :fondo_produccion_limpia, :cantidad_pequeña_empresa, :integer
    # change_column :fondo_produccion_limpia, :cantidad_mediana_empresa, :integer
    # change_column :fondo_produccion_limpia, :cantidad_grande_empresa, :integer
    # change_column :fondo_produccion_limpia, :empresas_asociadas_ag, :integer
    # change_column :fondo_produccion_limpia, :empresas_no_asociadas_ag, :integer
    # change_column :fondo_produccion_limpia, :duracion, :integer
    # change_column :fondo_produccion_limpia, :fortalezas_consultores, :string
    # change_column :fondo_produccion_limpia, :codigo_proyecto, :string
    # change_column :fondo_produccion_limpia, :revisor_tecnico_id, :integer
    # change_column :fondo_produccion_limpia, :revisor_financiero_id, :integer
    # change_column :fondo_produccion_limpia, :revisor_juridico_id, :integer
    # change_column :fondo_produccion_limpia, :comentario_asignar_revisor, :string
  end
end
