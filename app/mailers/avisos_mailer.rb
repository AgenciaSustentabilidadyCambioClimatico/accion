class AvisosMailer < ApplicationMailer

	def cierre_proceso(to, manifestacion_de_interes)
    @manifestacion_de_interes = manifestacion_de_interes
    mail(to: to, subject: 'Aviso cierre de proceso')
  end

  def certificacion_vencimiento_inminente(to, auditoria)
  	@auditoria = auditoria
    mail(to: to, subject: "Aviso pérdida de vigencia inminente")
  end

  def certificacion_vencida(to, auditoria)
  	@auditoria = auditoria
    mail(to: to, subject: "Aviso pérdida de vigencia")
  end
end