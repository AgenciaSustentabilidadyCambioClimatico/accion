class ChatsController < ApplicationController
  protect_from_forgery except: :create

  def create
    message = params[:message] || params.dig(:chat, :message)
    manual_path = Rails.root.join('app', 'manuales', 'ASCC_Manual_de_Usuario_Plataforma_Accion.docx')
    client = GeminiClient.new(manual_path: manual_path)

    begin
      reply = client.generate_content(message)
      render json: { ok: true, reply: reply }
    rescue => e
      Rails.logger.error "Chat error: #{e.message}"
      render json: { ok: false, error: e.message }, status: 500
    end
  end
end
