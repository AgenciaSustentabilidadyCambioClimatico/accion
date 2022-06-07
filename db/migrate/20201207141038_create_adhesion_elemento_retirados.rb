class CreateAdhesionElementoRetirados < ActiveRecord::Migration[5.1]
  def change
    create_table :adhesion_elemento_retirados do |t|
      t.references :adhesion, foreign_key: true
      t.references :persona, foreign_key: true
      t.references :alcance, foreign_key: true
      t.references :establecimiento_contribuyente, foreign_key: true, index: {name: 'idx_aer_ec'}
      t.references :maquinaria, foreign_key: true
      t.references :otro, foreign_key: true
      t.string :archivo_adhesion
      t.string :archivo_respaldo
      t.string :archivo_retiro
      t.text :fila
      t.timestamps
    end
  end
end
