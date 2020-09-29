class AddColumnsToManifestacionDeInteres < ActiveRecord::Migration[5.1]
  def change
    add_column :manifestacion_de_intereses, :institucion_entregables_id, :integer
    add_column :manifestacion_de_intereses, :institucion_entregables_name, :string
    add_column :manifestacion_de_intereses, :usuario_entregable_name, :string
  end
end
