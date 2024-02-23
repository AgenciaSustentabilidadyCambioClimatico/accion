class DropEquipoEmpresa < ActiveRecord::Migration[5.1]
  def change
    drop_table :equipo_empresas
  end
end
