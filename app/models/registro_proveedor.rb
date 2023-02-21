class RegistroProveedor < ApplicationRecord
  belongs_to :contribuyente, optional: true
  belongs_to :tipo_contribuyente, optional: true
  belongs_to :tipo_proveedor
  has_many :certificado_proveedores, dependent: :destroy
  has_many :documento_registro_proveedores, dependent: :destroy

  accepts_nested_attributes_for :certificado_proveedores, allow_destroy: true
  accepts_nested_attributes_for :documento_registro_proveedores, allow_destroy: true


  mount_uploader :archivo_respuesta_rechazo, ArchivoRespuestaRechazoProveedorUploader
  mount_uploader :archivo_respuesta_rechazo_directiva, ArchivoRespuestaRechazoDirectivaProveedorUploader

  validates :rut, presence: true
  validates :rut, uniqueness: true
  validates :nombre, presence: true
  validates :apellido, presence: true
  validates :profesion, presence: true
  validates :email, presence: true, format: { with: /\A([\w\.%\+\-]+)@([\w\-]+\.)+([\w]{2,})\z/i }
  validates :telefono, presence: true
  validates :telefono, numericality: true, length: {in: 8..11}
  validates :direccion, presence: true
  validates :region, presence: true
  validates :comuna, presence: true
  validates :ciudad, presence: true
  validates :rut_institucion, :nombre_institucion, presence: true, if: :asociar_institucion_present?
  validates :nombre_institucion, presence: true, if: :asociar_institucion_present?
  validates :direccion_casa_matriz, presence: true, if: :asociar_institucion_present?
  validates :ciudad_casa_matriz, presence: true, if: :asociar_institucion_present?
  validate :terms_of_service_value

  enum estado: [:enviado, :recomendado, :con_observaciones, :rechazado, :aprobado, :rechazado_directiva, :rechazado_definitivo]

  before_validation :normalizar_rut

  def terms_of_service_value
    if terminos_y_servicion != true
      errors.add(:terminos_y_servicion, "Debes aceptar los terminos y servicios")
    end
  end

  def normalizar_rut
    self.rut = self.rut.to_s.upcase.gsub(/[^0-9\-K]/,'') unless self.rut.blank?
  end

  def asociar_institucion_present?
    self.asociar_institucion == true && !self.contribuyente_id.present?
  end

  def nombre_completo
    "#{self.nombre} #{self.apellido}"
  end

  def nombre_user_encargado
    if self.user_encargado.present?
      user = self.user_encargado
      user_encargado = User.find(self.user_encargado).nombre_completo
      "#{user_encargado}"
    end
  end

  def generar_pdf
    require 'stringio'

    pdf = Prawn::Document.new
    pdf.font Rails.root.join("app/assets/fonts/Open_Sans/OpenSans-Regular.ttf")
    ##HEADER
    pdf.repeat :all do
      pdf.bounding_box [pdf.bounds.left, pdf.bounds.top], :width  => pdf.bounds.width do
        #pdf.image Rails.root.join('app','assets','images','logo-ascc.png').to_s, width: 150
        pdf.image Rails.root.join("app/assets/images/logo-ascc.png"), width: 119
        pdf.bounding_box [pdf.bounds.left, pdf.bounds.bottom], :width  => pdf.bounds.width do
          pdf.font Rails.root.join("app/assets/fonts/Open_Sans/OpenSans-Bold.ttf") do
            pdf.text "FORMULARIO REGISTRO PROVEEDORES", size: 10, color: "003DA6", align: :right
          end
        end
        pdf.move_down 8
        pdf.stroke do
          pdf.stroke_color '003DA6'
          pdf.line_width 3
          pdf.stroke_horizontal_rule
        end
      end
    end

    ##CONTENIDO

    pdf.bounding_box [pdf.bounds.left, pdf.bounds.top - 100], :width  => pdf.bounds.width do
      #PESTAÑA 1
      self.pdf_titulo_formato(pdf, 'Datos Solicitante', "")
      self.pdf_contenido_formato(pdf, 'RUT', self.rut)
      self.pdf_contenido_formato(pdf, 'Nombre', self.nombre_completo)
      self.pdf_contenido_formato(pdf, 'Email', self.email)
      self.pdf_contenido_formato(pdf, 'Teléfono', self.telefono)
      self.pdf_contenido_formato(pdf, 'Profesión', self.profesion)
      self.pdf_contenido_formato(pdf, 'Dirección', self.direccion)
      self.pdf_contenido_formato(pdf, 'Región', self.region)
      self.pdf_contenido_formato(pdf, 'Comuna', self.comuna)
      self.pdf_contenido_formato(pdf, 'Ciudad', self.ciudad)
      self.pdf_separador(pdf, 11)
      self.pdf_contenido_formato(pdf, 'Rut institución', self.rut_institucion)
      self.pdf_contenido_formato(pdf, 'Nombre institución', self.nombre_institucion)
      self.pdf_contenido_formato(pdf, 'Dirección casa matriz', self.direccion_casa_matriz)
      self.pdf_contenido_formato(pdf, 'Región casa matriz', self.region_casa_matriz)
      self.pdf_contenido_formato(pdf, 'Comuna casa matriz', self.comuna_casa_matriz)
      self.pdf_contenido_formato(pdf, 'Ciudad casa matriz', self.ciudad_casa_matriz)
      self.pdf_separador(pdf, 40)
      self.pdf_titulo_formato(pdf, 'Registro', "")
      self.pdf_contenido_formato(pdf, 'Tipo Proveedor', TipoProveedor.find(self.tipo_proveedor_id).nombre)
      self.certificado_proveedores.each do |certificado|
        self.pdf_contenido_formato(pdf, 'Archivo', certificado.archivo_certificado)
        self.pdf_contenido_formato(pdf, 'Materia', MateriaSustancia.find(certificado.materia_sustancia_id).nombre)
        self.pdf_contenido_formato(pdf, 'Actividad Económica:', ActividadEconomica.find(certificado.actividad_economica_id).descripcion_ciiuv4)
      end
      self.pdf_separador(pdf, 11)
      self.pdf_titulo_formato(pdf, 'Documentación', "")
      self.documento_registro_proveedores.each do |documento|
        self.pdf_contenido_formato(pdf, 'Descripción', documento.description)
        self.pdf_contenido_formato(pdf, 'Archivo', documento.archivo)
      end
    end

    pdf
  end

  def pdf_contenido_formato pdf, variable, contenido
    var = variable
    if !var.nil?
      pdf.font Rails.root.join("app/assets/fonts/Open_Sans/OpenSans-SemiBold.ttf") do
        pdf.text var, size: 9
      end
      pdf.move_down 4
      valor = contenido
      if valor.blank?
        pdf.font Rails.root.join("app/assets/fonts/Open_Sans/OpenSans-Italic.ttf") do
          pdf.text 'No se ingresa respuesta', size: 9, color: 'A4A5A7'
        end
      elsif valor.class.superclass == CarrierWave::Uploader::Base
        #pdf.text "<link href='"+valor.url+"'>"+valor.file.filename+"</link>", size: 9, color: '007BFF', inline_format: true
        self.pdf_boton_descarga(pdf, valor.url, valor.file.filename)
      elsif([String,Integer].include?(valor.class))
        pdf.text valor.to_s, size: 9, color: '555555', align: :justify
      elsif(valor.class == Symbol)
        pdf.text I18n.t(valor.to_s.gsub!('-', '_')), size: 9, color: '555555', align: :justify
      end
      pdf.move_down 11
    end
  end

  def pdf_titulo_formato pdf, titulo, subtitulo
    pdf.font Rails.root.join("app/assets/fonts/Open_Sans/OpenSans-Bold.ttf") do
      pdf.text titulo, size: 11
    end
    pdf.text subtitulo, size: 9
    pdf.text "··········<color rgb='003DA6'>··········</color>", size: 20, color: 'EB0029', inline_format: true, leading: 0
    pdf.move_down 15
  end

  def pdf_separador(pdf, tamano_pos)
    pdf.stroke do
      pdf.stroke_color 'E5E5E5'
      pdf.line_width 1
      pdf.stroke_horizontal_rule
    end
    pdf.move_down tamano_pos

  end

  def pdf_boton_descarga pdf, link, texto
    pdf.table([
      [
        {
          image: Rails.root.join("app/assets/images/download-solid-blue.jpg").to_s,
          image_height: 9,
          image_width: 9
        },
        "<font size='9'><color rgb='007BFF'><link href='"+link+"'>"+texto+"</link></color></font>"
      ]
    ],
    cell_style: {
      border_color: "007BFF",
      inline_format: true
    }) do
      cells.borders = []
      column(0).borders =[:bottom, :left, :top]
      column(0).padding =[5, 2, 5, 5]
      column(1).borders =[:bottom, :right, :top]
      column(1).padding =[5, 5, 5, 2]
    end
  end

end
