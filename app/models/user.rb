class User < ApplicationRecord
  attr_accessor :is_admin, :updated, :current, :claveunica
  has_many :equipo_trabajos
  has_many :personas, dependent: :destroy
  has_many :contribuyentes, through: :personas
  has_many :persona_cargos, through: :personas
  has_many :tarea_pendientes, dependent: :destroy
  has_many :mapa_de_actores, through: :personas
  has_many :registro_apertura_correos, dependent: :destroy # DZC 2019-08-06 15:57:06 se agrega dependencia para destroy
  belongs_to :user, optional: true
  accepts_nested_attributes_for :personas, :allow_destroy => true#, reject_if: :all_blank
  serialize :fields_visibility
  serialize :session

  ROOT  = 1
  ADMIN = 2
  USER  = 3 #User test

  BASIC = [ROOT, ADMIN, USER]

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :invitable, :database_authenticatable, :registerable, :recoverable, :rememberable, :trackable, :validatable
  validates :rut, presence: true
  validates :rut, rut: true, if: -> { !rut.blank? && rut != "no" }
  validates :nombre_completo, presence: true
  validates :telefono, numericality: true, length: {in: 8..11}, allow_blank: false, if: -> { !claveunica }
  validates :email, presence: true, if: -> { !claveunica }
  validates :email, format: { with: /\A([\w\.%\+\-]+)@([\w\-]+\.)+([\w]{2,})\z/i }, if: -> { !email.blank? && email != "no"}
  validates_uniqueness_of :email, on: :create, if: ->  {email != "no" }
  validates_uniqueness_of :rut, on: :create, if: ->  {rut != "no" }

  attr_accessor :rol, :cargo

  before_validation :normalizar_rut, if: ->  {rut != "no" }
  before_save :clear_no_data

  default_scope { where(temporal: false) }

  def clear_no_data
    self.rut = "" if self.rut == "no"
    self.email = "" if self.email == "no"
  end

  def persona_segun_(contribuyente_id)
    self.personas.map{|p|p if (p.contribuyente_id == contribuyente_id) }.compact.first
  end

  def normalizar_rut
    self.rut = self.rut.to_s.upcase.gsub(/[^0-9\-K]/,'') unless self.rut.blank?
  end

  # def nombre_completo
  #   "#{self.nombres} #{self.apellido_paterno} #{self.apellido_materno}"
  # end

  def self.__for_choosen
    self.order(rut: :asc).all.map{|u|["#{u.rut} - #{u.nombre_completo}",u.id]}
  end

  def is_root?
    self.persona_cargos.map{|m|m.cargo_id}.include?(Cargo::ROOT)
  end

  def is_proponente?(flujo_id)
    # session[:cargos].include?(Cargo::PROPONENTE)
    MapaDeActor.where(flujo_id: flujo_id, persona_id: self.personas.pluck(:id)).pluck(:rol_id).include?(Rol::PROPONENTE)
    # self.persona_cargos.pluck(:cargo_id).include?(Cargo::PROPONENTE)
  end

  #Se concidera administrador solo a aquel que posea el cargo adminsitrado dentro de la agencia
  def is_admin?
    cargos = []
    self.personas.each do |p|
      cargos += p.persona_cargos.map{|cp| cp.cargo_id}
    end
    # DZC 2018-11-19 14:28:39 se agrega como administrador al root, para efectos de control y acceso a solución de problemas
    if cargos.include?(Cargo::ROOT)# || session[:cargos].include?(Cargo::ADMIN)
      true
    else
      ascc = Contribuyente.find_by_rut(75980060)
      personas_ascc = self.personas.where(contribuyente_id: ascc.id)
      self.persona_cargos.where(persona_id: personas_ascc).pluck(:cargo_id).include?(Cargo::ADMIN)
    end
  end

  #Aquel que posea el cargo adminsitrador fuera de la agencia
  def is_admin_no_agencia?
    self.persona_cargos.pluck(:cargo_id).include?(Cargo::ADMIN)
  end

  #devuelve las instituciones en donde es adminstrador.-
  def instituciones_donde_es_admin
    persona_cargos_user = persona_cargos.where(cargo_id: Cargo::ADMIN)
    personas_user = personas.where(id: persona_cargos_user.pluck('persona_id'))
    contribuyentes = Contribuyente.where(id: personas_user.pluck('contribuyente_id'))
    contribuyentes.ids
  end

  #DZC averigua si usuario posee alguno de los roles señalados en el array roles, como por ejemplo [Rol::JEFE_DE_LINEA]
  def posee_rol_ascc? (roles=nil)
    #DZC si se ingresa un rol como simple numero, lo transforma en Array 
    (roles = (roles.class == Array)? roles : [roles]) if (roles.class == Integer) 
    lo_es = false
    personas = self.personas
    cargos = []
    self.personas.each do |p|
      cargos += p.persona_cargos.map{|cp| cp.cargo_id}
    end
    contribuyentes_de_usuario_id = []
    contribuyentes_de_usuario_id = personas.map{|p| p[:contribuyente_id]}
    contribuyentes_de_usuario_rut = Contribuyente.where(id: contribuyentes_de_usuario_id).pluck(:rut)
    unless ([75980060] & contribuyentes_de_usuario_rut).blank?
      cargos_en_tabla_responsables = Responsable.where(rol_id: roles).includes([:contribuyente]).where("contribuyentes.rut" => 75980060).uniq.pluck(:cargo_id)
      lo_es = !(cargos & cargos_en_tabla_responsables).blank?
    end
    lo_es
  end

  def is_ascc?
    !self.personas.includes(:contribuyente).where(contribuyentes: {rut: 75980060}).blank?
  end

  def mis_instituciones
    personas.map{|p| p[:contribuyente_id]}
  end

  def is_encargado_institucion?
    #se asume que el cargo de encarga de institucion es siempre 14
    persona_cargos.pluck(:cargo_id).include?(Cargo::ENCARGADO_INS)
  end

  def is_encargado_institucion_solicitada? institucion
    #se asume que el cargo de encarga de institucion es siempre 14
    #Si es administrador posee todos los permisos, y sino se valida que posea el cargo.-
    if self.is_admin?
      true
    else
      personas_institucion = personas.where(contribuyente_id: institucion.id)
      persona_cargos.where(persona_id: personas_institucion).pluck(:cargo_id).include?(14)
    end
  end

  def is_coordinador?
    #self.cargo_users.map{|m|m.cargo_id}.include?(Cargo::COORDINADOR)
  end

  def is_cogestor?
    #self.cargo_users.map{|m|m.cargo_id}.include?(Cargo::CO_GESTOR)
  end

  def is_responsable?
    personas = Responsable.__personas_responsables_v2(Rol::RESPONSABLE_ENTREGABLES, TipoInstrumento::ACUERDO_DE_PRODUCCION_LIMPIA)
    personas.select{|p| p.user_id = self.id}.first
  end

  #Jamás podremos borrar al usuario root, admin ni user
  def destroy
    unless BASIC.include?(self.id)
      super
    end
  end

  #Determina si el usuario es editable, considerando que no este asociado a un mapa de actores o que no tenga tareas pendientes.-
  def editable?
    mapas_asociados = Flujo.where(id: self.mapa_de_actores.pluck('flujo_id')).where(terminado: false)
    tarea_pendientes_asociadas = self.tarea_pendientes.where(estado_tarea_pendiente_id: 1)
    (mapas_asociados.count == 0 && tarea_pendientes_asociadas.count == 0)
  end

  def self.nombre_por_rut(rut=nil)
    rut = [rut] if !rut.blank? && !rut.is_a?(Array)
    usuarios = self.where(rut: rut).uniq.map do |u|
      
      "#{u[:rut]}"+" - "+ "#{u[:nombre_completo]}"
    end
    usuarios.to_sentence
  end

  def password_required?
    return false if temporal
    super
  end

  def clonar_con_relaciones
    user_temporal = self.dup
    user_temporal.user_id = self.id
    user_temporal.reset_password_token = nil
    user_temporal.save(validate: false)
    user_temporal
  end

  def confirmar_temporal
    if(self.user_id.nil?)
      #Es nuevo
      user_final = self
      user_final.temporal = false
      user_final.flujo_id = nil
      user_final.save
    else
      #Se edito uno existente
      user_final = User.find(self.user_id)

      #Primero los valores del padre
      user_final.telefono = self.telefono
      user_final.email = self.email
      user_final.nombre_completo = self.nombre_completo
      user_final.save(validate: false)
    end
    user_final
  end

  def update_without_password(params, *options)
    if params[:password].blank?
      params.delete(:password)
      params.delete(:password_confirmation) if params[:password_confirmation].blank?
    end

    result = update_attributes(params, *options)
    clean_up_passwords
    result
  end
end
