class ModificaNuevoEnInformeAcuerdo < ActiveRecord::Migration[5.1]
  def up
  	# DZC 2019-05-08 14:16:36 se agrega para precaver rollback al crear nuevo registro solucionando requerimiento de fecha 2019-04-29
  	# change_column_null :informe_acuerdos, :nuevo, false, true
  	change_column :informe_acuerdos, :nuevo, :boolean, default: true, null: false
  end
  def down
  	change_column :informe_acuerdos, :nuevo, :boolean, null: false
  end
end
