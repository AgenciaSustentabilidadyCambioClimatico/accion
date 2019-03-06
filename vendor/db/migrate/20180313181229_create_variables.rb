class CreateVariables < ActiveRecord::Migration[5.1]
	def change
		create_table :variables do |t|
			t.string :nombre, null: false, limit: 20
			t.text :valor, null: false
		end
	end
end