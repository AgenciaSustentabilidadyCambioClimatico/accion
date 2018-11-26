class AddSchemas < ActiveRecord::Migration[5.1]
  def change
    reversible do |dir|
      dir.up   { 
        execute <<-SQL
          -- CREATE SCHEMA admin
        SQL
      }
      dir.down { 
        execute <<-SQL
          -- DROP SCHEMA admin
        SQL
      }
    end
  end
end