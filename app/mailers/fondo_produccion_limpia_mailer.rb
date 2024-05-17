class FondoProduccionLimpiaMailer < ApplicationMailer
  
  def envio_mail(encabezado, user)
    mail(to: user, subject: encabezado)
  end

end
