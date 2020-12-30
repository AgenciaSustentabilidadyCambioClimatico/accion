class Admin::ElementosCertificadosController < ApplicationController
  before_action :authenticate_user!
  before_action :set_variables_del_usuario
  before_action :set_cargar_institucion, only: [:filtro_institucion]
  before_action :tiene_permiso?, except: [:index]

  def index
  end

  def filtro_institucion
  end

  private
    def set_variables_del_usuario
      @instituciones = Contribuyente.joins(personas: :persona_cargos)
                                  .where(personas: {user_id: current_user.id})
                                  .where(persona_cargos: {cargo_id: Cargo::ENCARGADO_INS})
      @elementos_certificados = []  
    end

    def set_cargar_institucion
      @institucion = nil
      if params[:institucion_id].present?
        institucion_id = params[:institucion_id].to_i
        @institucion = Contribuyente.find(institucion_id) 
        if @institucion.present? #DZC 2018-11-14 15:25:17 verificamos que la instución ingresada exista

          # DZC 2018-11-14 14:57:42 obtenemos los elementos adheridos
          adhesion_elementos = AdhesionElemento.joins([:persona, :adhesion]).where(personas: {contribuyente_id: institucion_id})

          # DZC 2018-11-14 14:58:01 obtenemos las auditorias con certificacion y ceremonia
          auditorias = Auditoria.where(flujo_id: adhesion_elementos.pluck("adhesiones.flujo_id").uniq, con_certificacion: true)

          # DZC 2018-11-14 18:23:57 obtenemos los elementos de auditoria correspondientes a la auditoria y elementos adheridos
          auditoria_elementos = AuditoriaElemento.where(auditoria_id: auditorias.pluck(:id), adhesion_elemento_id: adhesion_elementos.pluck(:id)).uniq

          # DZC 2018-11-14 18:18:28 obtenemos un array de elementos a revisar por la dupla auditoria y elemento adherido de la tabla auditoria_elementos
          elementos_por_revisar = auditoria_elementos.map do |aud_elem|
            {auditoria_id: aud_elem[:auditoria_id], adhesion_elemento_id: aud_elem[:adhesion_elemento_id]}
          end
          # DZC 2018-11-14 18:19:16 revisamos el cumplimiento de cada elemento adherido en funcion a la auditoría asociada y al set de metas y acciones respectivo
          elementos_por_revisar.uniq.each do |ear|
            
            auditoria = auditorias.select do |a|
              a[:id] == ear[:auditoria_id]
            end
            auditoria = auditoria.first
            adhesion_elemento = adhesion_elementos.select do |adh_elem|
              adh_elem[:id] == ear[:adhesion_elemento_id]
            end
            adhesion_elemento = adhesion_elemento.first

            cumplimiento = adhesion_elemento.calcula_porcentaje_cumplimiento(auditoria, true)
            if cumplimiento == 1
              # DZC 2018-11-14 18:21:24 obtenemos la fecha de certificación en función a la fecha del acta de la ceremonia
              convocatoria_id = auditoria.convocatoria_id
              minuta_ceremonia = convocatoria_id.present? ? Minuta.find_by(convocatoria_id: convocatoria_id) : nil
              if (minuta_ceremonia.present? && minuta_ceremonia.fecha_acta.present?)
                flujo = auditoria.flujo
                # DZC 2018-11-15 15:15:22 contemplamos el caso de que el plazo de certificación sea "con_e"
                #tiene_extension = (flujo.manifestacion_de_interes.present? && flujo.manifestacion_de_interes.informe_acuerdo.present? && flujo.manifestacion_de_interes.informe_acuerdo.con_extension)
                fecha_certificacion = minuta_ceremonia.fecha_acta.strftime("%F")
                #tiempo = tiene_extension ? 6 : 3
                #ToDo: definir cuando es con nivel y tomar plazo de nivel
                tiempo = auditoria.plazo
                vigencia_certificacion = (minuta_ceremonia.fecha_acta + tiempo.years).strftime("%F")
              else
                fecha_certificacion = "Pendiente"
                vigencia_certificacion = "Pendiente"
              end
              # DZC 2018-11-14 18:21:50 agregamos los datos correspondientes al elemento certificado
              @elementos_certificados << {
                auditoria_id: auditoria.id,
                auditoria_nombre: auditoria.nombre,
                tipo_elemento: adhesion_elemento.alcance.nombre,
                id_elemento: adhesion_elemento.id,
                nombre_elemento: adhesion_elemento.nombre_segun_alcance,
                fecha_certificacion: fecha_certificacion,
                con_extension: "No",
                vigencia_certificacion: vigencia_certificacion, 
                nombre_acuerdo: adhesion_elemento.adhesion.flujo.nombre_instrumento
              }
            end
          end
        else
          flash[:warning] = "La institución ID #{params[:institucion_id]} no fue encontrada."
          redirect_to admin_elementos_certificados_path
        end

      else
        @institucion=nil
      end
    end

    # DZC 2018-11-14 15:25:50 valida que el usuario este autorizado para este contribuyente específico
    def tiene_permiso?
      tiene = true
      unless @instituciones.include?(@institucion)
        tiene = false
        flash[:warning] = "Usted no tiene permiso para acceder a los elementos certificados de la institución #{@institucion.present? ? @institucion.razon_social.to_s : nil}"
        redirect_to admin_reporte_automatizado_avances_path
      end
      tiene
    end  
end