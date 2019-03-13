class CambioFlujoCampoContribuyente < ActiveRecord::Migration[5.1]
  def change
  	change_column_null :flujos, :contribuyente_id, true
  end
end
