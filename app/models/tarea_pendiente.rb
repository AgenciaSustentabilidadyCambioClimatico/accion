class TareaPendiente < ApplicationRecord
  belongs_to :tarea, -> { includes :tipo_instrumento }
  belongs_to :user
  belongs_to :flujo, -> { includes :contribuyente }
  belongs_to :estado_tarea_pendiente

  serialize :data

  validates :tarea_id, presence: true
  validates :user_id, presence: true
  validates :flujo_id , presence: true
  validates :estado_tarea_pendiente_id, presence: true

  def viene_desde_tarea_fpl_015?
    viene = false
    if self.data.has_key?(:tarea_pendiente_id) && self.data.has_key?(:codigo_tarea)
      if self.data[:codigo_tarea] == Tarea::COD_FPL_015
        viene = true
      end
    end
    viene
  end

  def no_esta_pendiente?
    self.estado_tarea_pendiente_id != EstadoTareaPendiente::NO_INICIADA
  end

  def esta_pendiente?
    self.estado_tarea_pendiente_id == EstadoTareaPendiente::NO_INICIADA
  end

  def self.acuerdos_de_(user_id)
    acuerdos_ids = TipoInstrumento.apl.map{|ti|ti.id}
    tareas_relacionadas_al_acuerdo = Tarea.where(tipo_instrumento_id: acuerdos_ids).map{|t|t.id}
    self.tareas_pendientes_del_(tareas_relacionadas_al_acuerdo,user_id)
  end

  def self.proyectos_de_(user_id)
    proyectos_ids = TipoInstrumento.ppf.map{|ti|ti.id}
    tareas_relacionadas_al_proyecto = Tarea.where(tipo_instrumento_id: proyectos_ids).map{|t|t.id}
    self.tareas_pendientes_del_(tareas_relacionadas_al_proyecto,user_id)
  end  

  def self.seguimientos_de_(user_id)
    seguimientos_ids = TipoInstrumento.fpl.map{|ti|ti.id}
    tareas_relacionadas_al_seguimiento = Tarea.where(tipo_instrumento_id: seguimientos_ids).map{|t|t.id}
    self.tareas_pendientes_del_(tareas_relacionadas_al_seguimiento,user_id)
  end

  def self.tareas_pendientes_del_(tipo_id,user_id)
    self
      .includes([:tarea,:flujo,:estado_tarea_pendiente])
      .where(
        "user_id = (?) AND tarea_id IN (?) AND estado_tarea_pendiente_id = (?)", 
        user_id,
        tipo_id,
        EstadoTareaPendiente::NO_INICIADA
      ).all
  end

  def self.todas_del_(user_id=nil)
    filtrar_usuario = user_id.blank? ? nil : "user_id = #{user_id} AND "
    self.includes([:tarea,:flujo]).where("#{filtrar_usuario}estado_tarea_pendiente_id = #{EstadoTareaPendiente::NO_INICIADA}").all
  end

  def self.crear_flujo(contribuyente_id,tipo_instrumento_id,tareas)
    resultado = { flujo: Flujo.new, tarea_pendientes: [Flujo.new.tarea_pendientes.build] }
    resultado[:flujo] = Flujo.new({
      contribuyente_id: contribuyente_id,
      tipo_instrumento_id: tipo_instrumento_id
    })
    if resultado[:flujo].save
      resultado[:tarea_pendientes] = resultado[:flujo].tarea_pendientes.create(tareas)
    end
    resultado
  end

  #DZC Comprueba que el usuario sea admin o tenga asignada la tarea pendiente
  def tengo_permiso? user
    permiso = false
    if (self.user == user) || user.is_admin?
      permiso = true
    end
    permiso
    true #DZC Comentar cuando se habilite la comprobación de permisos de usuario a tarea
  end

  def pertenece_a_esta_encuesta?(id)
    self.tarea.encuesta_id == id 
    # (self.data.has_key?(:encuesta_id) && self.data[:encuesta_id] == id)
  end

  def get_descargables
    
    descargables = {}
    tarea = self.tarea
    tarea.descargable_tareas.each do |desc|
      
      descargables[desc.codigo] = { nombre: desc.nombre, args: [id,tarea,desc] }
    end
    descargables
  end

  # aoliva
  # metodo que pasa a la siguiente tarea en el flujo de tareas
  # puede recibir una condicion de salida, para acotar la busqueda, condicion salida puede ser un string 'a' o un arreglo (['a','b'])
  # TODO: agregar una variable de salida para corroborar en los controladores donde se use, que en realidad se realizo correctamente todo,
  # al tener un save, puede fallar por algun motivo, entonces es mejor saberlo.
  def pasar_a_siguiente_tarea condicion_de_salida=nil, extra={}, finaliza=true

    #DZC tareas que terminan para un único actor
    tareas_unico_actor = []
    tareas_unico_actor += [Tarea::COD_APL_011, Tarea::COD_APL_016, Tarea::COD_APL_030, Tarea::COD_PPF_014] #DZC Convocatorias, salvo APL-021
    tareas_unico_actor += [Tarea::COD_APL_012, Tarea::COD_APL_017, Tarea::COD_APL_031, Tarea::COD_PPF_015] #DZC Minutas
    tareas_unico_actor += [Tarea::COD_APL_022] if !condicion_de_salida.blank? && (!condicion_de_salida.include?('A')) #DZC APL-022 que no finalizan la tarea
    tareas_unico_actor += [Tarea::COD_APL_015, Tarea::COD_APL_019, Tarea::COD_APL_039, Tarea::COD_APL_043, Tarea::COD_PPF_023, Tarea::COD_PPF_024] #DZC Encuestas
    
    #DZC tareas que finalizarán todas las tareas pendientes del flujo
    tareas_finalizan_flujo = []
    tareas_finalizan_flujo += [Tarea::COD_PPF_003] if !condicion_de_salida.blank? && condicion_de_salida.include?('A')
    tareas_finalizan_flujo += [Tarea::COD_PPF_006] if !condicion_de_salida.blank? && condicion_de_salida.include?('A')
    tareas_finalizan_flujo += [Tarea::COD_PPF_008, Tarea::COD_PPF_009] if !condicion_de_salida.blank? && condicion_de_salida.include?('C')
    tareas_finalizan_flujo += [Tarea::COD_PPF_010] if !condicion_de_salida.blank? && condicion_de_salida.include?('B')

    if ([Tarea::COD_APL_023].include?(self.tarea.codigo)) 
      TareaPendiente.finaliza_pendientes_por_auditoria(self.flujo_id)
    end
    if ([Tarea::COD_PPF_019].include?(self.tarea.codigo) && !condicion_de_salida.blank? && condicion_de_salida.include?('D'))
      TareaPendiente.where(flujo_id: self.flujo_id, tarea_id: Tarea::ID_PPF_018).update_all(estado_tarea_pendiente_id: EstadoTareaPendiente::ENVIADA)
    end
    if finaliza
      #DZC se finaliza solo la tarea pendiente actual y para ese actor
      if tareas_unico_actor.uniq.include?(self.tarea.codigo)
        self.estado_tarea_pendiente_id = EstadoTareaPendiente::ENVIADA

      #DZC se finalizan las tareas pendientes del mismo tipo para el flujo actual 
      else
        #DZC se finalizan todas las tareas del flujo
        if (tareas_finalizan_flujo.include?(self.tarea.codigo)) 
          TareaPendiente.where(flujo_id: self.flujo_id).update_all(estado_tarea_pendiente_id: EstadoTareaPendiente::ENVIADA)
          Flujo.find_by(id: self.flujo_id).update(terminado: true)

        #DZC se finalizan las tareas pendientes por auditoría específica
        # DZC 2018-11-07 03:40:07 se elimina Tarea::COD_APL_034 del array
        elsif ([Tarea::COD_APL_023].include?(self.tarea.codigo)) 
          TareaPendiente.finaliza_pendientes_por_auditoria(self.flujo_id, extra)

        #DZC se finalizan todas la tareas PPF-019 y PPF-018
        elsif ([Tarea::COD_PPF_019].include?(self.tarea.codigo) && !condicion_de_salida.blank? && condicion_de_salida.include?('D'))
          TareaPendiente.where(flujo_id: self.flujo_id, tarea_id: [Tarea::ID_PPF_018, self.tarea_id]).update_all(estado_tarea_pendiente_id: EstadoTareaPendiente::ENVIADA)

        #DZC se finalizan todas la tareas PPF-022, PPF-021, PPF-020
        elsif ([Tarea::COD_PPF_022].include?(self.tarea.codigo) && !condicion_de_salida.blank? && condicion_de_salida.include?('D'))
          TareaPendiente.where(flujo_id: self.flujo_id, tarea_id: [Tarea::ID_PPF_020, Tarea::ID_PPF_021, self.tarea_id]).update_all(estado_tarea_pendiente_id: EstadoTareaPendiente::ENVIADA)

        # DZC 2018-11-07 06:01:00 se agregar continuación de flujo para condición de término de APL-033
        elsif ([Tarea::COD_APL_033].include?(self.tarea.codigo) && !condicion_de_salida.blank? && condicion_de_salida.include?('A'))
          TareaPendiente.where(flujo_id: self.flujo_id, tarea_id: self.tarea_id, data: extra).update_all(estado_tarea_pendiente_id: EstadoTareaPendiente::ENVIADA)

        # DZC 2018-11-07 06:01:00 se agregar continuación de flujo para condición de término de APL-034
        elsif ([Tarea::COD_APL_034].include?(self.tarea.codigo) && !condicion_de_salida.blank? && condicion_de_salida.include?('C'))
          TareaPendiente.where(flujo_id: self.flujo_id, tarea_id: self.tarea_id, data: extra).update_all(estado_tarea_pendiente_id: EstadoTareaPendiente::ENVIADA)                      
        #DZC se finalizan las demás tareas del mismo tipo 
        else
          TareaPendiente.where(flujo_id: self.flujo_id).where(tarea_id: self.tarea_id).update_all(estado_tarea_pendiente_id: EstadoTareaPendiente::ENVIADA)
        end
      end
    end
    if self.save
      # aqui se crea el filtro para la condicion de salida, si no viene el campo lo crea como hash vacio, no afectado la busqueda
      filtro_condicion_salida = condicion_de_salida.blank? ? {} : {condicion_de_salida: condicion_de_salida}
      # se recorren todos los flujos de tareas que cumplen con la condicion y se agregan las tareas pedientes, 
      # si el flujo lo dicta (revisar metodo continuar flujo)
      
      FlujoTarea.where(tarea_entrada_id: self.tarea_id).where(filtro_condicion_salida).each do |ft|
        
        ft.continuar_flujo self.flujo.id, extra
      end
    end
  end

  #DZC finaliza tareas pendientes de auditorias inexistentes y de la actual
  def self.finaliza_pendientes_por_auditoria(flujo_id, extra=nil)
    
    auditorias = [] #DZC contendrá todas las auditorias existentes al momento 
    auditoria = [] #DZC contendrá la auditoria APL-033 o APL-034 específica terminada
    Auditoria.where(flujo_id: flujo_id).each do |a|
      auditorias << {auditoria_id: a.id}
    end 
    auditoria << extra unless (extra.nil?)
    tareas_pendientes = TareaPendiente.where(flujo_id: flujo_id).includes([:tarea]).where({"tareas.codigo" => [Tarea::COD_APL_032.to_s, Tarea::COD_APL_033.to_s, Tarea::COD_APL_034.to_s]})
    tareas_pendientes.each do |t|
      #DZC termina las tareas pendientes de auditorias borradas
      t.update(estado_tarea_pendiente_id: EstadoTareaPendiente::ENVIADA) if (!auditorias.include?(t.data))
      #DZC termina las tareas pendientes de la misma auditoria de la APL-033 y APL-032 específica
      t.update(estado_tarea_pendiente_id: EstadoTareaPendiente::ENVIADA) if (auditoria.include?(t.data))
    end
  end

  #DZC médodo para continuar con el flujo de las tareas que tienen plazo vencido
  def self.continua_flujo_tareas_plazo_vencido(user_id)
    tareas_pendientes= self.todas_del_(user_id).all
    tareas_pendientes.each do |pend|
      case pend.tarea.codigo
      when Tarea::COD_APL_004 #resolver observaciones de admisibilidad, 25 dias
        manifestacion=ManifestacionDeInteres.find(pend.flujo.manifestacion_de_interes_id)
        if !manifestacion.plazo_vigente? manifestacion.fecha_observaciones_admisibilidad, 25
          pend.pasar_a_siguiente_tarea 'B'
        end
      when Tarea::COD_APL_006 #resolver observaciones de pertinencia, 60 dias
        manifestacion=ManifestacionDeInteres.find(pend.flujo.manifestacion_de_interes_id)
        if !manifestacion.plazo_vigente? manifestacion.fecha_observaciones_pertinencia, 60
          pend.pasar_a_siguiente_tarea 'B'
        end
      when Tarea::COD_APL_012 #ingresar acta minutas, 25 dias
        
        conv = pend.determina_convocatoria
        minuta = conv.minuta
        if (!minuta.plazo_vigente? minuta.fecha_acta, 25) && !minuta.lista_asistencia.nil?
          conv.update({terminada: true})
          pend.pasar_a_siguiente_tarea 'A'
        end
      #DZC ENCUESTAS
      when Tarea::COD_APL_015, Tarea::COD_APL_039, Tarea::COD_APL_043, Tarea::COD_PPF_023, Tarea::COD_PPF_024
        encuesta=Encuesta.find(pend.tarea.encuesta_id)
        if encuesta.expirada?(pend.created_at)
          pend.pasar_a_siguiente_tarea 'A'
        end
      when Tarea::COD_APL_017
        conv = pend.determina_convocatoria
        unless conv.blank?
          minuta = conv.minuta
          if (!minuta.plazo_vigente? minuta.fecha_acta, 25) && !minuta.lista_asistencia.nil?
            conv.update({terminada: true})
            pend.pasar_a_siguiente_tarea 'B'
          end
        end
      when Tarea::COD_APL_019 #DZC Encuesta con comportamiento distinto, pues obedece a una pestaña no única en una vista
         
        encuesta=Encuesta.find(pend.tarea.encuesta_id)
        if encuesta.expirada?(pend.created_at)
          pend.pasar_a_siguiente_tarea 'A', {primera_ejecucion: true}
        end
        # manifestacion=pend.flujo.manifestacion_de_interes
        # if !manifestacion.plazo_vigente? manifestacion.fecha_termino_negociacion, 25
        #   pend.pasar_a_siguiente_tarea
        #DZC SE PRESIONO EL BOTON DE TERMINO DE PROCESO DE NEGOCIACION, Y COMIENZAN A CONTARSE 20 DIAS. Se lee la fecha de inicio desde el campo fecha_termino_negociacion de la manifestación de interés
        # end
      when Tarea::COD_APL_022, Tarea::COD_APL_038  #ingresar acta minutas, 25 dias
        conv = pend.determina_convocatoria
        minuta = conv.minuta
        if !minuta.plazo_vigente? minuta.fecha_acta, 25
          conv.update({terminada: true})# cierra la edición de la convocatoria
          pend.pasar_a_siguiente_tarea 'A' # modificar por cambios de Adan en el método
        end
      when Tarea::COD_APL_025 
        flujo = pend.flujo
        firma_fecha = flujo.manifestacion_de_interes.firma_fecha
        meses = InformeAcuerdo.find_by(manifestacion_de_interes_id: flujo.manifestacion_de_interes_id).plazo_maximo_adhesion
        unless meses.blank?
          plazo = firma_fecha + meses.months
          if (Time.now > plazo) 
            pend.pasar_a_siguiente_tarea 'B' 
          end
        end
      when Tarea::COD_APL_031 #ingresar acta minutas, 25 dias
        flujo=pend.flujo
        conv = pend.determina_convocatoria
        minuta = conv.minuta
        if !minuta.plazo_vigente? minuta.fecha_acta, 25
          conv.update({terminada: true})# cierra la edición de la convocatoria
          TareaPendiente.where(flujo_id: flujo.id).each do |tp| 
            if !tp.data.blank?
              begin
                if tp.data.has_key?(:convocatoria_id) && (tp.data[:convocatoria_id]==conv.id)
                  tp.update(estado_tarea_pendiente_id: EstadoTareaPendiente::ENVIADA)
                end
              rescue NoMethodError
              end
            end
          end         
          pend.pasar_a_siguiente_tarea 'A'
        end
      when Tarea::COD_APL_032
        flujo = pend.flujo
        manifestacion = flujo.manifestacion_de_interes
        informe = InformeAcuerdo.find_by(manifestacion_de_interes_id: manifestacion.id)
        auditoria = Auditoria.find_by_id(pend.data[:auditoria_id])
        plazo = informe.calcula_fecha_plazo_finalizacion_implementacion(auditoria.plazo)
        if (Time.now > plazo)
          pend.pasar_a_siguiente_tarea 'B'
        end
      when Tarea::COD_PPF_015 #ingresar acta minutas, 25 dias
        conv = pend.determina_convocatoria
        minuta = conv.minuta
        if (!minuta.plazo_vigente? minuta.fecha_acta, 25) && !minuta.lista_asistencia.nil?
          conv.update({terminada: true})
          pend.pasar_a_siguiente_tarea 'B'
        end       
      end   
    end
  end

  #DZC
  def es_convocatoria?
    [Tarea::COD_APL_011, Tarea::COD_APL_016, Tarea::COD_APL_030, Tarea::COD_PPF_014].include? self.tarea.codigo #DZC se excluyen APL-021 y APL-037, pues se programaron con controlador y vistas distintas de las genéricas
  end

  #DZC
  def es_minuta?
    [Tarea::COD_APL_012, Tarea::COD_APL_017, Tarea::COD_APL_022, Tarea::COD_APL_031, Tarea::COD_APL_038, Tarea::COD_PPF_015].include? self.tarea.codigo 
  end

  #DZC
  def es_auditoria?
    unless self.tarea.codigo == Tarea::COD_APL_037
      [Tarea::COD_APL_032, Tarea::COD_APL_033, Tarea::COD_APL_034].include? self.tarea.codigo 
    else
      self.data.has_key?(:auditoria_id) ? true : false
    end
  end

  def determina_auditoria
    (self.data.present? && self.data.has_key?(:auditoria_id)) ? Auditoria.find_by(id: self.data[:auditoria_id]) : nil
  end

  #DZC
  def determina_convocatoria
    
    (self.data.present? && self.data.has_key?(:convocatoria_id)) ? Convocatoria.find_by(id: self.data[:convocatoria_id]) : nil
  end

  # #DZC determina la instancia que se despliega como información en reporte de historial de instrumentos
  # def instancias
  #   flujo = self.flujo
  #   tarea = self.tarea
  #   instancia = ""
  #   case tarea.codigo
  #   #Convocatorias
  #     when Tarea::COD_APL_011, Tarea::COD_APL_016, Tarea::COD_APL_030, Tarea::COD_PPF_014
  #       instancia = self.data[:convocatoria_id]

  #     #Minutas
  #     when Tarea::COD_APL_012, Tarea::COD_APL_017, Tarea::COD_APL_031, Tarea::COD_PPF_015


  #     #Encuestas
  #     when Tarea::COD_APL_015, Tarea::COD_APL_019, Tarea::COD_APL_039, Tarea::COD_APL_043, Tarea::COD_PPF_023, Tarea::COD_PPF_024

  #     #Demas
  #     else
  #       instancia = "Unica"
  #   end
  #   instancia 


  #   #DZC en convocatorias y minutas corresponde al nombre de la convocatoria
  #   #DZC en encuestas corresponde al nombre de la encuesta
  #   #DZC en tareas de auditoria (APL 32, 33, 34) corresponde al nombre de la auditoría 
  # end
end