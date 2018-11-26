class AgregaCampoToInformeAcuerdos < ActiveRecord::Migration[5.1]
  def change
  	add_column :informe_acuerdos, :archivos_anexos_posteriores_firmas, :json, null: true, default: []
  end
end
