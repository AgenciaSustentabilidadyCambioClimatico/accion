class AddNombreCampoToDocumentacionLegal < ActiveRecord::Migration[5.1]
  def change
    add_column :documentacion_legals, :nombre_campo, :string
  end
end
