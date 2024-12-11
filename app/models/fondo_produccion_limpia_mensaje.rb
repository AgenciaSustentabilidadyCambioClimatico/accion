class FondoProduccionLimpiaMensaje < ApplicationRecord
  belongs_to :tarea
 
  validates :asunto, presence: true
  validates :body, presence: true

  def self.metodos(user, mdi=nil, fpl= nil)
		{
			#"[asunto]": "Mensaje de salida",
			"[nombre]": user.nombre_completo,
			"[telefono]": user.telefono,
			"[email]": user.email,
			"[rut]": user.rut,
			"[tipo_proyecto]": mdi.nil? ? '[tipo_proyecto]' : fpl.flujo.tipo_instrumento.nombre,
			"[codigo_proyecto]": fpl.nil? ? '[codigo_proyecto]' : fpl.codigo_proyecto,
			"[nombre_acuerdo]": mdi.nil? ? '[nombre_acuerdo]' : mdi.nombre_acuerdo
		}
	end
end
