class AddCamposToEstandarHomologacion < ActiveRecord::Migration[5.1]
  def change
    add_column :estandar_homologaciones, :descripcion, :text
    add_column :estandar_homologaciones, :url_referencia, :string
  end
end
