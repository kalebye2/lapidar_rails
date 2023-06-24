class BibliotecaObraTagJuncao < ApplicationRecord
  belongs_to :biblioteca_obra, foreign_key: :obra_id
  belongs_to :biblioteca_tag, foreign_key: :tag_id
end
