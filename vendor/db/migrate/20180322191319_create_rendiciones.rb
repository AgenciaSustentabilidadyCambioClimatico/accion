class CreateRendiciones < ActiveRecord::Migration[5.1]
  def change
    create_table :rendiciones do |t|
    	t.integer :proyecto_id
    	t.date :fecha_rendicion
    	t.integer :modalidad_id
    	t.timestamps 
    end
  end
end
