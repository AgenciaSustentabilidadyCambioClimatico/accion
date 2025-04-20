require 'sidekiq-cron'

class ScheduleNotificador
  def self.load
    Sidekiq::Cron::Job.all.each do |job|
      job.destroy if job.name.start_with?("Notificador de tareas pendientes")
    end

    Tarea.find_each do |tarea|
      next if tarea.recordatorio_tarea_frecuencia.blank?
      next unless Sidekiq::Cron::Job.valid_cron?(tarea.recordatorio_tarea_frecuencia)

      job_name = "Notificador de tareas pendientes - #{tarea.id}"

      Sidekiq::Cron::Job.create(
        name: job_name,
        cron: tarea.recordatorio_tarea_frecuencia,
        class: "NotificadorDeTareasPendientesWorker",
        args: [tarea.id],
        description: "Ejecuta recordatorio de tareas pendientes para Tarea ID #{tarea.id}",
        queue: "default"
      )
    end
  end
end
