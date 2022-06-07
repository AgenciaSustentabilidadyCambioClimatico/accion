namespace :ascc do

  def args
    fetch(:delayed_job_args, "")
  end
 
  desc 'Carga datos fpl externo'
  task :carga_proyectos_remoto do
    on roles(:app) do
      within release_path do
        with rails_env: fetch(:rails_env) do
          execute :rake, "ascc:carga_proyectos_remoto"
        end
      end
    end
  end

  # DZC 2018-11-22 12:19:48 rake task que agrega a crontab la ejecución de :limpia_cache_carrierwave todos los días a las 03:00 horas
  desc "# DZC 2019-08-23 20:24:47 DEPLETED - Ejecuta la rake task ':agrega_limpia_cache_carrierwave_a_crontab'"
  task :agrega_limpia_cache_carrierwave_a_crontab do
    on roles(:app) do
      within release_path do
        with rails_env: fetch(:rails_env) do
          execute :rake, "ascc:agrega_limpia_cache_carrierwave_a_crontab"
        end
      end
    end
  end

  # DZC 2018-11-22 14:49:06 rake task que agrega a crontab la ejecución de :agrega_recordatorios_crontab
  desc "# DZC 2019-08-23 20:24:47 DEPLETED - Ejecuta la rake task ':agrega_limpia_cache_carrierwave_a_crontab'"
  task :agrega_recordatorios_crontab do
    on roles(:app) do
      within release_path do
        with rails_env: fetch(:rails_env) do
          execute :rake, "ascc:agrega_recordatorios_crontab"
        end
      end
    end
  end

  desc "Ejecuta la rake task ':muestra_variables_de_entorno'"
  task :ejecuta_muestra_variables_de_entorno do
    on roles(:app) do
      within release_path do
        with rails_env: fetch(:rails_env) do
          execute :rake, "ascc:muestra_variables_de_entorno"
        end
      end
    end
  end

  desc "Ejecuta la rake task ':asigna_establecimiento_cargo'"
  task :asigna_establecimiento_cargo do
    on roles(:app) do
      within release_path do
        with rails_env: fetch(:rails_env) do
          execute :rake, "ascc:asigna_establecimiento_cargo"
        end
      end
    end
  end

end