module RendicionFplHelper

  # Obtiene y filtra gastos asignados al Fondo de Producción Limpia
  def obtener_gastos_actividad_fpl(flujo_id, actividad_id)
    filtrar_gastos_por_tipo(flujo_id, actividad_id, ['solicitado al fondo', 'solicitado_al_fondo'])
  end

  # Obtiene y filtra gastos de Aporte Propio (Valorado y Líquido)
  def obtener_gastos_actividad_aporte(flujo_id, actividad_id)
    filtrar_gastos_por_tipo(flujo_id, actividad_id, ['aporte propio valorado', 'aporte propio liquido', 'aporte_propio_valorado', 'aporte_propio_liquido'])
  end

  private

  def filtrar_gastos_por_tipo(flujo_id, actividad_id, tipos_validos)
    rec_int = PlanActividad.recursos_internos(flujo_id, actividad_id).select do |r|
      tipos_validos.any? { |t| r.try(:tipo_aporte).to_s.downcase.include?(t) }
    end

    rec_ext = PlanActividad.recursos_externos(flujo_id, actividad_id).select do |r|
      tipos_validos.any? { |t| r.try(:tipo_aporte).to_s.downcase.include?(t) }
    end

    g_op = PlanActividad.gastos_operaciones(flujo_id, actividad_id).select do |g|
      tipos_validos.any? { |t| g.try(:tipo_aporte).to_s.downcase.include?(t) }
    end

    g_adm = PlanActividad.gastos_administraciones(flujo_id, actividad_id).select do |g|
      tipos_validos.any? { |t| g.try(:tipo_aporte).to_s.downcase.include?(t) }
    end

    {
      rrhh_propios: rec_int,
      rrhh_externos: rec_ext,
      operaciones: g_op,
      administracion: g_adm
    }
  end

  # Helper para formatear valores en pesos chilenos
  def formatear_monto(monto)
    number_to_currency(monto || 0, unit: "$", separator: ",", delimiter: ".", precision: 0)
  end
end