class BibliotecaObraTipo < ApplicationRecord
  has_many :biblioteca_obra, foreign_key: :obra_tipo_id
end
