class AgregaCampoNecesitaEvidenciaToInformeAcuerdos < ActiveRecord::Migration[5.1]
  def change
  	add_column :informe_acuerdos, :necesita_evidencia, :boolean, null: true, default: false
  end
end
