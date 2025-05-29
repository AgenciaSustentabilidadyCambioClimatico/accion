require 'sidekiq-cron'

class ScheduleNotificador
  def self.load
    Rails.logger.info "[ScheduleNotificador] Cargando jobs dinámicos desde Tarea"

    Sidekiq::Cron::Job.all.each do |job|
      job.destroy if job.name.start_with?("Notificador de tareas pendientes")
    end

    Tarea.find_each do |tarea|
      next if tarea.recordatorio_tarea_frecuencia.blank?

      job_name = "Notificador de tareas pendientes - #{tarea.id}"

      created = Sidekiq::Cron::Job.create(
        name: job_name,
        cron: tarea.recordatorio_tarea_frecuencia,
        class: "NotificadorDeTareasPendientesWorker",
        args: [tarea.id],
        description: "Ejecuta recordatorio de tareas pendientes para Tarea ID #{tarea.id}",
        queue: "default"
      )

      Rails.logger.info "[ScheduleNotification] Job #{job_name} #{created ? 'creado' : 'falló'}"
    end
  end
end
