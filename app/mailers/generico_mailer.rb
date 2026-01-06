class GenericoMailer < ApplicationMailer
	def elimina_mapa_actores(flujo, actores_info)
    @actores_info = actores_info
		ascc = Contribuyente.find_by_rut(75980060)
    admins = User
      .includes(personas: :persona_cargos)
      .where(personas: {
        contribuyente_id: ascc.id,
        persona_cargos: { cargo_id: Cargo::ADMIN }
      })

    destinatarios = admins.pluck(:email)

    @nombre_instrumento = "#{flujo.nombre_para_raa}"
		titulo = "ASCC Sistemas: Modificaciones realizadas en usuarios del mapa de actores '#{@nombre_instrumento}'"
		@message = "Estimados, ASCC Sistemas le informa que se eliminaron usuarios del mapa del actores para el instrumento '#{@nombre_instrumento}'."
    mail(to: destinatarios, subject: titulo)
  end
end
