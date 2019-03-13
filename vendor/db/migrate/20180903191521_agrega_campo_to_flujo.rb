class AgregaCampoToFlujo < ActiveRecord::Migration[5.1]
  def change
  	add_column :flujos, :terminado, :boolean, default: false
  end
end
