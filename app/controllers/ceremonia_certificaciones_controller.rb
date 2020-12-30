class CeremoniaCertificacionesController < ApplicationController
  protect_from_forgery with: :exception, unless: proc{action_name == 'reset_convocatoria' || action_name == 'edit_convocatoria'}
  before_action :authenticate_user!
  before_action :set_tarea_pendiente
  before_action :set_flujo
  before_action :set_tipo
  before_action :set_descargable_tareas
  before_action :set_manifestacion_de_interes
  before_action :set_convocatoria, only: [:reset_convocatoria, :nueva_convocatoria, :edit_convocatoria, :update_convocatoria, :destroy]
  before_action :permiso_tarea

  #DZC TAREA APL-037
  def index
    
    @convocatoria_existe = !@tarea_pendiente.data.blank? && @tarea_pendiente.data.has_key?(:convocatoria_id)
  end

  def reset_convocatoria
    respond_to do |format|
      format.js
    end
  end

  def edit_convocatoria
  end

  def nueva_convocatoria
    # @convocatoria = Convocatoria.new(convocatoria_params.merge({flujo_id: @flujo.id, tarea_codigo: @tarea.codigo}))
    respond_to do |format|
      
      format.js {
        @convocatoria.assign_attributes(convocatoria_params)
        if @convocatoria.save
          @tarea_pendiente.update(data: {convocatoria_id: @convocatoria.id})#DZC permite almacenar el id de la convocatoria, a efecto de poder actualizar la convocatoria al cambiar de pestaña, sin perder los datos prexistentes

          #DZC crea minuta relacionada con esta convocatoria 
          minuta=Minuta.find_or_create_by({
            convocatoria_id: @convocatoria.id})
          minuta.update({
            fecha: @convocatoria.fecha,
            direccion: @convocatoria.direccion,
            lat: @convocatoria.lat,
            lng: @convocatoria.lng})
          params[:seleccionados].uniq.each do |dest|
          #crea listado de convocados como destinatarios del correo
            @convocatoria.convocatoria_destinatarios.find_or_create_by(destinatario_id: dest)
          end
          @convocatoria.convocatoria_destinatarios.update_all(
            fecha_correo: DateTime.now,
            asistio: false)
          @convocatoria.convocatoria_destinatarios.each do |rd|
            rgc = RegistroAperturaCorreo.create(convocatoria_destinatario_id: rd.id, fecha_envio_correo: DateTime.now)
            ConvocatoriaMailer.delay.enviar(rd, @convocatoria.mensaje_encabezado, @convocatoria.mensaje_cuerpo, @convocatoria.archivo_adjunto, rgc.id) # DZC 2018-10-11 12:08:19 se corrige error en nombre de variable rgc.id
          end
          # @convocatoria = Convocatoria.new #DZC esto vacia la convocatoria sin crear
          continua_flujo_segun_tipo_tarea 
          flash.now[:success] = "Convocatoria enviada"
        else
          flash.now[:warning] = "Debe completar todos los campos requeridos"
        end
      }
    end
  end

  # PATCH/PUT /convocatorias/edit, en ausencia de que el método edit esté definido
  def update_convocatoria
    respond_to do |format|
      format.js {
        if @convocatoria.update(convocatoria_params) #DZC no es necesario el merge por que el value preexiste desde el create, pero se deja como ilustración
          # DZC 2018-11-07 00:42:49 se agrega para guardar la minuta relacionada con la convocatoria
          minuta = Minuta.find_or_create_by({
            convocatoria_id: @convocatoria.id})
          minuta.assign_attributes({
            fecha: @convocatoria.fecha,
            direccion: @convocatoria.direccion,
            lat: @convocatoria.lat,
            lng: @convocatoria.lng
          })
          minuta.save(validate: false)
          #DZC actualiza la tabla de destinatarios
          params[:seleccionados].uniq.each do |dest|
          #crea listado de convocados como destinatarios del correo
            @convocatoria.convocatoria_destinatarios.find_or_create_by(destinatario_id: dest)
          end
          @convocatoria.convocatoria_destinatarios.update_all(
            fecha_correo: DateTime.now,
            asistio: false)
          @convocatoria.convocatoria_destinatarios.each do |rd|
            rgc = RegistroAperturaCorreo.create(convocatoria_destinatario_id: rd.id, fecha_envio_correo: DateTime.now)
          ConvocatoriaMailer.delay.enviar(rd, @convocatoria.mensaje_encabezado, @convocatoria.mensaje_cuerpo, @convocatoria.archivo_adjunto, rgc.id) # DZC 2018-10-11 12:08:19 se corrige error en nombre de variable rgc.id
          end
          continua_flujo_segun_tipo_tarea
          flash.now[:success] = "Convocatoria modificada"
          render js: "window.location='#{ceremonia_certificaciones_path(@tarea_pendiente)}'"
        else
          flash[:error] = "Convocatoria NO modificada"    
        end
      }
    end
  end

  #DZC agrega al campo data de la tarea_pendiente 
  def continua_flujo_segun_tipo_tarea(condicion_de_salida=nil)
    @tarea_pendiente.pasar_a_siguiente_tarea 'A', {convocatoria_id: @convocatoria.id, convocatoria_tarea_pendiente_id: @tarea_pendiente.id}, false
    #DZC la convocatoria sigue abierta hasta que se sube cumple la condición 'A' de la tarea APL-022
  end

  private

    def set_tarea_pendiente
      @tarea_pendiente = TareaPendiente.find(params[:tarea_pendiente_id])
      autorizado? @tarea_pendiente
      @tarea = @tarea_pendiente.tarea
      @descargables = @tarea_pendiente.get_descargables
    end

    #DZC define el flujo y tipo_instrumento, junto con la manifestación o el proyecto según corresponda, para efecto de completar datos. El id de la manifestación se obtiene del flujo correspondiente a la tarea pendiente.
    def set_flujo
      @flujo = @tarea_pendiente.flujo
      @tipo_instrumento=@flujo.tipo_instrumento
      @manifestacion_de_interes = @flujo.manifestacion_de_interes_id.blank? ? nil : ManifestacionDeInteres.find(@flujo.manifestacion_de_interes_id)
      @manifestacion_de_interes.update(tarea_codigo: @tarea.codigo) unless @manifestacion_de_interes.blank?
      @proyecto = @flujo.proyecto_id.blank? ? nil : Proyecto.find(@flujo.proyecto_id)
      @ppp = @flujo.programa_proyecto_propuesta_id.blank? ? nil : ProgramaProyectoPropuesta.find(@flujo.programa_proyecto_propuesta_id)
    end

    def set_tipo
        @tipo=ConvocatoriaTipo.where(tarea_codigo: @tarea.codigo).first
    end

    def set_manifestacion_de_interes
      # @manifestacion_de_interes = ManifestacionDeInteres.find(params[:id])
      actores_desde_tablas = MapaDeActor.construye_data_para_apl (@flujo)
      @actores = (!MapaDeActor.adecua_actores_para_vista(actores_desde_tablas).blank? ? MapaDeActor.adecua_actores_para_vista(actores_desde_tablas) : [])#DZC se cambia la lectura de actores a la tabla
      @actores = MapaDeActor.adecua_actores_unidos_rut_persona_institucion(@actores)
      @manifestacion_de_interes.temporal = true
      @manifestacion_de_interes.accion_en_mapa_de_actores = :actualizacion
      @manifestacion_de_interes.mapa_de_actores_correctamente_construido = true
    end

    def set_convocatoria #asigna al objeto los valores correspondientes a los campos del registro que calza con el id obtenido como parámetro de la URL
      tipo_convocatoria_id = ConvocatoriaTipo.find_by(tarea_codigo: @tarea.codigo).blank? ? nil : ConvocatoriaTipo.find_by(tarea_codigo: @tarea.codigo).id
      
      case action_name
      when "nueva_convocatoria", "reset_convocatoria"
        if Convocatoria.where(flujo_id: @flujo.id, tarea_codigo: @tarea.codigo).blank? || @tarea_pendiente.data.has_key?(:auditoria_id)
          @fecha = Convocatoria.fecha_ultima_convocatoria(@flujo.id, @tarea.codigo).blank? ? DateTime.now.in_time_zone.to_date : Convocatoria.fecha_ultima_convocatoria(@flujo.id, @tarea.codigo)
          @direccion = Convocatoria.direccion_ultima_convocatoria(@flujo.id, @tarea.codigo).blank? ? nil : Convocatoria.direccion_ultima_convocatoria(@flujo.id, @tarea.codigo)
          # DZC 2018-11-07 02:49:38 se agrega nombre de auditoria al nombre de la convocatoria, y se agrega el id de la convocatoria a la tabla de la auditoría
          @nombre = "Ceremonia de Certificación" #DZC 2019-07-04 16:40:19 se modifica por requerimiento de fecha 20190704
          if @tarea_pendiente.data.present? && @tarea_pendiente.data.has_key?(:auditoria_id)
            auditoria = Auditoria.find(@tarea_pendiente.data[:auditoria_id])
            @nombre += (auditoria.nombre.present? ? +" "+auditoria.nombre : "") #DZC 2019-07-04 16:40:19 se modifica por requerimiento de fecha 20190704
          end
          @convocatoria = Convocatoria.new(flujo_id: @flujo.id, fecha: @fecha, direccion: @direccion, tipo: tipo_convocatoria_id, tarea_codigo: @tarea.codigo, nombre: @nombre)
          @convocatoria.save(validate: false)
          auditoria.update(convocatoria_id: @convocatoria.id) if auditoria.present?
        else
          @convocatoria = Convocatoria.where(flujo_id: @flujo.id, tarea_codigo: @tarea.codigo).first
        end
        # DZC 2018-11-06 23:42:04 se corrige error en almacenamiento en @tarea_pendiente.data
        @convocatoria.accion = "nueva_convocatoria"
        @tarea_pendiente.update(data: {convocatoria_id: @convocatoria.id})
      when "edit_convocatoria", "update_convocatoria", "destroy"
        @convocatoria = Convocatoria.find_by(id: @tarea_pendiente.data[:convocatoria_id])
        @convocatoria.accion = "update_convocatoria"
      end
      @convocatoria.establece_mensaje_encabezado
      @convocatoria.establece_mensaje_cuerpo
      @destinatarios = @convocatoria.destinatarios
    end

    # def set_minuta
    #   @minuta = @convocatoria.minuta.blank? ? nil : @convocatoria.minuta
    # end

    def set_descargable_tareas 
      @descargable_tareas = DescargableTarea.where(tarea_id: @tarea.id).order(id: :asc).all
    end

    def actualizar_mapa_de_actores_manifestacion_de_interes_params
      params.require(:manifestacion_de_interes).permit(
        :mapa_de_actores_archivo,
        :mapa_de_actores_archivo_cache
      )
    end

    def convocatoria_params
      parametros=params.require(:convocatoria).permit(
        :flujo_id,
        :nombre,
        :fecha,
        :direccion,
        :lat,
        :lng,
        :encabezado,
        :mensaje,
        :caracterizacion,
        :mensaje_encabezado,
        :mensaje_cuerpo,
        archivo_adjunto: [] #permite agregar un hash de archivos
      )
    end

    def convocatoria_destinatario_params
      params.require(:convocatoria_destinatario).permit(
        :convocatoria_id,
        :destinatario_id,
        :fecha_correo,
        :asistio
      )
    end

    def manifestacion_params
      params.require(:convocatoria).permit(
        :comentarios
      ) 
    end

    def permiso_tarea
      unless @tarea_pendiente.tengo_permiso? current_user
        flash[:warning] = 'No tiene permiso para acceder a esta tarea'
        redirect_to root_path
      end
    end
end