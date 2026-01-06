class GenericoMailer < ApplicationMailer
	def elimina_mapa_actores(flujo, actores_info)
    @flujo = Flujo.find(flujo.to_i)
    @actores_info = actores_info
		ascc = Contribuyente.find_by_rut(75980060)
    admins = User
      .includes(personas: :persona_cargos)
      .where(personas: {
        contribuyente_id: ascc.id,
        persona_cargos: { cargo_id: Cargo::ADMIN }
      })

    destinatarios = admins.pluck(:email)
    
    @nombre_instrumento = "#{@flujo.nombre_para_raa}" 
		titulo = "ASCC Sistemas: Eliminaciones realizadas en actores del mapa de actores '#{@nombre_instrumento}'"
		@message = "ASCC Sistemas informa que se han eliminado actores del mapa de actores asociado al instrumento '#{@nombre_instrumento}'."
    mail(to: destinatarios, subject: titulo)
  end
end
