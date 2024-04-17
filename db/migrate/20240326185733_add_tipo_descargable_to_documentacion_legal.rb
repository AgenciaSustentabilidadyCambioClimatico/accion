class AddTipoDescargableToDocumentacionLegal < ActiveRecord::Migration[5.1]
  def change
    add_column :documentacion_legals, :tipo_descargable, :integer
  end
end
