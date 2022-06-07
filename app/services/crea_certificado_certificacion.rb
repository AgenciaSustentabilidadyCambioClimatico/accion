class CreaCertificadoCertificacion
  attr_accessor :auditoria, :adhesion_elemento, :institucion, :fecha_certificacion, :vigencia_certificacion, :auditoria_nivel


  def initialize(auditoria, adhesion_elemento, fecha_certificacion, vigencia_certificacion, auditoria_nivel=nil)
    @auditoria = auditoria
    @adhesion_elemento = adhesion_elemento
    rut_institucion = adhesion_elemento.fila[:rut_institucion].to_s.gsub("k","K").gsub(".","").split("-").first
    @institucion = Contribuyente.find_by(rut: rut_institucion)
    @fecha_certificacion = fecha_certificacion
    @vigencia_certificacion = vigencia_certificacion
    @auditoria_nivel = auditoria_nivel
  end

  def generar_archivo
    archivo = WickedPdf.new.pdf_from_string(
      ActionController::Base.new.render_to_string(
        #cover: render_to_string('_portada_reporte_sustentabilidad'),
        'admin/elementos_certificados/_certificado', 
        layout: 'layouts/wicked_pdf',
        locals: {
          auditoria: auditoria,
          adhesion_elemento: adhesion_elemento,
          institucion: institucion,
          fecha_certificacion: fecha_certificacion,
          vigencia_certificacion: vigencia_certificacion,
          auditoria_nivel: auditoria_nivel,
          app_helpers: ApplicationController.helpers
        }
      ),
      margin: {top: 10, bottom: 10, left: 10, right: 10},
      show_as_html: true,
      title: "Certificado"
    )
    archivo
  end
end