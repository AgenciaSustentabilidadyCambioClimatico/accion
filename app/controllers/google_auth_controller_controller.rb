require 'google/apis/calendar_v3'
require 'googleauth'
require 'googleauth/stores/file_token_store'
class GoogleAuthControllerController < ApplicationController
    OOB_URI = Rails.application.config.oob_uri.freeze
    APPLICATION_NAME = 'accion'.freeze
    CREDENTIALS_PATH = Rails.root.join('config', 'client_secret.json').freeze
    TOKEN_PATH = Rails.root.join('tmp', 'google_token.yaml').to_s.freeze
    SCOPE = Google::Apis::CalendarV3::AUTH_CALENDAR_EVENTS
    
    def authorize
        # The code for starting the authorization flow will be added here
        client_id = Google::Auth::ClientId.from_file(CREDENTIALS_PATH)
        token_store = Google::Auth::Stores::FileTokenStore.new(file: TOKEN_PATH)
        authorizer = Google::Auth::UserAuthorizer.new(client_id, SCOPE, token_store)
        user_id = 'sistemaaccion@ascc.cl'
        credentials = authorizer.get_credentials(user_id)

        if credentials.nil?
            url = authorizer.get_authorization_url(base_url: OOB_URI )
            # Redirect the user to the authorization URL
            redirect_to url
        else
            # Redirect to the desired page if the user is already authorized
            redirect_to root_path
        end
      end
    
      def oauth2callback
        # The code for handling the OAuth2 callback and processing the authorization code will be added here
        client_id = Google::Auth::ClientId.from_file(CREDENTIALS_PATH)
        token_store = Google::Auth::Stores::FileTokenStore.new(file: TOKEN_PATH)
        authorizer = Google::Auth::UserAuthorizer.new(client_id, SCOPE, token_store)
        user_id = 'sistemaaccion@ascc.cl'
        credentials = authorizer.get_and_store_credentials_from_code(
        user_id: user_id,
        code: params[:code],
        base_url: OOB_URI,
        authorization_uri: 'https://accounts.google.com/o/oauth2/auth',
        token_credential_uri: 'https://oauth2.googleapis.com/token',
        redirect_uri: 'http://localhost:3000/oauth2callback'
              )
        credentials.expires_at = Time.now + 10.years
				credentials.expiry = 10.years.to_i
        # almacena las credenciales actualizadas
        token_store.store(user_id, credentials.to_json)


        redirect_to root_path
        
      end
end
