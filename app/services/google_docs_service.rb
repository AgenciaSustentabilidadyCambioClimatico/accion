require "google/apis/docs_v1"
require "googleauth"

class GoogleDocsService
  DOCS = Google::Apis::DocsV1

  def initialize
    scope = ["https://www.googleapis.com/auth/documents.readonly"]

    @auth = Google::Auth::ServiceAccountCredentials.make_creds(
      json_key_io: File.open(Rails.root.join("config", "google_service_account.json")),
      scope: scope
    )

    @service = DOCS::DocsService.new
    @service.authorization = @auth
  end

  # Devuelve todo el texto de un documento Google Docs dado su ID
  def get_document_text(document_id)
    doc = @service.get_document(document_id)
    extract_text_from(doc)
  end

  private

  def extract_text_from(doc)
    text = ""
    doc.body.content.each do |element|
      if element.paragraph&.elements
        element.paragraph.elements.each do |el|
          text += el.text_run.content if el.text_run&.content
        end
      end
    end
    text
  end
end