class AgregaNombreCompletoToUsers < ActiveRecord::Migration[5.1]
  def up
  # 	add_column :users, :nombre_completo, :string, null: true
  # 	usuarios = User.all
  # 	usuarios.each do |usuario|
  # 		usuario.update(nombre_completo: (usuario.nombres+" "+usuario.apellido_paterno+" "+usuario.apellido_materno))
  # 	end
  # 	change_column_null :users, :nombre_completo, false
  # change_column_null :users, :nombres, true
  # change_column_null :users, :apellido_paterno, true
  # change_column_null :users, :apellido_materno, true
  end
  def down
  # 	remove_column :users, :nombre_completo
  end
end
