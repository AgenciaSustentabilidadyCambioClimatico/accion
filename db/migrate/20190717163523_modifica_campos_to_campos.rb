class ModificaCamposToCampos < ActiveRecord::Migration[5.1]
  def up
  	add_column :campos, :validacion_min_activa, :boolean, default: true
  	add_column :campos, :validacion_max_activa, :boolean, default: true
  	rename_column :campos, :validacion_activa, :validaciones_activas
    change_column :campos, :validaciones_activas, :boolean, default: true
  	rename_column :campos, :obligatorio, :validacion_contenido_obligatorio
  	change_column :campos, :validacion_contenido_obligatorio, :boolean, default: true
    change_column_null :campos, :clase, false
    change_column_null :campos, :atributo, false
    change_column_null :campos, :tipo, false
    add_column :campos, :tooltip, :string
    add_column :campos, :ayuda, :string
  end
  def down
  	remove_column :campos, :validacion_min_activa
  	remove_column :campos, :validacion_max_activa
  	rename_column :campos, :validaciones_activas, :validacion_activa
    change_column :campos, :validacion_activa, :boolean
  	rename_column :campos, :validacion_contenido_obligatorio, :obligatorio
  	change_column :campos, :obligatorio, :boolean
    change_column_null :campos, :clase, true
    change_column_null :campos, :atributo, true
    change_column_null :campos, :tipo, true
    remove_column :campos, :tooltip, :string
    remove_column :campos, :ayuda, :string
  end
end
