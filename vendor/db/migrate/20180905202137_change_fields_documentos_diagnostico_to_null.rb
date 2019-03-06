class ChangeFieldsDocumentosDiagnosticoToNull < ActiveRecord::Migration[5.1]
  def change
  	change_column_null :documento_diagnosticos, :tipo_documento_diagnostico_id, true
  end
end
