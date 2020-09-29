class CreateTraspasoInstrumentos < ActiveRecord::Migration[5.1]
  def change
    create_table :traspaso_instrumentos do |t|
    	t.references :origen, index: true, foreign_key: { to_table: :users }
    	t.references :flujo, index: true, foreign_key: true
    	t.references :destino, index: true, foreign_key: { to_table: :users }
    	t.integer :tipo_traspaso
    	t.date :fecha_retorno, null: true
      t.timestamps
    end
  end
end
