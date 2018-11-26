class AddCorreoEnviadoToMinutaParticipantes < ActiveRecord::Migration[5.1]
  def up
    add_column :minuta_participantes, :correo_enviado, :boolean, default: false
  end
	def down
    remove_column :minuta_participantes, :correo_enviado, :boolean
  end
end
