class ModificaCamposToPaises < ActiveRecord::Migration[5.1]
  def up
  	add_timestamps :paises, null: true
  	change_column_null :paises, :nombre_local, true
  	change_column_null :paises, :continente, true
  	change_column_null :paises, :region, true
  	change_column_null :paises, :codigo_corto, true
  	change_column_null :paises, :codigo_largo, true
  	change_column_null :paises, :gentilicio, true

  	ahora = DateTime.now
	  Pais.update_all(created_at: ahora, updated_at: ahora)

	  # devuelve la condición not null
	  change_column_null :paises, :created_at, false
	  change_column_null :paises, :updated_at, false
  end
  def down
    remove_column :paises, :created_at
    remove_column :paises, :updated_at
    change_column_null :paises, :nombre_local, false
    change_column_null :paises, :continente, false
    change_column_null :paises, :region, false
    change_column_null :paises, :codigo_corto, false
    change_column_null :paises, :codigo_largo, false
    change_column_null :paises, :gentilicio, false
  end
end
