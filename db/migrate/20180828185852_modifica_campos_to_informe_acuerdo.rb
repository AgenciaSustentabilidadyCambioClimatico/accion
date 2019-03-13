class ModificaCamposToInformeAcuerdo < ActiveRecord::Migration[5.1]
  def change
  	remove_column :informe_acuerdos, :plazo_maximo_neto
  	remove_column :informe_acuerdos, :plazo_maximo
  	add_column :informe_acuerdos, :plazo_maximo_neto, :integer , null: true
  	add_column :informe_acuerdos, :plazo_maximo, :integer, null: true
  end
end
