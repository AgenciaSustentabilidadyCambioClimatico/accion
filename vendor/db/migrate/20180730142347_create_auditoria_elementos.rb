class CreateAuditoriaElementos < ActiveRecord::Migration[5.1]
  def change
    create_table :auditoria_elementos do |t|
      t.references :auditoria, index: true, foreign_key: true
      t.references :adhesion_elemento, index: true, foreign_key: true
      t.references :propuesta_de_acuerdo, index: true, foreign_key: true
      t.boolean :aplica, default: true
      t.text :motivo
      t.boolean :cumple, default: false
      t.string :archivo_informe
      t.string :archivo_evidencia
      t.date :fecha_auditoria
      t.string :rut_auditor
      t.boolean :aceptado
      t.boolean :en_revision, default: false
      t.text :observacion
    end
  end
end
