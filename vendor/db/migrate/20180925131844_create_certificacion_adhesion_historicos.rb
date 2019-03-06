class CreateCertificacionAdhesionHistoricos < ActiveRecord::Migration[5.1]
  def change
    create_table :certificacion_adhesion_historicos do |t|
    	t.belongs_to :adhesion_elemento, foreign_key: true
    	t.date :fecha_certificacion_1
    	t.date :vigencia_certificacion_1
    	t.string :rut_auditor_cert_1
    	t.string :nombre_archivo_respaldo_certificacion_1
    	t.date :fecha_certificacion_2
    	t.date :vigencia_certificacion_2
    	t.string :rut_auditor_cert_2
    	t.string :nombre_archivo_respaldo_certificacion_2
    	t.date :fecha_certificacion_3
    	t.date :vigencia_certificacion_3
    	t.string :rut_auditor_cert_3
    	t.string :nombre_archivo_respaldo_certificacion_3

      t.timestamps
    end
  end
end
