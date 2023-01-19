class RegistroProveedorMailer < ApplicationMailer
  def enviar(registro_proveedor)
    @registro_proveedor = registro_proveedor
    user = registro_proveedor.email
    encabezado = 'Postulacion enviada'
    mail(to: user, subject: encabezado)
  end
end
