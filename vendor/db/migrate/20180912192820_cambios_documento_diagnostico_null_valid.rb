class CambiosDocumentoDiagnosticoNullValid < ActiveRecord::Migration[5.1]
  def change
  	change_column_null :documento_diagnosticos, :nombre, true
  	change_column_null :documento_diagnosticos, :archivo, true
  end
end
