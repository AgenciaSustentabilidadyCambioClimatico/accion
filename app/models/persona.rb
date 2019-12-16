class Persona < ApplicationRecord
	belongs_to :user
	belongs_to :contribuyente
	belongs_to :establecimiento_contribuyente, optional: true
	has_many :mapa_de_actores, dependent: :destroy
	has_many :persona_cargos, foreign_key: :persona_id, dependent: :destroy
	# has_many :adhesion_elementos, dependent: :destroy
	has_many :convocatoria_destinatarios, foreign_key: :destinatario_id, dependent: :destroy #DZC 2018-10-10 15:44:07
	accepts_nested_attributes_for :persona_cargos, :allow_destroy => true, reject_if: proc {|data| data['establecimiento_contribuyente_id'].blank? && data['cargo_id'].blank? }

	has_many :tarea_pendientes #, dependent: :destroy # DZC 2019-08-16 19:19:36 se debe descomentar según se decida el tratamiento para eliminación de relaciones persona en mantenedor de usuarios.

	validates :contribuyente_id, presence: true
  validates :email_institucional, presence: true, format: { with: /\A([\w\.%\+\-]+)@([\w\-]+\.)+([\w]{2,})\z/i }
  # DZC 2018-11-02 15:05:11 se modifica la condicion allow_blank a objeto de que el mantenedor de usuarios permita que el campo venga nulo
  validates :telefono_institucional, numericality: true, length: {in: 8..11}, allow_blank: true

  attr_accessor :establecimientos_data


  
  def contribuyente
    super || (Contribuyente.unscoped.find(self.contribuyente_id) if self.contribuyente_id.present?)
  end

  def user
    super || (User.unscoped.find(self.user_id) if self.user_id.present?)
  end

	def self.responsables_select(not_in=[])
    u=User
    u=u.where("id NOT IN (?)",not_in) if not_in.size > 0
    u.all.map {|u|["<label>#{u.rut}</label> - #{u.nombre_completo}".html_safe, u.id]} << ['','']
	end

	def self.responsables_por_rol_tipo_instrumento_select(rol_id,tipos_instrumentos_ids)
		self.to_select(
			:"user.nombre_completo",
			:"id",
			self.responsables_por_rol_tipo_instrumento(rol_id,tipos_instrumentos_ids)
			)
	end

	def self.responsables_por_rol_tipo_instrumento(rol_id,tipos_instrumentos_ids)
	  # me traigo los responsables por rol y tipo de intrumento en especifico
	  responsables = Responsable.where(rol: rol_id).where(tipo_instrumento_id: tipos_instrumentos_ids)#.includes(:contribuyente) # obtengo los cargos e instituciones
	  # si no viene las instituciones
	  # busco instituciones por actividad economica o tipo contribuyente (dato_anual_contribuyentes)
	  # y con esto busco en personas por cargo e institucion

	  instituciones_id = []
	  actecos_id = []
	  tip_cont_id = []
	  cargos_id = []

	  responsables.each do |responsable|
	    # obtengo las instituciones que vienen por rol y tipo instrumento
	    instituciones_id << responsable.contribuyente_id unless responsable.contribuyente_id.blank?
	    # obtengo las actecos que vienen por rol y tipo instrumento
	    # obtengo las actecos que vienen por rol y tipo instrumento
	    actecos_id << responsable.actividad_economica_id unless responsable.actividad_economica_id.blank?
	    # obtengo los tipo contribuyente que vienen por rol y tipo instrumento
	    tip_cont_id << responsable.tipo_contribuyente_id unless responsable.tipo_contribuyente_id.blank?
	    # obtengo los tipo contribuyente que vienen por rol y tipo instrumento
	    cargos_id << responsable.cargo_id unless responsable.cargo_id.blank?
	  end

	  # registros por tipo contribuyente
	  # muchos registros
	  instituciones_id += DatoAnualContribuyente.where(periodo: Date.today.year).where(tipo_contribuyente_id: tip_cont_id).map{ |e| e.contribuyente_id}

	  # registros por actividad_economica
	  # muchos registros
	  instituciones_id += ActividadEconomicaContribuyente.where(actividad_economica: actecos_id).map{ |e| e.contribuyente_id}

	  personas_id = []
	  # me traigo todos los id de personas de los cargos
	  personas_id = PersonaCargo.where(cargo_id: cargos_id).map { |e|  e.persona_id}


	  Persona.where("id IN (?) AND contribuyente_id IN (?)",personas_id,instituciones_id).includes(:user) #.map { |e|  [e.nombres, e.id]}
	end

	def es_proponente?
		es = false
		cargo_ids = Cargo.__normalizar(self.persona_cargos.map{|p|p.cargo_id})
		unless cargo_ids.size == 0
			es = Responsable.where(cargo_id: cargo_ids, rol_id: Rol::PROPONENTE).all.size > 0
		end
		es
	end

	def self.de_la_institucion(contribuyente_id,user_id)
		Persona.where(contribuyente_id: contribuyente_id, user_id: user_id).first
	end

	def self.por_institucion(contribuyente_id)
			Persona.where(contribuyente_id: contribuyente_id).includes(:user).all
	end

	def self.por_institucion_cargo(contribuyente_id, cargo, seleccionado=nil, seleccion= false)
		#permite obtener todos los usuarios que poseen un cargo espeficco en una institucion.
		persona_cargos = PersonaCargo.where(cargo_id: cargo).pluck("persona_id")
		#permite detiminar si se esta agregan un usuario que no se encuentra en la institucion
		nuevo_usuario = false
		if seleccion
			personas = Persona.where(contribuyente_id: contribuyente_id, id: persona_cargos).includes(:user).pluck('users.nombre_completo', 'users.id')
		else
			personas = Persona.where(contribuyente_id: contribuyente_id, id: persona_cargos).includes(:user).all
		end
		if seleccionado.present?
			unless Persona.where(contribuyente_id: contribuyente_id, id: persona_cargos).includes(:user).pluck('users.id').include?(seleccionado.id)
				nuevo_usuario = true
				personas << [seleccionado.nombre_completo, seleccionado.id]
			end
		end
		resultado = [personas, nuevo_usuario]
	end
end
