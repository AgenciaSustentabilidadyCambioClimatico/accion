require 'sidekiq-cron'

return unless Sidekiq.server?

Rails.application.config.after_initialize do
  require Rails.root.join('lib/schedule_notificador').to_s
  ScheduleNotificador.load
end
