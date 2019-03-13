class AddForeingKeyToMinuta < ActiveRecord::Migration[5.1]
  def change
  	add_foreign_key :minutas, :convocatorias, column: :convocatoria_id
  end
end
