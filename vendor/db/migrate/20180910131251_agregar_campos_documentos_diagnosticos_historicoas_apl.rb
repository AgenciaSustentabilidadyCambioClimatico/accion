class AgregarCamposDocumentosDiagnosticosHistoricoasApl < ActiveRecord::Migration[5.1]
  def change
  	add_column :documento_diagnosticos, :fecha_documento, :date, null: true
  end
end
