class ApplicationController < ActionController::Base
  include Pundit::Authorization

  rescue_from Pundit::NotAuthorizedError do
    redirect_to root_url, alert: "No tiene permiso para acceder a esta página"
  end

  before_action :configure_permitted_parameters, if: :devise_controller?
  protect_from_forgery with: :exception, prepend: true


  before_action :set_personas
  before_action :set_flash_trio
  before_action :set_default_url
  before_action :clean_prev_redirect
  before_action :set_header

  def clean_prev_redirect
    session.delete(:user_return_to) if request.path == session[:user_return_to]
  end

  # DZC 2018-10-25 20:21:52 permite descargar zips, independiente de la clase, objeto y atributo donde se almacenan los archivos a comprimir
  def desacarga_zip
    # 
    clase = params[:clase].to_s.constantize
    objeto_id = params[:objeto_id]
    objeto = clase.find(objeto_id)
    if params[:atributo].is_a?(Array)
      atributo = params[:atributo]
    else
      atributo = objeto.send(params[:atributo].to_sym)
    end
    send_data(objeto.genera_zip(atributo), type: 'application/zip',filename: "archivos_adjuntos.zip")
  end
  
  protected
    def configure_permitted_parameters
      added_attrs = [:rut, :email, :password, :password_confirmation, :remember_me]
      devise_parameter_sanitizer.permit :sign_up, keys: added_attrs
      devise_parameter_sanitizer.permit(:sign_in) do |u|
        #ActionController::Parameters.new({rut: "15439729-9",password:"12345678"}).permit(:rut,:password)
      end
      devise_parameter_sanitizer.permit :account_update, keys: added_attrs
      update_attrs = [:password, :password_confirmation, :current_password]
      devise_parameter_sanitizer.permit :account_update, keys: update_attrs + [
        :nombre_completo,
        :telefono,
        :email,
        :web_o_red_social_1,
        :web_o_red_social_2,
        :fields_visibility => {}
      ]
    end

    def set_header
      @header = ReporteriaDato.find_by(ruta: nil)
    end

    def set_personas
      @personas = []
      unless current_user.blank? || current_user.session.blank?
        # DZC 2018-10-10 16:33:18 se modifica para que lee las personas desde la tabla pertinente
        # @personas  = current_user.session[:personas]
        @personas = current_user.personas
      end
    end

    def set_flash_trio
      @flash_trio = { warning: nil, success: nil, error: nil }
    end

    # DZC método que define una tarea como terminada, eliminar cuando se pullen los cambios hechos por adan, y se configure el uso del método en el modelo tareas_pendientes
    def tarea_success tarea_pendiente
      tarea_pendiente.estado_tarea_pendiente_id = EstadoTareaPendiente::ENVIADA
      if tarea_pendiente.save
        flujo_tareas = FlujoTarea.where(tarea_entrada_id: tarea_pendiente.tarea_id).all
        flujo_tareas.each do |ft|
          ft.continuar_flujo tarea_pendiente.flujo.id
        end
      end
    end

    def set_default_url
      
      @default_url = root_path
    end

    def autorizado? tarea_pendiente
      
      unless tarea_pendiente.tengo_permiso? current_user
        flash[:warning] = 'No tiene permiso para acceder a esta tarea'
        redirect_to root_path
      end
      true
    end

    # DZC 2018-11-15 19:57:33 envía correos a los responsables de cumplimiento en el caso de que se actualizen las auditorías
    def enviar_correos_revisar_reportes(flujo)
      # DZC 2018-11-15 19:56:33 obtengo la url correcta
      url = "#{request.protocol}#{request.host_with_port}#{admin_reporte_automatizado_avances_path}.#{flujo.id}"
      MapaDeActor.where(flujo: flujo.id, rol: Rol::RESPONSABLE_CUMPLIMIENTO_COMPROMISOS).each do |actor|
        
        rgc = RegistroAperturaCorreo.create(user_id: actor.persona.user.id, flujo_tarea_id: nil, 
          fecha_envio_correo: DateTime.now, flujo_id: flujo.id)
        RevisarReportesMailer.enviar(flujo, actor.persona, url, rgc.id).deliver_now
      end
    end
    #def devise_parameter_sanitizer
    #  parameters=params.to_json.as_hash
    #  if parameters.has_key?(:user) && parameters[:user].has_key?(:rut)
    #    parameters[:user][:rut] = parameters[:user][:rut].gsub(/[^0-9\-]/,'')
    #  end
    #  params = ActionController::Parameters.new(parameters)
    #  super
    #end
    
    #def authenticate_user!(options={})
    #  if user_signed_in?
    #    super(options)
    #  else
    #    redirect_to new_user_session_path, :alert => t(:debe_autenticarse_para_acceder_a_esta_página)
        ### if you want render 404 page
        ##render :file => File.join(Rails.root, 'public/404'), :formats => [:html], :status => 404, :layout => false
    #  end
    #end

    def dinero_params(valor)
      valor.gsub(/[\$\.]/,"").gsub(/\,/,".")
    end

    def convert(cast,k,v)
      if cast.include?(k.to_sym)
        convert_method = "to_#{cast[k.to_sym]}"
        if convert_method == "to_i"
          v = v.gsub(/\./,'').send(convert_method)
        elsif convert_method == "to_f"
          v = v.gsub(/\./,'').gsub(/\,/,'.').send(convert_method)
        else
          v = v.send(convert_method)
        end
      end
      v #  raise ArgumentError, 'Para convertir valores debe indicar métodos válidos'
    end

    def __hash(e,cast=[],ignore_destroyed_nested=false)
      nh={}
      e.each do |k,v|
        if v.respond_to?(:each)
          unless e.has_key?("_destroy") && e["_destroy"]=="1" && ignore_destroyed_nested==true
            nh[k.to_sym] = __hash(v,cast)
          end
        else
          nh[k.to_sym] = convert(cast,k,v)
        end
      end
      nh
    end

    def __params_as_hash(model,cast=[],ignore_destroyed_nested=false)
      #_params = { model.to_sym => {} }
      _params = { }
      params.require(model.to_sym).each do |k,v|
        if v.respond_to?(:each)
          #_params[model.to_sym][k.to_sym] = __hash(v)
          _params[k.to_sym] = __hash(v,cast,ignore_destroyed_nested)
        else
          #_params[model.to_sym][k.to_sym] = v
          _params[k.to_sym] = convert(cast,k,v)
        end
      end
      _params
    end

    def __list_errors(object)
      unless object.blank?
        object.errors.messages.inject("<ul>"){|l,(k,e)|l+="<li><b>#{I18n.t(k)}:</b><ul class='p-0'>"+e.map{|m|"<li class='block-message-item small'>#{m}</li>"}.join("")+"</ul></li>";"#{l}</ul>"}
      else
        I18n.t(:no_hay_errores)
      end
    end


    def set_metas_by_antiguo_acuerdo manifestacion_id, flujo_actual
      manifestacion_actual = flujo_actual.manifestacion_de_interes
      manifestacion = ManifestacionDeInteres.find(manifestacion_id)
      flujo = manifestacion.flujo
      set_metas = flujo.set_metas_acciones
      
      set_metas.each do |set|     
        nuevo_set = set.dup
        nuevo_set.flujo_id = flujo_actual.id
        nuevo_set.estado = 1
        nuevo_set.id_referencia = set.id
        nuevo_set.modelo_referencia = 'SetMetasAccion'
        nuevo_set.save
      end
      
      #manifestacion_actual.documento_diagnosticos.clear
      #documentos_diagnosticos = manifestacion.documento_diagnosticos 
      #documentos_diagnosticos.each do |documento| 
      #  nuevo_documento = documento.dup
      #  nuevo_documento.archivo = File.open(documento.archivo.file.file) if documento.archivo.present?
      #  nuevo_documento.manifestacion_de_interes_id = manifestacion_actual.id
      #  
      #  nuevo_documento.desde_set_antiguo = true # DZC 2018-10-11 10:50:03 se modifica a efecto de que permita cargar documentos con tipo_diagnóstico nil
      #  nuevo_documento.save
      #end
    end

    #variable para determinar si posee el cargo encargado de institucion
    def posee_permisos_administracion_encargado
      # if @contribuyente.present? 
      #   @encargado = current_user.is_encargado_institucion_solicitada? @contribuyente
      # elsif action_name == "index"
      #   @encargado =  current_user.is_encargado_institucion?
      # else
      #   @encargado =  false
      # end
      # current_user.is_admin? ? @solo_encargado = false : @solo_encargado = @encargado
      # unless current_user.is_admin? || @encargado
      #   return render :file => "layouts/error_pages/401.html.haml", :status => :unauthorized
      # end 

      @acceso = nil
      if current_user.is_admin?
        @acceso = :admin
      elsif current_user.is_encargado_institucion?
        @acceso = :encargado_institucion
      elsif current_user.posee_rol_ascc?(Rol::JEFE_DE_LINEA)
        @acceso = :jefe_de_linea
      elsif current_user.posee_rol_ascc?(Rol::REVISOR_TECNICO)
        @acceso = :revisor_tecnico          
      else
        @acceso = :user
      end

      if @acceso == :user
        return render :file => "layouts/error_pages/401.html.haml", :status => :unauthorized
      end
    end

    #variable para determinar si posee el cargo administrador
    def posee_permisos_administracion_admin
      @acceso = nil
      if current_user.is_admin?
        @acceso = :admin
      elsif current_user.is_admin_no_agencia?
        @acceso = :admin_no_agencia
      elsif current_user.posee_rol_ascc?(Rol::JEFE_DE_LINEA)
        @acceso = :jefe_de_linea
      elsif current_user.posee_rol_ascc?(Rol::REVISOR_TECNICO)
        @acceso = :revisor_tecnico
      elsif params[:buscador].present? && params[:buscador][:flujo_id].present? && current_user.is_proponente?(params[:buscador][:flujo_id].to_i)
        @acceso = :proponente
      elsif params[:user].present? && params[:user][:flujo_id].present? && current_user.is_proponente?(params[:user][:flujo_id].to_i)
        @acceso = :proponente     
      else
        @acceso = :user
      end

      if @acceso == :user
        return render :file => "layouts/error_pages/401.html.haml", :status => :unauthorized
      end
    end

end
