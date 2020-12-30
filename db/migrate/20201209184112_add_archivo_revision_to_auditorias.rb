class AddArchivoRevisionToAuditorias < ActiveRecord::Migration[5.1]
  def change
    add_column :auditorias, :archivo_revision, :string, null: true
  end
end
