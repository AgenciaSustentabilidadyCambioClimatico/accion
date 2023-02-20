class RegistroProveedor::UpdateService
  def initialize(registro_proveedor, params, asociar_institucion, contribuyente_id, rut_institucion)
    @registro_proveedor = registro_proveedor
    @params = params
    @asociar_institucion = asociar_institucion
    @contribuyente_id = contribuyente_id
    @rut_institucion = rut_institucion
  end

  def perform
    if @params[:asociar_institucion] == 0 && @asociar_institucion != false
      create_and_update_instituciones
    elsif @params[:asociar_institucion] == 1 && @asociar_institucion == false
      update_persona_cargo
    elsif @params[:asociar_institucion] == 1 && @asociar_institucion == true
      update_persona_cargo_2
    end
    update_region_and_comuna
  end

  def create_and_update_instituciones
    quitar_persona_cargo_de_institucion
    create_institucion
  end


  def update_persona_cargo
    quitar_persona_cargo_de_institucion_legal
    if @params[:contribuyente_id].present?
      find_institucion
    else
      create_institucion_with_user_data
    end
  end

  def update_persona_cargo_2
    quitar_persona_cargo_de_institucion
    if @params[:contribuyente_id].present?
      unless @params[:contribuyente_id] == @registro_proveedor.contribuyente_id
        find_institucion
      end
    else
      create_institucion_with_user_data
    end
  end


  def quitar_persona_cargo_de_institucion_legal
    user = User.where(rut: @registro_proveedor.rut).first
    persona = Persona.where(user_id: user.id).first
    cargo = Cargo.where(nombre: 'Representante Legal')
    persona_cargo = PersonaCargo.where(persona_id: persona.id, cargo_id: cargo.first.id).first
    persona_cargo.destroy unless persona_cargo.nil?
  end

  def quitar_persona_cargo_de_institucion
    user = User.where(rut: @registro_proveedor.rut).first
    persona = Persona.where(user_id: user.id).first
    cargo = Cargo.where(nombre: 'Profesional Técnico')
    persona_cargo = PersonaCargo.where(persona_id: persona.id, cargo_id: cargo.first.id).first
    persona_cargo.destroy unless persona_cargo.nil?
  end

  def update_region_and_comuna
    region = Region.find(@params[:region].to_i).nombre
    comuna = Comuna.find(@params[:comuna].to_i).nombre
    @registro_proveedor.update(region: region, comuna: comuna)
    if @params[:region_casa_matriz].present? && @params[:comuna_casa_matriz].present?
      region_casa_matriz = Region.find(@params[:region_casa_matriz].to_i).nombre
      comuna_casa_matriz = Comuna.find(@params[:comuna_casa_matriz].to_i).nombre
      @registro_proveedor.update(region_casa_matriz: region_casa_matriz, comuna_casa_matriz: comuna_casa_matriz)
    end
  end

  # def update_user
  #   rut = @registro_proveedor.rut
  #   nombre_completo = "#{@registro_proveedor.nombre} #{@registro_proveedor.apellido}"
  #   telefono = @registro_proveedor.telefono
  #   user_proveedor = User.find_by(rut: rut)
  #   user_proveedor.update(nombre_completo: nombre_completo, telefono: telefono)
  # end

  def create_institucion
    rut = @registro_proveedor.rut
    dv = @registro_proveedor.rut.chars.last
    razon_social = "#{@params[:nombre]} #{@params[:nombre]}"
    region = Region.where(nombre: @params[:region]).first
    comuna = Comuna.where(nombre: @params[:comuna]).first
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
    region = Region.where(nombre: @params[:region]).first
    comuna = Comuna.where(nombre: @params[:comuna]).first
    institucion = Contribuyente.find(@params[:contribuyente_id].to_i)
    actividad_economica = ActividadEconomica.where(codigo_ciiuv4: '702000')
    ActividadEconomicaContribuyente.create(actividad_economica_id: actividad_economica.first, contribuyente_id: institucion.id)
    establecimiento = EstablecimientoContribuyente.create(contribuyente_id: institucion.id, direccion: @registro_proveedor.direccion, comuna_id: comuna.id, region_id: region.id , ciudad: @registro_proveedor.ciudad, casa_matriz: false)
    user = User.where(rut: @registro_proveedor.rut).first
    persona = Persona.create(user_id: user.id , contribuyente_id: institucion.id, email_institucional: @registro_proveedor.email , telefono_institucional: @registro_proveedor.telefono)
    cargo = Cargo.where(nombre: 'Profesional Técnico')
    PersonaCargo.create(persona_id: persona.id, cargo_id: cargo.first.id, establecimiento_contribuyente_id: establecimiento.id)
  end
end
