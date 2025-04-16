require 'sidekiq-cron'

# Clear old scheduled jobs
Sidekiq::Cron::Job.destroy_all!

# Get the environment
ambiente = Rails.env || "development"

# Schedule jobs dynamically
Tarea.find_each do |tarea|
  next if tarea.recordatorio_tarea_frecuencia.blank?

  Sidekiq::Cron::Job.create(
    name: "Notificador de tareas pendientes - #{tarea.id}",
    cron: tarea.recordatorio_tarea_frecuencia, # Assuming it's a valid cron expression
    class: "NotificadorDeTareasPendientesWorker",
    args: [tarea.id],
    description: "Ejecuta recordatorio de tareas pendientes para Tarea ID #{tarea.id}",
    queue: "default"
  )
end
