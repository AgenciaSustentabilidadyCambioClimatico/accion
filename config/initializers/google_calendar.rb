# config/initializers/google_calendar.rb

require 'google/apis/calendar_v3'
require 'googleauth'
require 'googleauth/stores/file_token_store'


module GoogleCalendar
  class << self

    OOB_URI = Rails.application.config.oob_uri.freeze
    APPLICATION_NAME = 'accion'.freeze
    CREDENTIALS_PATH = Rails.root.join('config', 'client_secret.json').freeze
    TOKEN_PATH = Rails.root.join('tmp', 'google_token.yaml').to_s.freeze
    SCOPE = Google::Apis::CalendarV3::AUTH_CALENDAR

    def get_service
      client_id = Google::Auth::ClientId.from_file(CREDENTIALS_PATH)
      token_store = Google::Auth::Stores::FileTokenStore.new(file: TOKEN_PATH)
      authorizer = Google::Auth::UserAuthorizer.new(client_id, SCOPE, token_store)
      user_id = 'sistemaaccion@ascc.cl'
      credentials = authorizer.get_credentials(user_id)

      if credentials.nil?
        url = authorizer.get_authorization_url(base_url: OOB_URI )
        puts "Open the following URL in the browser and enter the " \
            "resulting code after authorization:\n" + url
        code = get
        credentials = authorizer.get_and_store_credentials_from_code(user_id: user_id, code: code, base_url: OOB_URI )
      end

      service = Google::Apis::CalendarV3::CalendarService.new
      service.client_options.application_name = APPLICATION_NAME
      service.authorization = credentials
      return service
    end
  end 
end 