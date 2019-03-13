class AddProyectoIdToFlujos < ActiveRecord::Migration[5.1]
  def change
    add_foreign_key :flujos, :proyectos
  end
end
