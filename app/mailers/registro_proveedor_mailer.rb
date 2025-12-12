class RegistroProveedorMailer < ApplicationMailer
  def enviar(registro_proveedor)
    @registro_proveedor = registro_proveedor
    tipo_proveeedor = registro_proveedor.tipo_proveedor_id
    @tipo_proveedor = TipoProveedor.find(tipo_proveeedor).nombre
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

  def con_observaciones(registro_proveedor)
    @registro_proveedor = registro_proveedor
    user = registro_proveedor.email
    encabezado = 'Postulacion observada'
    mail(to: user, subject: encabezado)
  end

  def rechazo_definitivo(registro_proveedor)
    @registro_proveedor = registro_proveedor
    user = registro_proveedor.email
    encabezado = 'Postulacion rechazada definitivamente'
    mail(to: user, subject: encabezado)
  end

  def primer_rechazo_directiva(registro_proveedor)
    @registro_proveedor = registro_proveedor
    user = registro_proveedor.email
    encabezado = 'Postulacion rechazada'
    mail(to: user, subject: encabezado)
  end

  def aprobado_directiva(registro_proveedor)
    @registro_proveedor = registro_proveedor
    tipo_proveeedor = registro_proveedor.tipo_proveedor_id
    @tipo_proveedor = TipoProveedor.find(tipo_proveeedor).nombre
    user = registro_proveedor.email
    encabezado = 'Postulacion aprobada'
    mail(to: user, subject: encabezado)
  end

  def aviso_venciminento_proveedor(registro_proveedor)
    @registro_proveedor = registro_proveedor
    tipo_proveeedor = registro_proveedor.tipo_proveedor_id
    @tipo_proveedor = TipoProveedor.find(tipo_proveeedor).nombre
    user = registro_proveedor.email
    encabezado = 'Actualizar postulacion'
    mail(to: user, subject: encabezado)
  end

  def aviso_vencido_proveedor(registro_proveedor)
    @registro_proveedor = registro_proveedor
    user = registro_proveedor.email
    encabezado = 'Postulacion vencida'
    mail(to: user, subject: encabezado)
  end

  def revision_positiva(registro_proveedor)
    @registro_proveedor = registro_proveedor
    tipo_proveeedor = registro_proveedor.tipo_proveedor_id
    @tipo_proveedor = TipoProveedor.find(tipo_proveeedor).nombre
    user = registro_proveedor.email
    encabezado = 'Actualizar postulacion'
    mail(to: user, subject: encabezado)
  end

  def revision_negativa(registro_proveedor)
    @registro_proveedor = registro_proveedor
    user = registro_proveedor.email
    encabezado = 'Actualizar postulacion'
    mail(to: user, subject: encabezado)
  end

  def actualizacion_con_observaciones(registro_proveedor)
    @registro_proveedor = registro_proveedor
    user = registro_proveedor.email
    encabezado = 'Actualización observada'
    mail(to: user, subject: encabezado)
  end
end
