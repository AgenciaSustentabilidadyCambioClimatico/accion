class AddFieldsNewToFondoProduccionLimpia < ActiveRecord::Migration[5.1]
  def change
    add_column :fondo_produccion_limpia, :flujo_apl_id, :integer
    add_column :fondo_produccion_limpia, :institucion_receptor_cof_fpl_id, :integer
    add_column :fondo_produccion_limpia, :cantidad_micro_empresa, :integer
    add_column :fondo_produccion_limpia, :cantidad_pequeña_empresa, :integer
    add_column :fondo_produccion_limpia, :cantidad_mediana_empresa, :integer
    add_column :fondo_produccion_limpia, :cantidad_grande_empresa, :integer
    add_column :fondo_produccion_limpia, :empresas_asociadas_ag, :integer
    add_column :fondo_produccion_limpia, :empresas_no_asociadas_ag, :integer
    add_column :fondo_produccion_limpia, :duracion, :integer
    add_column :fondo_produccion_limpia, :fortalezas_consultores, :string
    add_column :fondo_produccion_limpia, :codigo_proyecto, :string
    add_column :fondo_produccion_limpia, :revisor_tecnico_id, :integer
    add_column :fondo_produccion_limpia, :revisor_financiero_id, :integer
    add_column :fondo_produccion_limpia, :revisor_juridico_id, :integer
    add_column :fondo_produccion_limpia, :comentario_asignar_revisor, :string
  end
end
