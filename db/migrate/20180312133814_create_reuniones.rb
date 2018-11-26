class CreateReuniones < ActiveRecord::Migration[5.1]
  def change
    create_table :reuniones do |t|
        t.integer :proyecto_id
    	t.date :fecha
    	t.string :direccion
    	t.decimal :lat 
    	t.decimal :lng
    	t.string :encabezado
    	t.string :mensaje
    	t.timestamps
    end
  end
end
