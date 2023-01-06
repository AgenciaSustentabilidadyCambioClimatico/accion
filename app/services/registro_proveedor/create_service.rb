class RegistroProveedor::CreateService
  def initialize(registro_proveedor, params)
    @registro_proveedor = registro_proveedor
    @params = params
  end

  def perform
    create_user
    if @registro_proveedor.asociar_institucion == false
      create_institucion


  end

  def create_user
    rut = @registro_proveedor.rut
    nombre_completo = "#{@registro_proveedor.nombre} #{@registro_proveedor.apellido}"
    telefono = @registro_proveedor.telefono
    email = @registro_proveedor.email
    User.create(rut: rut, nombre_completo: nombre_completo, telefono: telefono, email: email)
  end

  def create_institucion
    rut = @registro_proveedor.rut
    dv = @registro_proveedor.rut.chars.last
    razon_social = "#{@registro_proveedor.nombre} #{@registro_proveedor.apellido}"
    institucion = Institucion.create(rut: rut, dv: dv, razon_social: razon_social)
    actividad_economica = ActividadEconomica.where(codigo_ciiuv4: '702000')
    ActivdadEconomicaContribuyente.create(actividad_economica_id: actividad_economica.first, contribuyente_id: institucion)
    establecimiento = EstablecimientoContribuyente.create(contribuyente_id:, direccion:,  comuna_id: @params[:comuna].to_i, region_id: @params[:region], ciudad: @registro_proveedor.ciudad)
    persona = Persona.create(user_id: , contribuyente_id: , establecimiento_contribuyente_id: , email_institucional: , telefono_institucional: ,)
    cargo = Cargo.where(nombre: 'Representante Legal')
    PersonaCargo.create(persona_id: persona.id cargo_id: cargo.first.id)
  end


  Cargo.where(nombre: 'Profesional Técnico')
end
