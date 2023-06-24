class BibliotecaObraAutorJuncao < ApplicationRecord
  belongs_to :biblioteca_obra, foreign_key: :obra_id
  belongs_to :biblioteca_autor, foreign_key: :autor_id
end
