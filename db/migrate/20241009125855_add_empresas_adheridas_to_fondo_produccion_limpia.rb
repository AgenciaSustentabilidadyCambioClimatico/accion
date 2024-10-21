class AddEmpresasAdheridasToFondoProduccionLimpia < ActiveRecord::Migration[5.1]
  def change
    add_column :fondo_produccion_limpia, :empresas_adheridas, :string
  end
end
