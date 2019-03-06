class CreatePrivacidadPermisos < ActiveRecord::Migration[5.1]
  def up
    create_table :privacidad_permisos do |t|
      t.string :entidad
      t.text :fields_visibility
      t.timestamps
    end
  end
end
