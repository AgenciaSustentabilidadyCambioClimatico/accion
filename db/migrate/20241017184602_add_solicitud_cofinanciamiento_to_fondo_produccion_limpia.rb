class AddSolicitudCofinanciamientoToFondoProduccionLimpia < ActiveRecord::Migration[5.1]
  def change
    add_column :fondo_produccion_limpia, :solicitud_cofinanciamiento, :string
  end
end
