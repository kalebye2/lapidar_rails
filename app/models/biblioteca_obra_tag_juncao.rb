class BibliotecaObraTagJuncao < ApplicationRecord
  belongs_to :biblioteca_obra, foreign_key: :obra_id
  belongs_to :biblioteca_tag, foreign_key: :tag_id

  def obra
    biblioteca_obra.order(titulo: :asc, subtitulo: :asc, isbn: :asc)
  end

  def tag
    biblioteca_tag.order(ordem: :asc)
  end
end
