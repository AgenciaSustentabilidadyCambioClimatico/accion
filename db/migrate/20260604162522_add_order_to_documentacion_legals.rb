class AddOrderToDocumentacionLegals < ActiveRecord::Migration[6.0]
  def change
    add_column :documentacion_legals, :orden, :integer
  end
end
