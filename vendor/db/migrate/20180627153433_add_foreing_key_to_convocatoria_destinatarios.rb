class AddForeingKeyToConvocatoriaDestinatarios < ActiveRecord::Migration[5.1]
  def change
  		add_foreign_key :convocatoria_destinatarios, :personas, column: :destinatario_id #, primary_key: :id # se refiere al nombre del campo de llave primaria en la tabla "to_table"
  end
end
