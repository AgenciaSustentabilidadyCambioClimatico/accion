class RegistroProveedorMensajeMailer < ApplicationMailer
  def paso_de_tarea(registro_proveedor, asunto, body, user)
    @registro_proveedor = registro_proveedor
    @asunto = asunto
    @body = body
    @user = user.email
    mail(to: @user, subject: @asunto)
  end
end
