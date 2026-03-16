class AddCheckDocumentosJuridicosFromFondoProduccionLimpia < ActiveRecord::Migration[6.0]
  def change
    add_column :fondo_produccion_limpia, :check_documentos_juridicos, :boolean, default: false
  end
end


