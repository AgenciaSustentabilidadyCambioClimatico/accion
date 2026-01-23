class AddCorrelativoToObjetivosEspecifico < ActiveRecord::Migration[6.0]
  def change
    add_column :objetivos_especificos, :correlativo, :integer
  end
end
