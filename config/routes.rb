Rails.application.routes.draw do     
# path_names = { sign_in: 'login', sign_out: 'logout' }
# if Rails.env.production?
#   devise_for :users, path: '', path_names: path_names, :skip => [:registrations]
#   as :user do
#   get 'users/edit' => 'devise/registrations#edit', :as => 'edit_user_registration'
#   put 'users' => 'devise/registrations#update', :as => 'user_registration'
#  end
# else
#   devise_for :users, path: '', path_names: path_names
 # end

 #namespace :admin do
 #  resources :personas, except: [:show] do
 #  end
 #  resources :users, except: [:show] do
 #  end
 #  resources :cargos, except: [:show] do
 
 #end

  #################################################################################################
  # Configuración relativa al sistema base y no ha verifact (excepto root_to)
  #################################################################################################
  devise_for :users, :controllers => { sessions: 'admin/sessions', invitations: 'admin/invitations', passwords: 'admin/passwords' }, path_names: { sign_in: 'login', sign_out: 'logout' }, :skip => [:registrations]



  as :user do
    get 'account' => 'admin/registrations#edit', :as => 'edit_user_registration'    
    patch 'users' => 'admin/registrations#update', :as => 'user_registration'
    authenticated :user do
      root :to => "home#index", :as => "authenticated_user_home"
    end
    #root to: 'devise/sessions#new'
    root :to => "home#index"
  end

  get 'consulta-publica-propuestas-acuerdo', to: "home#consulta_publica_propuestas_acuerdo", as: :consulta_publica_propuestas_acuerdo

  #no logeado
  get 'adherir-a-un-acuerdo', to: "home#adherir_a_un_acuerdo", as: :adherir_a_un_acuerdo
  get 'solicitar-adhesion/:manifestacion_de_interes_id', to: "home#solicitar_adhesion", as: :solicitar_adhesion
  get 'get_comunas', to: "home#get_comunas", as: :get_comunas
  get 'get_contribuyentes', to: "registro_proveedores#get_contribuyentes", as: :get_contribuyentes
  get 'get_by_rut', to: 'registro_proveedores#get_by_rut', as: :get_by_rut
  post 'solicitar-adhesion/:manifestacion_de_interes_id/save', to: "home#solicitar_adhesion_guardar", as: :solicitar_adhesion_guardar
  get 'acuerdos-firmados', to: "home#acuerdos_firmados", as: :acuerdos_firmados
  get 'acuerdo-seleccionado', to: "home#acuerdo_seleccionado", as: :acuerdo_seleccionado
  get 'empresas-y-elementos-adheridos', to: "home#empresas_y_elementos_adheridos", as: :empresas_y_elementos_adheridos
  get 'empresas-y-elementos-certificados', to: "home#empresas_y_elementos_certificados", as: :empresas_y_elementos_certificados
  get 'registro-proveedor', to: 'registro_proveedores#search'
  #Clave única
  get 'claveunica', to: "admin/clave_unica#callback", as: 'claveunica_callback' 

  get 'registro_get_comunas', to: "registro_proveedores#registro_get_comunas", as: :registro_get_comunas
  get 'registro_get_comunas_casa_matriz', to: "registro_proveedores#registro_get_comunas_casa_matriz", as: :registro_get_comunas_casa_matriz

  # DZC 2018-10-25 20:01:31 ruta para descargar zips
  get :desacarga_zip, controller:"application"

  get 'hitos-de-prensa' => 'admin/hitos_de_prensa#index'

  #DZC agregado como reemplazo de APL-027
  get 'reporte_automatizado_avances' => 'admin/reporte_automatizado_avances#index'

  #DZC agregado para acceso a menú de historiales
  get 'historial_instrumentos' => 'admin/historial_instrumentos#index'

  # agregado para acceso a proveedores
  get 'proveedores' => 'admin/proveedores#index'

  if Rails.env.production?
    post "geo-localization/coordinates" => "geo_localization#coordinates"
  else
    match "geo-localization/coordinates", to: "geo_localization#coordinates", via: [:get, :post]
  end
  #------------------------------------------------------------------------------------------------------------#


  ##############################################################################################################
  # @ginobarahona / mié 13 jun 2018
  # Descomentar los member/collection si cada caso necesita más funcionalidades.
  ##############################################################################################################
  namespace :ppf do #, path: 'programas-y-proyectos-de-financiamientos' do
    resources :programa_proyecto_propuestas, path: 'propuestas-programa-proyecto', except: [:index,:new,:edit,:update,:destroy,:show] do
      #member do
      #end

      #collection do
      #end
    end
    #DZC ACCESO A PPF-001 (EDIT)
    scope ':tarea_pendiente_id', as: :tarea_pendiente do
      resources :programa_proyecto_propuestas, path: 'propuestas-programa-proyecto', only: [:edit,:update,:destroy] do 
        member do
          get 'asignar-revisor', to: 'programa_proyecto_propuestas#asignar_revisor', as: :asignar_revisor #DZC ACCESO A PPF-002
          patch 'guardar-revisor', to: 'programa_proyecto_propuestas#guardar_revisor', as: :guardar_revisor
          get 'revision', to: 'programa_proyecto_propuestas#revision', as: :revision #DZC ACCESO A PPF-003
          patch 'guardar-revision', to: 'programa_proyecto_propuestas#guardar_revision', as: :guardar_revision 
          get 'resolver-observaciones', to: 'programa_proyecto_propuestas#resolver_observaciones', as: :resolver_observaciones #DZC ACCESO A PPF-004
          patch 'guardar-observaciones-resueltas', to: 'programa_proyecto_propuestas#guardar_observaciones_resueltas', as: :guardar_observaciones_resueltas 
          get 'carta-de-apoyo', to: 'programa_proyecto_propuestas#carta_de_apoyo', as: :carta_de_apoyo #DZC ACCESO A PPF-005
          patch 'subir-carta-de-apoyo', to: 'programa_proyecto_propuestas#subir_carta_de_apoyo', as: :subir_carta_de_apoyo 
          get 'seguimiento-a-terceros', to: 'programa_proyecto_propuestas#seguimiento_a_terceros', as: :seguimiento_a_terceros #DZC ACCESO A PPF-006
          patch 'guardar-seguimiento-a-terceros', to: 'programa_proyecto_propuestas#guardar_seguimiento_a_terceros', as: :guardar_seguimiento_a_terceros 
          patch 'finalizar', to: 'programa_proyecto_propuestas#finalizar', as: :finalizar
          get 'elaboracion-inicial-propuesta', to: 'programa_proyecto_propuestas#elaboracion_inicial_propuesta', as: :elaboracion_inicial_propuesta #DZC ACCESO A PPF-007
          patch 'guardar-elaboracion-inicial-propuesta', to: 'programa_proyecto_propuestas#guardar_elaboracion_inicial_propuesta', as: :guardar_elaboracion_inicial_propuesta
          get 'observaciones-tecnicas', to: 'programa_proyecto_propuestas#observaciones_tecnicas', as: :observaciones_tecnicas #DZC ACCESO A PPF-008
          patch 'guardar-observaciones-tecnicas', to: 'programa_proyecto_propuestas#guardar_observaciones_tecnicas', as: :guardar_observaciones_tecnicas 
          get 'datos-postulacion', to: 'programa_proyecto_propuestas#datos_postulacion', as: :datos_postulacion #DZC ACCESO A PPF-009
          patch 'guardar-datos-postulacion', to: 'programa_proyecto_propuestas#guardar_datos_postulacion', as: :guardar_datos_postulacion
          get 'seguimiento-proyecto', to: 'programa_proyecto_propuestas#seguimiento_proyecto', as: :seguimiento_proyecto #DZC ACCESO A PPF-010
          patch 'guardar-seguimiento-proyecto', to: 'programa_proyecto_propuestas#guardar_seguimiento_proyecto', as: :guardar_seguimiento_proyecto
          get 'asignar-usuarios-a-cargo-ejecucion-programa', to: 'programa_proyecto_propuestas#asignar_usuarios_a_cargo_ejecucion_programa', as: :asignar_usuarios_a_cargo_ejecucion_programa #DZC ACCESO A PPF-011
          patch 'guardar-asignar-usuarios-a-cargo-ejecucion-programa', to: 'programa_proyecto_propuestas#guardar_usuarios_a_cargo_ejecucion_programa', as: :guardar_usuarios_a_cargo_ejecucion_programa
          get 'datos-ejecucion-presupuestaria-anual', to: 'programa_proyecto_propuestas#datos_ejecucion_presupuestaria_anual', as: :datos_ejecucion_presupuestaria_anual #DZC ACCESO A PPF-012
          patch 'guardar-datos-ejecucion-presupuestaria-anual', to: 'programa_proyecto_propuestas#guardar_datos_ejecucion_presupuestaria_anual', as: :guardar_datos_ejecucion_presupuestaria_anual
          #DZC DEPLETED, SE ACCEDE Y EJECUTA DICHA TAREA DESDE CONTROLADOR PPF_ACTIVIDADES_CONTROLLER 
          # get 'agenda', to: 'programa_proyecto_propuestas#agenda', as: :agenda 
          # patch 'guardar-agenda', to: 'programa_proyecto_propuestas#agenda', as: :guardar_agenda
        end
            
        #collection do
        #end
      end
      #RDO PPF-018 PPF-019
      resources :set_metas_acciones do
        collection do
          get :get_establecimientos
          get :revision
          post :enviar_a_revision
          patch '/:id/enviar_revision', to: 'set_metas_acciones#enviar_revision', as: "enviar_revision"
          get :pdf_set_metas
        end
        member do
          get :acciones_relacionadas
          post :duplicar
        end
      end 

      #RDO PPF-021
      scope 'auditorias', controller: :auditorias do
        get 'cargar_establecimiento'
        get 'cargar' #DZC ACCESO A PPF-021
        patch 'update_cargar'
        get :descargar_formato
        get :aprobar #DZC ACCESO A PPF-021
        patch :update_aprobar
        get :aprobar_establecimiento
      end
    end
  end
  ##############################################################################################################
  # End PPF

  #Registro Proveedores routes.
  resources :registro_proveedores, only: [:index, :show, :new, :create, :edit, :update]

  get 'revision-proveedores', to: 'registro_proveedores#revision', as: "revision_registro_proveedores"
  patch 'registro_proveedor/revisar_pertinencia', to: "registro_proveedores#revisar_pertinencia", as: :revisar_pertinencia
  get 'registro-proveedor/:id/descargar_documentos_proveedores', to: "registro_proveedores#descargar_documentos_proveedores", as: :descargar_documentos_proveedores
  patch 'registro_proveedor/asignar_revisor', to: "registro_proveedores#asignar_revisor", as: :asignar_revisor
  post 'registro_proveedor/:id/descargar_registro_proveedor_pdf_archivo', to: "registro_proveedores#descargar_registro_proveedor_pdf_archivo", as: :descargar_pdf_proveedores
  get 'resultado_revision', to: 'registro_proveedores#resultado_revision', as: "resultado_revision"
  patch 'registro_proveedor/resultado_de_revision', to: "registro_proveedores#resultado_de_revision", as: :resultado_de_revision
  get 'registro_proveedores/:id/edit_proveedor', to: "registro_proveedores#edit_proveedor", as: :edit_proveedor
  patch 'registro_proveedores/:id/update_proveedor', to: "registro_proveedores#update_proveedor", as: :update_proveedor
  #PRO-007
  get 'registro_proveedores/:id/actualizar_proveedor', to: "registro_proveedores#actualizar_proveedor", as: :actualizar_proveedor
  patch 'registro_proveedores/:id/update_plazo_proveedor', to: "registro_proveedores#update_plazo_proveedor", as: :update_plazo_proveedor
  #PRO-008
  get 'resultado_actualizacion', to: 'registro_proveedores#resultado_actualizacion', as: "resultado_actualizacion"
  patch 'registro_proveedor/resultado_de_actualizacion', to: "registro_proveedores#resultado_de_actualizacion", as: :resultado_de_actualizacion
  #PRO-009
  get 'evaluacion_proveedores', to: 'registro_proveedores#evaluacion_proveedores', as: "evaluacion_proveedores"

  #------------------------------------------------------------------------------------------------------------#

  #------------------------------------------------------------------------------------------------------------#
  get 'manifestacion-de-interes/:id/google-map-kml/:file(.:format)', to: 'manifestacion_de_interes#google_map_kml', as: :google_map_kml
  get 'responder-encuesta/:tarea_pendiente_id/:encuesta_id', to: 'admin/encuestas#responder', as: :responder_admin_encuesta
  post 'guardar-encuesta/:tarea_pendiente_id/:encuesta_id', to: 'admin/encuestas#guardar', as: :guardar_admin_encuesta
  namespace :admin do
    resources :encuestas, except: [:show] do
      #scope '(:tarea_pendiente_id)' do
      #  member do
      #    get :responder
      #    post :guardar
      #  end
      #end
    end
    resources :registro_proveedor_mensajes
    get 'get_apls_registro/:id', to: 'proveedores#get_apls_registro', as: :get_apls_registro
    resources :preguntas, except: [:show] do
    end
    resources :acciones, except: [:show] do
    end
    resources :materia_sustancias, path: "materias-sustancias", except: [:show] do
    end
    resources :clasificaciones, except: [:show] do
    end
    resources :alcances, except: [:show] do
    end
    resources :proveedores, except: [:show] do
      collection do
        match 'establecimientos/:id(.:format)', to: 'proveedores#establecimientos', as: :establecimientos, via: [:post, :get] #DZC match permite que rails escoja cual vervo REST es el mas adecuado según necesidad
        get 'get_apls_registro/:id', to: 'proveedores#get_apls_registro', as: :get_apls_registro
      end
    end

    # resources :proveedores, except: [:show] do
    #   patch 'proveedores/establecimientos(.:format)', to: 'proveedores#establecimientos', as: :proveedores_establecimientos
    # end

    resources :tipos_proveedores, path: "tipo-proveedores", except: [:show] do
    end
    resources :centro_de_costos, path: "centro-de-costos", except: [:show] do
    end
    resources :actividades, except: [:show] do
    end
    resources :lineas, except: [:show] do
    end
    resources :actividades_por_lineas, path: "actividades-por-linea", except: [:show] do
    end
    resources :tipo_aportes, path: "tipo-aportes", except: [:show] do
    end

    # DOSSA 23-07-2019 rutas para mantenedor de campos
    get 'campos', to: "campos#index", as: :campos
    get ':id/actualizar_campos', to: "campos#actualizar_campos", as: :actualizar_campos
    get ':id/lista_campos', to: "campos#lista_campos", as: :lista_campos
    patch ':id/actualiza_campos', to: "campos#actualiza_campos", as: :actualiza_campos
    
    resources :cargos, except: [:show] do
    end
    
    resources :users, except: [:show] do
      collection do
        put :privacidad
        get :buscador
        get :edit_modal
      end
    end
    
    resources :tipos_instrumentos, except: [:show], path: "tipos-instrumentos" do
    end

    resources :contribuyentes, path: "instituciones" do
      collection do
        put :search
        post :search_contribuyente
        get :mis_instituciones
        get :region_comunas 
        get :edit_modal
      end
    end

    #RDDO Se agregan rutas para acceder a los territorios
    resources :establecimientos do 
      collection do
        put :search
        get :get_regiones
        get :get_comunas
      end
    end

    #ruta para carga historica
    namespace :cargas_historicas do
      get :index      
      post :carga_historica
      get :formato_instrumento
      get :formato_apl
      get :formato_ppf
      get :formato_actores
      get :formato_adhesion
      get :formato_set_metas
      get :formato_datos_productivos
    end

    resources :maquinarias do 
      collection do
        put :search
        get :image_download
      end
    end


    resources :otros do 
      collection do
        put :search
      end
    end

    resources :elementos_certificados, only: [:index] do
      collection do
        get :filtro_institucion
        get ':auditoria_id/:adhesion_elemento_id/certificado(/:auditoria_nivel_id)', to: 'elementos_certificados#certificado', as: 'certificado'
      end
    end

    #ricardo, rutas para edicion de lugares
    resources :lugares, except: [:edit, :update, :destroy] do
      collection do
        post :search
        get :get_regiones
        get :get_provincias
        get :get_comunas
        post :create, as: 'create'
        post :actualizar 
        get 'lugares/:tipo/:id/edit', to: 'lugares#edit', as: "edit"   
        delete '/lugares/:tipo/id/:id', to: 'lugares#destroy', as: "delete" 
      end
    end

    resources :materia_rubro_relacions do
      collection do
        post :search
        get :tupla_existe
      end
    end

    resources :dato_recolectados do
      collection do
        post :search
        get :get_unidades
      end
    end



    resources :privacidad_permisos, only: [:update] do #DZC crea la ruta para el manejo de permisos de privacidad a nivel de administrador
    end

    resources :tipos_contribuyentes do 
    end

    resources :actividades_economicas do 
    end

    # DOSSA 2019-10-09 11:05 se añade para mantenedor de CUENCAS
    resources :cuencas, except: [:destroy] do
    end

    resources :tipo_documento_diagnosticos

    resources :hitos_de_prensa, path: "hitos-de-prensa" do
      collection do
        put :search
        post :search_instrumentos
      end
    end

    #DZC Reemplazo de APL-027
    resources :reporte_automatizado_avances, path: "reporte_automatizado_avances" do
      collection do
        get 'cargar_instrumento'
        get 'cargar_seleccion'
        # get 'cargar_auditoria'
        # get 'cargar_elemento_adherido'
      end
    end


    # DZC 2018-10-17 11:20:13 Mis instrumentos
    resources :gestionar_mis_instrumentos, path: "gestionar_mis_instrumentos" do
      collection do
        get 'cargar_instrumento'
        # get 'apl_set_metas_acciones'
        get 'apl/:id/set_metas_acciones/', to: "gestionar_mis_instrumentos#apl_set_metas_acciones", as: :apl_set_metas_acciones
        get 'apl/:id/set_auditorias/', to: "gestionar_mis_instrumentos#apl_set_auditorias", as: :apl_set_auditorias        
        get 'ppf/:id/set_metas_acciones/', to: "gestionar_mis_instrumentos#ppf_set_metas_acciones", as: :ppf_set_metas_acciones
        get 'fpl/:id/set_metas_acciones/', to: "gestionar_mis_instrumentos#fpl_set_metas_acciones", as: :fpl_set_metas_acciones
        get 'fpl/:id/rendiciones/', to: "gestionar_mis_instrumentos#fpl_rendiciones", as: :fpl_rendiciones
        get 'descargar_reporte_sustentabilidad(/:id)', to: "gestionar_mis_instrumentos#descargar_reporte_sustentabilidad", as: :descargar_reporte_sustentabilidad
      end
    end

    #DZC Corresponde al acceso a Historial de Instrumentos
    resources :historial_instrumentos, path: "historial_instrumentos" do
      collection do
        get 'cargar_instrumento'
        get ':manifestacion_de_interes_id/descargar_observaciones_informe_metas_acciones', to: "historial_instrumentos#descargar_observaciones_informe_metas_acciones", as: :descargar_observaciones_informe_metas_acciones
        get ':manifestacion_de_interes_id/descargar_respuesta_encuesta_diagnostico', to: "historial_instrumentos#descargar_respuesta_encuesta_diagnostico", as: :descargar_respuesta_encuesta_diagnostico
        get ':manifestacion_de_interes_id/descargar_respuesta_encuesta/:tarea_id', to: "historial_instrumentos#descargar_respuesta_encuesta", as: :descargar_respuesta_encuesta
        get ':manifestacion_de_interes_id/descargar_respuesta_encuesta_auditoria/:tarea_id/:auditoria_id', to: "historial_instrumentos#descargar_respuesta_encuesta_auditoria", as: :descargar_respuesta_encuesta_auditoria
        get ':manifestacion_de_interes_id/descargar_manifestacion_pdf', to: "historial_instrumentos#descargar_manifestacion_pdf", as: :descargar_manifestacion_pdf
        post ':manifestacion_de_interes_id/descargar_manifestacion_pdf', to: "historial_instrumentos#descargar_manifestacion_pdf_archivo", as: :descargar_manifestacion_pdf_archivo
        get ':manifestacion_de_interes_id/descargar_informe_acuerdo_pdf', to: "historial_instrumentos#descargar_informe_acuerdo_pdf", as: :descargar_informe_acuerdo_pdf
      end
    end     

    resources :roles do 
    end

    resources :responsables do
    end

    resources :flujo_tareas, path: "flujo-tareas" do
    end

    resources :tareas do
      resources :descargable_tareas, path: :descargables, except: [:show] do
        member do
          get :descargar
        end
        collection do 
          patch :descargar_formato
          post :previsualizacion
        end
      end
    end

    resources :variables, except: [:show,:destroy]

    #RDO: Estandar de homologacion 
    resources :estandar_homologaciones, except: [:show] do
      collection do
        get :get_estandar
      end
    end

    get '/datos_publicos/edit', to: "datos_publicos#edit", as: :edit_datos_publico
    match '/datos_publicos', to: "datos_publicos#update", as: :datos_publico, via: [:patch, :put]

    get '/reporte_sustentabilidad/edit', to: "reporte_sustentabilidad#edit", as: :edit_reporte_sustentabilidad
    match '/reporte_sustentabilidad', to: "reporte_sustentabilidad#update", as: :reporte_sustentabilidad, via: [:patch, :put]

  end
  #end namespace admin

  resources :tarea_pendientes, path: 'tareas-pendientes', only: [:acuerdos,:seguimientos_fpl] do
    collection do 
      get :acuerdos
      get "proyectos-ppf", to: "tarea_pendientes#proyectos_ppf", as: :proyectos_ppf
      get "seguimiento-fpl", to: "tarea_pendientes#seguimientos_fpl", as: :seguimientos_fpl
    end
  end

  resources :traspaso_instrumentos do
    collection do
      get :usuario_flujos
    end
  end

  # ToDo GABM - Mayo 29 2018 : Quitar params: :tarea_pendiente_id al resources de manifestacion_de_interes y agrupar todo el resources con
  # scope '/:tarea_pendientes_id' do. Luego quitar todos lo :id de cada metodo declarado y quitar :tarea_pendiente del grupo collection.
  resources :manifestacion_de_interes, param: :tarea_pendiente_id, path: "manifestacion-de-interes", except: [:show,:index,:create,:edit,:update] do
    collection do
      get :lista_usuarios_entregables
      get :lista_usuarios_carga_datos
      patch 'iniciar-flujo', to: "manifestacion_de_interes#iniciar_flujo", as: :iniciar_flujo
      get ':tarea_pendiente_id/:descargable_tarea_id/descargable', to: "manifestacion_de_interes#descargable", as: :descargable
      get ':tarea_pendiente_id/descargar/mapa-de-actores', to: "manifestacion_de_interes#descargar_mapa_de_actores", as: :descargar_mapa_de_actores
    end
    
    member do

      #DZC TAREA APL-024
      # usuarios cargo_entregables CERTIFICACION
      post 'usuarios_cargo_entregables/entregables', to: "usuarios_cargo_entregables#filtro_entregables", as: :usuarios_cargo_entregables_entregables
      post 'usuarios_cargo_entregables/carga_datos', to: "usuarios_cargo_entregables#filtro_carga_datos", as: :usuarios_cargo_entregables_carga_datos
      match 'usuarios_cargo_entregables/update', to: 'usuarios_cargo_entregables#update', as: :update_usuarios_cargo_entregables, via: [:post,:patch]
      #DZC TAREA APL-024 propiamente tal
      get 'usuarios_cargo_entregables', to: 'usuarios_cargo_entregables#index', as: :usuarios_cargo_entregables
      # resources :usuarios_cargo_entregables, except: [:show,:new,:edit,:create,:destroy]


      #DZC TAREA APL-040
      # usuarios cargo_informe CERTIFICACION
      post 'usuarios_cargo_informe/carga_datos', to: "usuarios_cargo_informe#filtro_carga_datos", as: :usuarios_cargo_informe_carga_datos
      match 'usuarios_cargo_informe/update', to: 'usuarios_cargo_informe#update', as: :update_usuarios_cargo_informe, via: [:post,:patch]
      #DZC TAREA APL-040 propiamente tal
      get 'usuarios_cargo_informe', to: 'usuarios_cargo_informe#index', as: :usuarios_cargo_informe 
      
      #DZC TAREA APL-041, TAREA APL-042 
      get 'informe_impacto/revisar', to: 'informe_impactos#revisar'
      match 'informe_impacto/dirigir_revision/:accion', to: 'informe_impactos#dirigir_revision', as: :dirigir_revision, via: [:get,:post,:patch]
      resources :informe_impactos, except: [:show,:new,:edit]

      #DZC Tarea APL-001
      match '', to: "manifestacion_de_interes#create", as: :create_from_tarea_pendiente, via: [:get, :post] #DZC Iniciar proceso APL
      get ':id/edit(.:format)', to: "manifestacion_de_interes#edit", as: :edit #DZC Manifestacion instanciada
      match ':id/edit(.:format)', to: "manifestacion_de_interes#update", as: :tarea_pendiente, via: [:get, :post, :patch]

      #DZC TAREA APL-002
      get ':id/revisor', to: "manifestacion_de_interes#revisor", as: :revisor
      patch ':id/revisor', to: "manifestacion_de_interes#asignar_revisor"

      #DZC TAREA APL-003.1
      get ':id/admisibilidad', to: "manifestacion_de_interes#admisibilidad", as: :admisibilidad
      patch ':id/admisibilidad', to: "manifestacion_de_interes#revisar_admisibilidad"

      #DZC TAREA APL-003.2
      get ':id/admisibilidad-juridica', to: "manifestacion_de_interes#admisibilidad_juridica", as: :admisibilidad_juridica
      patch ':id/admisibilidad-juridica', to: "manifestacion_de_interes#revisar_admisibilidad_juridica"

      #DZC TAREA APL-004.1
      get ':id/observaciones-admisibilidad', to: "manifestacion_de_interes#observaciones_admisibilidad", as: :observaciones_admisibilidad
      patch ':id/observaciones-admisibilidad', to: "manifestacion_de_interes#resolver_observaciones_admisibilidad"

      #DZC TAREA APL-004.2
      get ':id/observaciones-admisibilidad-juridica', to: "manifestacion_de_interes#observaciones_admisibilidad_juridica", as: :observaciones_admisibilidad_juridica
      patch ':id/observaciones-admisibilidad-juridica', to: "manifestacion_de_interes#resolver_observaciones_admisibilidad_juridica"

      #DZC TAREA APL-005
      get ':id/pertinencia-factibilidad', to: "manifestacion_de_interes#pertinencia_factibilidad", as: :pertinencia_factibilidad
      patch ':id/pertinencia-factibilidad', to: "manifestacion_de_interes#revisar_pertinencia_factibilidad"

      #DZC TAREA APL-006
      get ':id/responder-pertinencia-factibilidad', to: "manifestacion_de_interes#responder_pertinencia_factibilidad", as: :responder_pertinencia_factibilidad
      patch ':id/responder-pertinencia-factibilidad', to: "manifestacion_de_interes#responder_cond_obs_pertinencia_factibilidad"

      #DZC TAREA APL-008
      get ':id/usuario-entregables', to: "manifestacion_de_interes#usuario_entregables", as: :usuario_entregables
      patch ':id/usuario-entregables', to: "manifestacion_de_interes#guardar_usuario_entregables"

      #DZC TAREA APL-009
      get ':manifestacion_de_interes_id/actores/actualizacion', to: "actores#actualizacion", as: :actualizacion_mapa_de_actores
      patch ':manifestacion_de_interes_id/actores/actualizar', to: "actores#actualizar", as: :actualizar_mapa_de_actores
      get ':manifestacion_de_interes_id/actores/descargar', to: "actores#descargar", as: :descargar_mapa_de_actores
      get ':manifestacion_de_interes_id/actores/descargar-revisor', to: "actores#descargar_revisor", as: :descargar_revisor_mapa_de_actores
      get ':manifestacion_de_interes_id/actores/revision', to: "actores#revision", as: :revision_mapa_de_actores #DZC APL-010
      patch ':manifestacion_de_interes_id/actores/enviar-revision', to: "actores#enviar_revision", as: :enviar_revision_mapa_de_actores #DZC APL-010
                 
      get ':manifestacion_de_interes_id/documentos-diagnosticos/actualizacion', to: "documento_diagnosticos#actualizacion", as: :actualizacion_documento_diagnosticos
      patch ':manifestacion_de_interes_id/documentos-diagnosticos/actualizar', to: "documento_diagnosticos#actualizar", as: :actualizar_documento_diagnosticos
      get ':manifestacion_de_interes_id/documentos-diagnosticos/revision', to: "documento_diagnosticos#revision", as: :revision_documento_diagnosticos
      patch ':manifestacion_de_interes_id/documentos-diagnosticos/enviar-revision', to: "documento_diagnosticos#enviar_revision", as: :enviar_revision_documento_diagnosticos
      get ':manifestacion_de_interes_id/documentos-diagnosticos/descarga', to: "documento_diagnosticos#descarga", as: :descarga_documento_diagnosticos
      get ':manifestacion_de_interes_id/documentos-diagnosticos/descarga_estandar_acuerdo_informe', to: "documento_diagnosticos#descarga_estandar_acuerdo_informe", as: :descarga_estandar_o_acuerdo_documento_diagnosticos

      #APL-013 APL-014 APL-018 APL-020 APL-023
      get 'pdf_set_metas', to: 'set_metas_acciones#pdf_set_metas', as: :pdf_set_metas
      #DZC TAREA 3
      get ':id/cargar-actualizar-entregable-diagnostico', to: "manifestacion_de_interes#cargar_actualizar_entregable_diagnostico", as: :cargar_actualizar_entregable_diagnostico

      #DZC TAREA APL-014
      get ':id/revisar-entregable-diagnostico', to: "manifestacion_de_interes#revisar_entregable_diagnostico", as: :revisar_entregable_diagnostico
      #DZC TAREA APL-014 continua con el flujo al presionar terminar etapa
      patch 'termina-etapa-diagnostico(.:format)', to: "manifestacion_de_interes#termina_etapa_diagnostico", as: :termina_etapa_diagnostico

      #DZC TAREA APL-016 continua con el flujo al presionar terminar etapa
      patch 'termina-etapa-negociacion(.:format)', to: "manifestacion_de_interes#termina_etapa_negociacion", as: :termina_etapa_negociacion

      #DZC TAREA APL-019 
      get ':id/evaluacion-negociacion/:encuesta_id', to: 'manifestacion_de_interes#evaluacion_negociacion', as: :evaluacion_negociacion
      post ':id/evaluacion-negociacion/:encuesta_id/enviar-observaciones/:informe_id', to: 'manifestacion_de_interes#observaciones_informe', as: :observaciones_informe
      patch ':tarea_pendiente_id/envia-observaciones-metas-acciones-informe(.:format)', to: 'manifestacion_de_interes#envia_observaciones_metas_acciones_informe', as: :envia_observaciones_metas_acciones_informe
      
      #DZC TAREA APL-020
      patch ':id/actualizar-acuerdos-actores/responder-observaciones/:informe_id', to: 'manifestacion_de_interes#responder_observaciones_informe', as: :responder_observaciones_informe
      get ':id/actualizar-acuerdos-actores', to: 'manifestacion_de_interes#actualizar_acuerdos_actores', as: :actualizar_acuerdos_actores
      
      #DZC TAREA APL-023
      get ':id/actualizar-comite-acuerdos', to: 'actualizar_comite_acuerdos#index', as: :actualizar_comite_acuerdos
      patch ':id/actualizar-comite-acuerdos/guardar-comite', to: 'actualizar_comite_acuerdos#guardar_comite', as: :guardar_comite_actualizar_acuerdos_actores
      # get ':id/actualizar-comite-acuerdos/reload-informe', to: 'actualizar_comite_acuerdos#reload_informe', as: :reload_informe_actualizar_comite_acuerdos_actores
      patch ':id/actualizar-comite-acuerdos/guardar_archivos_anexos_posteriores_firmas(.:format)', to: 'actualizar_comite_acuerdos#guardar_archivos_anexos_posteriores_firmas', as: :guardar_archivos_anexos_posteriores_firmas_actualizar_acuerdos_actores

      #DZC TAREA APL-016 y APL-023 pausa acuerdo
      patch 'detener-acuerdo(.:format)', to: "manifestacion_de_interes#detener_acuerdo", as: :detener_acuerdo
      #DZC TAREA APL-023 continua con el flujo al presionar terminar acuerdo
      patch 'terminar-acuerdo(.:format)', to: "manifestacion_de_interes#terminar_acuerdo", as: :terminar_acuerdo

      get ':id/firma', to: "manifestacion_de_interes#firma", as: :firma
      patch ':id/firma', to: "manifestacion_de_interes#actualizar_firma"

      #DZC TAREA APL-032 *** REVISAR UTILIDAD
      get ':id/carga-auditoria', to: "manifestacion_de_interes#carga_auditoria", as: :carga_auditoria
      patch ':id/carga-auditoria', to: "manifestacion_de_interes#enviar_carga_auditoria"

      #DZC TAREA APL-021
      get ':id/actores-convocatorias', to: "actores_convocatorias#index", as: :actores_convocatorias
      get ':id/actores-convocatorias/edit(.:format)', to: "actores_convocatorias#edit_convocatoria", as: :edit_convocatoria_actores_convocatorias
      patch ":id/actores-convocatorias/update(.:format)", to: "actores_convocatorias#update_convocatoria", as: :update_convocatoria_actores_convocatorias
      post ':id/actores-convocatorias/reset_convocatoria', to: "actores_convocatorias#reset_convocatoria", as: :reset_convocatoria_actores_convocatorias
      post ':id/actores-convocatorias/convocatoria', to: "actores_convocatorias#nueva_convocatoria", as: :nueva_convocatoria_actores_convocatorias

      #DZC TAREA APL-032
      get ':id/auditoria/descargar', to: "auditorias#descargar", as: :descargar_auditorias
      get ':id/auditoria/descargar_compilado', to: "auditorias#descargar_compilado", as: :descargar_compilado_auditorias
      get ':id/auditoria/actualizar', to: "auditorias#actualizar", as: :actualizar_auditorias
      get ':id/auditoria/revisar', to: "auditorias#revisar", as: :revisar_auditorias
      get ':id/auditoria/validar', to: "auditorias#validar", as: :validar_auditorias
      patch ':id/auditoria/actualizar_guardar', to: "auditorias#actualizar_guardar", as: :guardar_actualizar_auditorias
      patch ':id/auditoria/revisar_guardar', to: "auditorias#revisar_guardar", as: :guardar_revisar_auditorias
      patch ':id/auditoria/validar_guardar', to: "auditorias#validar_guardar", as: :guardar_validar_auditorias

      get ':id/roles_especificos', to: "roles_especificos#index", as: :roles_especificos
      patch ':id/roles_especificos', to: "roles_especificos#update"
      #no se si dejarlo aqui con los ids o sacarlo para trabajarlo sin tarea y manif de interes
      post ':id/roles_especificos/entregables', to: "roles_especificos#filtro_entregables", as: :roles_especificos_entregables
      post ':id/roles_especificos/carga_datos', to: "roles_especificos#filtro_carga_datos", as: :roles_especificos_carga_datos

      #DZC TAREA APL-018
      get ':id/acuerdo-actores', to: "acuerdo_actores#index", as: :acuerdo_actores
      patch ':id/acuerdo-actores/actualizar_actores', to: "acuerdo_actores#actualizar_actores", as: :actualizar_actores_acuerdo_actores
      post ':id/reload-informe', to: "acuerdo_actores#reload_informe", as: :reload_informe
      post ':id/mostrar-informe', to: "acuerdo_actores#mostrar_informe", as: :mostrar_informe
      patch ':id/guardar-informe', to: "acuerdo_actores#guardar_informe", as: :guardar_informe
    end

  end


  scope 'manifestacion-de-interes/:tarea_pendiente_id/:manifestacion_de_interes_id', as: :tarea_pendiente_manifestacion_de_interes do
    #DZC APL-013, APL-014
    # resources :set_metas_acciones, path: 'propuestas-de-acuerdos', except: [:show] do
    resources :set_metas_acciones, path: 'set_metas_acciones', except: [:show] do  
      member do
        get 'acciones-relacionadas', to: 'set_metas_acciones#acciones_relacionadas', as: :acciones_relacionadas
        post 'duplicar', to: 'set_metas_acciones#duplicar', as: :duplicar
        #DZC APL-013, 3era pestaña
        get 'actualizacion', to: "set_metas_acciones#actualizacion", as: :actualizacion
        #DZC APL-014, 3era pestaña
        get 'revision', to: "set_metas_acciones#revision", as: :revision
      end
      collection do
        post 'utilizar/:accion_id', to: 'set_metas_acciones#utilizar', as: :utilizar
      end
    end
      patch 'set-metas-acciones/enviar-revision', to: "set_metas_acciones#enviar_revision", as: :enviar_revision
      post 'set-metas-acciones/establecer_tipo_meta', to: "set_metas_acciones#establecer_tipo_meta", as: :establecer_tipo_meta
      post 'metas_acciones_tipo_meta', to: "set_metas_acciones#metas_acciones_tipo_meta", as: :metas_acciones_tipo_meta
      get 'eliminar_grupo_combi', to: "set_metas_acciones#eliminar_grupo_combi", as: :eliminar_grupo_combi
  end

  resources :instrumentos do
    collection do
      put :search
    end
  end

  resources :comentarios, except: [:edit,:destroy,:update] do
    collection do
      post :modal_create
      get :reset
    end
    member do
      put :read
      put :solved
    end
  end

  namespace :seguimiento_fpl do
    
    resources :proyectos, only: [:index] do
      member do
        post :iniciar_syc
        post :mostrar_ocultar
      end
      
    end
  end
  #responsables
  get 'seguimiento_fpl/:tarea_pendiente/proyectos/:id/responsables(.:format)', to: 'seguimiento_fpl/proyectos#responsables', as: :responsables_seguimiento_fpl_proyecto
  patch 'seguimiento_fpl/:tarea_pendiente/proyectos/:id/responsables(.:format)', to: 'seguimiento_fpl/proyectos#actualizar_responsables', as: :actualizar_responsables_seguimiento_fpl_proyecto

  #reuniones
  post 'seguimiento_fpl/:tarea_pendiente/proyectos/:proyecto_id/reuniones(.:format)', to: 'seguimiento_fpl/reuniones#create', as: :seguimiento_fpl_proyecto_reuniones
  get 'seguimiento_fpl/:tarea_pendiente/proyectos/:proyecto_id/reuniones/new(.:format)', to: 'seguimiento_fpl/reuniones#new', as: :new_seguimiento_fpl_proyecto_reunion

  #calendario(rendiciones)
  get 'seguimiento_fpl/:tarea_pendiente/proyectos/:id/calendario(.:format)', to: 'seguimiento_fpl/proyectos#calendario', as: :calendario_seguimiento_fpl_proyecto
  patch 'seguimiento_fpl/:tarea_pendiente/proyectos/:id/calendario(.:format)', to: 'seguimiento_fpl/proyectos#actualizar_calendario', as: :actualizar_calendario_seguimiento_fpl_proyecto

  #rendicion actividades FPL-011
  get 'seguimiento_fpl/:tarea_pendiente/proyectos/:proyecto_id/rendicion_actividades(.:format)', to: 'seguimiento_fpl/rendicion_actividades#index', as: :seguimiento_fpl_proyecto_rendicion_actividades
  patch 'seguimiento_fpl/:tarea_pendiente/proyectos/:proyecto_id/rendicion_actividades/:id(.:format)', to: 'seguimiento_fpl/rendicion_actividades#update', as: :seguimiento_fpl_proyecto_rendicion_actividad
  # define funciones para descargar
  get 'seguimiento_fpl/:tarea_pendiente/proyectos/:proyecto_id/rendicion_actividades/:id/descargar/:tipo(.:format)', to: 'seguimiento_fpl/rendicion_actividades#descargar', as: :seguimiento_fpl_proyecto_rendicion_actividad_descargar
  get "seguimiento_fpl/:tarea_pendiente/proyectos/:proyecto_id/rendicion_actividades/:id/descargar_tecnicas", to: "seguimiento_fpl/rendicion_actividades#descargar_tecnicas", as: :seguimiento_fpl_proyecto_rendicion_actividad_descargar_tecnicas
  get "seguimiento_fpl/:tarea_pendiente/proyectos/:proyecto_id/rendicion_actividades/:id/descargar_respaldos", to: "seguimiento_fpl/rendicion_actividades#descargar_respaldos", as: :seguimiento_fpl_proyecto_rendicion_actividad_descargar_respaldos
  get "seguimiento_fpl/:tarea_pendiente/proyectos/:proyecto_id/rendicion_actividades/rendicion_tecnica", to: "seguimiento_fpl/rendicion_actividades#rendicion_tecnica", as: :seguimiento_fpl_proyecto_rendicion_actividad_rendicion_tecnica
  get "seguimiento_fpl/:tarea_pendiente/proyectos/:proyecto_id/rendicion_actividades/rendicion_contable", to: "seguimiento_fpl/rendicion_actividades#rendicion_contable", as: :seguimiento_fpl_proyecto_rendicion_actividad_rendicion_contable
  
  #proyecto actividades
  patch 'seguimiento_fpl/:tarea_pendiente/proyectos/:proyecto_id/proyecto_actividades/actualizar_rendiciones(.:format)', to: 'seguimiento_fpl/proyecto_actividades#actualizar_rendiciones', as: :seguimiento_fpl_proyecto_proyecto_actividades_actualizar_rendiciones
  get 'seguimiento_fpl/:tarea_pendiente/proyectos/:proyecto_id/proyecto_actividades(.:format)', to: 'seguimiento_fpl/proyecto_actividades#index', as: :seguimiento_fpl_proyecto_proyecto_actividades
  post 'seguimiento_fpl/:tarea_pendiente/proyectos/:proyecto_id/proyecto_actividades(.:format)', to: 'seguimiento_fpl/proyecto_actividades#create'
  get 'seguimiento_fpl/:tarea_pendiente/proyectos/:proyecto_id/proyecto_actividades/new(.:format)', to: 'seguimiento_fpl/proyecto_actividades#new', as: :new_seguimiento_fpl_proyecto_proyecto_actividad
  get 'seguimiento_fpl/:tarea_pendiente/proyectos/:proyecto_id/proyecto_actividades/:id/edit(.:format)', to: 'seguimiento_fpl/proyecto_actividades#edit', as: :edit_seguimiento_fpl_proyecto_proyecto_actividad
  post 'seguimiento_fpl/:tarea_pendiente/proyectos/:proyecto_id/proyecto_actividades/:id(.:format)', to: 'seguimiento_fpl/proyecto_actividades#update', as: :seguimiento_fpl_proyecto_proyecto_actividad
  post 'seguimiento_fpl/:tarea_pendiente/proyectos/:proyecto_id/proyecto_actividades/:id(.:format)', to: 'seguimiento_fpl/proyecto_actividades#update'
  delete 'seguimiento_fpl/:tarea_pendiente/proyectos/:proyecto_id/proyecto_actividades/:id(.:format)', to: 'seguimiento_fpl/proyecto_actividades#destroy'
  patch 'seguimiento_fpl/:tarea_pendiente/proyectos/:proyecto_id/proyecto_actividades/nuevo_anticipo(.:format)', to: 'seguimiento_fpl/proyecto_actividades#nuevo_anticipo', as: :seguimiento_fpl_proyecto_proyecto_actividades_nuevo_anticipo
  patch 'seguimiento_fpl/:tarea_pendiente/proyectos/:proyecto_id/proyecto_actividades/modificaciones(.:format)', to: 'seguimiento_fpl/proyecto_actividades#modificaciones', as: :seguimiento_fpl_proyecto_proyecto_actividades_modificaciones
  get 'seguimiento_fpl/:tarea_pendiente/proyectos/:proyecto_id/proyecto_actividades/reset_rendiciones(.:format)', to: 'seguimiento_fpl/proyecto_actividades#reset_rendiciones', as: :seguimiento_fpl_proyecto_proyecto_actividades_reset_rendiciones
  patch 'seguimiento_fpl/:tarea_pendiente/proyectos/:proyecto_id/proyecto_actividades/aceptar_modificaciones(.:format)', to: 'seguimiento_fpl/proyecto_actividades#aceptar_modificaciones', as: :seguimiento_fpl_proyecto_proyecto_actividades_aceptar_modificaciones

  #solicitud pago
  get 'seguimiento_fpl/:tarea_pendiente/proyectos/:id/solicitud_pago(.:format)', to: 'seguimiento_fpl/proyectos#solicitud_pago', as: :solicitud_pago_seguimiento_fpl_proyecto
  match 'seguimiento_fpl/:tarea_pendiente/proyectos/:id/enviar_pago(.:format)', to: 'seguimiento_fpl/proyectos#enviar_pago', as: :enviar_pago_seguimiento_fpl_proyecto, via: [:patch, :post]
  get 'seguimiento_fpl/:tarea_pendiente/proyectos/:proyecto_id/proyecto_pagos/:id/orden_pago(.:format)', to: 'seguimiento_fpl/proyecto_pagos#orden_pago', as: :seguimiento_fpl_proyecto_proyecto_pagos_orden_pago
  get 'seguimiento_fpl/:tarea_pendiente/proyectos/:proyecto_id/proyecto_pagos/:id/fecha_pago(.:format)', to: 'seguimiento_fpl/proyecto_pagos#fecha_pago', as: :seguimiento_fpl_proyecto_proyecto_pagos_fecha_pago
  patch 'seguimiento_fpl/:tarea_pendiente/proyectos/:proyecto_id/proyecto_pagos/:id(.:format)', to: 'seguimiento_fpl/proyecto_pagos#update', as: :seguimiento_fpl_proyecto_proyecto_pago

  #restitucion
  get 'seguimiento_fpl/:tarea_pendiente/proyectos/:id/restitucion(.:format)', to: 'seguimiento_fpl/proyectos#restitucion', as: :restitucion_seguimiento_fpl_proyecto
  patch 'seguimiento_fpl/:tarea_pendiente/proyectos/:id/actualizar_restitucion(.:format)', to: 'seguimiento_fpl/proyectos#actualizar_restitucion', as: :actualizar_restitucion_seguimiento_fpl_proyecto

  #resolucion
  get 'seguimiento_fpl/:tarea_pendiente/proyectos/:id/resolucion_contrato(.:format)', to: 'seguimiento_fpl/proyectos#resolucion_contrato', as: :resolucion_contrato_seguimiento_fpl_proyecto
  patch 'seguimiento_fpl/:tarea_pendiente/proyectos/:id/actualizar_resolucion_contrato(.:format)', to: 'seguimiento_fpl/proyectos#actualizar_resolucion_contrato', as: :actualizar_resolucion_contrato_seguimiento_fpl_proyecto

  #documentos garantia
  get 'seguimiento_fpl/:tarea_pendiente/proyectos/:proyecto_id/documento_garantias(.:format)', to: 'seguimiento_fpl/documento_garantias#index', as: :seguimiento_fpl_proyecto_documento_garantias
  post 'seguimiento_fpl/:tarea_pendiente/proyectos/:proyecto_id/documento_garantias(.:format)', to: 'seguimiento_fpl/documento_garantias#create'
  get 'seguimiento_fpl/:tarea_pendiente/proyectos/:proyecto_id/documento_garantias/new(.:format)', to: 'seguimiento_fpl/documento_garantias#new', as: :new_seguimiento_fpl_proyecto_documento_garantia
  get 'seguimiento_fpl/:tarea_pendiente/proyectos/:proyecto_id/documento_garantias/:id/edit(.:format)', to: 'seguimiento_fpl/documento_garantias#edit', as: :edit_seguimiento_fpl_proyecto_documento_garantia
  patch 'seguimiento_fpl/:tarea_pendiente/proyectos/:proyecto_id/documento_garantias/:id(.:format)', to: 'seguimiento_fpl/documento_garantias#update', as: :seguimiento_fpl_proyecto_documento_garantia
  delete 'seguimiento_fpl/:tarea_pendiente/proyectos/:proyecto_id/documento_garantias/:id(.:format)', to: 'seguimiento_fpl/documento_garantias#destroy'

  #fecha_efectiva_pago
  get 'seguimiento_fpl/:tarea_pendiente/proyectos/:id/fecha_efectiva_pago(.:format)', to: 'seguimiento_fpl/proyectos#fecha_efectiva_pago', as: :fecha_efectiva_pago_seguimiento_fpl_proyecto
  patch 'seguimiento_fpl/:tarea_pendiente/proyectos/:id/actualizar_fecha_efectiva_pago(.:format)', to: 'seguimiento_fpl/proyectos#actualizar_fecha_efectiva_pago', as: :actualizar_fecha_efectiva_pago_seguimiento_fpl_proyecto
  
  get 'descargable-tarea(/:tarea_pendiente_id)/:tarea_id/:id/', to: 'admin/descargable_tareas#descargar', as: :ext_descargable_tarea #se llama ext porque existe otra forma de acceder a esta acción pero en la URL aparece 'admin'

  #DZC APL-011, APL-016, APL-030
  get ":tarea_pendiente_id/convocatorias", to: "convocatorias#index", as: :tarea_pendiente_convocatorias #lleva al mantenedor de convocatorias
  get ":tarea_pendiente_id/convocatorias/new(.:format)", to: "convocatorias#new", as: :new_tarea_pendiente_convocatoria
  post ":tarea_pendiente_id/convocatorias", to: "convocatorias#create", as: :create_tarea_pendiente_convocatoria
  get ":tarea_pendiente_id/convocatorias/:id/edit(.:format)", to: "convocatorias#edit", as: :edit_tarea_pendiente_convocatoria
  patch ":tarea_pendiente_id/convocatorias/:id(.:format)", to: "convocatorias#update", as: :tarea_pendiente_convocatoria
  delete ":tarea_pendiente_id/convocatorias/:id(.:format)", to: "convocatorias#destroy"

  #ruta para descargar adjuntos a ser llamada desde vista
  get ":tarea_pendiente_id/convocatorias/:id/descargar_adjuntos", to: "convocatorias#descargar_adjuntos", as: :tarea_pendiente_convocatoria_descargar_adjuntos

  #DZC APL-016 ruta para poner término a la negociación del acuerdo
  patch ":tarea_pendiente_id/convocatorias/:id/termina_etapa_negociacion(.:format)", to: "convocatorias#termina_etapa_negociacion", as: :tarea_pendiente_convocatoria_termina_etapa_negociacion
  
  #DZC APL-012, APL-017, APL-022, APL-031
  get ":tarea_pendiente_id/convocatorias/:convocatoria_id/minutas/edit(.:format)", to: "minutas#edit", as: :edit_tarea_pendiente_convocatoria_minuta
  patch ":tarea_pendiente_id/convocatorias/:convocatoria_id/minutas/:id(.:format)", to: "minutas#update", as: :tarea_pendiente_convocatoria_minuta
  # Obtener el archivo del acuerdo para APL-022
  get ":tarea_pendiente_id/:flujo/archivo-apl-022", to: "minutas#archivo", as: :obtener_archivo_apl_022, format: 'docx'
  get ":flujo/archivo-acuerdo-anexos-zip", to: "minutas#archivo_acuerdo_anexos_zip", as: :obtener_archivo_acuerdo_anexos_zip


  #DZC APL-020 termina tarea y continúa el flujo
  patch ":tarea_pendiente_id/termina-actualizacion-actores-resuelve-comentarios-propuestas(.:format)", to: "manifestacion_de_interes#termina_actualizacion_actores_resuelve_comentarios_propuestas", as: :tarea_pendiente_termina_actualizacion_actores_resuelve_comentarios_propuestas

  # #DZC APL-037
  # # actualizar mapa de actores y ceremonia de certificacion
  # get "/manifestacion-de-interes/:tarea_pendiente_id/:manifestacion_de_interes_id/ceremonia-certificaciones(.:format)", to: "ceremonia_certificaciones#index", as: :tarea_pendiente_ceremonia_certificaciones

  #DZC TAREA APL-037
  get ':tarea_pendiente_id/ceremonia-certificaciones', to: "ceremonia_certificaciones#index", as: :ceremonia_certificaciones
  get ':tarea_pendiente_id/ceremonia-certificaciones/edit(.:format)', to: "ceremonia_certificaciones#edit_convocatoria", as: :edit_convocatoria_ceremonia_certificaciones
  # patch ":tarea_pendiente_id/ceremonia-certificaciones/update(.:format)", to: "ceremonia_certificaciones#update_convocatoria", as: :update_convocatoria_ceremonia_certificaciones
  patch ":tarea_pendiente_id/ceremonia-certificaciones/update(.:format)", to: "ceremonia_certificaciones#update_convocatoria", as: :update_convocatoria_ceremonia_certificaciones
  post ':tarea_pendiente_id/ceremonia-certificaciones/reset_convocatoria', to: "ceremonia_certificaciones#reset_convocatoria", as: :reset_convocatoria_ceremonia_certificaciones
  post ':tarea_pendiente_id/ceremonia-certificaciones/convocatoria', to: "ceremonia_certificaciones#nueva_convocatoria", as: :nueva_convocatoria_ceremonia_certificaciones

  #DZC TAREA-APL-007 ruta para hitos de prensa como tarea pendiente
  get ":tarea_pendiente_id/hitos_de_prensa", to: "admin/hitos_de_prensa#index", as: :tarea_pendiente_hitos_de_prensa #DZC TAREA APL-007
  get ":tarea_pendiente_id/hitos_de_prensa/new(.:format)", to: "admin/hitos_de_prensa#new", as: :new_tarea_pendiente_hito_de_prensa
  post ":tarea_pendiente_id/hitos_de_prensa", to: "admin/hitos_de_prensa#create", as: :create_tarea_pendiente_hito_de_prensa
  get ":tarea_pendiente_id/hitos_de_prensa/:id/edit(.:format)", to: "admin/hitos_de_prensa#edit", as: :edit_tarea_pendiente_hito_de_prensa
  patch ":tarea_pendiente_id/hitos_de_prensa/:id(.:format)", to: "admin/hitos_de_prensa#update", as: :tarea_pendiente_hito_de_prensa
  delete ":tarea_pendiente_id/hitos_de_prensa/:id(.:format)", to: "admin/hitos_de_prensa#destroy"

  # #DZC TODO: TAREA-APL-027 ruta para reporte automatizado de avance
  #DZC DEPLETED ==> Se cambia a acceso mediante link
  # get "/:tarea_pendiente_id/reporte_automatizado_avances", to: "admin/reporte_automatizado_avances#index", as: :tarea_pendiente_reporte_automatizado_avances
  # get "/:tarea_pendiente_id/reporte_automatizado_avances/new(.:format)", to: "admin/reporte_automatizado_avances#new", as: :new_tarea_pendiente_reporte_automatizado_avance
  # post "/:tarea_pendiente_id/reporte_automatizado_avances", to: "admin/reporte_automatizado_avances#create", as: :create_tarea_pendiente_reporte_automatizado_avance
  # get "/:tarea_pendiente_id/reporte_automatizado_avances/:id/edit(.:format)", to: "admin/reporte_automatizado_avances#edit", as: :edit_tarea_pendiente_reporte_automatizado_avance
  # patch "/:tarea_pendiente_id/reporte_automatizado_avances/:id(.:format)", to: "admin/reporte_automatizado_avances#update", as: :tarea_pendiente_reporte_automatizado_avance
  # delete "/:tarea_pendiente_id/reporte_automatizado_avances/:id(.:format)", to: "admin/reporte_automatizado_avances#destroy"  

  #RDO APL-029 PPF-020
  #resources :dato_productivo_elemento_adheridos
  get ":tarea_pendiente_id/dato_productivo_elemento_adheridos", to: "dato_productivo_elemento_adheridos#edit", as: :dato_productivo_elemento_adheridos
  get ":tarea_pendiente_id/dato_productivo_elemento_adheridos/descargar_formato", to: "dato_productivo_elemento_adheridos#descargar_formato", as: :dato_productivo_elemento_adheridos_formato
  patch ":tarea_pendiente_id/dato_productivo_elemento_adherido/cargar", to: "dato_productivo_elemento_adheridos#cargar_dato_productivo", as: :dato_productivo_elemento_adherido_formato

  #RDO PPF-013
  get ":tarea_pendiente_id/ppf/agenda", to: "ppf_actividades#edit", as: :ppf_agenda #DZC ACCESO A PPF-013 
  patch ":tarea_pendiente_id/ppf/agenda", to: "ppf_actividades#update", as: :ppf_agenda_update
  get ':tarea_pendiente_id/ppf/preparar-convocatoria/', to: 'ppf_actividades#preparar_convocatoria', as: :ppf_preparar_convocatoria #DZC CONDICIÓN 'A' FLUJO PPF-014
  get ':tarea_pendiente_id/ppf/cargar-actividades', to: 'ppf_actividades#cargar_actividades', as: :ppf_cargar_actividades #DZC CONDICIÓN 'B' FLUJO PPF-013
  get ':tarea_pendiente_id/ppf/cargar-resultados-auditoria', to: 'ppf_actividades#cargar_resultados_auditoria', as: :ppf_cargar_resultados_auditoria #DZC CONDICIÓN 'C' FLUJO PPF-013
  get ":tarea_pendiente_id/ppf/descargar", to: "ppf_actividades#descargar", as: :ppf_agenda_descargar

  #DZC TAREA APL-025, APL-028, PPF-016, PPF-017
  get ':tarea_pendiente_id/adhesion/actualizar', to: "adhesiones#actualizar", as: :actualizar_adhesion #DZC APL-025, PPF-016
  get ':tarea_pendiente_id/adhesion/revisar', to: "adhesiones#revisar", as: :revisar_adhesion #DZC APL-028, PPF-017
  patch ':tarea_pendiente_id/adhesion/actualizar_guardar', to: "adhesiones#actualizar_guardar", as: :guardar_actualizar_adhesion
  patch ':tarea_pendiente_id/adhesion/actualizar_revisar', to: "adhesiones#revisar_guardar", as: :guardar_revisar_adhesion
  post ':tarea_pendiente_id/auditoria/retirar_elemento', to: "adhesiones#retirar_elemento", as: :retirar_elemento_adhesion
  get ':tarea_pendiente_id/adhesion/descargar', to: "adhesiones#descargar", as: :descargar_adhesion
  get ':tarea_pendiente_id/adhesion/descargar_compilado', to: "adhesiones#descargar_compilado", as: :descargar_compilado_adhesion

  # DZC 2018-11-05 13:24:14 Errores varios en bandeja de entrada
  get ':tarea_pendiente_id/error', to: "tarea_pendientes#auditoria_sin_elementos_adheridos", as: :tarea_pendiente_auditoria_sin_elementos_adheridos

  if Rails.env.production?
    match '*a' => redirect("/"), via: :all
  else
    match 'admin' => redirect("/"), via: :all
  end
  #Para identificar la lectura de los correos enviados registro_apertura_correos
  get 'registro_apertura/:id' => 'registro_apertura_correos#image', as: 'registro_apertura_correos'
  get 'test_registro_apertura' => 'registro_apertura_correos#test', as: 'test_registro_apertura_correos'

  #Añadido para autorización de google calendar
  get '/auth/google', to: 'google_auth_controller#authorize', as: :google_authorize
  get '/oauth2callback', to: 'google_auth_controller#oauth2callback'

end
