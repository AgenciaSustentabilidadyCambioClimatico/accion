class AddCopiaCedulaRepresentantesLegalesEjecutorFondoProduccionLimpia < ActiveRecord::Migration[6.0]
  def change
    add_column :fondo_produccion_limpia, :copia_cedula_representantes_legales_ejecutor, :string
  end
end
