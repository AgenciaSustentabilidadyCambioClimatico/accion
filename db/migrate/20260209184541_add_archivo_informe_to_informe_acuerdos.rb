class AddArchivoInformeToInformeAcuerdos < ActiveRecord::Migration[6.0]
  def change
    add_column :informe_acuerdos, :archivo_informe, :string
  end
end
