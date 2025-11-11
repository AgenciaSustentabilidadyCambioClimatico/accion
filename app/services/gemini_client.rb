require "httparty"

class GeminiClient
  include HTTParty
  base_uri "https://generativelanguage.googleapis.com/v1beta/models"

  def initialize(manual_text: "")
    @api_key = ENV["GEMINI_API_KEY"]
    @manual_text = manual_text
  end

  def generate_content(message)
    system_prompt = <<~PROMPT
      Eres un asistente del sistema.
      Solo puedes responder basándote en la siguiente documentación oficial:
      Debes responder **EXCLUSIVAMENTE** basándote en la información del manual a continuación.
      ❌ No inventes información.
      ❌ No respondas preguntas generales.
      ✅ Si la respuesta no está en el manual, responde exactamente: "No lo sé, el manual no tiene esa información."
      ✅ No incluyas referencias visuales como "Ver Figura", "Figura", "Gráfico", "ver tabla", ni comentarios similares.

      #{@manual_text}
      ---
      Si la respuesta no está en el manual, responde literalmente:
      "No lo sé, el manual no tiene esa información."
    PROMPT

    response = self.class.post(
      "/gemini-2.0-flash:generateContent?key=#{@api_key}",
      headers: { "Content-Type" => "application/json" },
      body: {
        contents: [
          {
            role: "user",
            parts: [{ text: "#{system_prompt}\n\nPregunta: #{message}" }]
          }
        ]
      }.to_json
    )

    response.parsed_response.dig("candidates", 0, "content", "parts", 0, "text") ||
      "No lo sé, el manual no tiene esa información."
  end
end
