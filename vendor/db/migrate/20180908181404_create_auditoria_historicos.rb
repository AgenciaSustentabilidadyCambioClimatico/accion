class CreateAuditoriaHistoricos < ActiveRecord::Migration[5.1]
  def change
    create_table :auditoria_historicos do |t|
    	t.belongs_to :manifestacion_de_interes, foreign_key: true
    	t.string :tipo
    	t.integer :numero
    	t.date :fecha
    	t.string :resultado_ponderado
    	t.string :documento_respaldo

      t.timestamps
    end
  end
end
