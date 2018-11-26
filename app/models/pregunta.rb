class Pregunta < ApplicationRecord
	enum tipo_respuestas: [:escala_likert_numerica_0_7,:texto_libre,:si_o_no]

	validates :texto, presence: true, uniqueness: { scope: [:tipo_respuestas] }
	validates :tipo_respuestas, presence: true
end