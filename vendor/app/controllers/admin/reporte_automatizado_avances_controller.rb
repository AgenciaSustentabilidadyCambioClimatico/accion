class Admin::ReporteAutomatizadoAvancesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_variables_del_usuario
  before_action :set_cargar_instrumento
  before_action :tiene_permiso?
  before_action :set_cargar_seleccion, only: [:cargar_seleccion]

  def index
  end

  def cargar_instrumento    
  end

  def cargar_seleccion    
  end

  private

    #DZC define las variables a instanciar para el usuario específico. Determina el flujo dependiendo de los flujos de los contribuyentes a los que esta asociado el usuario. Si el usuario tiene el rol Rol::JEFE_DE_LINEA de la ASCC, entonces accede a todos los flujos
    def set_variables_del_usuario
      
      personas = current_user.personas
      # contribuyentes = Contribuyente.where(id: personas.pluck(:contribuyente_id))
      if current_user.posee_rol_ascc?(Rol::JEFE_DE_LINEA) ||  current_user.is_admin? #DZC se trata del jefe de línea de la ASCC
        @instrumentos = Flujo.where(proyecto_id: nil).where("manifestacion_de_interes_id IS NOT NULL OR programa_proyecto_propuesta_id IS NOT NULL").order(id: :asc).all 
      else
        # DZC 2018-11-16 11:20:11 se modifica para contemplar todos los flujos en los que el usuario es actor
        @actores = MapaDeActor.where(persona_id: personas)
        flujos_id = @actores.pluck(:flujo_id)
        @instrumentos = Flujo.where(id: flujos_id, proyecto_id: nil, terminado: [false, nil]).order(id: :asc).all
        # @instrumentos = Flujo.where(proyecto_id: nil, contribuyente_id: contribuyentes.pluck(:id), terminado: [false, nil]).order(id: :asc).all
        # @adhesion_elementos = AdhesionElemento.where(persona_id: persona.id).all
      end
    end

    def set_cargar_instrumento
      @disponible = true
      if params[:format].present? # DZC 2018-11-06 16:18:57 se agrega para pasar parametros desde gestionar mis instrumentos
        @disponible = false
        params[:instrumento] = params[:format]
      end
      if params[:instrumento].present? 
        @instrumento = Flujo.find_by_id(params[:instrumento])
        if @instrumento.present?
          @auditorias = Auditoria.where(flujo_id: @instrumento.id).all
          @auditoria_elementos = AuditoriaElemento.where(auditoria_id: @auditorias.pluck(:id)).all
          @adhesion_elementos = AdhesionElemento.where(id: @auditoria_elementos.pluck(:adhesion_elemento_id)).all.uniq
          @set_metas_acciones = @instrumento.set_metas_acciones

          

          # DZC 2018-11-16 11:39:49 obtengo los actores del mapa de este flujo para este usuario
          if @actores.present?
            
            actores_de_flujo = @actores.select do |a|
              a.flujo_id == @instrumento.id
            end
            if (actores_de_flujo.size == 1) &&  (actores_de_flujo.first[:rol_id] == Rol::RESPONSABLE_CUMPLIMIENTO_COMPROMISOS)
              @adhesion_elementos = @adhesion_elementos.select do |ae|
                ae[:persona_id] == actores_de_flujo[0].persona_id
              end
              @auditoria_elementos = @auditoria_elementos.select do |ae|
                @adhesion_elementos.pluck(:id).include?(ae[:adhesion_elemento_id]) if @adhesion_elementos.present?
              end
              @auditorias = @auditorias.select do |a|
                @auditoria_elementos.pluck(:auditoria_id).include?(a[:id]) if @auditoria_elementos.present?
              end             
              
            end
          end
          contribuyentes_id = @adhesion_elementos.map{|ae| ae.persona.contribuyente.id}.uniq
          @contribuyentes = Contribuyente.where(id: contribuyentes_id)
          
          

          # DZC 2018-11-14 11:14:26 se agrega para el correcto funcionamiento de los filtros seleccionados
          @adhesion_elementos_tabla = @adhesion_elementos
          @auditoria = nil
          @adhesion_elemento = nil
        else
          flash[:warning] = "El instrumento ID #{params[:instrumento]} no fue encontrado."
          redirect_to admin_reporte_automatizado_avances_path
        end
      else
        @instrumento=nil
      end
      # 
    end

    # DZC 2018-10-20 13:20:20 valida que el usuario este autorizado para este flujo específico
    def tiene_permiso?
      tiene = true
      unless action_name = "index" && !params.has_key?(:format)
        unless @instrumentos.include?(@instrumento)
          tiene = false
          flash[:warning] = "Usted no tiene permiso para acceder a las actividades y acciones del instrumento #{@instrumento.present? ? "ID "+@instrumento.id.to_s : nil}"
          redirect_to admin_reporte_automatizado_avances_path
        end
      end
      tiene
    end  


    def set_cargar_seleccion
      # DZC 2018-11-14 11:15:02 se instancian la auditoria y/o elemento adherido filtrado
      
      @auditoria = params[:auditoria].present? ? (@auditorias.select{|a| a.id == params[:auditoria].to_i}).first : nil
      @adhesion_elemento = params[:elemento_adherido].present? ? (@adhesion_elementos.select{|ae| ae.id == params[:elemento_adherido].to_i}).first : nil

      # DZC 2018-11-14 11:21:28 se escogen los ids de los contribuyentes correspondientes a todos los elementos adheridos
      contribuyentes_id = @adhesion_elementos.map{|ae| ae.persona.contribuyente.id}.uniq

      if @auditoria.present? #DZC 2018-11-14 11:16:21 se filtró por auditoria
        # DZC 2018-11-14 11:17:21 del total de elementos de auditoría solo se escogen los correspondientes a la auditoría filtrada
        @auditoria_elementos = @auditoria_elementos.select do |ae|
          ae[:auditoria_id] == @auditoria.id
        end
      end

      if @adhesion_elemento.present? #DZC 2018-11-14 11:18:35 se filtró por elemento adherido
        # DZC 2018-11-14 11:18:55 del total de elementos de auditoría solo se escogen los correspondientes al elemento adherido filtrado
        @auditoria_elementos = @auditoria_elementos.select do |ae|
          ae[:adhesion_elemento_id] == @adhesion_elemento.id
        end

        # DZC 2018-11-14 11:19:31 se filtran los elementos adheridos a mostrar en sus respectiva tabla, en función del elemento adherido escogido por el usuario
        @adhesion_elementos_tabla = [@adhesion_elemento]
        # DZC 2018-11-14 11:22:25 se filtran los ids de los contribuyentes por el correspondiente al elemento adherido escogido
        contribuyentes_id = [@adhesion_elemento.persona.contribuyente.id]
      end
      # DZC 2018-11-14 11:21:14 se filtran los contribuyentes correspondientes
      @contribuyentes = @contribuyentes.select do |c|
        contribuyentes_id.include?(c[:id])
      end

      # DZC 2018-11-14 11:39:34 filtramos el set de metas y acciones en virtud del establecimiento correspondiente, si se trata de un PPF y se escogió un elemento adherido 
      if @instrumento.ppf?
          @set_metas_acciones = @set_metas_acciones.select do |sma|
            @adhesion_elementos_tabla.pluck(:establecimiento_contribuyente_id).include?(sma.ppf_metas_establecimiento.establecimiento_contribuyente_id)
          end          
      end
    end
end
