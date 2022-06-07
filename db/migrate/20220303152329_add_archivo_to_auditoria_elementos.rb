class AddArchivoToAuditoriaElementos < ActiveRecord::Migration[5.1]
  def change
    add_reference :auditoria_elementos, :archivo_informe, foreign_key: { to_table: :auditoria_elemento_archivos }
    add_reference :auditoria_elementos, :archivo_evidencia, foreign_key: { to_table: :auditoria_elemento_archivos }
  end
end
