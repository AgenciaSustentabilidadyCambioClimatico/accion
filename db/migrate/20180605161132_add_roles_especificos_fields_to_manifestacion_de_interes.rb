class AddRolesEspecificosFieldsToManifestacionDeInteres < ActiveRecord::Migration[5.1]
  def change
    add_column :manifestacion_de_intereses, :roles_especificos_institucion_entregables, :integer
    add_column :manifestacion_de_intereses, :roles_especificos_usuario_entregables, :integer
    add_column :manifestacion_de_intereses, :roles_especificos_comentarios_entregables, :text
    add_column :manifestacion_de_intereses, :roles_especificos_institucion_carga_datos, :integer
    add_column :manifestacion_de_intereses, :roles_especificos_usuario_carga_datos, :integer
    add_column :manifestacion_de_intereses, :roles_especificos_comentarios_carga_datos, :text
  end
end
