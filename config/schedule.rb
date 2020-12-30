# Use this file to easily define all of your cron jobs.
#
# It's helpful, but not entirely necessary to understand cron before proceeding.
# http://en.wikipedia.org/wiki/Cron

# Example:
#
# set :output, "/path/to/my/cron_log.log"
#
# every 2.hours do
#   command "/usr/bin/some_great_command"
#   runner "MyModel.some_method"
#   rake "some:great:rake:task"
# end
#
# every 4.days do
#   runner "AnotherModel.prune_old_records"
# end

# Learn more: http://github.com/javan/whenever

##
# DZC 2019-08-27 10:41:01
# seteamos las variables de entorno para el correcto funcionamiento de whenever desde un contenedor docker, lo 
# que no impacta el despliegue del proyecto sin uso de docker
# env :PATH, ENV['PATH']
# env :BUNDLE_PATH, ENV['BUNDLE_PATH']
# env :LOCALHOST_PSQL_SERVER, ENV['LOCALHOST_PSQL_SERVER']
# env :LOCALHOST_PSQL_USERNAME, ENV['LOCALHOST_PSQL_USERNAME']
# env :LOCALHOST_PSQL_PASSWORD, ENV['LOCALHOST_PSQL_PASSWORD']

# DZC 2019-12-16 18:12:38 Descomentar si se quiere realizar deploy/levantar el proyecto en un contenedor docker 
# ENV.each_key do |key|
# 	env key.to_sym, ENV[key]
# end

set :environment, ENV["RAILS_ENV"]

#Evita errores de variables de ambiente en docker
#ENV.each { |k, v| env(k, v) }


##
# DZC 2019-08-23 19:36:11
# agregamos los recordatorios de las tareas en cron
require "./"+ File.dirname(__FILE__) + "/environment.rb"
ambiente = (ENV["RAILS_ENV"] || "development" )
Tarea.all.each do |tarea|
	unless tarea.recordatorio_tarea_frecuencia.blank?
		every "#{tarea.recordatorio_tarea_frecuencia}" do
		  	rake "ascc:notificador_de_tareas_pendientes[#{tarea.id}]", :enviroment => ambiente.to_s, :output => "#{Rails.root}/log/notificador_de_tareas_pendientes_#{ambiente}.log"
		end
	end
end

##
# DZC 2019-08-23 19:48:33
# se agrega a crontab la eliminación de los temporales de carrierwave via rake task ascc:limpia_cache_carrierwave
every '0 3 * * *' do
  rake "ascc:limpia_cache_carrierwave", :enviroment => ambiente.to_s, :output => "#{Rails.root}/log/limpia_cache_carrierwave_#{ambiente}.log"
end

#todos los dias a las 2 elimina las tareas pendientes registradas y finaliza los flujos asociados
every '0 2 * * *' do
  rake "ascc:terminar_tareas_programadas", :enviroment => ambiente.to_s
end

#todos los dias a las 1 retorna traspasos de instrumentos programados para hoy
every '0 1 * * *' do
  rake "ascc:retornar_traspasos", :enviroment => ambiente.to_s
end

#todos los dias a las 3 envia correos de aviso de plazos acuerdo y certificaciones
every '0 4 * * *' do
  rake "ascc:envia_correos_aviso", :enviroment => ambiente.to_s
end