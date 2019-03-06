class CreatePpfMetasComentarios < ActiveRecord::Migration[5.1]
  def change
    create_table :ppf_metas_comentarios do |t|
    	t.belongs_to :ppf_metas_establecimiento, index: true, foreign_key: true
    	t.belongs_to :user, index: true, foreign_key: true
    	t.string :comentario

      t.timestamps
    end
  end
end
