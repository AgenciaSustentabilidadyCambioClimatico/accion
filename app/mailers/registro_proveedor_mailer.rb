class RegistroProveedorMailer < ApplicationMailer
  def enviar(registro_proveedor)
    @registro_proveedor = registro_proveedor
    user = registro_proveedor.email
    encabezado = 'Postulacion enviada'
    mail(to: user, subject: encabezado)
  end

  def primer_rechazo(registro_proveedor)
    @registro_proveedor = registro_proveedor
    user = registro_proveedor.email
    encabezado = 'Postulacion rechazada'
    mail(to: user, subject: encabezado)
  end

  def rechazo_definitivo(registro_proveedor)
    @registro_proveedor = registro_proveedor
    user = registro_proveedor.email
    encabezado = 'Postulacion rechazada definitivamente'
    mail(to: user, subject: encabezado)
  end
end
