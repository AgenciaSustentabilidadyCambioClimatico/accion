class CreateAdhesionElementos < ActiveRecord::Migration[5.1]
  def change
    create_table :adhesion_elementos do |t|
      t.references :adhesion, index: true, foreign_key: true
      t.references :persona, index: true, foreign_key: true
      t.references :alcance, index: true, foreign_key: true
      t.references :establecimiento_contribuyente, index:true, foreign_key: true
      t.references :maquinaria, index: true, foreign_key: true
      t.references :otro, index: true, foreign_key: true
      t.string :archivo_adhesion
      t.string :archivo_respaldo
      t.text :fila
      t.timestamps
    end
  end
end
