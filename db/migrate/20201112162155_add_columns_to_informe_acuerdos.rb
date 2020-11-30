class AddColumnsToInformeAcuerdos < ActiveRecord::Migration[5.1]
  def change
    add_column :informe_acuerdos, :vigencia_acuerdo, :text
    add_column :informe_acuerdos, :plazo_vigencia_acuerdo, :integer
    add_column :informe_acuerdos, :vigencia_certificacion, :text
    add_column :informe_acuerdos, :vigencia_certificacion_final, :integer
  end
end
