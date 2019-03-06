class CreateAdhesiones < ActiveRecord::Migration[5.1]
  def change
    create_table :adhesiones do |t|
    	t.integer :persona_id
    	t.json :archivos_adhesion_y_documentacion
    	t.string :archivo_elementos
    end
  end
end
