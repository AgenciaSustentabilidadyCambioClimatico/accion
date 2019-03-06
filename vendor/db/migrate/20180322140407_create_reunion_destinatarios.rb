class CreateReunionDestinatarios < ActiveRecord::Migration[5.1]
  def change
    create_table :reunion_destinatarios do |t|
    	t.integer :reunion_id
    	t.integer :destinatario_id
    	t.boolean :visto
    	t.timestamps
    end
  end
end
