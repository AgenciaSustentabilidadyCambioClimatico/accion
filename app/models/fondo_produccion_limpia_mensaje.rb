class FondoProduccionLimpiaMensaje < ApplicationRecord
  belongs_to :tarea
 
  validates :asunto, presence: true
  validates :body, presence: true

  def self.metodos(user, mdi=nil)
		{
			#"[asunto]": "Mensaje de salida",
			"[nombre]": user.nombre_completo,
			"[telefono]": user.telefono,
			"[email]": user.email,
			"[rut]": user.rut,
			"[nombre_acuerdo]": mdi.nil? ? '[nombre_acuerdo]' : mdi.nombre_acuerdo
		}
	end
end
