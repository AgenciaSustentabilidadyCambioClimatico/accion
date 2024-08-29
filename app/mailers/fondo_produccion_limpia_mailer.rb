class FondoProduccionLimpiaMailer < ApplicationMailer
  def paso_de_tarea(asunto, body, user)
    @asunto = asunto
    @body = body
    @user = user.email
    mail(to: @user, subject: @asunto)
  end
end
