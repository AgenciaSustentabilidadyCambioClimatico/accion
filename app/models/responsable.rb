class Responsable < ApplicationRecord
  belongs_to :tipo_instrumento
  belongs_to :rol
  belongs_to :cargo
  belongs_to :contribuyente, -> { includes [:actividad_economica_contribuyentes, :dato_anual_contribuyentes] }, optional: true
  belongs_to :actividad_economica, optional: true
  belongs_to :tipo_contribuyente, optional: true

  validates :tipo_instrumento_id, presence: true
  validates :rol_id, presence: true

  validates_presence_of :cargo_id, unless: proc { self.contribuyente.present? || self.actividad_economica_id.present? || self.tipo_contribuyente_id.present? }
  validates_presence_of :contribuyente_id, unless: proc { self.cargo_id.present? || self.actividad_economica_id.present? || self.tipo_contribuyente_id.present? }
  validates_presence_of :actividad_economica_id, unless: proc { self.cargo_id.present? || self.contribuyente.present? || self.tipo_contribuyente_id.present? }
  validates_presence_of :tipo_contribuyente_id, unless: proc { self.cargo_id.present? || self.contribuyente.present? || self.actividad_economica_id.present? }

  # =========================================================================
  # HELPERS INTERNOS DE MEMOIZACIÓN DE ÁRBOLES Y INSTRUMENTOS
  # =========================================================================
  def self.instrumentos_relacionados(instrumento_id)
    instrumento = TipoInstrumento.find_by(id: instrumento_id)
    [instrumento_id, instrumento&.tipo_instrumento_id].compact.uniq
  end

  def self.resolver_ae_ids(responsable, cache)
    return [] if responsable.actividad_economica_id.blank?

    cache[responsable.actividad_economica_id] ||= (
      [responsable.actividad_economica_id] + responsable.actividad_economica.get_children.pluck(:id)
    )
  end

  def self.resolver_tc_ids(responsable, cache)
    return [] if responsable.tipo_contribuyente_id.blank?

    cache[responsable.tipo_contribuyente_id] ||= (
      [responsable.tipo_contribuyente_id] + responsable.tipo_contribuyente.get_children_id
    )
  end

  # =========================================================================
  # VERIFICACIÓN DIRECTA DE ROL PARA EL USUARIO ACTUAL (O(1) / ~10ms)
  # =========================================================================
  def self.personas_tienen_rol?(rol_id, instrumento_id, personas_ids)
    return false if personas_ids.blank?

    instrumentos_id = instrumentos_relacionados(instrumento_id)

    cargos_por_persona = PersonaCargo.where(persona_id: personas_ids)
                                     .pluck(:persona_id, :cargo_id)
                                     .group_by(&:first)
                                     .transform_values { |pares| pares.map(&:last) }
    todos_los_cargos = cargos_por_persona.values.flatten.uniq

    responsables = includes(:actividad_economica, :tipo_contribuyente)
                     .where(rol_id: rol_id, tipo_instrumento_id: instrumentos_id)
                     .where("cargo_id IS NULL OR cargo_id IN (?)", todos_los_cargos.presence || [-1])
    return false if responsables.empty?

    personas = Persona.includes(contribuyente: [:actividad_economica_contribuyentes, :dato_anual_contribuyentes])
                      .where(id: personas_ids)

    ae_cache = {}
    tc_cache = {}

    responsables.any? do |r|
      aeid = resolver_ae_ids(r, ae_cache)
      tcid = resolver_tc_ids(r, tc_cache)

      personas.any? do |p|
        next false unless p.contribuyente
        next false if r.cargo_id.present? && !(cargos_por_persona[p.id] || []).include?(r.cargo_id)

        __info_contribuyente_optimized(p.contribuyente, r.contribuyente_id, aeid, tcid)
      end
    end
  end

  # =========================================================================
  # MÉTODOS DE CONSULTA OPTIMIZADOS
  # =========================================================================
  def self.intituciones_de_los_cogestores
    includes(:contribuyente)
      .where(rol_id: Rol::COGESTOR)
      .where.not(contribuyente_id: nil)
      .uniq(&:contribuyente_id)
      .map(&:contribuyente)
  end

  def self.responsables_solo_rol_fast(roles_id)
    personas = []
    tipo_instrumentos_ids = TipoInstrumento.all.map { |ti| ti.tipo_instrumento_id || ti.id }.uniq

    ae_cache = {}
    tc_cache = {}
    todos_pcs = PersonaCargo.includes(persona: { contribuyente: [:actividad_economica_contribuyentes, :dato_anual_contribuyentes] }).to_a
    pcs_por_cargo = todos_pcs.group_by(&:cargo_id)

    includes(:actividad_economica, :tipo_contribuyente)
      .where(rol_id: roles_id, tipo_instrumento_id: tipo_instrumentos_ids)
      .each do |r|
        ctid = r.contribuyente_id
        aeid = resolver_ae_ids(r, ae_cache)
        tcid = resolver_tc_ids(r, tc_cache)

        pcs = r.cargo_id.present? ? (pcs_por_cargo[r.cargo_id] || []) : todos_pcs
        pcs.each do |pc|
          next unless pc.persona&.contribuyente

          if __info_contribuyente_optimized(pc.persona.contribuyente, ctid, aeid, tcid)
            personas << pc.persona
          end
        end
      end

    personas.uniq
  end

  # DZC 2018-10-10 13:06:02 obtiene el array de personas proponentes de determinada institución
  def self.responsables_por_rol(roles_id, contribuyente_id = nil, tipo_instrumento_id = nil, user = nil)
    personas = []
    if tipo_instrumento_id.nil?
      TipoInstrumento.pluck(:id).each do |ti|
        personas += Responsable.__personas_responsables(roles_id, ti, nil, nil, nil, user)
      end
    else
      tipo_instrumento_id = [tipo_instrumento_id] unless tipo_instrumento_id.is_a?(Array)
      tipo_instrumento_id.each do |ti|
        personas += Responsable.__personas_responsables(roles_id, ti, nil, nil, nil, user)
      end
    end

    personas = personas.uniq.sort
    unless contribuyente_id.nil?
      contribuyente_id = [contribuyente_id] unless contribuyente_id.is_a?(Array)
      personas.select { |p| contribuyente_id.include?(p.contribuyente_id) }
    end
    personas
  end

  def self.__personas_responsables(rol_id, instrumento_id, contribuyente_id = nil, actividad_economica_id = nil, tipo_contribuyente_id = nil, user = nil)
    personas = []
    instrumentos_id = instrumentos_relacionados(instrumento_id)

    responsables = includes(:actividad_economica, :tipo_contribuyente)
                     .where(rol_id: rol_id, tipo_instrumento_id: instrumentos_id)
    responsables = responsables.where(contribuyente_id: contribuyente_id) unless contribuyente_id.nil?
    responsables = responsables.where(actividad_economica_id: actividad_economica_id) unless actividad_economica_id.nil?
    responsables = responsables.where(tipo_contribuyente_id: tipo_contribuyente_id) unless tipo_contribuyente_id.nil?

    ae_cache = {}
    tc_cache = {}

    if user.present?
      user_personas_raw = [user.session[:personas] || []].flatten
      user_persona_ids = user_personas_raw.map { |p| p[:id] }.compact.uniq
      return [] if user_persona_ids.empty?

      user_personas_cargos = PersonaCargo.where(persona_id: user_persona_ids).pluck(:cargo_id).uniq
      respon = responsables.select { |r| user_personas_cargos.include?(r.cargo_id) }
      return [] if respon.empty?

      personas_loaded = Persona.includes(
        contribuyente: [:actividad_economica_contribuyentes, :dato_anual_contribuyentes]
      ).where(id: user_persona_ids).to_a

      respon.each do |r|
        ctid = r.contribuyente_id
        aeid = resolver_ae_ids(r, ae_cache)
        tcid = resolver_tc_ids(r, tc_cache)

        personas_loaded.each do |persona|
          if persona.contribuyente && __info_contribuyente_optimized(persona.contribuyente, ctid, aeid, tcid)
            personas << persona
          end
        end
      end
    else
      all_personas = []
      todos_pcs = PersonaCargo.includes(:persona).to_a
      pcs_por_cargo = todos_pcs.group_by(&:cargo_id)

      responsables.each do |r|
        ctid = r.contribuyente_id
        aeid = resolver_ae_ids(r, ae_cache)
        tcid = resolver_tc_ids(r, tc_cache)

        pcs = r.cargo_id.present? ? (pcs_por_cargo[r.cargo_id] || []) : todos_pcs
        pcs.each do |pc|
          next unless pc.persona

          all_personas << { persona: pc.persona, ctid: ctid, aeid: aeid, tcid: tcid }
        end
      end

      contribuyente_ids = all_personas.map { |p| p[:persona].contribuyente_id }.compact.uniq
      contribuyentes_loaded = Contribuyente.includes(
        :actividad_economica_contribuyentes,
        :dato_anual_contribuyentes
      ).where(id: contribuyente_ids).index_by(&:id)

      all_personas.each do |p|
        contribuyente = contribuyentes_loaded[p[:persona].contribuyente_id]
        if contribuyente && __info_contribuyente_optimized(contribuyente, p[:ctid], p[:aeid], p[:tcid])
          personas << p[:persona]
        end
      end
    end

    personas.uniq
  end

  def self.__personas_responsables_v2(rol_id, instrumento_id, contribuyente_id = nil, actividad_economica_id = nil, tipo_contribuyente_id = nil)
    __personas_responsables_v3(rol_id, instrumento_id, contribuyente_id, actividad_economica_id, tipo_contribuyente_id)
  end

  def self.__personas_responsables_v3(rol_id, instrumento_id, contribuyente_id = nil, actividad_economica_id = nil, tipo_contribuyente_id = nil)
    personas = Set.new
    all_personas = []
    instrumentos_id = instrumentos_relacionados(instrumento_id)

    ae_cache = {}
    tc_cache = {}
    todos_pcs = PersonaCargo.includes(:persona).to_a
    pcs_por_cargo = todos_pcs.group_by(&:cargo_id)

    responsables = includes(:actividad_economica, :tipo_contribuyente)
                     .where(rol_id: rol_id, tipo_instrumento_id: instrumentos_id)

    responsables.find_each do |r|
      ctid = r.contribuyente_id
      aeid = resolver_ae_ids(r, ae_cache)
      tcid = resolver_tc_ids(r, tc_cache)

      pcs = r.cargo_id.present? ? (pcs_por_cargo[r.cargo_id] || []) : todos_pcs
      pcs.each do |pc|
        next unless pc.persona

        all_personas << { persona: pc.persona, ctid: ctid, aeid: aeid, tcid: tcid }
      end
    end

    contribuyente_ids = all_personas.map { |p| p[:persona].contribuyente_id }.compact.uniq
    contribuyentes_loaded = Contribuyente.includes(
      :actividad_economica_contribuyentes,
      :dato_anual_contribuyentes
    ).where(id: contribuyente_ids).index_by(&:id)

    all_personas.each do |p|
      contribuyente = contribuyentes_loaded[p[:persona].contribuyente_id]
      if contribuyente && __info_contribuyente_optimized(contribuyente, p[:ctid], p[:aeid], p[:tcid], contribuyente_id, actividad_economica_id, tipo_contribuyente_id)
        personas.add(p[:persona])
      end
    end

    personas.to_a
  end

  def self.__info_contribuyente_v2(cpo, ctid, aeid, tcid)
    __info_contribuyente_optimized(cpo, ctid, aeid, tcid)
  end

  def self.__info_contribuyente(cpo, ctid, aeid, tcid, c_extra = nil, ae_extra = nil, tc_extra = nil)
    __info_contribuyente_optimized(cpo, ctid, aeid, tcid, c_extra, ae_extra, tc_extra)
  end

  def self.__info_contribuyente_optimized(cpo, ctid, aeid, tcid, c_extra = nil, ae_extra = nil, tc_extra = nil)
    coincide = true

    unless ctid.blank?
      coincide = (ctid.to_i == cpo.id.to_i)
    end

    if !aeid.blank? && coincide
      ae_ids = cpo.actividad_economica_contribuyentes.map(&:actividad_economica_id)
      coincide = !(ae_ids & aeid).blank?
    end

    if !tcid.blank? && coincide
      tc_ids = cpo.dato_anual_contribuyentes.map(&:tipo_contribuyente_id)
      coincide = !(tc_ids & tcid).blank?
    end

    if !c_extra.blank? && coincide
      coincide = (c_extra.to_i == cpo.id.to_i)
    end

    if !ae_extra.blank? && coincide
      ae_ids = cpo.actividad_economica_contribuyentes.map(&:actividad_economica_id)
      coincide = ae_ids.include?(ae_extra.to_i)
    end

    if !tc_extra.blank? && coincide
      tc_ids = cpo.dato_anual_contribuyentes.map(&:tipo_contribuyente_id)
      coincide = tc_ids.include?(tc_extra.to_i)
    end

    coincide
  end

  def self.__personas_responsables_por_instrumento(rol_id, instrumento_id, institucion)
    cargos = Responsable.where(rol_id: rol_id, tipo_instrumento_id: instrumento_id).select('cargo_id')
    personas_cargos = PersonaCargo.where(cargo_id: cargos).select('persona_id')
    Persona.where(id: personas_cargos).select('user_id').distinct
  end

  def self.__instituciones_con_rol(rol_id, tipo_instrumento_id, contribuyente_id)
    posee_rol = false
    contribuyente = Contribuyente.includes(:actividad_economica_contribuyentes, :dato_anual_contribuyentes).find(contribuyente_id)
    instrumentos_id = instrumentos_relacionados(tipo_instrumento_id)

    ae_cache = {}
    tc_cache = {}
    actividades_economicas_contribuyente = contribuyente.actividad_economica_contribuyentes.map(&:actividad_economica_id)
    tipo_contribuyentes = contribuyente.dato_anual_contribuyentes.map(&:tipo_contribuyente_id)

    responsables = Responsable.includes(:actividad_economica, :tipo_contribuyente)
                              .where(rol_id: rol_id, tipo_instrumento_id: instrumentos_id)
    responsables.each do |r|
      break if posee_rol

      ct_id = r.contribuyente_id
      aeid = resolver_ae_ids(r, ae_cache)
      tcid = resolver_tc_ids(r, tc_cache)

      if ct_id.present?
        if contribuyente_id == ct_id && !(actividades_economicas_contribuyente & aeid).blank?
          posee_rol = true
        end
      else
        posee_rol = true
        posee_rol = false if !aeid.blank? && (actividades_economicas_contribuyente & aeid).blank?
        posee_rol = false if !tcid.blank? && (tipo_contribuyentes & tcid).blank?
      end
    end

    posee_rol
  end

  def self.__tipo_instrumento_por_persona_rol(roles_id, personas)
    return [] if personas.blank?

    persona_ids = personas.map(&:id)
    cargos_por_persona = PersonaCargo.where(persona_id: persona_ids)
                                     .pluck(:persona_id, :cargo_id)
                                     .group_by(&:first)
                                     .transform_values { |pares| pares.map(&:last) }
    todos_cargos = cargos_por_persona.values.flatten.uniq
    return [] if todos_cargos.empty?

    responsables_loaded = where(rol_id: roles_id, cargo_id: todos_cargos)
                          .pluck(:cargo_id, :contribuyente_id, :tipo_instrumento_id)

    tipo_instrumentos = []
    personas.each do |persona|
      c_ids = cargos_por_persona[persona.id] || []
      responsables_loaded.each do |cargo_id, contrib_id, ti_id|
        next unless c_ids.include?(cargo_id)

        if contrib_id.nil? || contrib_id == persona.contribuyente_id
          tipo_instrumentos << ti_id
        end
      end
    end

    tipo_instrumentos.uniq
  end

  def self.__roles_por_persona(personas)
    return [] if personas.blank?

    persona_ids = personas.map(&:id)
    cargos_por_persona = PersonaCargo.where(persona_id: persona_ids)
                                     .pluck(:persona_id, :cargo_id)
                                     .group_by(&:first)
                                     .transform_values { |pares| pares.map(&:last) }
    todos_cargos = cargos_por_persona.values.flatten.uniq
    return [] if todos_cargos.empty?

    responsables_loaded = where(cargo_id: todos_cargos)
                          .pluck(:cargo_id, :contribuyente_id, :rol_id)

    roles = []
    personas.each do |persona|
      c_ids = cargos_por_persona[persona.id] || []
      responsables_loaded.each do |cargo_id, contrib_id, r_id|
        next unless c_ids.include?(cargo_id)

        if contrib_id.nil? || contrib_id == persona.contribuyente_id
          roles << r_id
        end
      end
    end

    roles.uniq
  end

  def self.__contribuyentes_por_rol(rol_id, tipo_instrumento_id)
    where_parts = []
    ae_cache = {}
    tc_cache = {}

    responsables = Responsable.includes(:actividad_economica, :tipo_contribuyente)
                              .where(rol_id: rol_id, tipo_instrumento_id: tipo_instrumento_id)
    responsables.each do |r|
      conditions = []
      conditions << "contribuyentes.id = #{r.contribuyente_id.to_i}" unless r.contribuyente_id.blank?

      unless r.actividad_economica_id.blank?
        aeid = resolver_ae_ids(r, ae_cache)
        conditions << "actividad_economica_contribuyentes.actividad_economica_id IN (#{aeid.join(',')})"
      end

      unless r.tipo_contribuyente_id.blank?
        tcid = resolver_tc_ids(r, tc_cache)
        conditions << "dato_anual_contribuyentes.tipo_contribuyente_id IN (#{tcid.join(',')})"
      end

      where_parts << "(#{conditions.join(' AND ')})" unless conditions.empty?
    end

    return [] if where_parts.empty?

    Contribuyente.joins([:actividad_economica_contribuyentes, :dato_anual_contribuyentes])
                 .where(where_parts.join(' OR '))
  end

  def self._cargos_por_rol_empresa(rol_id, tipo_instrumento_id, contribuyente_id)
    cargos = []
    instrumentos_id = instrumentos_relacionados(tipo_instrumento_id)
    ae_cache = {}
    tc_cache = {}

    contribuyente = Contribuyente.includes(:actividad_economica_contribuyentes, :dato_anual_contribuyentes)
                                 .find_by(id: contribuyente_id)
    return [] unless contribuyente

    responsables = Responsable.includes(:cargo, :actividad_economica, :tipo_contribuyente)
                              .where(rol_id: rol_id, tipo_instrumento_id: instrumentos_id)
    responsables.each do |r|
      aeid = resolver_ae_ids(r, ae_cache)
      tcid = resolver_tc_ids(r, tc_cache)

      if __info_contribuyente_optimized(contribuyente, r.contribuyente_id, aeid, tcid)
        cargos << r.cargo if r.cargo
      end
    end

    cargos
  end
end