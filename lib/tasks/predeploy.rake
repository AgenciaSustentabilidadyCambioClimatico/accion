task :predeploy => :environment do
  require "slack-notifier"

  begin
    notifier = Slack::Notifier.new ENV["SLACK_WEBHOOK_URL"] do
      defaults channel: "#deploys",
               username: "AppDeploy"
    end
    notifier.ping "Finalizando deploy ASCC - Accion #{ENV["AMBIENTE"]}..."
    #Sidekiq::ProcessSet.new.each(&:quiet!)

    #notifier.ping "Todas las colas ASCC en #{ENV["AMBIENTE"]} en estado quiet..."

    ACCESS_TOKEN = ENV["POST_SERVER_ITEM_ACCESS_TOKEN"]
    ENVIRONMENT = ENV["ROLLBAR_ENV"]
    LOCAL_USERNAME = `whoami`
    #REVISION = `git rev-parse --verify HEAD`
    REVISION = ENV["GIT_REV"]
    ENDPOINT = ENV["ROLLBAR_DEPLOY_ENDPOINT"]
    `curl #{ENDPOINT} -F access_token=#{ACCESS_TOKEN} -F revision=#{REVISION} -F environment=#{ENVIRONMENT}  -F local_username=#{LOCAL_USERNAME}`

    if ENV["AMBIENTE"] == "prod"
      `bundle exec newrelic deployment -r #{REVISION} -u #{LOCAL_USERNAME}`
    end
  rescue => e
    Rails.logger.info e
    Rollbar.error(e)
  else
  ensure
  end
end
