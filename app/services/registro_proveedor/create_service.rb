class RegistroProveedor::CreateService
  def initialize(registro_proveedor, params)
    @registro_proveedor = registro_proveedor
    @params = params
  end

  def perform
    create_user
    if @registro_proveedor.asociar_institucion == false
      create_institucion
    elsif @registro_proveedor.asociar_institucion == true && @registro_proveedor.contribuyente_id.present?
      find_institucion
    elsif @registro_proveedor.asociar_institucion == true && !@registro_proveedor.contribuyente_id.present?
      create_institucion_with_user_data
    end
    create_flujo
  end

  def create_user
    rut = @registro_proveedor.rut
    nombre_completo = "#{@registro_proveedor.nombre} #{@registro_proveedor.apellido}"
    telefono = @registro_proveedor.telefono
    email = @registro_proveedor.email
    user_proveedor = User.find_by(rut: rut)
    if user_proveedor.nil?
      user = User.create(rut: rut, nombre_completo: nombre_completo, telefono: telefono, email: email, password: '123456')
    end
  end

  def create_flujo
    user = User.where(rut: @registro_proveedor.rut).first
    f = Flujo.create(contribuyente_id: user.contribuyentes.first.id, tipo_instrumento_id: 26, registro_proveedor_id: @registro_proveedor.id)
    tarea = Tarea.where(nombre: "PRO-002").first
    u = User.select { |f| f.posee_rol_ascc?(Rol::JEFE_DE_LINEA_PROVEEDORES) }.last
    t = TareaPendiente.create(flujo_id: f.id, tarea_id: tarea.id, estado_tarea_pendiente_id: EstadoTareaPendiente::NO_INICIADA, user_id: u.id)
  end

  def create_institucion
    rut = @registro_proveedor.rut
    dv = @registro_proveedor.rut.chars.last
    razon_social = "#{@registro_proveedor.nombre} #{@registro_proveedor.apellido}"
    region = Region.where(nombre: @registro_proveedor.region).first
    comuna = Comuna.where(nombre: @registro_proveedor.comuna).first
    rut_para_institucion = @registro_proveedor.rut.chop.gsub(/[^0-9]/,'')
    institucion = Institucion.find_or_create_by(rut: rut_para_institucion, dv: dv, razon_social: razon_social)
    actividad_economica = ActividadEconomica.where(codigo_ciiuv4: '702000')
    ActividadEconomicaContribuyente.create(actividad_economica_id: actividad_economica.first, contribuyente_id: institucion.id)
    establecimiento = EstablecimientoContribuyente.create(contribuyente_id: institucion.id, direccion: @registro_proveedor.direccion,  comuna_id: comuna.id, region_id: region.id , ciudad: @registro_proveedor.ciudad, casa_matriz: true)
    user = User.where(rut: @registro_proveedor.rut).first
    persona = Persona.create(user_id: user.id , contribuyente_id: institucion.id, email_institucional: @registro_proveedor.email , telefono_institucional: @registro_proveedor.telefono)
    cargo = Cargo.where(nombre: 'Representante Legal')
    PersonaCargo.create(persona_id: persona.id, cargo_id: cargo.first.id, establecimiento_contribuyente_id: establecimiento.id)
  end

  def create_institucion_with_user_data
    rut = @registro_proveedor.rut_institucion
    dv = @registro_proveedor.rut_institucion.chars.last
    razon_social = @registro_proveedor.nombre_institucion
    region = Region.where(nombre: @registro_proveedor.region_casa_matriz).first
    comuna = Comuna.where(nombre: @registro_proveedor.comuna_casa_matriz).first
    rut_para_institucion = @registro_proveedor.rut_institucion.chop.gsub(/[^0-9]/,'')
    institucion = Institucion.find_or_create_by(rut: rut_para_institucion, dv: dv, razon_social: razon_social)
    actividad_economica = ActividadEconomica.where(codigo_ciiuv4: '702000')
    ActividadEconomicaContribuyente.create(actividad_economica_id: actividad_economica.first, contribuyente_id: institucion.id)
    establecimiento = EstablecimientoContribuyente.create(contribuyente_id: institucion.id, direccion: @registro_proveedor.direccion_casa_matriz,  comuna_id: comuna.id, region_id: region.id , ciudad: @registro_proveedor.ciudad_casa_matriz, casa_matriz: true)
    user = User.where(rut: @registro_proveedor.rut).first
    persona = Persona.create(user_id: user.id , contribuyente_id: institucion.id, email_institucional: @registro_proveedor.email , telefono_institucional: @registro_proveedor.telefono)
    cargo = Cargo.where(nombre: 'Profesional Técnico')
    PersonaCargo.create(persona_id: persona.id, cargo_id: cargo.first.id, establecimiento_contribuyente_id: establecimiento.id)
  end

  def find_institucion
    region = Region.where(nombre: @registro_proveedor.region).first
    comuna = Comuna.where(nombre: @registro_proveedor.comuna).first
    institucion = Contribuyente.find(@registro_proveedor.contribuyente_id)
    actividad_economica = ActividadEconomica.where(codigo_ciiuv4: '702000')
    ActividadEconomicaContribuyente.create(actividad_economica_id: actividad_economica.first, contribuyente_id: institucion.id)
    establecimiento = EstablecimientoContribuyente.create(contribuyente_id: institucion.id, direccion: @registro_proveedor.direccion,  comuna_id: comuna.id, region_id: region.id , ciudad: @registro_proveedor.ciudad, casa_matriz: false)
    user = User.where(rut: @registro_proveedor.rut).first
    persona = Persona.create(user_id: user.id , contribuyente_id: institucion.id, email_institucional: @registro_proveedor.email , telefono_institucional: @registro_proveedor.telefono)
    cargo = Cargo.where(nombre: 'Profesional Técnico')
    PersonaCargo.create(persona_id: persona.id, cargo_id: cargo.first.id, establecimiento_contribuyente_id: establecimiento.id)
  end


  # Cargo.where(nombre: 'Profesional Técnico')
end
