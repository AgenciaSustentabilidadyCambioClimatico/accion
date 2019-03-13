class CreateEstandarHomologaciones < ActiveRecord::Migration[5.1]
  def change
    create_table :estandar_homologaciones do |t|
    	t.string :nombre
    	t.json :referencias

      t.timestamps
    end
  end
end
