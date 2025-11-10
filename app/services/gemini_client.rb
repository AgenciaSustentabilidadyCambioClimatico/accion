require 'httparty'

class GeminiClient
  include HTTParty
  base_uri 'https://generativelanguage.googleapis.com/v1beta/models'

  def initialize(manual_path: nil)
    @api_key = ENV['GEMINI_API_KEY']
    @manual_text = manual_path ? load_manual_content(manual_path) : ""
  end

  def generate_content(message)
    system_prompt = <<~PROMPT
      Eres un asistente del sistema.
      Debes responder **EXCLUSIVAMENTE** basándote en la información del manual a continuación.
      ❌ No inventes información.
      ❌ No respondas preguntas generales.
      ✅ Si la respuesta no está en el manual, responde exactamente: "No lo sé, el manual no tiene esa información."

      --- MANUAL DEL SISTEMA ---
      #{@manual_text}
      ---------------------------
    PROMPT

    body = {
      contents: [
        {
          role: "user",
          parts: [
            { text: "#{system_prompt}\n\nPregunta del usuario: #{message}" }
          ]
        }
      ]
    }

    response = self.class.post(
      "/gemini-2.0-flash:generateContent?key=#{@api_key}",
      headers: { "Content-Type" => "application/json" },
      body: body.to_json
    )

    Rails.logger.info "Gemini response: #{response.parsed_response.inspect}"

    text = response.parsed_response.dig("candidates", 0, "content", "parts", 0, "text")
    text || "No se pudo obtener respuesta del modelo."
  end

  private

  def load_manual_content(path)
    ext = File.extname(path.to_s).downcase
    case ext
    when '.txt'
      File.read(path, encoding: 'UTF-8')
    when '.docx'
      require 'docx'
      doc = Docx::Document.open(path)
      doc.paragraphs.map(&:text).join("\n")
    else
      raise "Formato de manual no soportado: #{ext}"
    end
  end
end
