class Comentario < ApplicationRecord
	ERRORES = 1
	SUGERENCIAS = 2
	SOLICITUDES = 3

	has_many :comentario_archivos, foreign_key: :comentario_id
	belongs_to :tipo_comentario
	belongs_to :user, optional: true
	
	validates :tipo_comentario_id, presence: true
	validates :comentario, presence: true
	validates :email_contacto, presence: true, format: { with: /\A([\w\.%\+\-]+)@([\w\-]+\.)+([\w]{2,})\z/i }

	accepts_nested_attributes_for :comentario_archivos, :allow_destroy => true#, limit: 3

	attribute :requiere_envio_correo, :boolean, default: true
	attr_accessor :requiere_envio_correo
end