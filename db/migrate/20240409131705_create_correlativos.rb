class CreateCorrelativos < ActiveRecord::Migration[5.1]
  def change
    create_table :correlativos do |t|
      t.integer :year
      t.integer :valor

      t.timestamps
    end
  end
end
