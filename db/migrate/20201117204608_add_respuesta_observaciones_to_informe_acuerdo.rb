class AddRespuestaObservacionesToInformeAcuerdo < ActiveRecord::Migration[5.1]
  def change
    add_column :informe_acuerdos, :respuesta_observaciones, :text
  end
end
