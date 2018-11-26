class AddArchivoCorrectoToAuditorias < ActiveRecord::Migration[5.1]
  def change
  	add_column :auditorias, :archivo_correcto, :boolean, null: true
  end
end
