class CambiosToInformeAcuerdos < ActiveRecord::Migration[5.1]
  def change
  	remove_column :informe_acuerdos, :con_validacion
  	add_column :informe_acuerdos, :nuevo, :boolean, null: true
  	InformeAcuerdo.update_all(nuevo: false)
  	change_column_null :informe_acuerdos, :nuevo, false
  end
end
