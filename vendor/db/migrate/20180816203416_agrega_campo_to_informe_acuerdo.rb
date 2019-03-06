class AgregaCampoToInformeAcuerdo < ActiveRecord::Migration[5.1]
  def change
  	add_column :informe_acuerdos, :con_extension, :boolean, null: true
  end
end
