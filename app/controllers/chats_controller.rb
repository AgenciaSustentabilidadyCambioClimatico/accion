class ChatsController < ApplicationController
  protect_from_forgery except: :create

  def create
    message = params[:message] || params.dig(:chat, :message)
    doc_id = ENV["GEMINI_ID_DOC"] 

    docs_service = GoogleDocsService.new
    manual_text = docs_service.get_document_text(doc_id)

    client = GeminiClient.new(manual_text: manual_text)

    begin
      reply = client.generate_content(message)
      render json: { ok: true, reply: reply }
    rescue => e
      Rails.logger.error "Chat error: #{e.message}"
      render json: { ok: false, error: e.message }, status: 500
    end
  end
end
