class FondoProduccionLimpia < ApplicationRecord
  belongs_to :flujo
  belongs_to :linea
  belongs_to :sublinea, optional: true

  MINUTOS_MENSAJE_GUARDAR = 20

  ##CONTENIDO
  #validaciones = get_campos_validaciones

  def comunas
    self.flujo.comunas
  end
  
  def comunas_beauty_tree_selector
    Pais.find(Pais::CHILE).beauty_tree_selector(self.comunas.pluck(:id))
  end

  def get_campos_validaciones
    #filtro_tarea = self.tarea_id.present? ? {tarea_id: self.tarea_id} : {}
    filtro_tarea =  nil
    validaciones = {}
    campos = Campo.where(clase: self.class.name) #, validaciones_activas: true, tipo: "text")
    campos = filtro_tarea.present? ? campos.select{|v| v.tareas.where(filtro_tarea)} : campos
    campos.each do |c|
      clase_nombre = c.clase.to_s.constantize.table_name.singularize
      validaciones[clase_nombre.to_sym] = {} if validaciones[clase_nombre.to_sym].blank?
      validaciones[clase_nombre.to_sym][c.atributo.to_sym] = {
        id_campo: c.id,
        nombre: (c.nombre.present? ? c.nombre : c.atributo),
        tooltip_activo: c.tooltip_activo,
        tooltip: (c.tooltip.present? ? c.tooltip : c.atributo),
        ayuda_activo: c.ayuda_activo,
        ayuda: c.ayuda.present? ? c.ayuda : "",
        validaciones_activas: c.validaciones_activas,
        obligatorio_campo: c.validacion_contenido_obligatorio,
        tipo: c.tipo,
        atributo: c.atributo
      }
      if c.validaciones_activas
        validacion_min = c.validacion_min.present? ? c.validacion_min : 0
        validacion_max = c.validacion_max.present? ? c.validacion_max : 0
        validaciones[clase_nombre.to_sym][c.atributo.to_sym].merge!(
          validacion_min_activa: (c.validacion_min_activa.present? & validacion_min != 0) ? c.validacion_min_activa : false,
          validacion_max_activa: (c.validacion_max_activa.present? & validacion_max != 0) ? c.validacion_max_activa : false,
          validacion_min: validacion_min,
          validacion_max: validacion_max
        )
      end
    end
    validaciones
  end

  def revisores_select
    # DZC 2018-10-03 17:41:49 se corrige la búsqueda de responsables según el tipo de instrumento de la instancia
    #tipo_instrumento_id = self.tipo_instrumento_id.blank? ? self.flujo.tipo_instrumento_id : self.tipo_instrumento_id
    nombre_acuerdo = self.nombre_acuerdo.blank? ? self.flujo.tipo_instrumento_id : self.nombre_acuerdo
    Responsable.__personas_responsables(Rol::REVISOR_TECNICO, nombre_acuerdo).map{|p| [p.user.nombre_completo, p.id]}     
  end

end
