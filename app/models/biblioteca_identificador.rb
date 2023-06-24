class BibliotecaIdentificador < ApplicationRecord
  belongs_to :biblioteca_obra, foreign_key: :obra_id
end
