class Responsable < ApplicationRecord
  belongs_to :tipo_instrumento
  belongs_to :rol
  belongs_to :cargo
  belongs_to :contribuyente, -> { includes [:actividad_economica_contribuyentes,:dato_anual_contribuyentes] }, optional: true
  belongs_to :actividad_economica, optional: true
  belongs_to :tipo_contribuyente, optional: true

  validates :tipo_instrumento_id, presence: true
  validates :rol_id, presence: true

  validates_presence_of :cargo_id, unless: proc { self.contribuyente.present? || self.actividad_economica_id.present? || self.tipo_contribuyente_id.present? }
  validates_presence_of :contribuyente_id, unless: proc { self.cargo_id.present? || self.actividad_economica_id.present? || self.tipo_contribuyente_id.present? }
  validates_presence_of :actividad_economica_id, unless: proc { self.cargo_id.present? || self.contribuyente.present? || self.tipo_contribuyente_id.present? }
  validates_presence_of :tipo_contribuyente_id, unless: proc { self.cargo_id.present? || self.contribuyente.present? || self.actividad_economica_id.present? }

  def self.intituciones_de_los_cogestores
    self.includes([:contribuyente]).where("rol_id = #{Rol::COGESTOR} AND contribuyente_id IS NOT NULL").all.uniq{|m|m.contribuyente_id}.map{|m|m.contribuyente}
  end

  def self.responsables_solo_rol_fast(roles_id)
    personas=[]
    tipo_instrumentos_ids = TipoInstrumento.all.map{|ti| ti.tipo_instrumento_id || ti.id }
    self.where(rol_id: roles_id)
      .where(tipo_instrumento_id: tipo_instrumentos_ids).each do |r|  
      cgid = r.cargo_id
      ctid = r.contribuyente_id
      aeid = []
      if !r.actividad_economica_id.blank?
        aeid = [r.actividad_economica_id]
        aeid += r.actividad_economica.get_children.pluck(:id)
      end
      tcid = []
      if !r.tipo_contribuyente_id.blank?
        tcid = [r.tipo_contribuyente_id]
        tcid += r.tipo_contribuyente.get_children_id
      end

      personas_cargos = PersonaCargo.includes([:persona])
      personas_cargos = personas_cargos.where(cargo_id: r.cargo_id) unless r.cargo_id.blank?
      personas_cargos.each do |pc|
        if __info_contribuyente(pc.persona.contribuyente,ctid,aeid,tcid)
          personas << pc.persona
        end
      end

    end
    personas.uniq
  end
# DZC 2018-10-10 13:06:02 obtiene el array de personas proponentes de determinada institución
  def self.responsables_por_rol(roles_id, contribuyente_id=nil, tipo_instrumento_id=nil, user=nil)
    personas=[]
    # roles_id = [roles_id] if !roles_id.is_a?(Array)
    if tipo_instrumento_id.nil?
      TipoInstrumento.pluck(:id).each do |ti|
        # roles_id.each do |rol_id|
        
          personas += Responsable.__personas_responsables(roles_id, ti, nil, nil, nil, user)
        # end
      end
    else
      tipo_instrumento_id = [tipo_instrumento_id] if !tipo_instrumento_id.is_a?(Array)
      tipo_instrumento_id.each do |ti|
        
        personas += Responsable.__personas_responsables(roles_id, ti, nil, nil, nil, user)
        
      end
    end

    personas = personas.uniq.sort
    # DZC 2018-10-10 15:31:26 filtra personas por contribuyente o contribuyentes, si no viene nulo
    unless contribuyente_id.nil?
      contribuyente_id = [contribuyente_id] if !contribuyente_id.is_a?(Array)
      personas.select do |p|  
        
        contribuyente_id.include?(p.contribuyente_id)
      end
    end
    personas
  end

  def self.__personas_responsables(rol_id, instrumento_id, contribuyente_id=nil, actividad_economica_id=nil, tipo_contribuyente_id=nil, user=nil)
    personas = []
    instrumentos_id =[]
    instrumentos_id << instrumento_id
    

    instrumentos_id << TipoInstrumento.where(id: instrumento_id).first.tipo_instrumento_id unless TipoInstrumento.find_by(id: instrumento_id).tipo_instrumento_id.blank? #DZC agrega instrumento_id padre, en caso de que instrumento_id sea hijo
    
    
    # instrumentos_id += TipoInstrumento.where(tipo_instrumento_id: instrumento_id).all.pluck(:id) if TipoInstrumento.find_by(id: instrumento_id).tipo_instrumento_id.blank? #DZC agrega todos los instrumentos hijos
    
    instrumentos_id.uniq #DZC elimina repetidos
    
    
    #DZC TODO: Se debe modificar para contemplar todas las combinaciones de reglas posibles segun valores de tabla responsables
    #DZC TODO: Se debe leer el tipo de instrumento desde la instancia del proceso (manifestación, ppf, ppp) y no desde la tarea 
    
    responsables = self.where(rol_id: rol_id).where(tipo_instrumento_id: instrumentos_id)
    
    responsables = responsables.where(contribuyente_id: contribuyente_id) if(!contribuyente_id.nil?)
    
    responsables = responsables.where(actividad_economica_id: actividad_economica_id) if(!actividad_economica_id.nil?)
    
    responsables = responsables.where(tipo_contribuyente_id: tipo_contribuyente_id) if(!tipo_contribuyente_id.nil?)

    if (user.present?)
      user_personas = user.session[:personas]
      user_personas_cargos = user_personas.map{ |p| PersonaCargo.includes([:persona]).where(persona_id: p[:id]).pluck(:cargo_id) }.flatten
      respon = responsables.filter{ |r| user_personas_cargos.include?(r.cargo_id) }
      all_user_personas = []
      respon.each do |r|
        cgid = r.cargo_id
      
        ctid = r.contribuyente_id
        
        aeid = []
        if !r.actividad_economica_id.blank?
          aeid = [r.actividad_economica_id]
          aeid += r.actividad_economica.get_children.pluck(:id)
        end
        tcid = []
        if !r.tipo_contribuyente_id.blank?
          tcid = [r.tipo_contribuyente_id]
          tcid += r.tipo_contribuyente.get_children_id
        end
        user_personas = [user.session[:personas]].flatten
        user_personas.each do |p|
              persona = Persona.includes([:contribuyente]).find(p[:id])
              all_user_personas << { persona: persona, ctid: ctid, aeid: aeid, tcid: tcid }
         end
        end
         
      # OPTIMIZACIÓN: Hacer un solo includes para todos los contribuyentes
      contribuyente_ids = all_user_personas.map { |p| p[:persona].contribuyente_id }.compact.uniq
      contribuyentes_loaded = Contribuyente.includes(
        :actividad_economica_contribuyentes,
        :dato_anual_contribuyentes
      ).where(id: contribuyente_ids).index_by(&:id)
      
      # Ahora procesar con datos ya cargados
      all_user_personas.each do |p|
        contribuyente = contribuyentes_loaded[p[:persona].contribuyente_id]
        if contribuyente && self.__info_contribuyente_optimized(contribuyente, p[:ctid], p[:aeid], p[:tcid])
          personas << p[:persona]
        end
      end
    else
      all_personas = []
    # self.where(rol_id: rol_id)
    #   .where("cargo_id IS NOT NULL")

      responsables.each do |r|  
        cgid = r.cargo_id
        
        ctid = r.contribuyente_id
        
        aeid = []
        if !r.actividad_economica_id.blank?
          aeid = [r.actividad_economica_id]
          aeid += r.actividad_economica.get_children.pluck(:id)
        end
        tcid = []
        if !r.tipo_contribuyente_id.blank?
          tcid = [r.tipo_contribuyente_id]
          tcid += r.tipo_contribuyente.get_children_id
        end
        if r.cargo_id.blank? == false       
          PersonaCargo.includes([:persona]).where(cargo_id: r.cargo_id).each do |pc|
            all_personas << { persona: pc.persona, ctid: ctid, aeid: aeid, tcid: tcid }
          end
        else
          PersonaCargo.includes([:persona]).each do |pc|
            all_personas << { persona: pc.persona, ctid: ctid, aeid: aeid, tcid: tcid }
          end
        end
      end
      
      # OPTIMIZACIÓN: Hacer un solo includes para todos los contribuyentes
      contribuyente_ids = all_personas.map { |p| p[:persona].contribuyente_id }.compact.uniq
      contribuyentes_loaded = Contribuyente.includes(
        :actividad_economica_contribuyentes,
        :dato_anual_contribuyentes
      ).where(id: contribuyente_ids).index_by(&:id)
      
      # Ahora procesar con datos ya cargados
      all_personas.each do |p|
        contribuyente = contribuyentes_loaded[p[:persona].contribuyente_id]
        if contribuyente && self.__info_contribuyente_optimized(contribuyente, p[:ctid], p[:aeid], p[:tcid])
          personas << p[:persona]
        end
      end
    end
    personas.uniq
  end

  def self.__personas_responsables_v2(rol_id, instrumento_id, contribuyente_id=nil, actividad_economica_id=nil, tipo_contribuyente_id=nil)
    personas = []
    instrumentos_id =[]
    instrumentos_id << instrumento_id
    
    instrumentos_id << TipoInstrumento.where(id: instrumento_id).first.tipo_instrumento_id unless TipoInstrumento.find_by(id: instrumento_id).tipo_instrumento_id.blank? #DZC agrega instrumento_id padre, en caso de que instrumento_id sea hijo
    
    
    # instrumentos_id += TipoInstrumento.where(tipo_instrumento_id: instrumento_id).all.pluck(:id) if TipoInstrumento.find_by(id: instrumento_id).tipo_instrumento_id.blank? #DZC agrega todos los instrumentos hijos
    
    instrumentos_id.uniq #DZC elimina repetidos
    
    #DZC TODO: Se debe modificar para contemplar todas las combinaciones de reglas posibles segun valores de tabla responsables
    #DZC TODO: Se debe leer el tipo de instrumento desde la instancia del proceso (manifestación, ppf, ppp) y no desde la tarea 
    
    responsables = self.where(rol_id: rol_id).where(tipo_instrumento_id: instrumentos_id)
    # self.where(rol_id: rol_id)
    #   .where("cargo_id IS NOT NULL")
    responsables.each do |r|  
      cgid = r.cargo_id
      ctid = r.contribuyente_id
      aeid = []
      if !r.actividad_economica_id.blank?
        aeid = [r.actividad_economica_id]
        aeid += r.actividad_economica.get_children.pluck(:id)
      end
      tcid = []
      if !r.tipo_contribuyente_id.blank?
        tcid = [r.tipo_contribuyente_id]
        tcid += r.tipo_contribuyente.get_children_id
      end
      if r.cargo_id.blank? == false
        PersonaCargo.includes([:persona]).where(cargo_id: r.cargo_id).each do |pc|
          if self.__info_contribuyente(pc.persona.contribuyente,ctid,aeid,tcid,contribuyente_id,actividad_economica_id,tipo_contribuyente_id)
            personas << pc.persona
          end
        end
      else #DZC busca todas las personas asociadas a todos los cargos del contribuyente, para el caso de que no se indique cargo
        
        personas = PersonaCargo.includes([:persona]).each do |pc|
          if __info_contribuyente(pc.persona.contribuyente,ctid,aeid,tcid,contribuyente_id,actividad_economica_id,tipo_contribuyente_id)
            personas << pc.persona
          end
        end
      end
    end
    personas.uniq
  end

  def self.__personas_responsables_v3(rol_id, instrumento_id, contribuyente_id = nil, actividad_economica_id = nil, tipo_contribuyente_id = nil)
    # Usamos un Set para evitar duplicados
    personas = Set.new
    
    # Obtenemos el instrumento y sus instrumentos relacionados
    instrumento = TipoInstrumento.find_by(id: instrumento_id)
    instrumentos_id = [instrumento_id]
    
    if instrumento && instrumento.tipo_instrumento_id.present?
      instrumentos_id << instrumento.tipo_instrumento_id
    end
    
    instrumentos_id.uniq!  # Eliminamos duplicados
    
    # Realizamos la consulta inicial para obtener los responsables
    responsables = self.where(rol_id: rol_id, tipo_instrumento_id: instrumentos_id)
   
    responsables.find_each do |r|  # Usamos find_each para evitar cargar todo en memoria
      ctid = r.contribuyente_id
      aeid = r.actividad_economica_id.present? ? [r.actividad_economica_id] + r.actividad_economica.get_children.pluck(:id) : []
      tcid = r.tipo_contribuyente_id.present? ? [r.tipo_contribuyente_id] + r.tipo_contribuyente.get_children_id : []
    
      # Obtener cargos asociados
      if r.cargo_id.present?
        # Usamos `find_each` para cargar los registros de personas por cargo de manera más eficiente
        PersonaCargo.includes(:persona).where(cargo_id: r.cargo_id).find_each do |pc|
          if __info_contribuyente_v2(pc.persona.contribuyente, ctid, aeid, tcid)
            personas.add(pc.persona)  # Añadimos a personas sin duplicados
          end
        end
      else
        # Si no tiene cargo_id, buscamos todas las personas asociadas a todos los cargos
        PersonaCargo.includes(:persona).find_each do |pc|
          if __info_contribuyente_v2(pc.persona.contribuyente, ctid, aeid, tcid)
            personas.add(pc.persona)
          end
        end
      end 
    end
    # Devolvemos los resultados como un array
    personas.to_a
  end
    
  def self.__info_contribuyente_v2(cpo, ctid, aeid, tcid)
    coincide = true
  
    # Optimizar validaciones solo si es necesario
    coincide &= ctid.blank? || ctid.to_i == cpo.id.to_i
  
    # Obtener actividad económica ids solo si aeid está presente
    if aeid.present?
      ae_ids = cpo.actividad_economica_contribuyentes.pluck(:actividad_economica_id)
      coincide &= (ae_ids & aeid).any?
    end
  
    # Obtener tipo contribuyente ids solo si tcid está presente
    if tcid.present?
      tc_ids = cpo.dato_anual_contribuyentes.pluck(:tipo_contribuyente_id)
      coincide &= (tc_ids & tcid).any?
    end
  
    coincide
  end
   
  def self.__info_contribuyente(cpo,ctid,aeid,tcid,c_extra=nil,ae_extra=nil,tc_extra=nil)
    coincide = true
    unless ctid.blank?
      coincide = !coincide ? coincide : ( ctid.to_i == cpo.id.to_i )
    end
    if !aeid.blank? && coincide
      coincide = !(cpo.actividad_economica_contribuyentes.pluck(:actividad_economica_id) & aeid).blank?
      #coincide = !coincide ? coincide : (cpo.actividad_economica_contribuyentes.map{|aec|aec.actividad_economica_id.to_i}.include?(aeid.to_i))
    end
    if !tcid.blank? && coincide
      # datos_contribuyente = cpo.dato_anual_contribuyentes.order(periodo: :desc).map{|dac|dac.tipo_contribuyente_id}
      # DZC 2018-10-03 16:44:07 Se corrige error, permitiendo ahora la obtención del tipo_contribuyente_id para el caso de que el atributo :periodo sea nil
      
      # v2
      #datos_contribuyente = cpo.dato_anual_contribuyentes.pluck(:tipo_contribuyente_id)
      # datos_contribuyente = []
      # nulos = cpo.dato_anual_contribuyentes.where(periodo: nil).map{|dac|dac.tipo_contribuyente_id if dac.periodo.blank?}
      # datos_contribuyente += nulos
      # unico = cpo.dato_anual_contribuyentes.order(periodo: :desc).map{|dac|dac.tipo_contribuyente_id if dac.periodo.present?}.compact.first
      # datos_contribuyente += [unico]
      #coincide = !coincide ? coincide : (datos_contribuyente.include?(tcid.to_i))
      #v3
      coincide = !(cpo.dato_anual_contribuyentes.pluck(:tipo_contribuyente_id) & tcid).blank?

    end
    if !c_extra.blank? && coincide
      coincide = ( c_extra.to_i == cpo.id.to_i )
    end
    if !ae_extra.blank? && coincide
      coincide = cpo.actividad_economica_contribuyentes.pluck(:actividad_economica_id).include?(ae_extra.to_i)
    end
    if !tc_extra.blank? && coincide
      coincide = cpo.dato_anual_contribuyentes.pluck(:tipo_contribuyente_id).include?(tc_extra.to_i)
    end
    coincide
  end
  # Método optimizado que usa datos ya cargados
  def self.__info_contribuyente_optimized(cpo, ctid, aeid, tcid, c_extra=nil, ae_extra=nil, tc_extra=nil)
    coincide = true
    
    unless ctid.blank?
      coincide = !coincide ? coincide : (ctid.to_i == cpo.id.to_i)
    end
    
    if !aeid.blank? && coincide
      # Usar datos ya cargados en memoria
      ae_ids = cpo.actividad_economica_contribuyentes.map(&:actividad_economica_id)
      coincide = !(ae_ids & aeid).blank?
    end
    
    if !tcid.blank? && coincide
      # Usar datos ya cargados en memoria
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
    #Se obtienen todos los cargos asociados a este rol
    cargos = Responsable.where(rol_id: rol_id).where(tipo_instrumento_id: instrumento_id).select('cargo_id')
    personas_cargos = PersonaCargo.where(cargo_id: cargos).select('persona_id')
    personas = Persona.where(id: personas_cargos).select('user_id').distinct
  end

  def self.__instituciones_con_rol(rol_id, tipo_instrumento_id, contribuyente_id)
    posee_rol = false
    contribuyente = Contribuyente.find(contribuyente_id)
    contribuyentes = []
    instrumentos_id = []
    instrumentos_id << tipo_instrumento_id    
    instrumentos_id << TipoInstrumento.where(id: tipo_instrumento_id).first.tipo_instrumento_id unless TipoInstrumento.find_by(id: tipo_instrumento_id).tipo_instrumento_id.blank? 
    responsables = Responsable.where(rol_id: rol_id, tipo_instrumento_id: instrumentos_id)
    responsables.each do |r|
      if !posee_rol
        ct_id = r.contribuyente_id
        aeid = []
        if !r.actividad_economica_id.blank?
          aeid = [r.actividad_economica_id]
          aeid += r.actividad_economica.get_children.pluck(:id)
        end
        tcid = []
        if !r.tipo_contribuyente_id.blank?
          tcid = [r.tipo_contribuyente_id]
          tcid += r.tipo_contribuyente.get_children_id
        end
        if ct_id.present?
          if contribuyente_id == ct_id          
            #Se verifica que la institucion posea la actividad economica de la relacion       
            if !(contribuyente.actividad_economica_ids & aeid).blank?
              posee_rol = true
            end
          end
        else #DZC busca todas las personas asociadas a todos los cargos del contribuyente, para el caso de que no se indique cargo
          # por defecto es true y si uno no cumple lo mato
          posee_rol = true
          
          if !aeid.blank?
            actividades_economicas_contribuyente = contribuyente.actividad_economica_contribuyentes.pluck(:actividad_economica_id)
            posee_rol = false if (actividades_economicas_contribuyente & aeid).blank?
          end

          if !tcid.blank?
            tipo_contribuyentes = contribuyente.dato_anual_contribuyentes.pluck(:tipo_contribuyente_id)
            posee_rol = false if (tipo_contribuyentes & tcid).blank?
          end
        end
      end
    end
    posee_rol
  end

  def self.__tipo_instrumento_por_persona_rol(roles_id, personas)
    tipo_instrumentos = []
    personas.each do |persona|

      cargos_ids = persona.persona_cargos.pluck(:cargo_id)
      responsables = self.where(rol_id: roles_id).where(cargo_id: cargos_ids)

      #Dos busquedas
      #primero los que no tienen contribuyente asociado
      tipo_instrumentos += responsables.where(contribuyente_id: nil).pluck(:tipo_instrumento_id)
      #segundo los que si tienen contribuyente y coinciden con el de la persona
      #la persona no cambia segun activiad economica o tipo contribuyente, asique me lo salto
      tipo_instrumentos += responsables.where(contribuyente_id: persona.contribuyente_id).pluck(:tipo_instrumento_id)
    end
    tipo_instrumentos.uniq
  end

  def self.__roles_por_persona(personas)
    roles = []
    personas.each do |persona|

      cargos_ids = persona.persona_cargos.pluck(:cargo_id)
      responsables = self.where(cargo_id: cargos_ids)

      #Dos busquedas
      #primero los que no tienen contribuyente asociado
      roles += responsables.where(contribuyente_id: nil).pluck(:rol_id)
      #segundo los que si tienen contribuyente y coinciden con el de la persona
      #la persona no cambia segun activiad economica o tipo contribuyente, asique me lo salto
      roles += responsables.where(contribuyente_id: persona.contribuyente_id).pluck(:rol_id)
    end
    roles.uniq
  end

  def self.__contribuyentes_por_rol(rol_id, tipo_instrumento_id)
    where_query = ""
    responsables = Responsable.where(rol_id: rol_id, tipo_instrumento_id: tipo_instrumento_id)
    responsables.each do |r|
      subquery = ""
      if !r.contribuyente_id.blank? #subquery.where(contribuyente_id: r.contribuyente_id) if !r.contribuyente_id.blank?
        subquery += "contribuyentes.id = "+r.contribuyente_id.to_s 
      end
      if !r.actividad_economica_id.blank? #subquery.where(actividad_economica_contribuyentes: { actividad_economica_id: r.actividad_economica_id }) if !r.actividad_economica_id.blank?
        aeid = [r.actividad_economica_id]
        aeid += r.actividad_economica.get_children.pluck(:id)
        subquery += " AND " if !subquery.blank?
        subquery += "actividad_economica_contribuyentes.actividad_economica_id IN (#{aeid.join(',')}) "
      end
      if !r.tipo_contribuyente_id.blank? #subquery.where(dato_anual_contribuyentes: { tipo_contribuyente_id: r.tipo_contribuyente_id }) if !r.tipo_contribuyente_id.blank?
        tcid = [r.tipo_contribuyente_id]
        tcid += r.tipo_contribuyente.get_children_id
        subquery += " AND " if !subquery.blank? 
        subquery += "dato_anual_contribuyentes.tipo_contribuyente_id IN (#{tcid.join(',')})"
      end
      subquery = " OR ("+subquery+") " if !subquery.blank? && !where_query.blank?
      where_query += subquery if !subquery.blank?
    end
    contribuyentes = []
    contribuyentes = Contribuyente.joins([:actividad_economica_contribuyentes, :dato_anual_contribuyentes]).where(where_query) if !where_query.blank?
    contribuyentes
  end

  def self._cargos_por_rol_empresa(rol_id, tipo_instrumento_id, contribuyente_id)
    cargos = []
    instrumentos_id = [tipo_instrumento_id]    
    instrumentos_id << TipoInstrumento.where(id: tipo_instrumento_id).first.tipo_instrumento_id unless TipoInstrumento.find_by(id: tipo_instrumento_id).tipo_instrumento_id.blank?
    responsables = Responsable.where(rol_id: rol_id, tipo_instrumento_id: instrumentos_id)
    responsables.each do |r|
      subquery = ""
      if !r.contribuyente_id.blank? #subquery.where(contribuyente_id: r.contribuyente_id) if !r.contribuyente_id.blank?
        subquery += "contribuyentes.id = "+r.contribuyente_id.to_s 
      end
      if !r.actividad_economica_id.blank? #subquery.where(actividad_economica_contribuyentes: { actividad_economica_id: r.actividad_economica_id }) if !r.actividad_economica_id.blank?
        aeid = [r.actividad_economica_id]
        aeid += r.actividad_economica.get_children.pluck(:id)
        subquery += " AND " if !subquery.blank?
        subquery += "actividad_economica_contribuyentes.actividad_economica_id IN (#{aeid.join(',')}) "
      end
      if !r.tipo_contribuyente_id.blank? #subquery.where(dato_anual_contribuyentes: { tipo_contribuyente_id: r.tipo_contribuyente_id }) if !r.tipo_contribuyente_id.blank?
        tcid = [r.tipo_contribuyente_id]
        tcid += r.tipo_contribuyente.get_children_id
        subquery += " AND " if !subquery.blank? 
        subquery += "dato_anual_contribuyentes.tipo_contribuyente_id IN (#{tcid.join(',')})"
      end
      contribuyentes = Contribuyente.joins([:actividad_economica_contribuyentes, :dato_anual_contribuyentes]).where(subquery).where(id: contribuyente_id)
      cargos << r.cargo if contribuyentes.count > 0
    end
    cargos
  end

end
