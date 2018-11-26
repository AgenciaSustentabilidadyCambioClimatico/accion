class CreatePpfMetasEstablecimientos < ActiveRecord::Migration[5.1]
  def change
    create_table :ppf_metas_establecimientos do |t|
    	t.belongs_to :establecimiento_contribuyente, index: false
    	t.references :flujo, index: true, foreign_key: true
    	t.integer :estado, limit: 1, default: 1 # 1 = pendiente, 2 = aprobada, 3 = rechazada

      t.timestamps
    end
  end
end
