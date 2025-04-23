require 'sidekiq-cron'

return unless Sidekiq.server?

Rails.application.config.after_initialize do
  require Rails.root.join("lib/schedule_notification")
  ScheduleNotification.load
end
