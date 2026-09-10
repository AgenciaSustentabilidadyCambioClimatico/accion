class AddComentarioContableToRendicionFpl < ActiveRecord::Migration[6.0]
  def change
    add_column :rendiciones_fpl, :comentario_contable, :text
  end
end
