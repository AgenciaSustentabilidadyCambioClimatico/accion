class RegistroProveedorMensajeMailer < ApplicationMailer
  def paso_de_tarea_uno(registro_proveedor, asunto, body, user)
    @registro_proveedor = registro_proveedor
    @asunto = asunto
    @body = body
    @user = user
    mail(to: user, subject: @asunto)
  end

  def paso_de_tarea_dos(registro_proveedor, asunto, body, user)
    @registro_proveedor = registro_proveedor
    @asunto = asunto
    @body = body
    @user = user
    mail(to: user, subject: @asunto)
  end

  def paso_de_tarea_tres(registro_proveedor, asunto, body, user)
    @registro_proveedor = registro_proveedor
    @asunto = asunto
    @body = body
    @user = user
    mail(to: user, subject: @asunto)
  end

  def paso_de_tarea_cuatro(registro_proveedor, asunto, body, user)
    @registro_proveedor = registro_proveedor
    @asunto = asunto
    @body = body
    @user = user
    mail(to: user, subject: @asunto)
  end

  def paso_de_tarea_cinco(registro_proveedor, asunto, body, user)
    @registro_proveedor = registro_proveedor
    @asunto = asunto
    @body = body
    @user = user
    mail(to: user, subject: @asunto)
  end

  def paso_de_tarea_seis(registro_proveedor, asunto, body, user)
    @registro_proveedor = registro_proveedor
    @asunto = asunto
    @body = body
    @user = user
    mail(to: user, subject: @asunto)
  end
end
