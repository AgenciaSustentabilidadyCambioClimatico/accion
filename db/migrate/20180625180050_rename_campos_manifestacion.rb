class RenameCamposManifestacion < ActiveRecord::Migration[5.1]
  def up
  	rename_column :manifestacion_de_intereses, :usuario_entregables_diagnostico_general_id, :usuario_entregables_id
  	rename_column :manifestacion_de_intereses, :usuario_entregables_diagnostico_general_archivo, :archivo_usuario_entregables
  	rename_column :manifestacion_de_intereses, :usuario_entregables_diagnostico_general_comentario, :usuario_entregables_comentario
  	rename_column :manifestacion_de_intereses, :usuario_entregables_diagnostico_general_otros, :usuario_entregables_otros
  end
  def down
  	rename_column :manifestacion_de_intereses, :usuario_entregables_id, :usuario_entregables_diagnostico_general_id
  	rename_column :manifestacion_de_intereses, :usuario_entregables_archivo, :usuario_entregables_diagnostico_general_archivo
  	rename_column :manifestacion_de_intereses, :usuario_entregables_comentario, :usuario_entregables_diagnostico_general_comentario
  	rename_column :manifestacion_de_intereses, :usuario_entregables_otros, :usuario_entregables_diagnostico_general_otros
  end
end
